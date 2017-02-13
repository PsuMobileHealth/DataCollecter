function [acc_x, acc_y, acc_z, gyro_x, gyro_y, gyro_z] = fnct_readfile(filename)
    fileID = fopen(filename,'r');
    formatSpec = '%f %f %f %f %f %f';
    sizeA = [6 Inf];
    acc_gyro_arr = fscanf(fileID,formatSpec,sizeA);
    fclose(fileID);
    
    acc_x = acc_gyro_arr(1,:);
    acc_y = acc_gyro_arr(2,:);
    acc_z = acc_gyro_arr(3,:);
    gyro_x = acc_gyro_arr(4,:);
    gyro_y = acc_gyro_arr(5,:);
    gyro_z = acc_gyro_arr(6,:);
    
    %res = [acc_x, acc_y, acc_z, gyro_x, gyro_y, gyro_z];
end