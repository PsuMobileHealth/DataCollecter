function res = fnct_plot_accgyro_magn(...
    acc_x_arr, acc_y_arr, acc_z_arr, gyro_x_arr, gyro_y_arr, gyro_z_arr, dt)

%     %res = function_readfile(filename);
%     [acc_x_arr, acc_y_arr, acc_z_arr, gyro_x_arr, gyro_y_arr, gyro_z_arr] = fnct_readfile(filename);
    
    length(acc_x_arr)
    time_arr = 0:dt:(length(acc_x_arr)-1)*dt;
    length(time_arr)
    
    %Plot init
    fig = figure;
    acc_magn = sqrt(acc_x_arr.^2 + acc_y_arr.^2 + acc_z_arr.^2);
    gyro_magn = sqrt(gyro_x_arr.^2 + gyro_y_arr.^2 + gyro_z_arr.^2);
    subplot(2,1,1)
    plot(time_arr, acc_magn, 'blue')
    title('acc magnitude')
    xlabel('time [s]');
    ylabel('magnitude [g]');
    hold on;
    
    subplot(2,1,2)
    plot(time_arr, gyro_magn, 'red')
    title('gyro magnitude')
    xlabel('time [s]');
    %ylabel('magnitude [deg/s]');
    ylabel('magnitude [rad/s]');
    hold off;
    
    res = 0;
end