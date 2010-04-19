package supercollider;

import com.sun.jna.Pointer;
import java.nio.ByteBuffer;
import java.util.ArrayList;

public class ScSynth implements Runnable {

    private Pointer world = Pointer.NULL;

    public void openUdp(int port) {
        if (running) {
            ScSynthLibrary.World_OpenUDP(world, port);
        }
    }

    public void openTcp(int port) {
        if (running) {
            ScSynthLibrary.World_OpenTCP(world, port, 64, 8);
        }
    }
    boolean running = false;

    @Override
    public void run() {
        if (!running) {
            ScSynthLibrary.scsynth_jna_init();
            ScsynthJnaStartOptions.ByReference o = new ScsynthJnaStartOptions.ByReference();
            o.UGensPluginPath = ScSynthLibrary.getSynthdefsPath();
            world = ScSynthLibrary.scsynth_jna_start(o);
            running = true;
            ScSynthLibrary.World_WaitForQuit(world);
            ScSynthLibrary.scsynth_jna_cleanup();
            running = false;
        }
    }
    private ReplyCallback globalReplyCallback = new ReplyCallback() {

        @Override
        public void callback(Pointer addr, Pointer buf, int size) {
            ByteBuffer b = buf.getByteBuffer(0, size);
            for (MessageReceivedListener l : messageListeners) {
                l.messageReceived(b, size);
            }
        }
    };
    ArrayList<MessageReceivedListener> messageListeners = new ArrayList<MessageReceivedListener>();

    public void addMessageReceivedListener(MessageReceivedListener listener) {
        if (listener == null) {
            throw new IllegalArgumentException("null listener");
        }
        if (messageListeners == null) {
            messageListeners = new ArrayList<MessageReceivedListener>(1);
        }
        messageListeners.add(listener);
    }

    public void removeMessageReceivedListener(MessageReceivedListener listener) {
        if (listener == null) {
            throw new IllegalArgumentException("null listener");
        }
        if (messageListeners != null) {
            messageListeners.remove(listener);
        }
    }

    public void send(ByteBuffer b) {
        if (running) {
            ScSynthLibrary.World_SendPacket(world, b.limit(), b, globalReplyCallback);
        }
    }

    public SndBuf getSndBuf(int index) {
        SndBuf retval = null;
        if (running) {
            retval = ScSynthLibrary.scsynth_jna_copy_sndbuf(world, index);
        }
        return retval;
    }

    public static void main(String[] args) {
//        ScSynth sc = new ScSynth();
//        (new Thread(sc)).start();
    }
}
