import math
import numpy as np
from sspkg import file_parser, plt_wrapper, methods


class Gnrl():
    def find_dcm(self, parsedfile, a, b):
        acc_deltat, acc_x_mean, acc_y_mean, acc_z_mean, acc_x_std, acc_y_std, acc_z_std, acc_magn,\
        gyro_deltat, gyro_x_mean, gyro_y_mean, gyro_z_mean, gyro_x_std, gyro_y_std, gyro_z_std, gyro_magn  \
            = self.statinfo(parsedfile, a, b)

        acc_norm = [acc_x_mean/acc_magn, acc_y_mean/acc_magn, acc_z_mean/acc_magn]
        # [x0; y0; z0] = R_frd_ned*[0; 0; -1]
        R_frd_ned = [[]]

        # quaternion
        # qu0 = [cos(phi0 / 2) * cos(theta0 / 2) * cos(psi0 / 2) + sin(phi0 / 2) * sin(theta0 / 2) * sin(psi0 / 2);
        # sin(phi0 / 2) * cos(theta0 / 2) * cos(psi0 / 2) - cos(phi0 / 2) * sin(theta0 / 2) * sin(psi0 / 2);
        # cos(phi0 / 2) * sin(theta0 / 2) * cos(psi0 / 2) + sin(phi0 / 2) * cos(theta0 / 2) * sin(psi0 / 2);
        # cos(phi0 / 2) * cos(theta0 / 2) * sin(psi0 / 2) - sin(phi0 / 2) * sin(theta0 / 2) * cos(psi0 / 2)];
        # quat = qu0;

    def statinfo(self, parsedfile, a, b):
        a = int(a)
        b = int(b)

        acc_time_a = parsedfile.acc_t_arr[a]
        acc_time_b = parsedfile.acc_t_arr[b]
        acc_deltat = acc_time_b - acc_time_a
        gyro_time_a = parsedfile.gyro_t_arr[a]
        gyro_time_b = parsedfile.gyro_t_arr[b]
        gyro_deltat = gyro_time_b - gyro_time_a

        acc_x_arr = np.array(parsedfile.acc_x_arr[a:b])
        acc_x_mean = acc_x_arr.mean()
        acc_x_std = acc_x_arr.std()
        acc_y_arr = np.array(parsedfile.acc_y_arr[a:b])
        acc_y_mean = acc_y_arr.mean()
        acc_y_std = acc_y_arr.std()
        acc_z_arr = np.array(parsedfile.acc_z_arr[a:b])
        acc_z_mean = acc_z_arr.mean()
        acc_z_std = acc_z_arr.std()
        acc_magn = math.sqrt(acc_x_mean**2 + acc_y_mean**2 + acc_z_mean**2)

        gyro_x_arr = np.array(parsedfile.gyro_x_arr[a:b])
        gyro_x_mean = gyro_x_arr.mean()
        gyro_x_std = gyro_x_arr.std()
        gyro_y_arr = np.array(parsedfile.gyro_y_arr[a:b])
        gyro_y_mean = gyro_y_arr.mean()
        gyro_y_std = gyro_y_arr.std()
        gyro_z_arr = np.array(parsedfile.gyro_z_arr[a:b])
        gyro_z_mean = gyro_z_arr.mean()
        gyro_z_std = gyro_z_arr.std()
        gyro_magn = math.sqrt(gyro_x_mean**2 + gyro_y_mean**2+gyro_z_mean**2)

        arg = "acc_time_a %s, acc_time_b %s, acc_deltat %s " % (acc_time_a, acc_time_b, acc_deltat)
        print(arg)
        arg = "acc_mean_deltat %s " % (acc_deltat / parsedfile.acc_len)
        print(arg)
        arg = "acc_x_mean %s, acc_x_std %s" % (acc_x_mean, acc_x_std)
        print(arg)
        arg = "acc_y_mean %s, acc_y_std %s" % (acc_y_mean, acc_y_std)
        print(arg)
        arg = "acc_z_mean %s, acc_z_std %s" % (acc_z_mean, acc_z_std)
        print(arg)
        arg = "acc_magn %s" % acc_magn
        print(arg)

        arg = "gyro_time_a %s, gyro_time_b %s, gyro_deltat %s " % (gyro_time_a, gyro_time_b, gyro_deltat)
        print(arg)
        arg = "gyro_mean_deltat %s " % (gyro_deltat/parsedfile.gyro_len)
        print(arg)
        arg = "gyro_x_mean %s, gyro_x_std %s" % (gyro_x_mean, gyro_x_std)
        print(arg)
        arg = "gyro_y_mean %s, gyro_y_std %s" % (gyro_y_mean, gyro_y_std)
        print(arg)
        arg = "gyro_z_mean %s, gyro_z_std %s" % (gyro_z_mean, gyro_z_std)
        print(arg)
        arg = "gyro_magn %s" % gyro_magn
        print(arg)
        arg = "**********************************"
        print(arg)

        return [acc_deltat, acc_x_mean, acc_y_mean, acc_z_mean, acc_x_std, acc_y_std, acc_z_std, acc_magn,
                gyro_deltat, gyro_x_mean, gyro_y_mean, gyro_z_mean, gyro_x_std, gyro_y_std, gyro_z_std, gyro_magn]





class FilterData():
    @staticmethod
    def gyro_filter_below_treshold(acc_arr, gyro_arr):
        # -0.305, 0.427, -0.732
        magn_ref = math.sqrt(0.305**2 + 0.427**2 + 0.732**2)
        for i in range(0,len(acc_arr)):
            magn_i = math.sqrt(gyro_arr[i][0]**2 + gyro_arr[i][1]**2 + gyro_arr[i][2]**2)
            # if magn_i > 10:
            #     print(magn_i)
            if magn_i <= magn_ref*1.5:
                gyro_arr[i][0] = 0
                gyro_arr[i][1] = 0
                gyro_arr[i][2] = 0
        return (acc_arr, gyro_arr)