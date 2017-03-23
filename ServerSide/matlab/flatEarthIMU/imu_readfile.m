function [acc_arr, gyro_arr] = imu_readfile(filename)
    fileID = fopen(filename,'r');
    formatSpec = '%f %f %f %f %f %f';
    sizeA = [6 Inf];
    acc_gyro_arr = fscanf(fileID,formatSpec,sizeA);
    fclose(fileID);
    
    % acc_x  acc_y acc_z  gyro_x gyro_y gyro_z
    % -0.916 0.512 -0.083 1.341 0.427 -1.402
%     size(acc_gyro_arr)
%     acc_gyro_arr(:,1)
    
    acc_arr = [acc_gyro_arr(1,:); acc_gyro_arr(2,:); acc_gyro_arr(3,:)];
    acc_arr = acc_arr.*9.80665;
    gyro_arr = [acc_gyro_arr(4,:); acc_gyro_arr(5,:); acc_gyro_arr(6,:)];
    gyro_arr = gyro_arr.*pi./180;
    
%     return
%     
%     acc_x = acc_gyro_arr(1,:);
%     acc_y = acc_gyro_arr(2,:);
%     acc_z = acc_gyro_arr(3,:);
%     gyro_x = acc_gyro_arr(4,:);
%     gyro_y = acc_gyro_arr(5,:);
%     gyro_z = acc_gyro_arr(6,:);
%     
%     %Convert to [rad/s]
%     gyro_x = gyro_x.*pi./180;
%     gyro_y = gyro_y.*pi./180;
%     gyro_z = gyro_z.*pi./180;
%     
%     % Convert to vector form
%     gyro_arr = [...
%         transpose(gyro_x), ...
%         transpose(gyro_y), ...
%         transpose(gyro_z) ...
%         ];
%     acc_arr = [...
%         transpose(acc_x), ...
%         transpose(acc_y), ...
%         transpose(acc_z) ...
%         ];
%     %res = [acc_x, acc_y, acc_z, gyro_x, gyro_y, gyro_z];
end