function res = flatEarth_plot_NED_FRD_evol(x_arr)
    fig = figure;
    for i = 1:size(x_arr,2)
        phi = x_arr(4,i);
        theta = x_arr(5,i);
        psi = x_arr(6,i);
        % singularity at theta = 90 [deg] 
        % this undefines theta_dot and phi_dot

        %Plot NED coord frame
        ned_n = [1; 0; 0];
        ned_e = [0; 1; 0];
        ned_d = [0; 0; 1];
        starts = zeros(3,3);
        ends = [transpose(ned_n); transpose(ned_e); transpose(ned_d)];
        quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'black')
        hold on;

        %Plot (in NED coord frame) FRD coord frame
        R_3_psi  = [cos(psi) sin(psi) 0; -sin(psi) cos(psi) 0; 0 0 1];
        R_2_theta  = [cos(theta) 0 -sin(theta); 0 1 0; sin(theta) 0 cos(theta)];
        R_1_phi  = [1 0 0; 0 cos(phi) sin(phi); 0 -sin(phi) cos(phi)];
        %R_frd_ned = R_1_phi*R_2_theta*R_3_psi;
        R_ned_frd = transpose(R_3_psi)*transpose(R_2_theta)*transpose(R_1_phi);
        frd_f = [1; 0; 0];
        frd_r = [0; 1; 0];
        frd_d = [0; 0; 1];
        res1 = R_ned_frd*frd_f;
        res2 = R_ned_frd*frd_r;
        res3 = R_ned_frd*frd_d;
        ends = [transpose(res1); transpose(res2); transpose(res3)];
        quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'blue')
        hold on;
        
        %Plot (in NED coord frame) FRD coord frame
        res3 = R_ned_frd*frd_d;
        ends = [[0,0,0]; [0,0,0]; transpose(res3)];
        quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'red')
        hold off;
        
        % Plot settings
        %axis square;
        %axis equal;
        axis([-1 1 -1 1 -1 1]);
        %axis([-0.5 0.5 -0.5 0.5 -0.5 0.5]);
        title('NED coord frame: euler angles (FRD) evolution');
        xlabel('x-axis (North)');
        ylabel('y-axis (East)');
        zlabel('z-axis (Down)');
        set(gca,'YDir','reverse');
        set(gca,'ZDir','reverse');
        %text(0.5,0,' \leftarrow sin(\pi)','FontSize',18) 
        %hold off;
        drawnow;
        %pause(0.01);
    end
%     %Plot init
%     fig = figure;
%     for i = 1:length(x_arr); 
%         %Plot NED coord frame
%         ned_n = [1; 0; 0];
%         ned_e = [0; 1; 0];
%         ned_d = [0; 0; 1];
%         starts = zeros(3,3);
%         ends = [transpose(ned_n); transpose(ned_e); transpose(ned_d)];
%         quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'black')
%         hold on;
% 
%         %Plot (in NED coord frame) FRD C_tp_frd
%         Phi = [x_arr(4,i); x_arr(5,i); x_arr(6,i)];
%         phi = Phi(1);
%         theta = Phi(2);
%         psi = Phi(3);
%         % dcm = angle2dcm( yaw, pitch, roll); % 'ZYX' (default)
%         C_frd_tp = angle2dcm( psi, theta, phi, 'ZYX');
%         C_tp_frd = C_frd_tp^(-1);
%         frd_f = C_tp_frd*[1; 0; 0];
%         frd_r = C_tp_frd*[0; 1; 0];
%         frd_d = C_tp_frd*[0; 0; 1];
%         starts = zeros(3,3);
%         ends = [transpose(frd_f); transpose(frd_r); transpose(frd_d)];
%         quiver3(starts(:,1), starts(:,2), starts(:,3),...
%             ends(:,1), ends(:,2), ends(:,3),...
%             'red')
%         % 'MaxHeadSize', 1/norm(frd_f)
%         % 'Marker','.'
%         hold off;
% 
%         % Plot settings
%         %axis square;
%         %axis equal;
%         %axis([-1 1 -1 1 -1 1]);
%         %axis([-0.5 0.5 -0.5 0.5 -0.5 0.5]);
%         title('NED coord frame: pos of cm in NED (blue) vel of cm in NED (red)');
%         xlabel('x-axis (North)');
%         ylabel('y-axis (East)');
%         zlabel('z-axis (Down)');
%         set(gca,'YDir','reverse');
%         set(gca,'ZDir','reverse');
%         %text(0.5,0,' \leftarrow sin(\pi)','FontSize',18) 
%         %hold off;
%         drawnow;
%         pause(0.01);
%     end
% 
%     res = 0;
end

% function [ output_args ] = fnct_plot_in_NED_eulerang_FRD( euler_ang_arr )
% %FNCT_PLOT_IN_NED_EULERANG_FRD Summary of this function goes here
% %   Detailed explanation goes here
% 
%     fig = figure;
%     for i = 1:length(euler_ang_arr)
%         phi = euler_ang_arr(1,i);
%         theta = euler_ang_arr(2,i);
%         psi = euler_ang_arr(3,i);
%         % singularity at theta = 90 [deg] 
%         % this undefines theta_dot and phi_dot
% 
%         %Plot NED coord frame
%         ned_n = [1; 0; 0];
%         ned_e = [0; 1; 0];
%         ned_d = [0; 0; 1];
%         starts = zeros(3,3);
%         ends = [transpose(ned_n); transpose(ned_e); transpose(ned_d)];
%         quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'black')
%         hold on;
% 
%         %Plot (in NED coord frame) FRD coord frame
%         R_3_psi  = [cos(psi) sin(psi) 0; -sin(psi) cos(psi) 0; 0 0 1];
%         R_2_theta  = [cos(theta) 0 -sin(theta); 0 1 0; sin(theta) 0 cos(theta)];
%         R_1_phi  = [1 0 0; 0 cos(phi) sin(phi); 0 -sin(phi) cos(phi)];
%         %R_frd_ned = R_1_phi*R_2_theta*R_3_psi;
%         R_ned_frd = transpose(R_3_psi)*transpose(R_2_theta)*transpose(R_1_phi);
%         frd_f = [1; 0; 0];
%         frd_r = [0; 1; 0];
%         frd_d = [0; 0; 1];
%         res1 = R_ned_frd*frd_f;
%         res2 = R_ned_frd*frd_r;
%         res3 = R_ned_frd*frd_d;
%         ends = [transpose(res1); transpose(res2); transpose(res3)];
%         quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'blue')
%         hold on;
%         
%         %Plot (in NED coord frame) FRD coord frame
%         res3 = R_ned_frd*frd_d;
%         ends = [[0,0,0]; [0,0,0]; transpose(res3)];
%         quiver3(starts(:,1), starts(:,2), starts(:,3), ends(:,1), ends(:,2), ends(:,3), 'red')
%         hold off;
%         
%         % Plot settings
%         %axis square;
%         %axis equal;
%         axis([-1 1 -1 1 -1 1]);
%         %axis([-0.5 0.5 -0.5 0.5 -0.5 0.5]);
%         title('NED coord frame: euler angles (FRD) evolution');
%         xlabel('x-axis (North)');
%         ylabel('y-axis (East)');
%         zlabel('z-axis (Down)');
%         set(gca,'YDir','reverse');
%         set(gca,'ZDir','reverse');
%         %text(0.5,0,' \leftarrow sin(\pi)','FontSize',18) 
%         %hold off;
%         drawnow;
%         pause(0.01);
%     end
%     output_args = 1
% end
% 
