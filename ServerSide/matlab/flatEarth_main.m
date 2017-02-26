clear;      % clears variables
%clear all;  % clear vars, breakpoints, persistent vars and cached memory
clc;        % clears the command window
%format long; 
%format short;
format compact; 

% Position of cm wrt 'inertial' ecef in tp coord
r_tp_cm_e0 = [0; 0; 0];
% Euler Angles of DCM R_frd_tp. Phi = [phi; thta; psi]
Phi0 = [0; 0; 0];
% Velocity of cm wrt 'inertial' ecef in frd coord
v_frd_cm_e0 = [0; 0; 0];
% Angular Velocity of b-frame wrt ecef in frd coord
w_frd_b_e0 = [0; 0; 0];
% Relative velocity of the cm wrt the wind
v_frd_rel0 = [0; 0; 0];
    
x0 = [r_tp_cm_e0; Phi0; v_frd_cm_e0; w_frd_b_e0; v_frd_rel0]

y0 = 0;

% Initialize vars for loop
dt = 0.25;
tfinal = 10;
time_arr = 0:dt:tfinal;
u0 = [0];
x_curr = x0;
num_statevars = length(x0);
num_outputvars = length(y0);
x_arr = zeros(num_statevars, length(time_arr));
y_arr = zeros(num_outputvars, length(time_arr));
%size(time_arr)
%size(x_arr)
%size(y_arr)
for i = 1:length(time_arr)
    time_curr = time_arr(i);
    
    % Numerical integration one step forward using 4th order Runge-Kutta
    x_next = flatEarth_rk4('flatEarth_fdyn','flatEarth_finp',...
        time_curr,dt,x_curr,u0);

    % Store solutions
    x_arr(:,i) = x_next;
    %y_arr(i) = y_curr;
    
    % Prepare for next loop
    x_curr = x_next;

end;
% time_arr(1)
% time_arr(2)
% time_arr(3)

flatEarth_plot_trajectory(x_arr);

flatEarth_plot_pos_vel(x_arr);

flatEarth_plot_vel_trajectory(x_arr);
