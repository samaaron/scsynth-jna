package supercollider;

import com.sun.jna.Structure;

public class ScsynthJnaStartOptions extends Structure {

    public static class ByReference extends ScsynthJnaStartOptions implements Structure.ByReference {
    }

    public int verbosity = 1;
    public String UGensPluginPath = "";
    public String inDeviceName = "";
    public String outDeviceName = "";
    public int numControlBusChannels = -1;
    public int numAudioBusChannels = -1;
    public int numInputBusChannels = -1;
    public int numOutputBusChannels = -1;
    public int bufLength = -1;
    public int preferredHardwareBufferFrameSize = -1;
    public int preferredSampleRate = -1;
    public int numBuffers = -1;
    public int maxNodes = -1;
    public int maxGraphDefs = -1;
    public int realTimeMemorySize = -1;
    public int maxWireBufs = -1;
    public int numRGens = -1;
}
