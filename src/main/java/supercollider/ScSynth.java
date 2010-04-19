package supercollider;

import com.sun.jna.Pointer;
import java.nio.ByteBuffer;
import supercollider.ScSynthLibrary.ReplyCallback;
import supercollider.ScSynthLibrary.ScsynthJnaStartOptions;
import supercollider.ScSynthLibrary.SndBuf;

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
        }
    };

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
        (new Thread(new ScSynth())).start();
    }
}
