
from mpl_toolkits.mplot3d import axes3d
import matplotlib.pyplot as plt
import numpy as np
import sys
import time
import random
import re
import ast
import math


class FilterData():
    @staticmethod
    def gyro_filter_below_treshold(acc_arr, gyro_arr):
        # -0.305, 0.427, -0.732
        magn_ref = math.sqrt(0.305**2 + 0.427**2 + 0.732**2)
        for i in range(0,len(acc_arr)):
            magn_i = math.sqrt(gyro_arr[i][0]**2 + gyro_arr[i][1]**2 + gyro_arr[i][2]**2)
            #if magn_i > 10:
            #    print(magn_i)
            if magn_i <= magn_ref*1.5:
                gyro_arr[i][0] = 0
                gyro_arr[i][1] = 0
                gyro_arr[i][2] = 0
        return (acc_arr, gyro_arr)


class PltWrapper():

    def plot_2_acc_gyro_3dquiver(self, lim, acc_arr, gyro_arr):
        grid_axis = np.arange(-lim, lim + 1, 1)
        # grid_axis = np.arange(0, lim+1, 1)
        X_grid, Y_grid, Z_grid = np.meshgrid(grid_axis, grid_axis, grid_axis)
        U_grid = np.zeros(X_grid.shape)
        V_grid = np.zeros(Y_grid.shape)
        W_grid = np.zeros(Z_grid.shape)

        plt.ion()
        fig = plt.figure()
        for i in range(0, len(acc_arr)):
            # acc
            # non-zero value at point (x, y, z)
            U_grid[lim, lim, lim] = acc_arr[i][0]
            V_grid[lim, lim, lim] = acc_arr[i][1]
            W_grid[lim, lim, lim] = acc_arr[i][2]
            # non-zero value at point (x, y, z)
            U_grid[0, lim*2, lim] = acc_arr[i][0]
            V_grid[0, lim*2, lim] = acc_arr[i][1]
            W_grid[0, lim*2, lim] = acc_arr[i][2]

            # plot acc
            ax = fig.gca(projection='3d')
            # ax = fig.add_subplot(111, projection='3d')
            ax.quiver(X_grid, Y_grid, Z_grid, U_grid, V_grid, W_grid, pivot='tail', color='b')  # , scale=1

            # gyro
            # non-zero value at point (x, y, z)
            U_grid[lim, lim, lim] = gyro_arr[i][0]
            V_grid[lim, lim, lim] = gyro_arr[i][1]
            W_grid[lim, lim, lim] = gyro_arr[i][2]
            # non-zero value at point (x, y, z)
            U_grid[0, lim*2, lim] = gyro_arr[i][0]
            V_grid[0, lim*2, lim] = gyro_arr[i][1]
            W_grid[0, lim*2, lim] = gyro_arr[i][2]

            # plot gyro
            ax.quiver(X_grid, Y_grid, Z_grid, U_grid, V_grid, W_grid, pivot='tail', color='r')  # , scale=1

            # plot axes, info and refresh
            ax.set_xlim([-lim, lim])
            ax.set_ylim([-lim, lim])
            ax.set_zlim([-lim, lim])
            ax.set_xlabel('Y Label')
            ax.set_ylabel('X Label')
            ax.set_zlabel('Z Label')
            # ax.invert_xaxis()
            # plt.show()
            plt.draw()
            plt.pause(0.001)
            # plt.clf()
            plt.cla()

        plt.close()

    def plot_acc_gyro_3dquiver(self, lim, acc_arr_list, gyro_arr_list):
        grid_axis = np.arange(-lim, lim + 1, 1)
        # grid_axis = np.arange(0, lim+1, 1)
        X_grid, Y_grid, Z_grid = np.meshgrid(grid_axis, grid_axis, grid_axis)
        U_grid = np.zeros(X_grid.shape)
        V_grid = np.zeros(Y_grid.shape)
        W_grid = np.zeros(Z_grid.shape)

        # init plot settings
        plt.ion()
        fig = plt.figure()
        ax = fig.gca(projection='3d')
        # ax = fig.add_subplot(111, projection='3d')
        #for sample_i in range(0, len(acc_arr)):
        sample_i = -1
        while True:
            sample_i += 1

            no_samples_left = True
            # for every board_i plot acc data
            for board_i in range(0, len(acc_arr_list)):
                deltay = board_i
                acc_arr = acc_arr_list[board_i]
                try:
                    U_grid[lim, 0+deltay, lim] = acc_arr[sample_i][0]
                    V_grid[lim, 0+deltay, lim] = acc_arr[sample_i][1]
                    W_grid[lim, 0+deltay, lim] = acc_arr[sample_i][2]
                    no_samples_left = False
                except IndexError:
                    pass
            ax.quiver(X_grid, Y_grid, Z_grid, U_grid, V_grid, W_grid, pivot='tail', color='b')  # , scale=1

            # for every board_i plot gyro data
            for board_i in range(0, len(acc_arr_list)):
                deltay = board_i
                gyro_arr = gyro_arr_list[board_i]
                try:
                    U_grid[lim, 0+deltay, lim] = gyro_arr[sample_i][0]
                    V_grid[lim, 0+deltay, lim] = gyro_arr[sample_i][1]
                    W_grid[lim, 0+deltay, lim] = gyro_arr[sample_i][2]
                    no_samples_left = False
                except IndexError:
                    pass
            ax.quiver(X_grid, Y_grid, Z_grid, U_grid, V_grid, W_grid, pivot='tail', color='r')  # , scale=1

            # plot axes, info and refresh
            # ax.axis([-lim*10, lim*10, -lim*10, lim*10, -lim*10, lim*10])
            ax.set_xlim([-lim, lim])
            ax.set_ylim([-lim, lim])
            ax.set_zlim([-lim, lim])
            # ax.autoscale(True)
            ax.set_xlabel('Y Label')
            ax.set_ylabel('X Label')
            ax.set_zlabel('Z Label')
            # ax.invert_xaxis()

            plt.show()
            # plt.draw()
            plt.pause(0.001)
            #plt.clf()
            plt.cla()

            if no_samples_left:
                break
        plt.close()

    def plot_1arrow_3dquiver(self, lim, u_arr, v_arr, w_arr):
        grid_axis = np.arange(-lim, lim + 1, 1)
        # grid_axis = np.arange(0, lim+1, 1)
        X_grid, Y_grid, Z_grid = np.meshgrid(grid_axis, grid_axis, grid_axis)
        U_grid = np.zeros(X_grid.shape)
        V_grid = np.zeros(Y_grid.shape)
        W_grid = np.zeros(Z_grid.shape)

        plt.ion()
        fig = plt.figure()
        for i in range(0, len(u_arr)):
            # non-zero value at point (x, y, z)
            U_grid[lim, lim, lim] = u_arr[i]
            V_grid[lim, lim, lim] = v_arr[i]
            W_grid[lim, lim, lim] = w_arr[i]

            ax = fig.gca(projection='3d')
            # ax = fig.add_subplot(111, projection='3d')
            ax.quiver(X_grid, Y_grid, Z_grid, U_grid, V_grid, W_grid, pivot='tail')  # , scale=1
            ax.set_xlim([-lim, lim])
            ax.set_ylim([-lim, lim])
            ax.set_zlim([-lim, lim])
            ax.set_xlabel('Y Label')
            ax.set_ylabel('X Label')
            ax.set_zlabel('Z Label')
            # ax.invert_xaxis()

            # plt.show()
            plt.draw()
            plt.pause(0.001)
            # plt.clf()
            plt.cla()

        plt.close()


class AccelFileParser():
    def parse_re(self, fname):
        match_non_a_z_chars = '[^a-z]'
        re_whitespace = '\s'     # Matches any whitespace character; this is equivalent to the class [ \t\n\r\f\v].
        re_alphanumeric = '\w'   # Matches any alphanumeric character; this is equivalent to the class [a-zA-Z0-9_]
        re_numbers = '[0-9.]'
        # {manufacturer: MbientLab Inc, serialNumber: 00CADE, firmwareRevision: 1.2.2, hardwareRevision: 0.3, modelNumber: 2}
        re_header_key = '[{,][-.+\s\w]+[:]'
        re_header_key_obj = re.compile(re_header_key)
        re_header_val = '[:][-.+\s\w]+[,}]'
        re_header_val_obj = re.compile(re_header_val)
        re_gyro = '.*gyro_stream.*'
        re_gyro_obj = re.compile(re_gyro)
        re_acc = '.*acc_stream.*'
        re_acc_obj = re.compile(re_acc)
        re_number = '[+-]?\d+\.\d+|[+-]?\d+'
        re_number_obj = re.compile(re_number)

        nlines = 0
        header = ""
        gyro_arr = []
        acc_arr = []
        statevar = "first"
        with open(fname) as fp:
            for line in fp:
                nlines += 1
                if nlines == 1:
                    #print(line)
                    #header = ast.literal_eval(line)
                    line = line.replace(', ',',')
                    line = line.replace(': ', ':')
                    key_match = re_header_key_obj.findall(line)
                    key_match = [x[1:len(x)-1] for x in key_match]
                    #print("key_match")
                    #print(key_match)
                    val_match = re_header_val_obj.findall(line)
                    val_match = [x[1:len(x) - 1] for x in val_match]
                    #print("val_match")
                    #print(val_match)
                    header = dict(zip(key_match, val_match))
                    #print(header)

                else:
                    gyro_match = re_gyro_obj.search(line)
                    acc_match = re_acc_obj.search(line)
                    tuple_match = re_number_obj.findall(line.split('(')[1])
                    if (gyro_match is not None) and (len(tuple_match) == 3):
                        #arg = 'Match at line %s' % nlines
                        #print(arg)
                        #print(gyro_match.group())
                        #print(tuple_match)

                        if (statevar == "first") or (statevar == "acc"):
                            tuple_match = [float(x) for x in tuple_match]
                            gyro_arr.append(tuple_match)
                            statevar = "gyro"
                        #print(gyro_match)
                    elif (acc_match is not None) and (len(tuple_match) == 3):
                        if (statevar == "first") or (statevar == "gyro"):
                            tuple_match = [float(x) for x in tuple_match]
                            acc_arr.append(tuple_match)
                            statevar = "acc"
                    else:
                        arg = 'No match at line %s' % nlines
                        print(arg)

        # make them of the same length
        if len(gyro_arr) > len(acc_arr):
            gyro_arr.pop()
        if len(gyro_arr) < len(acc_arr):
            acc_arr.pop()

        #arg = "header keys = %s" % len(header)
        #print(arg)
        #arg = "header len = 1"
        #print(arg)
        arg = "acc len = %s" % len(acc_arr)
        print(arg)
        arg = "gyro len = %s" % len(gyro_arr)
        print(arg)
        arg = "header + acc + gyro = %s" % (len(acc_arr)+len(gyro_arr)+1)
        print(arg)
        arg = "lines in file = %s" % nlines
        print(arg)

        return (header, acc_arr, gyro_arr)

    def parse(self, fname):
        with open(fname) as f:
            content = f.readlines()
        lines = []
        U_grid = []
        V_grid = []
        W_grid = []
        for e in content:
            # "*(\d"
            if "I/tutorial:" in e:
                lines_arr = e.split('(')
                lines_arr = lines_arr[1]
                lines_arr = lines_arr.split(')')
                lines_arr = lines_arr[0]
                lines_arr = lines_arr.split(',')
                # lines.append(lines_arr[0])
                U_grid.append(lines_arr[0])
                V_grid.append(lines_arr[1])
                W_grid.append(lines_arr[2])

        return [len(U_grid), U_grid, V_grid, W_grid]
        # sys.exit(0)

if __name__ == "__main__":
    #fname = "../test/2016_12_06_v2_toopazo.txt"
    fname_list = []
    for i in range(1, len(sys.argv)):
        fname_list.append(sys.argv[i])
    acc_arr_list = []
    gyro_arr_list = []
    for fname_i in fname_list:
        print(fname_i)
        accelparser = AccelFileParser()
        header, acc_arr, gyro_arr = accelparser.parse_re(fname_i)

        #acc_arr, gyro_arr = FilterData.gyro_filter_below_treshold(acc_arr, gyro_arr)

        acc_arr_list.append(acc_arr)
        gyro_arr_list.append(gyro_arr)
    arg = "len(acc_arr_list) %s" % len(acc_arr_list)
    print(arg)
    arg = "len(gyro_arr_list) %s" % len(gyro_arr_list)
    print(arg)

    plotter = PltWrapper()
    semi_length = 1
    plotter.plot_acc_gyro_3dquiver(semi_length, acc_arr_list, gyro_arr_list)
    #plotter.plot_2_acc_gyro_3dquiver(semi_length, acc_arr, gyro_arr)

    ## 1 arrow
    #nlines, U_arr, V_arr, W_arr = accelparser.parse(fname)
    #plotter.plot_1arrow_3dquiver(semi_length, U_arr, V_arr, W_arr)

