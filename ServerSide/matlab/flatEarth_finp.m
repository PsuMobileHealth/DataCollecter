function [u]= flatEarth_finp(t, u0)

    if (t<1.)
        ff = 0;
        fr = 0;
        fd = 0;
        l = 0;
        m = 0;
        n = 0;
        windn = 0;
        winde = 0;
        windd = 0;
    elseif (t<3.)
        ff = 0.05;
        fr = 0.05;
        fd = -30.5;
%         l = 0.1;
%         m = 0.1;
%         n = 0.2;
        l = 0.005;
        m = 0.01;
        n = 0;
        windn = 0;
        winde = 0;
        windd = 0;
    else
        ff = 0;
        fr = 0;
        fd = 0;
        l = 0;
        m = 0;
        n = 0;
        windn = 0;
        winde = 0;
        windd = 0;
    end;
    % Inputs to the system
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    f_frd = [ff; fr; fd];
    M_frd = [l; m; n];
    v_tp_wind_e = [windn; winde; windd];
    u = [f_frd; M_frd; v_tp_wind_e];
end