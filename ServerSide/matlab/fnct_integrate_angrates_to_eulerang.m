function [time_arr, euler_ang_arr] = fnct_integrate_angrates_to_eulerang(...
    gyro_arr, dt, euler_ang0)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    angrate0 = [0;0;0];
    euler_ang = euler_ang0;
    euler_ang_arr = [euler_ang0];
    time_arr = [0];
    len_gyro_arr = length(gyro_arr);
    tfinal = (len_gyro_arr-2)*dt;
    for t=0:dt:tfinal

        %u=feval(finp,time,u0)
        %Numerical integration one step forward using 4th order Runge-Kutta
        euler_ang = fnct_rk4_arr('fnct_EulerKinematicalEq',gyro_arr,t,dt,euler_ang,angrate0);

        %[t,y] = ode45(odefun,tspan,y0)

        %Store values in arrays phi, theta, psi, and time fro plotting.
        euler_ang_arr = [euler_ang_arr, euler_ang];
        time_arr = [time_arr, (t+dt)];

    end;
%     size(euler_ang_arr);
%     size(time_arr);
end

