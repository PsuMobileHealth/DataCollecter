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
    f_frd = [u(1); u(2); u(3)];
    M_frd = [u(4); u(5); u(6)];
    v_tp_wind_e = [u(7); u(8); u(9)];

    % Aux calculations
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DCM(Phi)
    phi = Phi(1);
    theta = Phi(2);
    psi = Phi(3);
    % dcm = angle2dcm( yaw, pitch, roll); % 'ZYX' (default)
    C_frd_tp = angle2dcm( psi, theta, phi, 'ZYX');
    C_tp_frd = C_frd_tp^(-1);
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
    g_tp = [0;0;9.80665];   % Replaceble by a more refined model (J2 model)
    a_frd_cm_i = f_frd + C_frd_tp*g_tp;
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
    e_r_tp_cm_e_dot = C_tp_frd*v_frd_cm_e;
    
    % Euler Kinematical Eq
    e_Phi_dot = H_Phi*w_frd_b_e;
    
    % Force Eq for cm
    b_v_frd_cm_e_dot = a_frd_cm_i - CPM_w_frd_b_e*v_frd_cm_e;
    
    % Euler Eq of motion (Momentum Eq)
    J_frd_inv = J_frd^(-1);
    b_w_frd_b_e_dot = J_frd_inv*( M_frd - CPM_w_frd_b_e*J_frd*w_frd_b_e );
    
    % Eq for the derivative of relative velocity of the cm wrt the wind
    v_frd_rel = v_frd_cm_e - C_frd_tp*v_tp_wind_e;
    b_v_frd_rel_dot = a_frd_cm_i - CPM_w_frd_b_e*v_frd_rel;
    
    xdot = [...
        e_r_tp_cm_e_dot;...
        e_Phi_dot;...
        b_v_frd_cm_e_dot;...
        b_w_frd_b_e_dot;...
        b_v_frd_rel_dot...
        ];

    % Desired output variables
    y = [];
end
