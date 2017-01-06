package com.mbientlab.metawear.starter;

import android.os.Environment;
import android.util.Log;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

/**
 * Created by toopazo on 05-01-2017.
 */

public class LocalFileHandler {
    private static final String LOG_TAG = CommonUtils.BASE_TAG + CommonUtils.SEPARATOR + LocalFileHandler.class.getName();

    File mfile;
    FileWriter mwriter;

    /* Checks if external storage is available for read and write */
    public boolean isExternalStorageWritable() {
        String state = Environment.getExternalStorageState();
        if (Environment.MEDIA_MOUNTED.equals(state)) {
            return true;
        }
        return false;
    }

    /* Checks if external storage is available to at least read */
    public boolean isExternalStorageReadable() {
        String state = Environment.getExternalStorageState();
        if (Environment.MEDIA_MOUNTED.equals(state) ||
                Environment.MEDIA_MOUNTED_READ_ONLY.equals(state)) {
            return true;
        }
        return false;
    }

    public File getDocumentsStorageDir(String documentName) {
        // Get the directory for the user's public pictures directory.
        File file = new File(Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_DOCUMENTS), documentName);
        if (!file.mkdirs()) {
            Log.e(LOG_TAG, "Directory not created");
        }
        return file;
    }

    public void createFile (String fname){
        boolean value = isExternalStorageReadable();
        if(value == false){return ;}//null;}
        value = isExternalStorageWritable();
        if(value == false){return ;}//null;}

        String foldername = "";
        this.mfile = getDocumentsStorageDir(foldername);
        if (!mfile.exists()) {
            mfile.mkdirs();
        }
        mfile = new File(mfile, fname);

        String path = this.mfile.getAbsolutePath();
        String arg = "fd path is " + path;
        Log.i(LOG_TAG, arg);
    }

    public void append_line_data(String arg){
        try {
            this.mwriter = new FileWriter(this.mfile, true);
            this.mwriter.append(arg+"\r\n");
            this.mwriter.flush();
            this.mwriter.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
