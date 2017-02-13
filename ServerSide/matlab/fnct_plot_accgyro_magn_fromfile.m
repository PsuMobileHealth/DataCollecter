function res = fnct_plot_accgyro_magn_fromfile(filename)
    %res = function_readfile(filename);
    [acc_x_arr, acc_y_arr, acc_z_arr, gyro_x_arr, gyro_y_arr, gyro_z_arr] = fnct_readfile(filename);
    
    %Plot init
    fig = figure;

    acc_magn = sqrt(acc_x_arr.^2 + acc_y_arr.^2 + acc_z_arr.^2);
    gyro_magn = sqrt(gyro_x_arr.^2 + gyro_y_arr.^2 + gyro_z_arr.^2);
    subplot(2,1,1)
    plot(acc_magn, 'blue')
    title('acc magnitude')
    xlabel('samples [i]');
    ylabel('magnitude [g]');
    hold on;
    
    subplot(2,1,2)
    plot(gyro_magn, 'red')
    title('gyro magnitude')
    xlabel('samples [i]');
    ylabel('magnitude [deg/s]');
    hold off;
    
    res = 0;
end