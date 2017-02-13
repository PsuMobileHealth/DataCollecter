clear;      % clears variables
%clear all;  % clear vars, breakpoints, persistent vars and cached memory
clc;        % clears the command window
%format long; 
%format short;
format compact; 

%q0 = [0.5; 0.5; 0.5; 0.5];
Phi0 = [0; 0; 0];
x0 = Phi0;
gravity_frd = [-0.91684; 0.51144,; -0.08306]./1.0531217511759978
gravity_frd_magn = sqrt(dot(gravity_frd,gravity_frd));
v_ned = [0; 0; 1];
res = fnct_find_DCM(gravity_frd, v_ned, x0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% res is Phi = phi theta psi
phi = res(1);
theta = res(2);
psi = res(3);
%phi = pi/8;
%theta = 0;
%psi = 0;
Phi_deg = [phi*180/pi; theta*180/pi; psi*180/pi]
c11 = cos(theta)*cos(psi);
c12 = cos(theta)*sin(psi);
c13 = -sin(theta);
c21 = -cos(phi)*sin(psi) + sin(phi)*sin(theta)*cos(psi);
c22 = cos(phi)*cos(psi) + sin(phi)*sin(theta)*sin(psi);
c23 = sin(phi)*cos(theta);
c31 = sin(phi)*sin(psi) + cos(phi)*sin(theta)*cos(psi);
c32 = -sin(phi)*cos(psi) + cos(phi)*sin(theta)*sin(psi);
c33 = cos(phi)*cos(theta);
R_frd_ned = [c11, c12, c13; c21, c22, c23; c31, c32, c33];
R_ned_frd = R_frd_ned^(-1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% res is a quaternion
% q_frd_ned = res
% q0 = q_frd_ned(1);
% q1 = q_frd_ned(2);
% q2 = q_frd_ned(3);
% q3 = q_frd_ned(3);
% c11 = q0^2 + q1^2 - q2^2 - q3^2;
% c12 = 2*(q1*q2 + q0*q3);
% c13 = 2*(q1*q3 - q0*q2);
% c21 = 2*(q0*q1 - q0*q2);
% c22 = q0^2 - q1^2 + q2^2 - q3^2;
% c23 = 2*(q2*q3 + q0*q1);
% c31 = 2*(q1*q3 + q0*q2);
% c32 = 2*(q2*q3 - q0*q1);
% c33 = q0^2 - q1^2 - q2^2 + q3^2;
% R_frd_ned = [c11, c12, c13; c21, c22, c23; c31, c32, c33]
% phi = atan2(c23,c33)
% theta = -asin(c13)
% psi = atan2(c12,c11)
% %Initialize quaternion
% q_frd_ned2 = [
%     cos(phi/2)*cos(theta/2)*cos(psi/2)+sin(phi/2)*sin(theta/2)*sin(psi/2); ...
%     sin(phi/2)*cos(theta/2)*cos(psi/2)-cos(phi/2)*sin(theta/2)*sin(psi/2); ...
%     cos(phi/2)*sin(theta/2)*cos(psi/2)+sin(phi/2)*cos(theta/2)*sin(psi/2); ... 
%     cos(phi/2)*cos(theta/2)*sin(psi/2)-sin(phi/2)*sin(theta/2)*cos(psi/2)
%     ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gravity_frd2 = R_frd_ned*[0; 0; -1]
gravity_frd = gravity_frd
%fnct_plot_in_NED_v_frd(R_ned_frd, gravity_frd);

%filename = '../../tests/board_00CADE_acc_gyro_andrea1_parsed.txt';
%fnct_plot_in_FRD_accgyro_frd_fromfile(filename)

%filename = '../../tests/board_00CADE_acc_gyro_andrea1_parsed.txt';
%fnct_plot_in_NED_accgyro_frd_fromfile(filename, R_ned_frd)

%filename = '../../tests/board_00CADE_acc_gyro_andrea1_parsed.txt';
%fnct_plot_accgyro_magn_fromfile(filename)

freq = 25;
deltat_ms = 1/freq
