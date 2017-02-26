clear;      % clears variables
%clear all;  % clear vars, breakpoints, persistent vars and cached memory
clc;        % clears the command window
%format long; 
%format short;
format compact; 

%q0 = [0.5; 0.5; 0.5; 0.5];
Phi = [0; 0; 0];
avg_gravity_frd = [-0.91684; 0.51144,; -0.08306]./1.0531217511759978;
avg_gravity_frd_magn = sqrt(dot(avg_gravity_frd,avg_gravity_frd));
v_ned = [0; 0; 1];  % gravity is (0; 0; 1[g]) 

fsolve_mode = 2;
if fsolve_mode == 1 || fsolve_mode == 3
    disp('******************************')
    disp('Using fsolve with quat, Phi = [phi, theta, psi]')
    %q0 = [cos(2*pi/3), sin(2*pi/3).*[0.5, 0.5, 1]];
    q0 = [0.5, 0.5, 0.5, 0.5];
    %q0 = [0, 0, 0, 0];
    q_ned_frd = fnct_find_q_ned_frd(avg_gravity_frd, v_ned, q0)
    [Phi(3), Phi(2), Phi(1)] = quat2angle(q_ned_frd,'ZYX');
    Phi_deg = [Phi(1)*180/pi; Phi(2)*180/pi; Phi(3)*180/pi]
    R_ned_frd = fnct_quat_to_DCM(q_ned_frd)
end
if fsolve_mode == 2 || fsolve_mode == 3
    disp('******************************')
    disp('Using fsolve with DCM, Phi = [phi, theta, psi]')
    Phi0 = [0; 0; 0];
    Phi = fnct_find_Phi_frd_ned(avg_gravity_frd, v_ned, Phi0);
    Phi_deg = [Phi(1)*180/pi; Phi(2)*180/pi; Phi(3)*180/pi]
    R_ned_frd = fnct_Phi_to_R_ned_frd(Phi);
    q_frd_ned = angle2quat(Phi(3), Phi(2), Phi(1),'ZYX');
    q_ned_frd = quatinv(q_frd_ned)
    R_ned_frd = quat2dcm(q_ned_frd)
end
if fsolve_mode == 3
    return
end

% avg_gravity_frd2 = R_frd_ned*[0; 0; -1]
% avg_gravity_frd = avg_gravity_frd
% fnct_plot_in_NED_v_FRD(R_ned_frd, avg_gravity_frd);

freq = 25;
dt = 1/freq;
filename = '../../tests/board_00CADE_acc_gyro_andrea1_parsed.txt';
[acc_x_arr, acc_y_arr, acc_z_arr, gyro_x_arr, gyro_y_arr, gyro_z_arr] = ...
    fnct_readfile(filename);
gyro_x_arr = gyro_x_arr.*pi./180;
gyro_y_arr = gyro_y_arr.*pi./180;
gyro_z_arr = gyro_z_arr.*pi./180;
gyro_arr = [...
    transpose(gyro_x_arr), ...
    transpose(gyro_y_arr), ...
    transpose(gyro_z_arr) ...
    ];
acc_arr = [...
    transpose(acc_x_arr), ...
    transpose(acc_y_arr), ...
    transpose(acc_z_arr) ...
    ];

% fnct_plot_in_FRD_accgyro_FRD(acc_x_arr, acc_y_arr, acc_z_arr,...
%     gyro_x_arr, gyro_y_arr, gyro_z_arr)

fnct_plot_in_NED_accgyro_FRD(acc_x_arr, acc_y_arr, acc_z_arr,...
    gyro_x_arr, gyro_y_arr, gyro_z_arr, R_ned_frd)

fnct_plot_accgyro_magn(acc_x_arr, acc_y_arr, acc_z_arr,...
    gyro_x_arr, gyro_y_arr, gyro_z_arr, dt)

euler_ang0 = [0;0;0];
[time_arr, euler_ang_arr] = fnct_integrate_angrates_to_eulerang(...
    gyro_arr, dt, euler_ang0);

fnct_plot_in_NED_eulerang_FRD(euler_ang_arr)

