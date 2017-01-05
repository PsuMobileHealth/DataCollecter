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
import com.mbientlab.metawear.module.Accelerometer;
//import com.mbientlab.metawear.module.AmbientLight;
import com.mbientlab.metawear.module.Barometer;
import com.mbientlab.metawear.module.Gyro;
import com.mbientlab.metawear.module.Temperature;
import com.mbientlab.metawear.module.Led;
import static com.mbientlab.metawear.AsyncOperation.CompletionHandler;
import com.mbientlab.metawear.module.Led;
import com.mbientlab.metawear.starter.GraphOpenglActivity;

/**
 * A placeholder fragment containing a simple view.
 */
public class DeviceSetupActivityFragment extends Fragment implements ServiceConnection {
    //toopazo @ 06-12-2016
    Accelerometer accModule;
    Barometer baromModule;
    Gyro gyroModule;
    Temperature tempModule;
    Led LedModule;
    String devInfo;

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
        try {
            //MetaWearBoard.DeviceInformation.serialNumber()
            mwBoard.readDeviceInformation().onComplete(new CompletionHandler<MetaWearBoard.DeviceInformation>() {
                @Override
                public void success(MetaWearBoard.DeviceInformation result) {
                    //Log.i("test", "Device Information: " + result.toString());
                    //result.firmwareRevision();
                    //result.serialNumber();
                    devInfo = result.toString();
                }
            });
            // Set the output data rate to 25Hz or closet valid value
            accModule = mwBoard.getModule(Accelerometer.class);
            accModule.setOutputDataRate(25.f);
            baromModule = mwBoard.getModule(Barometer.class);
            //baromModule.setOutputDataRate(25.f);
            gyroModule = mwBoard.getModule(Gyro.class);
            gyroModule.setOutputDataRate(25.f);
            tempModule = mwBoard.getModule(Temperature.class);
            //tempModule.setOutputDataRate(25.f);
            //L edModule = mwBoard.getModule(Led.class);
            //ledModule.setOutputDataRate(25.f);
        } catch (UnsupportedModuleException e) {
            Snackbar.make(getActivity().findViewById(R.id.device_setup_fragment), e.getMessage(),
                    Snackbar.LENGTH_SHORT).show();
        }
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        view.findViewById(R.id.acc_start).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                accModule.routeData().fromAxes().stream("acc_stream").commit()
                        .onComplete(new AsyncOperation.CompletionHandler<RouteManager>() {
                            @Override
                            public void success(RouteManager result) {
                                result.subscribe("acc_stream", new RouteManager.MessageHandler() {
                                    @Override
                                    public void process(Message msg) {
                                        //Log.i("DataCollector", devInfo+", acc_stream: "+ msg.getData(CartesianFloat.class).toString());
                                        Log.i("The Coordinates are: ", extractCoord(msg.getData(CartesianFloat.class).toString()));
                                    }

                                });

                                accModule.enableAxisSampling();
                                accModule.start();
                            }
                        });
            }
        });
        view.findViewById(R.id.acc_stop).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                accModule.stop();
                accModule.disableAxisSampling();
                mwBoard.removeRoutes();
            }
        });

        view.findViewById(R.id.acc_graph).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                /** Called when the user clicks the Send button */
                Intent intent = new Intent(DeviceSetupActivityFragment.this.getActivity(), GraphOpenglActivity.class);
                //EditText editText = (EditText) findViewById(R.id.edit_message);
                //String message = editText.getText().toString();
                //intent.putExtra(EXTRA_MESSAGE, message);
                startActivity(intent);
            }
        });
    }
    public String extractCoord (String str){
        //char [] orig = str.toCharArray();
        // ArrayList<Character> coord = new ArrayList<Character>();
        String requiredString = str.substring(str.indexOf("(") + 1, str.indexOf(")"));

        return requiredString;
    }

}
