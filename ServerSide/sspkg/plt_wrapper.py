from mpl_toolkits.mplot3d import axes3d, Axes3D
import matplotlib.pyplot as plt
import matplotlib as mplt
import numpy as np
import math


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

    def plot_acc_gyro_3dquiver(self, lim, acctime_arr_list, accdata_arr_list, gyrotime_arr_list, gyrodata_arr_list):
        arg = 'Warning:  The plot is not at perfect scale, acc and gyro arrow sizes between samples are the same\n' \
              'As of 2017 there are apparently still issues with the matplotlib library with respect to xyz \n' \
              'orientation and with respect to "Varying arrow length in 3D quiver in matplotlib \n' \
              'See: http://stackoverflow.com/questions/35887058/varying-arrow-length-in-3d-quiver-in-matplotlib \n' \
              'matplotlib vesion at the time of coding this message is 1.5.3 \n' \
              'matplotlib vesion at the time of coding this message is %s\"' % mplt.__version__
        print(arg)

        grid_axis = np.arange(-lim, lim + 1, 1)
        # grid_axis = np.arange(0, lim+1, 1)
        X_grid, Y_grid, Z_grid = np.meshgrid(grid_axis, grid_axis, grid_axis)
        U_grid = np.zeros(X_grid.shape)
        V_grid = np.zeros(Y_grid.shape)
        W_grid = np.zeros(Z_grid.shape)

        # init plot settings
        title_time_arg = "datetime array "
        plt.ion()
        fig = plt.figure()
        ax = fig.gca(projection='3d')
        # ax = fig.add_subplot(111, projection='3d')
        sample_i = -1
        while True:
            sample_i += 1

            no_samples_left = True
            # for every board_i plot acc data
            for board_i in range(0, len(accdata_arr_list)):
                deltay = board_i
                acctime_arr = acctime_arr_list[board_i]
                accdata_arr = accdata_arr_list[board_i]
                try:
                    # title_time_arg += acctime_arr[sample_i].isoformat() + "\n"
                    # title_time_arg += acctime_arr[sample_i].strftime("%H:%M:%S.%f") + "\n"
                    title_time_arg += acctime_arr[sample_i].strftime("%H:%M:%S.%f") + "  "
                    x_data = accdata_arr[sample_i][0]
                    y_data = accdata_arr[sample_i][1]
                    z_data = accdata_arr[sample_i][2]
                    U_grid[lim, 0 + deltay, lim] = x_data
                    V_grid[lim, 0 + deltay, lim] = y_data
                    W_grid[lim, 0 + deltay, lim] = z_data
                    magn_ref = math.sqrt(x_data ** 2 + y_data ** 2 + z_data ** 2)
                    no_samples_left = False
                except IndexError:
                    pass
            ax.quiver(X_grid, Y_grid, Z_grid, U_grid, V_grid, W_grid, pivot='tail', color='b', length=magn_ref)  # , scale=1
            # ax.quiver(X_grid, Y_grid, Z_grid, U_grid, V_grid, W_grid, pivot='tail', color='b')

            # for every board_i plot gyro data
            for board_i in range(0, len(gyrodata_arr_list)):
                deltay = board_i
                gyrotime_arr = gyrotime_arr_list[board_i]
                gyrodata_arr = gyrodata_arr_list[board_i]
                try:
                    # title_time_arg += gyrotime_arr[sample_i].isoformat() + "\n"
                    # title_time_arg += gyrotime_arr[sample_i].strftime("%H:%M:%S.%f") + "\n"
                    title_time_arg += gyrotime_arr[sample_i].strftime("%H:%M:%S.%f") + "  "
                    x_data = gyrodata_arr[sample_i][0]
                    y_data = gyrodata_arr[sample_i][1]
                    z_data = gyrodata_arr[sample_i][2]
                    U_grid[lim, 0 + deltay, lim] = x_data
                    V_grid[lim, 0 + deltay, lim] = y_data
                    W_grid[lim, 0 + deltay, lim] = z_data
                    magn_ref = math.sqrt(x_data ** 2 + y_data ** 2 + z_data ** 2)
                    no_samples_left = False
                except IndexError:
                    pass
            ax.quiver(X_grid, Y_grid, Z_grid, U_grid, V_grid, W_grid, pivot='tail', color='r', length=magn_ref)  # , scale=1
            # ax.quiver(X_grid, Y_grid, Z_grid, U_grid, V_grid, W_grid, pivot='tail', color='r')

            if no_samples_left:
                break
            else:
                # plot axes, info and refresh
                # ax.axis([-lim*10, lim*10, -lim*10, lim*10, -lim*10, lim*10])
                gs = 3
                ax.set_xlim([-lim*gs, lim*gs])
                ax.set_ylim([-lim*gs, lim*gs])
                ax.set_zlim([-lim*gs, lim*gs])
                # ax.autoscale(True)
                ax.set_title(title_time_arg)
                title_time_arg = ""
                ax.set_xlabel('Y Label')
                ax.set_ylabel('X Label')
                ax.set_zlabel('Z Label')
                # ax.invert_xaxis()

                plt.show()
                # plt.draw()
                plt.pause(0.001)
                #plt.clf()
                plt.cla()
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


if __name__ == "__main__":
    lim = 1
    acc_arr_list = [[[-0.916, 0.512, -0.083], [-0.932, 0.496, -0.060], [-0.932, 0.496, -0.060]]]
    print(acc_arr_list)
    gyro_arr_list = [[[1.341, 0.427, -1.402], [1.890, 0.488, -0.549], [1.890*5, 0.488*5, -0.549*5]]]
    print(gyro_arr_list)
