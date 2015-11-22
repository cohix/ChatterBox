package com.connorhicks.chatterbox;

import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioRecord;
import android.media.AudioTrack;
import android.media.MediaRecorder;
import android.util.Base64;
import android.util.Log;

import java.io.ByteArrayOutputStream;

/**
 * Created by Tom on 11/21/15.
 */
public class AudioController extends Thread
{
    private boolean stopped = false;

    public AudioController()
    {
        android.os.Process.setThreadPriority(android.os.Process.THREAD_PRIORITY_URGENT_AUDIO);
        start();
    }

    @Override
    public void run()
    {
        Log.i("Audio", "Running");
        AudioRecord recorder = null;
        AudioTrack track = null;
        int i = 0;

        try{
            int num = AudioRecord.getMinBufferSize(8000, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT);
            recorder = new AudioRecord(MediaRecorder.AudioSource.MIC,8000,AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT,num*10);

            byte[]buff = new byte[num];
            recorder.startRecording();
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            track = new AudioTrack(AudioManager.STREAM_MUSIC, 8000, AudioFormat.CHANNEL_CONFIGURATION_MONO,AudioFormat.ENCODING_PCM_16BIT,num,AudioTrack.MODE_STREAM);

            while(i < 10240)
            {
                recorder.read(buff, 0, buff.length);
                String base64EncodedBuffer = Base64.encodeToString(buff, Base64.NO_WRAP);

                byte[] decodedBase64 = Base64.decode(base64EncodedBuffer, Base64.NO_WRAP);

                track.write(decodedBase64, 0, decodedBase64.length);

                //System.out.println("recording");
                i++;
            }
            recorder.stop();
            recorder.release();

            track.play();

        }
        catch (Exception e){
            e.printStackTrace();
        }

        //recorder.close();

    }
}
