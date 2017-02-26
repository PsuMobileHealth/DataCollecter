function [edot, y] = fnct_EulerKinematicalEq(t,e,omega)
    %Function for Euler Kinematics
    % Input: time, current Euler angles (vector e), and current angular
    % velocity (vector omega)
    % Output: time rate of change of the Euler angles, (the vector edot)

    p = omega(1);
    q = omega(2);
    r = omega(3);
    phi = e(1);
    theta = e(2);
    psi = e(3);

    sphi = sin(phi);
    cphi = cos(phi);
    sthe = sin(theta);
    cthe = cos(theta);
    
    phidot = p+q*sthe*sphi/cthe+r*sthe*cphi/cthe;
    thetadot = q*cphi-r*sphi;
    psidot = q*sphi/cthe+r*cphi/cthe;
    
    edot = [phidot;thetadot;psidot];
    %No output variables
    y = [];
end