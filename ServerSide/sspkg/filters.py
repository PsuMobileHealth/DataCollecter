import math


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