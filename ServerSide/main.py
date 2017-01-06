from mpl_toolkits.mplot3d import axes3d
import matplotlib.pyplot as plt
import numpy as np
import sys
import time
import random


class PltWrapper():
    def plot_1arrow_3dquiver(self, lim, u_arr, v_arr, w_arr):
        grid_axis = np.arange(-lim, lim + 1, 1)
        # grid_axis = np.arange(0, lim+1, 1)
        X_grid, Y_grid, Z_grid = np.meshgrid(grid_axis, grid_axis, grid_axis)
        U_grid = np.zeros(X_grid.shape)
        V_grid = np.zeros(Y_grid.shape)
        W_grid = np.zeros(Z_grid.shape)

        # non-zero value at point (x, y, z)
        # U_grid[lim*2,0,0] = 1
        # V_grid[lim*2,0,0] = 1
        # W_grid[lim*2,0,0] = 1
        # # non-zero value at point (x, y, z)
        # U_grid[lim*2,lim*2,lim*2] = 1
        # V_grid[lim*2,lim*2,lim*2] = 1
        # W_grid[lim*2,lim*2,lim*2] = 1
        # # non-zero value at point (x, y, z)
        # U_grid[0,0,0] = 1
        # V_grid[0,0,0] = 1
        # W_grid[0,0,0] = 1
        # # non-zero value at point (x, y, z)
        # U_grid[lim,lim,lim] = 1
        # V_grid[lim,lim,lim] = 1
        # W_grid[lim,lim,lim] = 1


        print("X_grid")
        print(X_grid)
        print("U_grid")
        print(U_grid)
        # print(X_grid.shape)
        # print(U_grid.shape)

        # sys.exit(0)

        # X,Y,Z,U,V,W = zip(*soa)
        # print(X)
        # print(U)
        plt.ion()
        fig = plt.figure()
        for i in range(0, nlines):
            # print('i = %d' % i)
            # print(U_arr[i])
            # print(V_arr[i])
            # print(W_arr[i])
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
    fname = "../test/2016_12_06_v2_toopazo.txt"
    accelparser = AccelFileParser()
    nlines, U_arr, V_arr, W_arr = accelparser.parse(fname)
    print(nlines)
    print(U_arr[0])
    print(V_arr[0])
    print(W_arr[0])
    #sys.exit(0)

    #plot
    plotter = PltWrapper()
    semi_length = 1
    plotter.plot_1arrow_3dquiver(semi_length, U_arr, V_arr, W_arr)

