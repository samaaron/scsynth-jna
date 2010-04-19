/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package supercollider;

import java.nio.ByteBuffer;
import java.util.EventListener;

/**
 *
 * @author mozinator
 */
public interface MessageReceivedListener extends EventListener {
    public void messageReceived(ByteBuffer message, int size);
}
