package supercollider;

import com.sun.jna.Native;
import com.sun.jna.Pointer;
import com.sun.jna.Structure;
import com.sun.jna.win32.StdCallLibrary.StdCallCallback;
import java.io.File;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.HashMap;

public class ScSynthLibrary {

    static {
        System.setProperty("jna.library.path", ScSynthLibrary.class.getResource(getScSynthLocation()).getPath());
        Native.register("scsynth_jna");
    }

    public interface ReplyCallback extends StdCallCallback {

        void callback(Pointer a, Pointer b, int c);
    }

    public static class SndBuf extends Structure {

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

    public static class ScsynthJnaStartOptions extends Structure {

        public static class ByReference extends ScsynthJnaStartOptions implements Structure.ByReference {
        }

        public int verbosity = 1;
        public String UGensPluginPath = getScSynthDefsCanonicalPath();
    }

    public static native int scsynth_jna_init();

    public static native void scsynth_jna_cleanup();

    public static native Pointer scsynth_jna_start(ScsynthJnaStartOptions options);

    public static native SndBuf scsynth_jna_copy_sndbuf(Pointer world, int index);

    public static native void World_Cleanup(Pointer world);

    public static native int World_OpenUDP(Pointer world, int b);

    public static native int World_OpenTCP(Pointer world, int b, int c, int d);

    public static native boolean World_SendPacket(Pointer world, int bufferSize, ByteBuffer buffer, ReplyCallback d);

    public static native boolean World_SendPacketWithContext(Pointer world, int b, String c, ReplyCallback d, Pointer e);

    public static native void World_WaitForQuit(Pointer world);

    private static String getScSynthDefsCanonicalPath() {
        String retval = "";
        try {
            if (System.getProperty("os.name").indexOf("Windows") == 0) {
                retval = new File(ScSynthLibrary.class.getResource(getScSynthLocation() ).getPath()).getCanonicalPath();
            } else {
                retval = new File(ScSynthLibrary.class.getResource(getScSynthLocation() + "/synthdefs").getPath()).getCanonicalPath();
            }
        } catch (IOException ex) {
        }
        return retval;
    }

    private static String getScSynthLocation() {
        HashMap<String, String> nativeNames = new HashMap<String, String>();
        nativeNames.put("Mac OS X", "macosx");
        nativeNames.put("Windows", "windows");
        nativeNames.put("Linux", "linux");
        nativeNames.put("amd64", "x86_64");
        nativeNames.put("x86_64", "x86_64");
        nativeNames.put("x86", "x86");
        nativeNames.put("i386", "x86");

        String name = System.getProperty("os.name");
        String arch = System.getProperty("os.arch");

        String nname = "";
        for (String key : nativeNames.keySet()) {
            if (name.indexOf(key) >= 0) {
                nname = nativeNames.get(key);
                break;
            }
        }
        String narch = "";
        for (String key : nativeNames.keySet()) {
            if (arch.indexOf(key) >= 0) {
                narch = nativeNames.get(key);
                break;
            }
        }

        return "/supercollider/" + nname + "/" + narch;
    }
}
