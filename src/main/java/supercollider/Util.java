package supercollider;

import java.util.HashMap;

public class Util {

    public static String getOsName() {
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

    public static String getOsArch() {
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
