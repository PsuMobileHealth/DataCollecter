function [u]= flatEarth_finp(t, u0, params)
 
%     if (t<1.)
%         ff = 0;
%         fr = 0;
%         fd = 0;
%         l = 0;
%         m = 0;
%         n = 0;
%         windn = 0;
%         winde = 0;
%         windd = 0;
%     elseif (t<3.)
%         ff = 0.05;
%         fr = 0.05;
%         fd = -30.5;
% %         l = 0.1;
% %         m = 0.1;
% %         n = 0.2;
%         l = 0.005;
%         m = 0.01;
%         n = 0;
%         windn = 0;
%         winde = 0;
%         windd = 0;
%     else
%         ff = 0;
%         fr = 0;
%         fd = 0;
%         l = 0;
%         m = 0;
%         n = 0;
%         windn = 0;
%         winde = 0;
%         windd = 0;
%     end;
%     % Inputs to the system
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     f_frd = [ff; fr; fd];
%     M_frd = [l; m; n];
%     v_tp_wind_e = [windn; winde; windd];
%     u = [f_frd; M_frd; v_tp_wind_e];

    % Interpolation based on data
    acc_arr = u0(1:3,:);
    gyro_arr = u0(4:6,:);
    acc_x_arr = acc_arr(1,:);
    acc_y_arr = acc_arr(2,:);
    acc_z_arr = acc_arr(3,:);
    gyro_x_arr = gyro_arr(1,:);
    gyro_y_arr = gyro_arr(2,:);
    gyro_z_arr = gyro_arr(3,:);
%     tfinal = dt*length(acc_arr)
%     time_arr = 0:dt:tfinal;
    Fs = params;
    tfinal = Fs*(size(acc_arr,2)-1);
    time_arr = 0:Fs:tfinal;
%     size(time_arr)
%     size(acc_arr)
%     acc_x_arr(1)
%     acc_y_arr(1)
%     acc_z_arr(1)
%     acc_x_arr(2)
%     acc_y_arr(2)
%     acc_z_arr(2)


    % Intepolate between sampled points
    % x = sampled_points;
    % v = sampled_values;
    % vq = interp1(x,v,xq);
    % interpolated_val = vq;
    u(1) = interp1(time_arr,acc_x_arr,t);
    u(2) = interp1(time_arr,acc_y_arr,t);
    u(3) = interp1(time_arr,acc_z_arr,t);
    u(4) = interp1(time_arr,gyro_x_arr,t);
    u(5) = interp1(time_arr,gyro_y_arr,t);
    u(6) = interp1(time_arr,gyro_z_arr,t);
    
%     disp(sprintf('t = %f acc_f = %f, gyro_f = %f', t, u(1), u(4)))
%     disp(sprintf('t = %f acc_r = %f, gyro_r = %f', t, u(2), u(5)))    
%     disp(sprintf('t = %f acc_d = %f, gyro_d = %f', t, u(3), u(6)))

end