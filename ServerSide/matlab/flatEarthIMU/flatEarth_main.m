clear;      % clears variables
%clear all;  % clear vars, breakpoints, persistent vars and cached memory
clc;        % clears the command window
%format long; 
%format short;
format compact; 

% Load imu data
disp('*******************************************************************')
disp('% Load imu data')
filename = '../../../tests/board_00CADE_acc_gyro_andrea1_parsed.txt';
[acc_arr, gyro_arr] = imu_readfile(filename);
len_acc_arr = length(acc_arr)
% freq = 25;  % imu sampling rate
% dt = 1/freq;
% In pratice data rate was different than theorical
telapsed = 52;
Fs = telapsed / len_acc_arr
dt = 0.1;
% size(acc_arr)
% size(gyro_arr)
% acc_arr(:,1)
% acc_arr(:,2)
% gyro_arr(:,1)
% gyro_arr(:,2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If we don't know the initial value of Phi0
% we can use the gravity vector to find it.
% To do so, we need to find a R_ned_frd such that:
% g_ned = R_ned_frd*g_frd
%
% In practice, we calculate this as:
% g_ned = [0; 0; 1] = R_ned_frd*acc_avg (acc meassured in [g] units)
% where acc_avg is the acc vector when gravity is the ONLY force present
% 
% If we calculate acc_frd = R_ned_frd*acc_frd for all the data,
% this is equivalent to a FRD frame INITIALLY alligned with NED and
% a Phi0 = [0; 0; 0]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1) Calculate g_frd_cm_e as the average acc vector of the first t [s]
disp('*******************************************************************')
disp('1) Calculate g_frd_cm_e as the average acc of the first t [s]')
index = round(2/dt);    % first 3 [s]
avg_acc = 0;
for i = 1:index
    avg_acc = avg_acc + acc_arr(:,i);
end
avg_acc = avg_acc./index
avg_acc_magn = norm(avg_acc)

% 1.1) Normalize ALL acc data to match g_tp = [0;0;9.80665] as in the
% flatEarth model
disp('*******************************************************************')
disp('1.1) Normalize ALL acc data to match g_tp = [0;0;9.80665]')
g_magn = 9.80665;
corrfactor = g_magn/avg_acc_magn
avg_acc_norm = avg_acc.*corrfactor;
avg_acc_magn = norm(avg_acc_norm)
acc_arr = acc_arr.*corrfactor;
acc_arr1 = acc_arr(:,1)
acc_arr2 = acc_arr(:,2)
gyro_arr1 = gyro_arr(:,1)
gyro_arr2 = gyro_arr(:,2)
%return

% 2) Calculate DCM that satisfies [0; 0; -g] = R_ned_frd*acc_avg 
% An extra constraint is that the DCM must also 
% satisfy psi = 0 (no heading deviation)
disp('*******************************************************************')
disp('2) Calculate DCM that satisfies [0; 0; g] = R_ned_frd*acc_avg')
psi = 0;
v_ned = [0; 0; -g_magn];
q0 = [0.5, 0.5, 0.5, 0.5];
%q0 = [0, 0, 0, 1];
q_ned_frd = imu_find_q_ned_frd(v_ned, avg_acc_norm, psi, q0)
[psi, theta, phi] = quat2angle(q_ned_frd,'ZYX');
Phi0 = [phi, theta, psi];
Phi0_deg = [Phi0(1)*180/pi; Phi0(2)*180/pi; Phi0(3)*180/pi]
R_ned_frd = quat2dcm(q_ned_frd)
R_frd_ned = R_ned_frd^(-1)
% R_ned_frd*transpose(R_ned_frd)
% R_frd_ned*transpose(R_frd_ned)
show_plot = 0;
if show_plot == 1
    % Show that we effectively rotated the data to INITIALY 
    % make FRD coincide with NED frame
    imu_plot_in_FRD_accgyro_FRD(acc_arr, gyro_arr);
    imu_plot_in_NED_accgyro_FRD(acc_arr, gyro_arr, R_ned_frd)
end

% 2.1) Rotate ALL data, so that we can use Phi0 = [0;0;0]
disp('*******************************************************************')
disp('2.1) Rotate ALL data, so that we can use Phi0 = [0;0;0]')
for i = 1:length(acc_arr)
    acc_arr(:,i) = R_ned_frd*acc_arr(:,i);
    gyro_arr(:,i) = R_ned_frd*gyro_arr(:,i);
end
acc_arr1 = acc_arr(:,1)
acc_arr2 = acc_arr(:,2)
gyro_arr1 = gyro_arr(:,1)
gyro_arr2 = gyro_arr(:,2)

% % 2.2 Filter acc data
% [envHigh, envLow] = envelope(acc_arr,10,'peak');
% envMean = (envHigh+envLow)/2;
% plot(time_arr,acc_arr, ...
%      time_arr,envHigh, ...
%      time_arr,envMean, ...
%      time_arr,envLow)

% 3) Calculate evolution of the system whose state vector is [x] = 
% r_tp_cm_e
% v_frd_cm_e ( we can also calculate v_ned_cm_e0 = R_ned_frd*v_frd_cm_e0 )
% Phi
% And the input vector is [u] = 
% a_frd_cm_i = acc_arr
% w_frd_b_e = gyro_arr
disp('*******************************************************************')
disp('3) Calculate evolution of the system')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All the rest of this .m file (an implementation of the FlatEarth Eqs)
% is devoted to this last step
% The flatEarth_fdyn and flatEarth_finp files have been 
% modfied according to step 3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Position of cm wrt 'inertial' ecef in tp coord
r_tp_cm_e0 = [0; 0; 0];
% Euler Angles of DCM R_frd_tp. Phi = [phi; thta; psi]
Phi0 = [0; 0; 0];
% Velocity of cm wrt 'inertial' ecef in frd coord
v_frd_cm_e0 = [0; 0; 0];
% Angular Velocity of b-frame wrt ecef in frd coord
w_frd_b_e0 = gyro_arr(:,1); %[0; 0; 0];
% Relative velocity of the cm wrt the wind
v_frd_rel0 = [0; 0; 0];
    
x0 = [r_tp_cm_e0; Phi0; v_frd_cm_e0; w_frd_b_e0; v_frd_rel0]

y0 = 0;

% Initialize vars for loop
tfinal = Fs*(size(acc_arr,2)-1);
time_arr = 0:dt:tfinal;
u0 = [acc_arr; gyro_arr];
params = Fs;
x_curr = x0;
num_statevars = length(x0);
num_outputvars = length(y0);
x_arr = zeros(num_statevars, length(time_arr));
x_arr(:,1) = x0;
y_arr = zeros(num_outputvars, length(time_arr));
y_arr(:,1) = y0;
%size(time_arr)
%size(x_arr)
%size(y_arr)
%return

% 3.1 Filter acc data before integrating
%imu_plot_in_NED_accgyro_FRD(acc_arr, gyro_arr, eye(3,3))
%acc_arr = imu_lowpass_FIR_compensated(time_arr, acc_arr, dt, 1);
%imu_plot_in_NED_accgyro_FRD(acc_arr, gyro_arr, eye(3,3))
%return
[time_arr,x_arr] = ode45(@(time_arr,x_arr) flatEarth_fdyn(time_arr,...
    x_arr,flatEarth_finp(time_arr, u0, params)), [0 tfinal], x0);
time_arr = transpose(time_arr);
x_arr = transpose(x_arr);
size_time_arr = size(time_arr)
size_x_arr = size(x_arr)
% for i = 1:(size(time_arr,2)-1)
%     time_curr = time_arr(i);
%     
%     % Numerical integration one step forward using 4th order Runge-Kutta
%     x_next = flatEarth_rk4('flatEarth_fdyn','flatEarth_finp',...
%         time_curr,dt,x_curr,u0,params);
%     
% %     % Velocity of cm wrt frd coord
% %     v_frd_cm_e = [x_next(7); x_next(8); x_next(9)];
% %     disp(sprintf('t = %f v_frd_cm_e_f = %f', time_curr, v_frd_cm_e(1)))
% %     disp(sprintf('t = %f v_frd_cm_e_r = %f', time_curr, v_frd_cm_e(2)))
% %     disp(sprintf('t = %f v_frd_cm_e_d = %f', time_curr, v_frd_cm_e(3)))
% %     % Euler Angles of DCM R_frd_tp. Phi = [phi; thta; psi]
% %     Phi = [x_next(4); x_next(5); x_next(6)];
% %     Phi_deg = [Phi(1)*180/pi; Phi(2)*180/pi; Phi(3)*180/pi]
% %     phi = Phi(1);
% %     theta = Phi(2);
% %     psi = Phi(3);
% %     C_frd_tp = angle2dcm( psi, theta, phi, 'ZYX');
% %     C_tp_frd = transpose(C_frd_tp);
% %     % Velocity of cm wrt 'inertial' ecef in frd coord
% %     v_ned_cm_e = C_tp_frd*v_frd_cm_e;
% %     disp(sprintf('t = %f v_ned_cm_e_n = %f', time_curr, v_ned_cm_e(1)))
% %     disp(sprintf('t = %f v_ned_cm_e_e = %f', time_curr, v_ned_cm_e(2)))
% %     disp(sprintf('t = %f v_ned_cm_e_d = %f', time_curr, v_ned_cm_e(3)))
% 
%     % Store solutions
%     x_arr(:,i+1) = x_next;
%     %y_arr(i) = y_curr;
%     
%     % Prepare for next loop
%     x_curr = x_next;
%     
%     %flatEarth_plot_NED_FRD_evol(x_next);
%     %return
% end;
disp('check boundary values')
tfinal = tfinal
len_time_arr = size(time_arr,2)
time_1 = time_arr(1)
time_last = time_arr(size(time_arr,2))
len_x_arr = size(x_arr,2)
x_arr_1 = x_arr(1:3,1)
x_arr_last = x_arr(1:3,size(x_arr,2))
% time_arr(3)

flatEarth_plot_NED_FRD_evol(x_arr);
%return

flatEarth_plot_trajectory(x_arr);

%flatEarth_plot_pos_vel(x_arr);

%flatEarth_plot_vel_trajectory(x_arr);
