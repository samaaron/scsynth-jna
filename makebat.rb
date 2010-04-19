# Same license as Supercollider
# Author: Fabian Aussems
# mozinator.eu

arch = 'x86'
debug = false

scsynth_source_files = <<EOF
../supercollider/common/source/server/Samp.cpp
../supercollider/common/source/server/SC_BufGen.cpp
../supercollider/common/source/server/SC_Carbon.cpp
../supercollider/common/source/server/SC_Complex.cpp
../supercollider/common/source/server/SC_ComPort.cpp
../supercollider/common/source/server/SC_CoreAudio.cpp
../supercollider/common/source/server/SC_Errors.cpp
../supercollider/common/source/server/SC_Graph.cpp
../supercollider/common/source/server/SC_GraphDef.cpp
../supercollider/common/source/server/SC_Group.cpp
../supercollider/common/source/server/SC_Lib.cpp
../supercollider/common/source/server/SC_Lib_Cintf.cpp
../supercollider/common/source/server/SC_MiscCmds.cpp
../supercollider/common/source/server/SC_Node.cpp
../supercollider/common/source/server/SC_Rate.cpp
../supercollider/common/source/server/SC_SequencedCommand.cpp
../supercollider/common/source/server/SC_Str4.cpp
../supercollider/common/source/server/SC_SyncCondition.cpp
../supercollider/common/source/server/SC_Unit.cpp
../supercollider/common/source/server/SC_UnitDef.cpp
../supercollider/common/source/server/SC_World.cpp
../supercollider/common/source/server/scsynth_main.cpp
../supercollider/common/source/common/SC_AllocPool.cpp
../supercollider/common/source/common/SC_DirUtils.cpp
../supercollider/common/source/common/SC_Sem.cpp
../supercollider/common/source/common/SC_StringParser.cpp
../supercollider/common/source/common/SC_Win32Utils.cpp
../pthread-win32/pthread.c
../supercollider/windows/compat_stuff/WSA-pthread-compat-stuff.cpp
../portaudio/src/common/pa_allocation.c
../portaudio/src/common/pa_converters.c
../portaudio/src/common/pa_cpuload.c
../portaudio/src/common/pa_debugprint.c
../portaudio/src/common/pa_dither.c
../portaudio/src/common/pa_front.c
../portaudio/src/common/pa_process.c
../portaudio/src/common/pa_ringbuffer.c
../portaudio/src/common/pa_skeleton.c
../portaudio/src/common/pa_stream.c
../portaudio/src/common/pa_trace.c
../portaudio/src/hostapi/wmme/pa_win_wmme.c
../portaudio/src/hostapi/asio/iasiothiscallresolver.cpp
../portaudio/src/hostapi/asio/pa_asio.cpp
../portaudio/src/hostapi/wasapi/pa_win_wasapi.c
../portaudio/src/os/win/pa_win_hostapis.c
../portaudio/src/os/win/pa_win_util.c
../portaudio/src/os/win/pa_win_waveformat.c
../portaudio/src/os/win/pa_x86_plain_converters.c
../asio-sdk/common/asio.cpp
../asio-sdk/common/debugmessage.cpp
../asio-sdk/common/register.cpp
../asio-sdk/host/ASIOConvertSamples.cpp
../asio-sdk/host/asiodrivers.cpp
../asio-sdk/host/pc/asiolist.cpp
./src/scsynth-jna.cpp
EOF
scsynth_source_files = scsynth_source_files.split

header_dirs = <<EOF
../supercollider/common/Headers/common                      
../supercollider/common/Headers/plugin_interface 
../supercollider/common/Headers/server 
../pthread-win32
../portaudio/include
../portaudio/src/common
../asio-sdk/common
../asio-sdk/host
../asio-sdk/host/pc
../supercollider/windows/lib32/libsndfile/include
../supercollider/windows/lib32/fftw3
../supercollider/windows/compat_stuff
./include
EOF
header_dirs = header_dirs.split


ugens = {}
ugens["BinaryOpUGens"] = {}
ugens["BinaryOpUGens"]["sources"]= []
ugens["BinaryOpUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["BinaryOpUGens"]["sources"] << "../supercollider/common/source/plugins/BinaryOpUGens.cpp"
ugens["BinaryOpUGens"]["export"] = "BINARYOPUGENS_EXPORTS"
ugens["ChaosUGens"] = {}
ugens["ChaosUGens"]["sources"]= []
ugens["ChaosUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["ChaosUGens"]["sources"] << "../supercollider/common/source/plugins/ChaosUGens.cpp"
ugens["ChaosUGens"]["export"] = "DELAYUGENS_EXPORTS"
ugens["DelayUGens"] = {}
ugens["DelayUGens"]["sources"]= []
ugens["DelayUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["DelayUGens"]["sources"] << "../supercollider/common/source/plugins/DelayUGens.cpp"
ugens["DelayUGens"]["export"] = "DELAYUGENS_EXPORTS"
ugens["DemandUGens"] = {}
ugens["DemandUGens"]["sources"]= []
ugens["DemandUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["DemandUGens"]["sources"] << "../supercollider/common/source/plugins/DemandUGens.cpp"
ugens["DemandUGens"]["export"] = "DELAYUGENS_EXPORTS"
ugens["DiskIOUGens"] = {}
ugens["DiskIOUGens"]["sources"]= []
ugens["DiskIOUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["DiskIOUGens"]["sources"] << "../supercollider/common/source/plugins/DiskIO_UGens.cpp"
ugens["DiskIOUGens"]["sources"] << "../supercollider/common/source/server/SC_SyncCondition.cpp"
ugens["DiskIOUGens"]["export"] = "DISKIOUGENS_EXPORTS"
ugens["DiskIOUGens"]["sndfile"] = true
ugens["DynNoiseUGens"] = {}
ugens["DynNoiseUGens"]["sources"]= []
ugens["DynNoiseUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["DynNoiseUGens"]["sources"] << "../supercollider/common/source/plugins/DynNoiseUGens.cpp"
ugens["DynNoiseUGens"]["export"] = "DELAYUGENS_EXPORTS"
ugens["FFT2_UGens"] = {}
ugens["FFT2_UGens"]["sources"]= []
ugens["FFT2_UGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["FFT2_UGens"]["sources"] << "../supercollider/common/Source/plugins/Convolution.cpp"
ugens["FFT2_UGens"]["sources"] << "../supercollider/common/Source/plugins/FeatureDetection.cpp"
ugens["FFT2_UGens"]["sources"] << "../supercollider/common/Source/plugins/FFT2InterfaceTable.cpp"
ugens["FFT2_UGens"]["sources"] << "../supercollider/common/Source/plugins/PV_ThirdParty.cpp"
ugens["FFT2_UGens"]["sources"] << "../supercollider/common/Source/common/SC_fftlib.cpp"
ugens["FFT2_UGens"]["sources"] << "../supercollider/common/Source/plugins/SCComplex.cpp"
ugens["FFT2_UGens"]["export"] = "DELAYUGENS_EXPORTS"
ugens["FFT2_UGens"]["fftw"] = true
ugens["FFT_UGens"] = {}
ugens["FFT_UGens"]["sources"]= []
ugens["FFT_UGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["FFT_UGens"]["sources"] << "../supercollider/common/source/plugins/FFT_UGens.cpp"
ugens["FFT_UGens"]["sources"] << "../supercollider/common/Source/plugins/FFTInterfaceTable.cpp"
ugens["FFT_UGens"]["sources"] << "../supercollider/common/Source/plugins/PartitionedConvolution.cpp"
ugens["FFT_UGens"]["sources"] << "../supercollider/common/Source/plugins/PV_UGens.cpp"
ugens["FFT_UGens"]["sources"] << "../supercollider/common/Source/common/SC_fftlib.cpp"
ugens["FFT_UGens"]["sources"] << "../supercollider/common/source/plugins/SCComplex.cpp"
ugens["FFT_UGens"]["export"] = "FFT_UGENS_EXPORTS"
ugens["FFT_UGens"]["fftw"] = true
ugens["FilterUGens"] = {}
ugens["FilterUGens"]["sources"]= []
ugens["FilterUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["FilterUGens"]["sources"] << "../supercollider/common/source/plugins/FilterUGens.cpp"
ugens["FilterUGens"]["export"] = "FILTERUGENS_EXPORTS"
ugens["GendynUGens"] = {}
ugens["GendynUGens"]["sources"]= []
ugens["GendynUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["GendynUGens"]["sources"] << "../supercollider/common/source/plugins/GendynUGens.cpp"
ugens["GendynUGens"]["export"] = "DELAYUGENS_EXPORTS"
ugens["GrainUGens"] = {}
ugens["GrainUGens"]["sources"]= []
ugens["GrainUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["GrainUGens"]["sources"] << "../supercollider/common/Source/plugins/GrainUGens.cpp"
ugens["GrainUGens"]["export"] = "DELAYUGENS_EXPORTS"
ugens["IOUGens"] = {}
ugens["IOUGens"]["sources"]= []
ugens["IOUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["IOUGens"]["sources"] << "../supercollider/common/source/plugins/IOUGens.cpp"
ugens["IOUGens"]["export"] = "IOUGENS_EXPORTS"
#ugens["JoshUGens"] = {}
#ugens["JoshUGens"]["sources"]= []
#ugens["JoshUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
#ugens["JoshUGens"]["sources"] << "../../JoshLib/JoshUGens.cpp"
#ugens["JoshUGens"]["export"] = "DELAYUGENS_EXPORTS"
ugens["LFUGens"] = {}
ugens["LFUGens"]["sources"]= []
ugens["LFUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["LFUGens"]["sources"] << "../supercollider/common/source/plugins/LFUGens.cpp"
ugens["LFUGens"]["export"] = "LFUGENS_EXPORTS"
ugens["MachineListeningUGens"] = {}
ugens["MachineListeningUGens"]["sources"]= []
ugens["MachineListeningUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["MachineListeningUGens"]["sources"] << "../supercollider/common/Source/plugins/BeatTrack.cpp"
ugens["MachineListeningUGens"]["sources"] << "../supercollider/common/Source/plugins/BeatTrack2.cpp"
ugens["MachineListeningUGens"]["sources"] << "../supercollider/common/Source/plugins/KeyTrack.cpp"
ugens["MachineListeningUGens"]["sources"] << "../supercollider/common/Source/plugins/Loudness.cpp"
ugens["MachineListeningUGens"]["sources"] << "../supercollider/common/Source/plugins/MFCC.cpp"
ugens["MachineListeningUGens"]["sources"] << "../supercollider/common/Source/plugins/ML.cpp"
ugens["MachineListeningUGens"]["sources"] << "../supercollider/common/Source/plugins/ML_SpecStats.cpp"
ugens["MachineListeningUGens"]["sources"] << "../supercollider/common/Source/plugins/Onsets.cpp"
ugens["MachineListeningUGens"]["sources"] << "../supercollider/common/Source/plugins/onsetsds.c"
ugens["MachineListeningUGens"]["sources"] << "../supercollider/common/Source/plugins/SCComplex.cpp"
ugens["MachineListeningUGens"]["export"] = "DELAYUGENS_EXPORTS"
ugens["MouseUGens"] = {}
ugens["MouseUGens"]["sources"]= []
ugens["MouseUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["MouseUGens"]["sources"] << "../supercollider/common/Source/plugins/MouseUGens.cpp"
ugens["MouseUGens"]["export"] = "MACUGENS_EXPORTS"
ugens["MulAddUGens"] = {}
ugens["MulAddUGens"]["sources"]= []
ugens["MulAddUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["MulAddUGens"]["sources"] << "../supercollider/common/source/plugins/MulAddUGens.cpp"
ugens["MulAddUGens"]["export"] = "MULADDUGENS_EXPORTS"
ugens["NoiseUGens"] = {}
ugens["NoiseUGens"]["sources"]= []
ugens["NoiseUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["NoiseUGens"]["sources"] << "../supercollider/common/source/plugins/NoiseUGens.cpp"
ugens["NoiseUGens"]["export"] = "NOISEUGENS_EXPORTS"
ugens["OSCUGens"] = {}
ugens["OSCUGens"]["sources"]= []
ugens["OSCUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["OSCUGens"]["sources"] << "../supercollider/common/source/plugins/OscUGens.cpp"
ugens["OSCUGens"]["export"] = "OSCUGENS_EXPORTS"
ugens["PanUGens"] = {}
ugens["PanUGens"]["sources"]= []
ugens["PanUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["PanUGens"]["sources"] << "../supercollider/common/source/plugins/PanUGens.cpp"
ugens["PanUGens"]["export"] = "PANUGENS_EXPORTS"
ugens["PhysicalModelingUGens"] = {}
ugens["PhysicalModelingUGens"]["sources"]= []
ugens["PhysicalModelingUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["PhysicalModelingUGens"]["sources"] << "../supercollider/common/source/plugins/PhysicalModelingUGens.cpp"
ugens["PhysicalModelingUGens"]["export"] = "PHYSICALMODELINGUGENS_EXPORTS"
ugens["ReverbUGens"] = {}
ugens["ReverbUGens"]["sources"]= []
ugens["ReverbUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["ReverbUGens"]["sources"] << "../supercollider/common/source/plugins/ReverbUGens.cpp"
ugens["ReverbUGens"]["export"] = "REVERBUGENS_EXPORTS"
ugens["TestUGens"] = {}
ugens["TestUGens"]["sources"]= []
ugens["TestUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["TestUGens"]["sources"] << "../supercollider/common/source/plugins/TestUGens.cpp"
ugens["TestUGens"]["export"] = "TESTUGENS_EXPORTS"
ugens["TriggerUGens"] = {}
ugens["TriggerUGens"]["sources"]= []
ugens["TriggerUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["TriggerUGens"]["sources"] << "../supercollider/common/source/plugins/TriggerUGens.cpp"
ugens["TriggerUGens"]["export"] = "TRIGGERUGENS_EXPORTS"
ugens["UnaryOpUGens"] = {}
ugens["UnaryOpUGens"]["sources"]= []
ugens["UnaryOpUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["UnaryOpUGens"]["sources"] << "../supercollider/common/source/plugins/UnaryOpUGens.cpp"
ugens["UnaryOpUGens"]["export"] = "UNARYOPUGENS_EXPORTS"
ugens["UnpackFFTUGens"] = {}
ugens["UnpackFFTUGens"]["sources"]= []
ugens["UnpackFFTUGens"]["sources"] << "../supercollider/windows/PlugIns/ExportHelper.cpp"
ugens["UnpackFFTUGens"]["sources"] << "../supercollider/common/Source/plugins/SCComplex.cpp"
ugens["UnpackFFTUGens"]["sources"] << "../supercollider/common/Source/plugins/UnpackFFTUGens.cpp"
ugens["UnpackFFTUGens"]["export"] = "DELAYUGENS_EXPORTS"


flags = ['/ERRORREPORT:PROMPT', '/W1', '/EHsc', '/D_DEBUG', '/DDEBUG', '/MTd', '/RTC1', '/Od'] if debug == true
flags = ['/O2', '/EHsc', '/DNDEBUG', '/MT'] if debug == false
pthread_compat_defines = ['__CLEANUP_C', 'PTW32_BUILD', '_WINSOCKAPI_', 'WSAGetLastError=WSAGetLastError_Compat', 'WSASetLastError=WSASetLastError_Compat'] 

scsynth_link_opts = "/SUBSYSTEM:CONSOLE /DYNAMICBASE:NO /NXCOMPAT:NO /nologo "
scsynth_link_opts += " /DEBUG " if debug == true
scsynth_link_opts += " /MACHINE:X86 " if arch == 'x86'
scsynth_link_opts += " /MACHINE:X64 " if arch == 'x86_64'

scsynth_libs = ['ws2_32.lib', 'user32.lib', 'ole32.lib', 'advapi32.lib', 'wsock32.lib' ]
scsynth_libs << '../supercollider/windows/lib64/libsndfile/libsndfile-1.lib' if arch == 'x86_64'
scsynth_libs << '../supercollider/windows/lib32/libsndfile/libsndfile-1.lib' if arch == 'x86'

scsynth_defines = []
scsynth_defines << '_CONSOLE'
scsynth_defines << '_MBCS'
scsynth_defines << 'SC_WIN32'
scsynth_defines << 'NOMINMAX'
scsynth_defines << 'SC_WIN32_STATIC_PTHREADS'
scsynth_defines << 'PA_NO_DS'
scsynth_defines << 'WIN64' if arch == 'x86_64'
scsynth_defines << 'WIN32' if arch == 'x86'

file = File.new("make32.bat", "w") if arch == 'x86' && debug == false
file = File.new("make64.bat", "w") if arch == 'x86_64' && debug == false
file = File.new("make32-debug.bat", "w") if arch == 'x86' && debug == true
file = File.new("make64-debug.bat", "w") if arch == 'x86_64' && debug == true

scsynth_source_files.each do |f|
  extra_defines = []
  extra_defines = pthread_compat_defines if f =~ /pthread\.c/
  
  file.puts "cl /nologo /c #{f} " + flags.map { |i| i + " "}.to_s \
           + header_dirs.map { |i| "/I\"#{i}\" " }.to_s \
           + scsynth_defines.map { |i| "/D#{i} "}.to_s + extra_defines.map { |i| "/D#{i} "}.to_s
end

file.puts "link " + scsynth_link_opts.gsub(/CONSOLE/,'WINDOWS') + "/DLL /OUT:scsynth_jna.dll " + scsynth_libs.map { |i| i + " " }.to_s \
                      + scsynth_source_files.map { |i| i.split('/').last.split('.').first + ".obj " }.to_s


file.puts "rem UGENS"

ugens.keys.each do |k|
  
  defines = ['SC_WIN32', '_WINDOWS', 'NOMINMAX', '_USRDLL', '_MBCS']
  defines << 'WIN64' if arch == 'x86_64'
  defines << 'WIN32' if arch == 'x86'

  defines << 'SC_FFT_FFTW' if ugens[k].has_key?('fftw')
      
  ugens[k]["sources"].each do |f| 
    extra_defines = []
    extra_defines = pthread_compat_defines if f =~ /pthread\.c/
    file.puts "cl /nologo /c #{f} " + flags.map { |i| i + " "}.to_s \
              + header_dirs.map { |i| "/I\"#{i}\" " }.to_s \
              + defines.map { |i| "/D#{i} "}.to_s + extra_defines.map { |i| "/D#{i} "}.to_s\
              + "/D#{ugens[k]["export"]} "
  end

  link_opts = "/SUBSYSTEM:WINDOWS /DYNAMICBASE:NO /NXCOMPAT:NO /nologo "
  link_opts += " /MACHINE:X86 " if arch == 'x86'
  link_opts += " /MACHINE:X64 " if arch == 'x86_64'
  link_opts += " /DEBUG " if debug == true

  libs = ['ws2_32.lib','user32.lib','ole32.lib','advapi32.lib', 'scsynth_jna.lib' ]
  libs << '../supercollider/windows/lib64/libsndfile/libsndfile-1.lib' if arch == 'x86_64'
  libs << '../supercollider/windows/lib32/libsndfile/libsndfile-1.lib' if arch == 'x86'

  if ugens[k].has_key?('fftw')
    if arch == 'x86_64'
      libs << '../supercollider/windows/lib64/fftw3/libfftw3-3.lib' 
      libs << '../supercollider/windows/lib64/fftw3/libfftw3f-3.lib' 
      libs << '../supercollider/windows/lib64/fftw3/libfftw3l-3.lib' 
    end
    if arch == 'x86'
      libs << '../supercollider/windows/lib32/fftw3/libfftw3-3.lib' 
      libs << '../supercollider/windows/lib32/fftw3/libfftw3f-3.lib' 
      libs << '../supercollider/windows/lib32/fftw3/libfftw3l-3.lib' 
    end
  end
  
  libs << '../supercollider/windows/lib32/libsndfile/libsndfile-1.lib' if arch == 'x86' && ugens[k].has_key?('sndfile')

  file.puts "link " + link_opts + " /OUT:#{k}.scx /DLL " + libs.map { |i| i + " " }.to_s \
                    + ugens[k]["sources"].map { |i| i.split('/').last.split('.').first + ".obj " }.to_s
end

if arch == 'x86_64'
  file.puts 'copy /y scsynth_jna.dll src\main\resources\supercollider\scsynth\windows\x86_64'
  file.puts 'copy /y *.scx src\main\resources\supercollider\scsynth\windows\x86_64'
  file.puts 'copy /y ..\supercollider\windows\lib64\libsndfile\*.dll src\main\resources\supercollider\scsynth\windows\x86_64'
  file.puts 'copy /y ..\supercollider\windows\lib64\fftw3\*.dll src\main\resources\supercollider\scsynth\windows\x86_64'
end
if arch == 'x86'
  file.puts 'copy /y scsynth_jna.dll src\main\resources\supercollider\scsynth\windows\x86'
  file.puts 'copy /y *.scx src\main\resources\supercollider\scsynth\windows\x86'
  file.puts 'copy /y ..\supercollider\windows\lib32\libsndfile\*.dll src\main\resources\supercollider\scsynth\windows\x86'
  file.puts 'copy /y ..\supercollider\windows\lib32\fftw3\*.dll src\main\resources\supercollider\scsynth\windows\x86'
end

file.close
