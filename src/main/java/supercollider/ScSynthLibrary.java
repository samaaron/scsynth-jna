package supercollider;

import com.sun.jna.Native;
import com.sun.jna.Pointer;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Random;

public class ScSynthLibrary {

    public static String getSynthdefsPath() {
        return synthdefsDir;
    }

    public static String getScSynthJnaPath() {
        return scsynthJnaDir;
    }
    private static String synthdefsDir = "";
    private static String scsynthJnaDir = "";

    static {
        try {

            final String baseTempPath = System.getProperty("java.io.tmpdir");

            Random rand = new Random();
            int randomInt = 100000 + rand.nextInt(899999);

            File tempDir = new File(baseTempPath + File.separator + "scsynth_jna" + randomInt);
            if (tempDir.exists() == false) {
                tempDir.mkdir();
            }

            tempDir.deleteOnExit();
            File tempSynthdefsDir = new File(tempDir.getPath() + File.separator + "synthdefs");
            if (tempSynthdefsDir.exists() == false) {
                tempSynthdefsDir.mkdir();
            }
            tempSynthdefsDir.deleteOnExit();

            {
                String fn = ScSynthLibrary.getScSynthJna();
                URL res = ScSynthLibrary.class.getResource(ScSynthLibrary.getScSynthJnaLocation() + "/" + fn);

                InputStream is = res.openStream();
                File lib = new File(tempDir.getPath() + File.separator + fn);
                FileOutputStream fos = new FileOutputStream(lib);

                /* Copy the DLL fro the JAR to the filesystem */
                byte[] array = new byte[1024];
                for (int i = is.read(array);
                        i != -1;
                        i = is.read(array)) {
                    fos.write(array, 0, i);
                }
                fos.close();
                is.close();
                lib.deleteOnExit();


            }
            // Copy synthdefs to temp dir
            for (String fn : ScSynthLibrary.getScSynthDefs()) {
                URL res = ScSynthLibrary.class.getResource(ScSynthLibrary.getScSynthdefsLocation() + "/" + fn);

                InputStream is = res.openStream();
                File ugen = new File(tempSynthdefsDir.getPath() + File.separator + fn);
                FileOutputStream fos = new FileOutputStream(ugen);
                
                /* Copy the DLL fro the JAR to the filesystem */
                byte[] array = new byte[1024];
                for (int i = is.read(array);
                        i != -1;
                        i = is.read(array)) {
                    fos.write(array, 0, i);
                }
                fos.close();
                is.close();
                ugen.deleteOnExit();

            }

            scsynthJnaDir = tempDir.getPath();
            synthdefsDir = tempSynthdefsDir.getPath();

            System.out.println("path: " + tempDir.getPath());

            System.setProperty("jna.library.path", tempDir.getPath());
            Native.register("scsynth_jna");
        } catch (Throwable e) {
            e.printStackTrace();
        }
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

    private static String getScSynthdefsLocation() {
        return getScSynthJnaLocation() + "/synthdefs";
    }

    private static String[] getScSynthDefs() {

        if (getOsName().equals("linux")) {
            return new String[]{
                        "BinaryOpUGens.so",
                        "GendynUGens.so", "PanUGens.so",
                        "ChaosUGens.so", "GrainUGens.so", "PhysicalModelingUGens.so",
                        "DelayUGens.so", "IOUGens.so", "PV_ThirdParty.so",
                        "DemandUGens.so", "LFUGens.so", "ReverbUGens.so",
                        "DiskIO_UGens.so", "ML_UGens.so", "TestUGens.so",
                        "DynNoiseUGens.so", "MulAddUGens.so", "TriggerUGens.so",
                        "FFT_UGens.so", "NoiseUGens.so", "UnaryOpUGens.so",
                        "FilterUGens.so", "OscUGens.so", "UnpackFFTUGens.so"};
        } else if (getOsName().equals("windows")) {
        } else if (getOsName().equals("macosx")) {
        }

        return null;
    }

    private static String getScSynthJna() {
        String retval = "";
        if (getOsName().equals("linux")) {
            retval = "libscsynth_jna.so";
        } else if (getOsName().equals("windows")) {
            retval = "";
        } else if (getOsName().equals("macosx")) {
            retval = "";
        }
        return retval;
    }

    private static String getScSynthJnaLocation() {
        return "/supercollider/scsynth/" + getOsName() + "/" + getOsArch();
    }

    private static String getOsName() {
        HashMap<String, String> nativeNames = new HashMap<String, String>();
        nativeNames.put("Mac OS X", "macosx");
        nativeNames.put("Windows", "windows");
        nativeNames.put("Linux", "linux");

        String name = System.getProperty("os.name");

        String nname = "";
        for (String key : nativeNames.keySet()) {
            if (name.indexOf(key) >= 0) {
                nname = nativeNames.get(key);
                break;
            }
        }

        return nname;
    }

    private static String getOsArch() {
        HashMap<String, String> nativeNames = new HashMap<String, String>();
        nativeNames.put("amd64", "x86_64");
        nativeNames.put("x86_64", "x86_64");
        nativeNames.put("x86", "x86");
        nativeNames.put("i386", "x86");

        String arch = System.getProperty("os.arch");

        String narch = "";
        for (String key : nativeNames.keySet()) {
            if (arch.indexOf(key) >= 0) {
                narch = nativeNames.get(key);
                break;
            }
        }

        return narch;
    }
}
