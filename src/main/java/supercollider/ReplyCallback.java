package supercollider;

import com.sun.jna.Pointer;
import com.sun.jna.win32.StdCallLibrary.StdCallCallback;

public interface ReplyCallback extends StdCallCallback {

    void callback(Pointer a, Pointer b, int c);
}
