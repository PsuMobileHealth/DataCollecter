
import sys

from sspkg import file_parser, plt_wrapper, filters


if __name__ == "__main__":
    # fname = "../test/2016_12_06_v2_toopazo.txt"
    fname_list = []
    for i in range(1, len(sys.argv)):
        fname_list.append(sys.argv[i])
    accdata_arr_list = []
    acctime_arr_list = []
    gyrodata_arr_list = []
    gyrotime_arr_list = []
    for fname_i in fname_list:
        print(fname_i)
        fileparser = file_parser.AccGyroFileParser()
        header, acc_time_arr, acc_data_arr, gyro_time_arr, gyro_data_arr = fileparser.parse_re(fname_i)

        # acc_arr, gyro_arr = filters.FilterData.gyro_filter_below_treshold(acc_arr, gyro_arr)

        acctime_arr_list.append(acc_time_arr)
        accdata_arr_list.append(acc_data_arr)
        gyrotime_arr_list.append(gyro_time_arr)
        gyrodata_arr_list.append(gyro_data_arr)
    arg = "len(acc_arr_list) %s" % len(accdata_arr_list)
    print(arg)
    arg = "len(gyro_arr_list) %s" % len(gyrodata_arr_list)
    print(arg)

    plotter = plt_wrapper.PltWrapper()
    semi_length = 1
    plotter.plot_acc_gyro_3dquiver(semi_length, acctime_arr_list, accdata_arr_list, gyrotime_arr_list, gyrodata_arr_list)
    # plotter.plot_2_acc_gyro_3dquiver(semi_length, acc_arr, gyro_arr)

    # # 1 arrow
    # nlines, U_arr, V_arr, W_arr = accelparser.parse(fname)
    # plotter.plot_1arrow_3dquiver(semi_length, U_arr, V_arr, W_arr)

