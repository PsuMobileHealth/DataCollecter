function res = flatEarth_plot_vel_trajectory(x_arr)
    %Plot init
    fig = figure;
    
    %Plot NED coord frame
    ned_n = [1; 0; 0];
    ned_e = [0; 1; 0];
    ned_d = [0; 0; 1];
    starts = zeros(3,3);
    ends = [transpose(ned_n); transpose(ned_e); transpose(ned_d)];
    quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'black')
    hold on;

    for i = 1:size(x_arr,2)
        Phi = [x_arr(4,i); x_arr(5,i); x_arr(6,i)];
        phi = Phi(1);
        theta = Phi(2);
        psi = Phi(3);
        % dcm = angle2dcm( yaw, pitch, roll); % 'ZYX' (default)
        C_frd_tp = angle2dcm( psi, theta, phi, 'ZYX');
        C_tp_frd = C_frd_tp^(-1);
        v_frd_cm_e = [x_arr(7,i); x_arr(8,i); x_arr(9,i)];
        v_tp_cm_e = C_tp_frd*v_frd_cm_e;
        plot3(v_tp_cm_e(1,:), v_tp_cm_e(2,:), v_tp_cm_e(3,:),'-*b');
        hold on;
    end
    grid on;
    title('NED coord frame: vel of cm in NED (blue)');
    xlabel('x-axis (North)');
    ylabel('y-axis (East)');
    zlabel('z-axis (Down)');
    set(gca,'YDir','reverse');
    set(gca,'ZDir','reverse');
    %axis([-0.3 0.3 -0.3 0.3 -33 15]);
    hold off;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Plot init
    fig = figure;
    
    %Plot FRD coord frame
    frd_f = [1; 0; 0];
    frd_r = [0; 1; 0];
    frd_d = [0; 0; 1];
    starts = zeros(3,3);
    ends = [transpose(frd_f); transpose(frd_r); transpose(frd_d)];
    quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'black')
    hold on;
    
    for i = 1:length(x_arr);
        v_frd_cm_e = [x_arr(7,i); x_arr(8,i); x_arr(9,i)];
        plot3(v_frd_cm_e(1,:), v_frd_cm_e(2,:), v_frd_cm_e(3,:),'-*b');
        hold on;
    end
    grid on;
    title('FRD coord frame: vel of cm in FRD (blue)');
    xlabel('x-axis (Forward)');
    ylabel('y-axis (Right)');
    zlabel('z-axis (Down)');
    set(gca,'YDir','reverse');
    set(gca,'ZDir','reverse');
    %axis([-0.3 0.3 -0.3 0.3 -33 15]);
    hold off;
    res = 0;
end