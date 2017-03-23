function [xdot, y]= flatEarth_fdyn(t,x,u)

    % Position of cm wrt 'inertial' ecef in tp coord
    r_tp_cm_e = [x(1); x(2); x(3)];
    % Euler Angles of DCM R_frd_tp. Phi = [phi; thta; psi]
    Phi = [x(4); x(5); x(6)];
    % Velocity of cm wrt 'inertial' ecef in frd coord
    v_frd_cm_e = [x(7); x(8); x(9)];
    % Angular Velocity of b-frame wrt ecef in frd coord
    w_frd_b_e = [x(10); x(11); x(12)];
    % Relative velocity of the cm wrt the wind
    v_frd_rel = [x(13); x(14); x(15)];
    
    x = [r_tp_cm_e; Phi; v_frd_cm_e; w_frd_b_e; v_frd_rel];
    
    % Inputs to the system
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     f_frd = [u(1); u(2); u(3)];
%     M_frd = [u(4); u(5); u(6)];
%     v_tp_wind_e = [u(7); u(8); u(9)];
    M_frd = [0; 0; 0];
    v_tp_wind_e = [0; 0; 0];

    f_frd = [u(1); u(2); u(3)]; % acc data
    w_frd_b_e = [u(4); u(5); u(6)];

    % Aux calculations
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DCM(Phi)
    phi = Phi(1);
    theta = Phi(2);
    psi = Phi(3);
    % dcm = angle2dcm( yaw, pitch, roll); % 'ZYX' (default)
    C_frd_tp = angle2dcm( psi, theta, phi, 'ZYX');
    C_tp_frd = transpose(C_frd_tp);     %C_frd_tp^(-1);
    % H(Phi) matrix from Euler Kinametical Eq
    H_Phi = [...
        [1, sin(phi)*tan(theta), cos(phi)*tan(theta)];...
        [0, cos(phi), -sin(phi)];...
        [0, sin(phi)/cos(theta), cos(phi)/cos(theta)]...
        ];
    % CPM_u = Cross Prod Matrix of u => CPM_u*v <==> cross(u,v)
    ux = w_frd_b_e(1);
    uy = w_frd_b_e(2);
    uz = w_frd_b_e(3);
    CPM_w_frd_b_e = [...
        [0, -uz, uy];...
        [uz, 0, -ux];...
        [-uy, ux, 0]...
        ];
    % Total acceleration in the inertial frame
    % Output from an acc sensor in the cm of the flying body
    g_magn = 9.80665;
    g_tp = [0;0;g_magn];   % Replaceble by a more refined model (J2 model)
    a_frd_cm_e = f_frd + C_frd_tp*g_tp;
    % Intertia Matri J
    Jf = 3;
    Jr = 1;
    Jd = 2;
    J_frd = [...
        [Jf, 0, 0];...
        [0, Jr, 0];...
        [0, 0, Jd]...
    ];

    % Dynamic system
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Position Eq (Navigation)
    e_rdot_tp_cm_e = C_tp_frd*v_frd_cm_e;
    
    % Euler Kinematical Eq
    e_Phidot = H_Phi*w_frd_b_e;
    
    % Force Eq for cm
    b_vdot_frd_cm_e = 0.9*a_frd_cm_e - 0.1*CPM_w_frd_b_e*v_frd_cm_e;
    %b_vdot_frd_cm_e = a_frd_cm_e - cross(w_frd_b_e,v_frd_cm_e);  %CPM_w_frd_b_e*v_frd_cm_e;
    
    % Euler Eq of motion (Momentum Eq)
    J_frd_inv = J_frd^(-1);
    b_wdot_frd_b_e = J_frd_inv*( M_frd - cross(w_frd_b_e,J_frd*w_frd_b_e) );%CPM_w_frd_b_e*J_frd*w_frd_b_e );
    
    % Eq for the derivative of relative velocity of the cm wrt the wind
    v_frd_rel = v_frd_cm_e - C_frd_tp*v_tp_wind_e;
    b_vdot_frd_rel = a_frd_cm_e - CPM_w_frd_b_e*v_frd_rel;
   
%     disp(sprintf('t = %f acc_f = %f, gyro_f = %f', t, u(1), u(4)))
%     disp(sprintf('t = %f acc_r = %f, gyro_r = %f', t, u(2), u(5)))    
%     disp(sprintf('t = %f acc_d = %f, gyro_d = %f', t, u(3), u(6)))    
    xdot = [...
        e_rdot_tp_cm_e;...
        e_Phidot;...
        b_vdot_frd_cm_e;...
        b_wdot_frd_b_e;...
        b_vdot_frd_rel...
        ];
   

    % Desired output variables
    y = [];
    
    % Debug info
%     disp(sprintf('t = %f f_frd_f = %f f_frd_r = %f f_frd_d = %f', ...
%         t, f_frd(1), f_frd(2), f_frd(3)))
%     if norm(f_frd) > g_magn
%         disp(sprintf('t = %f f_frd_magn = %f > g_magn  (rising)', t, norm(f_frd)))
%     else
%         disp(sprintf('t = %f f_frd_magn = %f < g_magn  (falling)', t, norm(f_frd)))
%     end
    g_frd = C_frd_tp*g_tp;
    disp(sprintf('t = %f g_frd_f = %f g_frd_r = %f g_frd_d = %f g_frd_magn = %f', ...
        t, g_frd(1), g_frd(2), g_frd(3), norm(g_frd)))
    
    disp(sprintf('t = %f f_frd_f = %f f_frd_r = %f f_frd_d = %f f_frd_magn = %f', ...
        t, f_frd(1), f_frd(2), f_frd(3), norm(f_frd)))
    
    disp(sprintf('t = %f a_frd_f = %f a_frd_r = %f a_frd_d = %f a_frd_magn = %f', ...
        t, a_frd_cm_e(1), a_frd_cm_e(2), a_frd_cm_e(3), norm(a_frd_cm_e)))
    
    disp(sprintf('t = %f v_frd_f = %f v_frd_r = %f v_frd_d = %f v_frd_magn = %f', ...
        t, v_frd_cm_e(1), (2), v_frd_cm_e(3), norm(v_frd_cm_e)))
        
    w_frd_cm_e = - cross(w_frd_b_e,v_frd_cm_e);
    disp(sprintf('t = %f w_frd_f = %f w_frd_r = %f w_frd_d = %f w_frd_magn = %f', ...
        t, w_frd_cm_e(1), w_frd_cm_e(2), w_frd_cm_e(3), norm(w_frd_cm_e)))
    
    t_frd_cm_e = b_vdot_frd_cm_e;
    disp(sprintf('t = %f t_frd_f = %f t_frd_r = %f t_frd_d = %f t_frd_magn = %f', ...
        t, t_frd_cm_e(1), t_frd_cm_e(2), t_frd_cm_e(3), norm(t_frd_cm_e) ))
    disp('------------------------------------------')
    
end
