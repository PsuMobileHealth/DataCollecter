function res = flatEarth_plot_pos_vel(x_arr)
    %Plot init
    fig = figure;
    for i = 1:size(x_arr,2)
        %Plot NED coord frame
        ned_n = [1; 0; 0];
        ned_e = [0; 1; 0];
        ned_d = [0; 0; 1];
        starts = zeros(3,3);
        ends = [transpose(ned_n); transpose(ned_e); transpose(ned_d)];
        quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'black')
        hold on;

        %Plot (in NED coord frame) r_tp_cm_e = [x(1); x(2); x(3)];
        starts = zeros(3,3);
        res1 = [x_arr(1,i); x_arr(2,i); x_arr(3,i)];
        ends = [transpose(res1); [0, 0, 0]; [0, 0, 0]];
        quiver3(starts(:,1), starts(:,2), starts(:,3),...
            ends(:,1), ends(:,2), ends(:,3),...
            'blue', 'MaxHeadSize', 1/norm(res1))
        hold on;

        %Plot (in NED coord frame) v_frd_cm_e = [x(7); x(8); x(9)];
        Phi = [x_arr(4,i); x_arr(5,i); x_arr(6,i)];
        phi = Phi(1);
        theta = Phi(2);
        psi = Phi(3);
        % dcm = angle2dcm( yaw, pitch, roll); % 'ZYX' (default)
        C_frd_tp = angle2dcm( psi, theta, phi, 'ZYX');
        C_tp_frd = C_frd_tp^(-1);
        v_frd_cm_e = [x_arr(7,i); x_arr(8,i); x_arr(9,i)];
        v_tp_cm_e = C_tp_frd*v_frd_cm_e;
        starts = zeros(3,3);
        res1 = [v_tp_cm_e(1); v_tp_cm_e(2); v_tp_cm_e(3)];
        ends = [transpose(res1); [0, 0, 0]; [0, 0, 0]];
        quiver3(starts(:,1), starts(:,2), starts(:,3),...
            ends(:,1), ends(:,2), ends(:,3),...
            'red', 'MaxHeadSize', 1/norm(res1))
        % 'Marker','.'
        hold off;

        % Plot settings
        %axis square;
        %axis equal;
        %axis([-1 1 -1 1 -1 1]);
        %axis([-0.5 0.5 -0.5 0.5 -0.5 0.5]);
        title('NED coord frame: pos of cm in NED (blue) vel of cm in NED (red)');
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