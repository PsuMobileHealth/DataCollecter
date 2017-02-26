function res = flatEarth_plot_trajectory(x_arr)
    %Plot init
    fig = figure;
    % for i = 1:length(x_arr); 
    %     plot3(x_arr(1,i), x_arr(2,i), x_arr(3,i),'-*r');
    %     hold on;
    % end
    %Plot NED coord frame
    ned_n = [1; 0; 0];
    ned_e = [0; 1; 0];
    ned_d = [0; 0; 1];
    starts = zeros(3,3);
    ends = [transpose(ned_n); transpose(ned_e); transpose(ned_d)];
    quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'black')
    hold on;
    
    plot3(x_arr(1,:), x_arr(2,:), x_arr(3,:),'-*b');
    grid on;
    title('NED coord frame: pos of cm in NED (blue)');
    xlabel('x-axis (North)');
    ylabel('y-axis (East)');
    zlabel('z-axis (Down)');
    set(gca,'YDir','reverse');
    set(gca,'ZDir','reverse');
    %axis([-1 1 -1 1 -90 1]);
    hold off;
    
    res = 0;
end