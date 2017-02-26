function res = fnct_plot_in_NED_accgyro_FRD(...
    acc_x_arr, acc_y_arr, acc_z_arr, gyro_x_arr, gyro_y_arr, gyro_z_arr, R_ned_frd)

%     %res = function_readfile(filename);
%     [acc_x_arr, acc_y_arr, acc_z_arr, gyro_x_arr, gyro_y_arr, gyro_z_arr] = fnct_readfile(filename);
    
    %Plot init
    fig = figure;
    for i = 1:length(acc_x_arr); 
        %Plot NED coord frame
        ned_n = [1; 0; 0];
        ned_e = [0; 1; 0];
        ned_d = [0; 0; 1];
        starts = zeros(3,3);
        ends = [transpose(ned_n); transpose(ned_e); transpose(ned_d)];
        quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'black')
        hold on;

        %Plot (in NED coord frame) acc_ned = R_ned_frd*acc_frd;
        starts = zeros(3,3);
        res1 = R_ned_frd*[acc_x_arr(i); acc_y_arr(i); acc_z_arr(i)];
        ends = [transpose(res1); [0, 0, 0]; [0, 0, 0]];
        quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'blue')
        hold on;
        
        %Plot (in NED coord frame) gyro_ned = R_ned_frd*gyro_frd;
        starts = zeros(3,3);
        res1 = R_ned_frd*[gyro_x_arr(i); gyro_y_arr(i); gyro_z_arr(i)];
        ends = [transpose(res1); [0, 0, 0]; [0, 0, 0]];
        quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'red')
        hold off;

        % Plot settings
        %axis square;
        %axis equal;
        axis([-1 1 -1 1 -1 1]);
        %axis([-0.5 0.5 -0.5 0.5 -0.5 0.5]);
        title('NED coord frame: acc (blue) and gyro (red)');
        xlabel('x-axis (North)');
        ylabel('y-axis (East)');
        zlabel('z-axis (Down)');
        set(gca,'YDir','reverse');
        set(gca,'ZDir','reverse');
        %text(0.5,0,' \leftarrow sin(\pi)','FontSize',18) 
        %hold off;
        drawnow;
        pause(0.01);
    end
    res = 0;
end