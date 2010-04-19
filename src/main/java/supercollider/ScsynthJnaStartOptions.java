package supercollider;

import com.sun.jna.Structure;

public class ScsynthJnaStartOptions extends Structure {

    public static class ByReference extends ScsynthJnaStartOptions implements Structure.ByReference {
    }
    public int verbosity = 1;
    public String UGensPluginPath = "";
}
