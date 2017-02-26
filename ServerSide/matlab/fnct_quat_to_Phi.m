function Phi = fnct_quat_to_Phi(q)      
    q0 = q(1);
    q1 = q(2);
    q2 = q(3);
    q3 = q(4);
    c11 = q0^2 + q1^2 - q2^2 - q3^2;
    c12 = 2*(q1*q2 + q0*q3);
    c13 = 2*(q1*q3 - q0*q2);
    c21 = 2*(q1*q2 - q0*q3);
    c22 = q0^2 - q1^2 + q2^2 - q3^2;
    c23 = 2*(q2*q3 + q0*q1);
    c31 = 2*(q1*q3 + q0*q2);
    c32 = 2*(q2*q3 - q0*q1);
    c33 = q0^2 - q1^2 - q2^2 + q3^2;
    phi = atan2(c23,c33);
    theta = -asin(c13);
    psi = atan2(c12,c11);
    Phi = [phi; theta; psi];
%     R = [...
%         [ c11, c12, c13 ];...
%         [ c21, c22, c23 ];...
%         [ c31, c32, c33 ]
%         ];
end