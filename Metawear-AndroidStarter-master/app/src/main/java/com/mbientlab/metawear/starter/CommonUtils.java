package com.mbientlab.metawear.starter;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

/**
 * Created by toopazo on 05-01-2017.
 */

final public class CommonUtils {
    static String BASE_TAG = "DataCollector";
    static String SEPARATOR = " > ";

    static public String get_datetime_iso() {
        TimeZone tz = TimeZone.getTimeZone("UTC");
        //DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'"); // Quoted "Z" to indicate UTC, no timezone offset
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"); // Quoted "Z" to indicate UTC, no timezone offset
        df.setTimeZone(tz);
        String iso_datetime = df.format(new Date());
        return iso_datetime;
    }

    static public String get_datetime_filename(){
        TimeZone tz = TimeZone.getTimeZone("UTC");
        //DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'"); // Quoted "Z" to indicate UTC, no timezone offset
        DateFormat df = new SimpleDateFormat("yyyy_MM_dd'T'HH_mm_ss_SSSSSS'Z'"); // Quoted "Z" to indicate UTC, no timezone offset
        df.setTimeZone(tz);
        String iso_datetime = df.format(new Date());
        return iso_datetime;
    }
}
