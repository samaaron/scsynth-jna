package supercollider;

import com.sun.jna.Pointer;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.ArrayList;
import javax.swing.JFrame;

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
    ScsynthJnaStartOptions.ByReference options = new ScsynthJnaStartOptions.ByReference();

    public ScsynthJnaStartOptions.ByReference getOptions() {
        return options;
    }

    @Override
    public void run() {
        if (!running) {
            ScSynthLibrary.scsynth_jna_init();

            options.UGensPluginPath = ScSynthLibrary.getUgensPath();
            world = ScSynthLibrary.scsynth_jna_start(options);
            running = true;
            for (ScSynthStartedListener l : startedListeners) {
                l.scSynthStarted();
            }
            ScSynthLibrary.World_WaitForQuit(world);
            ScSynthLibrary.scsynth_jna_cleanup();
            running = false;
            for (ScSynthStoppedListener l : stoppedListeners) {
                l.scSynthStopped();
            }
        }
    }
    private ReplyCallback globalReplyCallback = new ReplyCallback() {

        @Override
        public void callback(Pointer addr, Pointer buf, int size) {
            ByteBuffer b = buf.getByteBuffer(0, size);
            for (MessageReceivedListener l : messageListeners) {
                l.messageReceived(b.order(ByteOrder.BIG_ENDIAN), size);
            }
        }
    };
    ArrayList<ScSynthStartedListener> startedListeners = new ArrayList<ScSynthStartedListener>();
    ArrayList<ScSynthStoppedListener> stoppedListeners = new ArrayList<ScSynthStoppedListener>();
    ArrayList<MessageReceivedListener> messageListeners = new ArrayList<MessageReceivedListener>();

    public void addScSynthStartedListener(ScSynthStartedListener listener) {
        if (listener == null) {
            throw new IllegalArgumentException("null listener");
        }
        startedListeners.add(listener);
    }

    public void removeScSynthStartedListener(ScSynthStartedListener listener) {
        if (listener == null) {
            throw new IllegalArgumentException("null listener");
        }
        startedListeners.remove(listener);
    }

    public void addScSynthStoppedListener(ScSynthStoppedListener listener) {
        if (listener == null) {
            throw new IllegalArgumentException("null listener");
        }
        stoppedListeners.add(listener);
    }

    public void removeScSynthStoppedListener(ScSynthStoppedListener listener) {
        if (listener == null) {
            throw new IllegalArgumentException("null listener");
        }
        stoppedListeners.remove(listener);
    }

    public void addMessageReceivedListener(MessageReceivedListener listener) {
        if (listener == null) {
            throw new IllegalArgumentException("null listener");
        }
        messageListeners.add(listener);
    }

    public void removeMessageReceivedListener(MessageReceivedListener listener) {
        if (listener == null) {
            throw new IllegalArgumentException("null listener");
        }
        messageListeners.remove(listener);
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
//        ScsynthJnaStartOptions.ByReference retval = ScSynthLibrary.scsynth_jna_get_default_start_options();
//        int count = ScSynthLibrary.scsynth_jna_get_device_count();
//        //int nrc = ScSynthLibrary.scsynth_jna_get_device_max_input_channels(0);
//        System.out.println("Nr devices: " + count);
//        ScSynth sc = new ScSynth();
//        (new Thread(sc)).start();
        ScSynthSetup s = new ScSynthSetup();
        s.setVisible(true);
        s.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }
}
