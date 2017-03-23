function res = imu_find_q_ned_frd(v_ned, v_frd, psi, x0)
    %x0 = transpose(x0);
    v_frd = transpose(v_frd);
    v_ned = transpose(v_ned);
    res = fsolve(@function2, x0);
    %res = transpose(res);
    %function2(res)
    
    function [fx] = function2(x)
        q0 = x(1);
        q1 = x(2);
        q2 = x(3);
        q3 = x(4);
        q = [q0 q1 q2 q3];
        r = v_frd;
        n = v_ned;
%         r = [0, v_frd];
%         n = [0, v_ned];
                
        % We are looking for a solution to 
        % n = quatinv(q)*r*q
        % 1.0 = quatnorm(q)
        % atan2(c12(q), c11(q)) = 0
        
        f1 = quatnorm(q) - 1;
        f2 = quatrotate(q, r) - n;  % quatinv(q)*r*q - n
        c11 = q0^2 + q1^2 - q2^2 - q3^2;
        c12 = 2*(q1*q2 + q0*q3);
        f3 = atan2(c12,c11) - psi;    % No heading difference between NED and FRD
        %f3 = 0;
        
        fx = [f1 f2 f3];
        
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
    end
end