function [xnew]= rk4(fdyn, finp, time, dt, xcurr, u0)

%Performs 4th order Runge-Kutta Integration of the equations xdot=f(t,x,u)
% Function fdyn is dynamic model.
% Function finp determines input as a function of time.
% Variable time is current time (used to find input and for time varying dynamics).
% Time step  = dt
% Value of state vector at current time = xcurr
% Returns state vector at time t+dt

%u=feval(finp,time,u0);
index_tcurr = round(time+dt/dt) + 1;    % index start at 1
ucurr = finp(index_tcurr,:);

[xd,y] = feval(fdyn,time,xcurr,ucurr);
k1 = dt*xd;

%u=feval(finp,time+0.5*dt,u0);
index_tnext= round((time+dt)/dt) + 1;    % index start at 1
umiddle = 0.5.*(finp(index_tcurr,:) + finp(index_tnext,:));

[xd,y] = feval(fdyn,time+0.5*dt,xcurr+0.5*k1,umiddle);
k2 = dt*xd;
[xd,y] = feval(fdyn,time+0.5*dt,xcurr+0.5*k2,umiddle);
k3 = dt*xd;

%u = feval(finp,time+dt,u0);
index_tnext= round((time+dt)/dt) + 1;    % index start at 1
unext = finp(index_tnext,:);

[xd,y] = feval(fdyn,time+dt,xcurr+k3,unext);
k4 = dt*xd;

xnew = xcurr + k1/6 + k2/3 + k3/3 + k4/6;

return;