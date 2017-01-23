import re
import datetime


class AccGyroFileParser():
    def parse_re(self, fname):
        match_non_a_z_chars = '[^a-z]'
        re_whitespace = '\s'     # Matches any whitespace character; this is equivalent to the class [ \t\n\r\f\v].
        re_alphanumeric = '\w'   # Matches any alphanumeric character; this is equivalent to the class [a-zA-Z0-9_]
        re_numbers = '[0-9.]'
        # {manufacturer: MbientLab Inc, serialNumber: 00CADE, firmwareRevision: 1.2.2, 
        # hardwareRevision: 0.3, modelNumber: 2}
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
        gyrotime_arr = []
        gyrodata_arr = []
        acctime_arr = []
        accdata_arr = []
        statevar = "first"
        with open(fname) as fp:
            for line in fp:
                nlines += 1
                if nlines == 1:
                    # print(line)
                    # header = ast.literal_eval(line)
                    line = line.replace(', ',',')
                    line = line.replace(': ', ':')
                    key_match = re_header_key_obj.findall(line)
                    key_match = [x[1:len(x)-1] for x in key_match]
                    # print("key_match")
                    # print(key_match)
                    val_match = re_header_val_obj.findall(line)
                    val_match = [x[1:len(x) - 1] for x in val_match]
                    # print("val_match")
                    # print(val_match)
                    header = dict(zip(key_match, val_match))
                    # print(header)

                else:
                    gyro_match = re_gyro_obj.search(line)
                    acc_match = re_acc_obj.search(line)
                    num_match = re_number_obj.findall(line)
                    if len(num_match) == 9:
                        #     0       1      2     3     4        5           6        7        8
                        # ['2017', '-01', '-09', '05', '34', '06.000989', '1.341', '0.427', '-1.402']
                        time_match = [abs(int(x)) for x in num_match[0:5]]
                        secs = int(num_match[5].split('.')[0])
                        frac_secs = int(num_match[5].split('.')[1])
                        time_match.append(secs)
                        time_match.append(frac_secs)
                        time_match = datetime.datetime(time_match[0], time_match[1], time_match[2], time_match[3],
                                                       time_match[4], time_match[5], time_match[6])
                        tuple_match = [float(x) for x in num_match[6:9]]
                    else:
                        arg = 'No num_match at line %s' % nlines
                        print(arg)
                        return

                    if (gyro_match is not None) and (len(tuple_match) == 3):
                        if (statevar == "first") or (statevar == "acc"):
                            gyrotime_arr.append(time_match)
                            gyrodata_arr.append(tuple_match)
                            statevar = "gyro"
                        # print(gyro_match)
                    elif (acc_match is not None) and (len(tuple_match) == 3):
                        if (statevar == "first") or (statevar == "gyro"):
                            acctime_arr.append(time_match)
                            accdata_arr.append(tuple_match)
                            statevar = "acc"
                    else:
                        arg = 'No match at line %s' % nlines
                        print(arg)

        # make them of the same length
        if len(gyrodata_arr) > len(accdata_arr):
            gyrodata_arr.pop()
        if len(gyrodata_arr) < len(accdata_arr):
            accdata_arr.pop()

        # arg = "header keys = %s" % len(header)
        # print(arg)
        # arg = "header len = 1"
        # print(arg)
        arg = "acctime len = %s" % len(acctime_arr)
        print(arg)
        arg = "accdata len = %s" % len(accdata_arr)
        print(arg)
        arg = "gyrotime len = %s" % len(gyrotime_arr)
        print(arg)
        arg = "gyrodata len = %s" % len(gyrodata_arr)
        print(arg)
        arg = "header + acc + gyro = %s" % (len(accdata_arr)+len(gyrodata_arr)+1)
        print(arg)
        arg = "lines in file = %s" % nlines
        print(arg)

        return (header, acctime_arr, accdata_arr, gyrotime_arr, gyrodata_arr)

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
