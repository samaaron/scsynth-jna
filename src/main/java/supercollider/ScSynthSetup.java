package supercollider;

import java.awt.HeadlessException;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Vector;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSeparator;
import javax.swing.JSpinner;
import javax.swing.JTable;
import javax.swing.ListSelectionModel;
import javax.swing.ScrollPaneConstants;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableColumn;


import net.miginfocom.swing.MigLayout;

public class ScSynthSetup extends JFrame {

    public ScSynthSetup() throws HeadlessException {
        setTitle("ScSynth Setup");

        setLayout(new MigLayout());

        ScsynthJnaStartOptions.ByReference options = ScSynthLibrary.scsynth_jna_get_default_start_options();

        add(new JLabel("Information"), "split, span, gaptop 10");
        add(new JSeparator(), "growx, wrap, gaptop 10");
        add(new JLabel("operating system"), " growx");
        add(new JLabel(Util.getOsName()), " growx, wrap");
        add(new JLabel("architecture"), " growx");
        add(new JLabel(Util.getOsArch()), " growx, wrap");

        add(new JLabel("Channels"), "split, span, gaptop 10");
        add(new JSeparator(), "growx, wrap, gaptop 10");
        addVariable("numControlBusChannels", 0, 4000, options.numControlBusChannels, false);
        addVariable("numAudioBusChannels", 0, 3000, options.numAudioBusChannels, false);
        addVariable("numInputBusChannels", 0, 3000, options.numInputBusChannels, false);
        addVariable("numOutputBusChannels", 0, 3000, options.numOutputBusChannels, true);

        add(new JLabel("Buffers"), "split, span, gaptop 10");
        add(new JSeparator(), "growx, wrap, gaptop 10");
        addVariable("bufLength", 0, 30, options.bufLength, false);
        addVariable("preferredHardwareBufferFrameSize", 0, 30, options.preferredHardwareBufferFrameSize, false);
        addVariable("preferredSampleRate", 0, 30, options.preferredSampleRate, false);
        addVariable("numBuffers", 0, 30, options.numBuffers, false);

        add(new JLabel("Input device"), "split, span, gaptop 10");
        add(new JSeparator(), "growx, wrap, gaptop 10");


        DeviceSelection t = new DeviceSelection();
        t.addRow("hoi", 3, 8);
        add(t, "span, height 120!");
    }

    class DeviceSelection extends JPanel {

        class DeviceTable extends JTable {

            class DeviceTableModel extends DefaultTableModel {

                public DeviceTableModel() {
                    setColumnCount(3);
                }

                @Override
                public boolean isCellEditable(int rowIndex, int columnIndex) {
                    return false;
                }
            }
            DeviceTableModel model = new DeviceTableModel();

            public DeviceTable() {
                setModel(model);
            }

            public void addRow(String name, int max_inputs, int max_outputs) {
                Vector row = new Vector();
                row.add(name);
                row.add(max_inputs);
                row.add(max_outputs);
                model.addRow(row);
            }
        }
        DeviceTable table;

        public DeviceSelection() {
            setLayout(new MigLayout());

            table = new DeviceTable();

            table.getColumnModel().getColumn(0).setPreferredWidth(200);
            table.getColumnModel().getColumn(0).setHeaderValue("Name");
            table.getColumnModel().getColumn(1).setPreferredWidth(30);
            table.getColumnModel().getColumn(1).setHeaderValue("Max inputs");
            table.getColumnModel().getColumn(2).setPreferredWidth(30);
            table.getColumnModel().getColumn(2).setHeaderValue("Max outputs");

            table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
            table.setColumnSelectionAllowed(false);
            table.setCellSelectionEnabled(false);
            table.setRowSelectionAllowed(true);
            table.setShowVerticalLines(false);

            JScrollPane pane = new JScrollPane(table);
            pane.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS);
            pane.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);

            add(pane);
        }

        public void addRow(String name, int max_inputs, int max_outputs) {
            table.addRow(name, max_inputs, max_outputs);
        }
    }

    private void addVariable(String name, int min, int max, int val, boolean wrap) {
        add(new JLabel(name), "gap 10");
        //JSlider slider = new JSlider(JSlider.HORIZONTAL, min, max, val);
        final JSpinner spinner = new JSpinner();
        JButton reset = new JButton("reset");

        final int resetval = val;
        reset.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                spinner.setValue(resetval);
            }
        });
        spinner.setValue(val);
        //p.add(spinner, "growx");
        add(reset, "growx, height 15!");
        add(spinner, "span, growx" + (wrap ? ", wrap" : ""));
    }
}
