package supercollider;

import com.sun.jna.Pointer;
import com.sun.jna.Structure;

public class SndBuf extends Structure {

    public double samplerate;
    public double sampledur;
    public Pointer data;
    public int channels;
    public int samples;
    public int frames;
    public int mask;
    public int mask1;
    public int coord;
    public Pointer sndfile;
}
