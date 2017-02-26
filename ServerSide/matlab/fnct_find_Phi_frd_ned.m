function res = fnct_find_Phi_frd_ned(v_frd, v_ned, x0)
    res = fsolve(@function2, x0);
    %function2(res)
    
    function [fx] = function2(x)
%         q0 = x(1);
%         q1 = x(2);
%         q2 = x(3);
%         q3 = x(4);
%         c11 = q0^2 + q1^2 - q2^2 - q3^2;
%         c12 = 2*(q1*q2 + q0*q3);
%         c13 = 2*(q1*q3 - q0*q2);
%         c21 = 2*(q0*q1 - q0*q2);
%         c22 = q0^2 - q1^2 + q2^2 - q3^2;
%         c23 = 2*(q2*q3 + q0*q1);
%         c31 = 2*(q1*q3 + q0*q2);
%         c32 = 2*(q2*q3 - q0*q1);
%         c33 = q0^2 - q1^2 - q2^2 + q3^2;
        
        phi = x(1);
        theta = x(2);
        psi = x(3);
        c11 = cos(theta)*cos(psi);
        c12 = cos(theta)*sin(psi);
        c13 = -sin(theta);
        c21 = -cos(phi)*sin(psi) + sin(phi)*sin(theta)*cos(psi);
        c22 = cos(phi)*cos(psi) + sin(phi)*sin(theta)*sin(psi);
        c23 = sin(phi)*cos(theta);
        c31 = sin(phi)*sin(psi) + cos(phi)*sin(theta)*cos(psi);
        c32 = -sin(phi)*cos(psi) + cos(phi)*sin(theta)*sin(psi);
        c33 = cos(phi)*cos(theta);
        
        R_frd_ned = [c11, c12, c13; c21, c22, c23; c31, c32, c33];
        f1 = R_frd_ned*v_ned - v_frd;
        f2 = [0; 0; psi];   % No heading difference between NED and FRD
        fx = [f1 f2];
    end
end