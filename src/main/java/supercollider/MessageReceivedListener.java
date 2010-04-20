package supercollider;

import java.nio.ByteBuffer;
import java.util.EventListener;

public interface MessageReceivedListener extends EventListener {
    public void messageReceived(ByteBuffer message, int size);
}
