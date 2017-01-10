/*
 * Copyright 2015 MbientLab Inc. All rights reserved.
 *
 * IMPORTANT: Your use of this Software is limited to those specific rights
 * granted under the terms of a software license agreement between the user who
 * downloaded the software, his/her employer (which must be your employer) and
 * MbientLab Inc, (the "License").  You may not use this Software unless you
 * agree to abide by the terms of the License which can be found at
 * www.mbientlab.com/terms . The License limits your use, and you acknowledge,
 * that the  Software may not be modified, copied or distributed and can be used
 * solely and exclusively in conjunction with a MbientLab Inc, product.  Other
 * than for the foregoing purpose, you may not use, reproduce, copy, prepare
 * derivative works of, modify, distribute, perform, display or sell this
 * Software and/or its documentation for any purpose.
 *
 * YOU FURTHER ACKNOWLEDGE AND AGREE THAT THE SOFTWARE AND DOCUMENTATION ARE
 * PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF MERCHANTABILITY, TITLE,
 * NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL
 * MBIENTLAB OR ITS LICENSORS BE LIABLE OR OBLIGATED UNDER CONTRACT, NEGLIGENCE,
 * STRICT LIABILITY, CONTRIBUTION, BREACH OF WARRANTY, OR OTHER LEGAL EQUITABLE
 * THEORY ANY DIRECT OR INDIRECT DAMAGES OR EXPENSES INCLUDING BUT NOT LIMITED
 * TO ANY INCIDENTAL, SPECIAL, INDIRECT, PUNITIVE OR CONSEQUENTIAL DAMAGES, LOST
 * PROFITS OR LOST DATA, COST OF PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY,
 * SERVICES, OR ANY CLAIMS BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY
 * DEFENSE THEREOF), OR OTHER SIMILAR COSTS.
 *
 * Should you have any questions regarding your right to use this Software,
 * contact MbientLab Inc, at www.mbientlab.com.
 */

package com.mbientlab.metawear.starter;

import android.app.Activity;
import android.bluetooth.BluetoothDevice;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.mbientlab.metawear.AsyncOperation;
import com.mbientlab.metawear.Message;
import com.mbientlab.metawear.MetaWearBleService;
import com.mbientlab.metawear.MetaWearBoard;
import com.mbientlab.metawear.RouteManager;
import com.mbientlab.metawear.data.CartesianFloat;
import com.mbientlab.metawear.UnsupportedModuleException;

// modules (sensor) to retreive
import com.mbientlab.metawear.module.Accelerometer;
import com.mbientlab.metawear.module.Gyro;
import com.mbientlab.metawear.module.Bme280Humidity;
import com.mbientlab.metawear.module.Bmp280Barometer;
import com.mbientlab.metawear.module.Temperature;
import com.mbientlab.metawear.module.Led;
//import com.mbientlab.metawear.module.AmbientLight;
//import com.mbientlab.metawear.module.ppg;

import static com.mbientlab.metawear.AsyncOperation.CompletionHandler;
/**
 * A placeholder fragment containing a simple view.
 */
public class DeviceSetupActivityFragment extends Fragment implements ServiceConnection {
    //toopazo @ 06-12-2016
    private static final String LOG_TAG = CommonUtils.BASE_TAG + CommonUtils.SEPARATOR + DeviceSetupActivityFragment.class.getName();
    Accelerometer maccModule;
    Gyro mgyroModule;
    //Barometer mbaromModule;
    Bmp280Barometer mbaromModule;
    Temperature mtempModule;
    Bme280Humidity mhumiModule;
    Led mledModule;
    String mdevInfo;
    String mdevInfo_serialNumber;
    LocalFileHandler mlfh_acc_gyro;
    LocalFileHandler mlfh_general;

    public interface FragmentSettings {
        BluetoothDevice getBtDevice();
    }

    private MetaWearBoard mwBoard= null;
    private FragmentSettings settings;

    public DeviceSetupActivityFragment() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Activity owner= getActivity();
        if (!(owner instanceof FragmentSettings)) {
            throw new ClassCastException("Owning activity must implement the FragmentSettings interface");
        }

        settings= (FragmentSettings) owner;
        owner.getApplicationContext().bindService(new Intent(owner, MetaWearBleService.class), this, Context.BIND_AUTO_CREATE);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();

        ///< Unbind the service when the activity is destroyed
        getActivity().getApplicationContext().unbindService(this);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        setRetainInstance(true);
        return inflater.inflate(R.layout.fragment_device_setup, container, false);
    }

    @Override
    public void onServiceConnected(ComponentName name, IBinder service) {
        mwBoard= ((MetaWearBleService.LocalBinder) service).getMetaWearBoard(settings.getBtDevice());
        ready();
    }

    @Override
    public void onServiceDisconnected(ComponentName name) {

    }

    /**
     * Called when the app has reconnected to the board
     */
    public void reconnected() { }

    /**
     * Called when the mwBoard field is ready to be used
     */
    public void ready() {
        //Initialize Board and the data to be retreived from it
        String arg = "Starting Board initialization";
        Log.i(LOG_TAG, arg);
        deviInfo_config();
        acc_config();
        gyro_config();
        barom_config();
        temp_config();
        humi_config();
        led_config();

        //Create LocalFile where data is to be saved
        arg = "Create LocalFile where data is to be stored";
        Log.i(LOG_TAG, arg);
        // acc gyro
        mlfh_acc_gyro = new LocalFileHandler();
        String datetime = CommonUtils.get_datetime_filename();
        String fname = "board_" + mdevInfo_serialNumber +"_acc_gyro_" + datetime+".txt";
        mlfh_acc_gyro.createFile(fname);
        // general
        mlfh_general = new LocalFileHandler();
        datetime = CommonUtils.get_datetime_filename();
        fname = "board_" + mdevInfo_serialNumber +"_general_" + datetime+".txt";
        mlfh_general.createFile(fname);

        //Append mdevInfo
        mlfh_acc_gyro.append_line_data(mdevInfo);
        mlfh_general.append_line_data(mdevInfo);

        //End
        arg = "End of Board initialization";
        Log.i(LOG_TAG, arg);
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        view.findViewById(R.id.button_data_start).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                acc_onReceivedData();
                gyro_onReceivedData();
                barom_and_ohters_onReceivedData();
            }
        });
        view.findViewById(R.id.button_data_stop).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                acc_stop();
                gyro_stop();
                barom_stop();
                mwBoard.removeRoutes();
            }
        });
    }
    //public String extractCoord (String str){
    //    //char [] orig = str.toCharArray();
    //   // ArrayList<Character> coord = new ArrayList<Character>();
    //    String requiredString = str.substring(str.indexOf("(") + 1, str.indexOf(")"));
    //
    //    return requiredString;
    //}
    public void temp_config(){
        try{
            mtempModule = mwBoard.getModule(Temperature.class);
        } catch (UnsupportedModuleException e) {
            Snackbar.make(getActivity().findViewById(R.id.device_setup_fragment), e.getMessage(),
                    Snackbar.LENGTH_SHORT).show();
        }
    }
    public void temp_get_data(){
        mtempModule.routeData().fromSensor().stream("temp_stream").commit()
                .onComplete(new CompletionHandler<RouteManager>() {
                    @Override
                    public void success(RouteManager result) {
                        result.subscribe("temp_stream", new RouteManager.MessageHandler() {
                            @Override
                            public void process(Message msg) {
                                //Log.i(LOG_TAG, String.format("Pressure= %.3fPa",
                                //        msg.getData(Float.class)));

                                // Append latest data to LocalFile
                                String datetime = CommonUtils.get_datetime_iso();
                                String temp_tuple = msg.getData(Float.class).toString();
                                String arg = "temp_stream: " + datetime +", "+ temp_tuple;
                                mlfh_general.append_line_data(arg);
                                arg = "temp data appended";
                                Log.i(LOG_TAG, arg);

                                // Send latest data to ServeSide
                                // ..
                            }
                        });
                        mtempModule.readTemperature(false);
                    }
                });
    }
    public void humi_config(){
        try{
            mhumiModule = mwBoard.getModule(Bme280Humidity.class);
        } catch (UnsupportedModuleException e) {
            Snackbar.make(getActivity().findViewById(R.id.device_setup_fragment), e.getMessage(),
                    Snackbar.LENGTH_SHORT).show();
        }
    }
    public void humi_get_data() {
        mhumiModule.routeData().fromSensor(false).stream("humidity").commit()
                .onComplete(new CompletionHandler<RouteManager>() {
                    @Override
                    public void success(RouteManager result) {
                        result.subscribe("humidity", new RouteManager.MessageHandler() {
                            @Override
                            public void process(Message msg) {
                                //Log.i("MainActivity", "Humidity percent: "
                                //        + msg.getData(Float.class));

                                // Append latest data to LocalFile
                                String datetime = CommonUtils.get_datetime_iso();
                                String humi_tuple = msg.getData(Float.class).toString();
                                String arg = "humi_stream: " + datetime +", "+ humi_tuple;
                                mlfh_general.append_line_data(arg);
                                arg = "humi data appended";
                                Log.i(LOG_TAG, arg);

                                // Send latest data to ServeSide
                                // ..
                            }
                        });
                        mhumiModule.readHumidity(false);
                    }
                });
    }
    public void led_config(){
        try{
            mledModule = mwBoard.getModule(Led.class);
        } catch (UnsupportedModuleException e) {
            Snackbar.make(getActivity().findViewById(R.id.device_setup_fragment), e.getMessage(),
                    Snackbar.LENGTH_SHORT).show();
        }
    }
    public void barom_config() {
        try{
            //mbaromModule = mwBoard.getModule(Barometer.class);
            mbaromModule = mwBoard.getModule(Bmp280Barometer.class);
            // Set filter coefficient to 4 for IIR filter
            // Set oversampling mode to low power
            // Set standby time to 125ms
            mbaromModule.configure()
                    .setFilterMode(Bmp280Barometer.FilterMode.AVG_4)
                    .setPressureOversampling(Bmp280Barometer.OversamplingMode.LOW_POWER)
                    .setStandbyTime(Bmp280Barometer.StandbyTime.TIME_1000)
                    .commit();

        } catch (UnsupportedModuleException e) {
            Snackbar.make(getActivity().findViewById(R.id.device_setup_fragment), e.getMessage(),
                    Snackbar.LENGTH_SHORT).show();
        }
    }
    public void barom_and_ohters_onReceivedData(){
        mbaromModule.routeData().fromPressure().stream("pressure_stream").commit()
                .onComplete(new CompletionHandler<RouteManager>() {
                    @Override
                    public void success(RouteManager result) {
                        result.subscribe("pressure_stream", new RouteManager.MessageHandler() {
                            @Override
                            public void process(Message msg) {
                                //Log.i(LOG_TAG, String.format("Pressure= %.3fPa",
                                //        msg.getData(Float.class)));

                                // Append latest data to LocalFile
                                String datetime = CommonUtils.get_datetime_iso();
                                String pressure_tuple = msg.getData(Float.class).toString();
                                String arg = "pressure_stream: " + datetime +", "+ pressure_tuple;
                                mlfh_general.append_line_data(arg);
                                arg = "pressure data appended";
                                Log.i(LOG_TAG, arg);

                                // Send latest data to ServeSide
                                // ..

                                // retrieve other "non-stremable" data
                                temp_get_data();
                                humi_get_data();
                            }
                        });
                        mbaromModule.start();
                    }
                });
    }
    public void barom_stop(){
        mbaromModule.stop();
        //mbaromModule.disableAltitudeSampling();
    }
    public void deviInfo_config(){
        // get devInfo and setup mdevInfo member
        //MetaWearBoard.DeviceInformation.serialNumber()
        mwBoard.readDeviceInformation().onComplete(new CompletionHandler<MetaWearBoard.DeviceInformation>() {
            @Override
            public void success(MetaWearBoard.DeviceInformation result) {
                String arg = "Device Information: " + result.toString();
                Log.i(LOG_TAG, arg);
                //result.firmwareRevision();
                mdevInfo_serialNumber = result.serialNumber();
                mdevInfo = result.toString();
            }
        });
    }
    public void acc_config(){
        try{
            // Set the output data rate to 5Hz or closet valid value
            maccModule = mwBoard.getModule(Accelerometer.class);
            maccModule.setOutputDataRate(5.f);
        } catch (UnsupportedModuleException e) {
            Snackbar.make(getActivity().findViewById(R.id.device_setup_fragment), e.getMessage(),
                    Snackbar.LENGTH_SHORT).show();
        }
    }
    public void acc_onReceivedData(){
        maccModule.routeData().fromAxes().stream("acc_stream").commit()
                .onComplete(new AsyncOperation.CompletionHandler<RouteManager>() {
                    @Override
                    public void success(RouteManager result) {
                        result.subscribe("acc_stream", new RouteManager.MessageHandler() {
                            @Override
                            public void process(Message msg) {
                                // Print latest data to LocalLog
                                //String arg = "acc_stream: " + msg.getData(CartesianFloat.class).toString();
                                //Log.i(LOG_TAG, arg);
                                //Log.i("The Coordinates are: ", extractCoord(msg.getData(CartesianFloat.class).toString()));

                                // Append latest data to LocalFile
                                String datetime = CommonUtils.get_datetime_iso();
                                String acc_tuple = msg.getData(CartesianFloat.class).toString();
                                String arg = "acc_stream: " + datetime +", "+ acc_tuple;
                                mlfh_acc_gyro.append_line_data(arg);
                                arg = "acc data appended";
                                Log.i(LOG_TAG, arg);

                                // Send latest data to ServeSide
                                // ..
                            }
                        });
                        maccModule.enableAxisSampling();
                        maccModule.start();
                    }
                });
    }
    public void gyro_config(){
        try{
            mgyroModule = mwBoard.getModule(Gyro.class);
            mgyroModule.setOutputDataRate(5.f);
        } catch (UnsupportedModuleException e) {
            Snackbar.make(getActivity().findViewById(R.id.device_setup_fragment), e.getMessage(),
                    Snackbar.LENGTH_SHORT).show();
        }
    }
    public void gyro_stop(){
        mgyroModule.stop();
        //mgyroModule.disableAxisSampling();
    }
    public void gyro_onReceivedData(){
        mgyroModule.routeData().fromAxes().stream("gyro_stream").commit()
                .onComplete(new AsyncOperation.CompletionHandler<RouteManager>() {
                    @Override
                    public void success(RouteManager result) {
                        result.subscribe("gyro_stream", new RouteManager.MessageHandler() {
                            @Override
                            public void process(Message msg) {
                                // Print latest data to LocalLog
                                //String arg = "acc_stream: " + msg.getData(CartesianFloat.class).toString();
                                //Log.i(LOG_TAG, arg);
                                //Log.i("The Coordinates are: ", extractCoord(msg.getData(CartesianFloat.class).toString()));

                                // Append latest data to LocalFile
                                String datetime = CommonUtils.get_datetime_iso();
                                String gyro_tuple = msg.getData(CartesianFloat.class).toString();
                                String arg = "gyro_stream: " + datetime +", "+ gyro_tuple;
                                mlfh_acc_gyro.append_line_data(arg);
                                arg = "gyro data appended";
                                Log.i(LOG_TAG, arg);

                                // Send latest data to ServeSide
                                // ..
                            }
                        });

                        //mgyroModule.enableAxisSampling();
                        mgyroModule.start();
                    }
                });
    }
    public void acc_stop(){
        maccModule.stop();
        maccModule.disableAxisSampling();
    }
}
