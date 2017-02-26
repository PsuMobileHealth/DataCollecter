function res = fnct_plot_in_FRD_accgyro_FRD(...
    acc_x_arr, acc_y_arr, acc_z_arr,gyro_x_arr, gyro_y_arr, gyro_z_arr)

%     %res = function_readfile(filename);
%     [acc_x_arr, acc_y_arr, acc_z_arr, gyro_x_arr, gyro_y_arr, gyro_z_arr] = fnct_readfile(filename);
    
    %Plot init
    fig = figure;

    for i = 1:length(acc_x_arr); 
        %Plot FRD coord frame
        frd_f = [1; 0; 0];
        frd_r = [0; 1; 0];
        frd_d = [0; 0; 1];
        starts = zeros(3,3);
        ends = [transpose(frd_f); transpose(frd_r); transpose(frd_d)];
        quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'black')
        hold on;

        %Plot (in FRD coord frame) acc
        starts = zeros(3,3);
        res1 = [acc_x_arr(i); acc_y_arr(i); acc_z_arr(i)];
        ends = [transpose(res1); [0, 0, 0]; [0, 0, 0]];
        quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'blue')
        hold on;

        %Plot (in FRD coord frame) gyro
        starts = zeros(3,3);
        res1 = [gyro_x_arr(i); gyro_y_arr(i); gyro_z_arr(i)];
        ends = [transpose(res1); [0, 0, 0]; [0, 0, 0]];
        quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'red')
        hold off;

        % Plot settings
        %axis square;
        %axis equal;
        axis([-1 1 -1 1 -1 1]);
        %axis([-0.5 0.5 -0.5 0.5 -0.5 0.5]);
        title('FRD coord frame: acc (blue) and gyro (red)');
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