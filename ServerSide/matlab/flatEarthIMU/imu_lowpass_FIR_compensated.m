function res = imu_lowpass_FIR_compensated(time_arr, data_arr, dt, Fst)
    % [envHigh, envLow] = envelope(acc_arr(1,:),1,'peak');
    % envMean = (envHigh+envLow)/2;
    % plot(time_arr,acc_arr(1,:),time_arr,envMean)
    % plot(time_arr,acc_arr(1,:), ...
    %      time_arr,envHigh, ...
    %      time_arr,envMean, ...
    %      time_arr,envLow)
    
    for i = 1:size(data_arr,1)
        data_arr_i = data_arr(i,:);
        Fs = 1/dt;
        %N = size(time_arr,2);
        nfilt = 50;
        %Fst = 1;
        d = designfilt('lowpassfir','FilterOrder',nfilt, ...
            'CutoffFrequency',Fst,'SampleRate',Fs);
        xn = data_arr_i ;
        tn = time_arr;
        xf = filter(d,xn);

%         plot(tn,xn)
%         hold on, plot(tn,xf,'-r','linewidth',1.5), hold off
        
        % grpdelay(d,N,Fs)
        delay = mean(grpdelay(d));
        tt = tn(1:end-delay);
        sn = xn(1:end-delay);
        sf = xf;
        sf(1:delay) = [];
        
%         plot(tt,sn)
%         hold on, plot(tt,sf,'-r','linewidth',1.5), hold off
        size(sf)
        sf = [sf zeros(1,delay)];
        size(sf)
        size(data_arr(i,:))
        data_arr(i,:) = sf;
    end
    res = data_arr;
end