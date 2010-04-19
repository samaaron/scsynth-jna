# Same license as Supercollider
# Author: Fabian Aussems
# mozinator.eu

arch = 'x86'
debug = true

scsynth_source_files = <<EOF
../supercollider/common/source/server/samp.cpp
../supercollider/common/source/server/sc_bufgen.cpp
../supercollider/common/source/server/sc_carbon.cpp
../supercollider/common/source/server/sc_complex.cpp
../supercollider/common/source/server/sc_comport.cpp
../supercollider/common/source/server/sc_coreaudio.cpp
../supercollider/common/source/server/sc_errors.cpp
../supercollider/common/source/server/sc_graph.cpp
../supercollider/common/source/server/sc_graphdef.cpp
../supercollider/common/source/server/sc_group.cpp
../supercollider/common/source/server/sc_lib.cpp
../supercollider/common/source/server/sc_lib_cintf.cpp
../supercollider/common/source/server/sc_misccmds.cpp
../supercollider/common/source/server/sc_node.cpp
../supercollider/common/source/server/sc_rate.cpp
../supercollider/common/source/server/sc_sequencedcommand.cpp
../supercollider/common/source/server/sc_str4.cpp
../supercollider/common/source/server/sc_synccondition.cpp
../supercollider/common/source/server/sc_unit.cpp
../supercollider/common/source/server/sc_unitdef.cpp
../supercollider/common/source/server/sc_world.cpp
../supercollider/common/source/server/scsynth_main.cpp
../supercollider/common/source/common/sc_allocpool.cpp
../supercollider/common/source/common/sc_dirutils.cpp
../supercollider/common/source/common/sc_sem.cpp
../supercollider/common/source/common/sc_stringparser.cpp
../supercollider/common/source/common/sc_win32utils.cpp
../pthread-win32/pthread.c
../supercollider/windows/compat_stuff/wsa-pthread-compat-stuff.cpp
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
../asio-sdk/host/asioconvertsamples.cpp
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
#scsynth_defines << 'WIN32' if arch == 'x86' # only needed for portmidi

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


if arch == 'x86_64' && debug == false
  file.puts 'del /q src\main\resources\supercollider\scsynth\windows\x86_64\*.*'
  file.puts 'del /q src\main\resources\supercollider\scsynth\windows\x86_64\ugens\*.*'
  file.puts 'copy /y scsynth_jna.dll src\main\resources\supercollider\scsynth\windows\x86_64'
  file.puts 'copy /y ..\supercollider\windows\scsynth-x86_64-release\libsndfile-1.dll src\main\resources\supercollider\scsynth\windows\x86_64'  
  
  file.puts 'copy /y ..\supercollider\windows\scsynth-x86_64-release\scsynth.dll src\main\resources\supercollider\scsynth\windows\x86_64\ugens'
  file.puts 'copy /y ..\supercollider\windows\scsynth-x86_64-release\ugens\*.scx src\main\resources\supercollider\scsynth\windows\x86_64\ugens'
  file.puts 'copy /y ..\supercollider\windows\scsynth-x86_64-release\ugens\*.dll src\main\resources\supercollider\scsynth\windows\x86_64\ugens'
end

if arch == 'x86_64' && debug == true
  file.puts 'del /q src\main\resources\supercollider\scsynth\windows\x86_64\*.*'
  file.puts 'del /q src\main\resources\supercollider\scsynth\windows\x86_64\ugens\*.*'  
  file.puts 'copy /y scsynth_jna.dll src\main\resources\supercollider\scsynth\windows\x86_64'
  file.puts 'copy /y ..\supercollider\windows\scsynth-x86_64-debug\libsndfile-1.dll src\main\resources\supercollider\scsynth\windows\x86_64'  
  
  file.puts 'copy /y ..\supercollider\windows\scsynth-x86_64-debug\scsynth.dll src\main\resources\supercollider\scsynth\windows\x86_64\ugens'
  file.puts 'copy /y ..\supercollider\windows\scsynth-x86_64-debug\ugens\*.scx src\main\resources\supercollider\scsynth\windows\x86_64\ugens'
  file.puts 'copy /y ..\supercollider\windows\scsynth-x86_64-debug\ugens\*.dll src\main\resources\supercollider\scsynth\windows\x86_64\ugens'
end

if arch == 'x86' && debug == false
  file.puts 'del /q src\main\resources\supercollider\scsynth\windows\x86\*.*'
  file.puts 'del /q src\main\resources\supercollider\scsynth\windows\x86\ugens\*.*'  
  file.puts 'copy /y scsynth_jna.dll src\main\resources\supercollider\scsynth\windows\x86'
  file.puts 'copy /y ..\supercollider\windows\scsynth-x86-release\libsndfile-1.dll src\main\resources\supercollider\scsynth\windows\x86'  
  
  file.puts 'copy /y ..\supercollider\windows\scsynth-x86-release\scsynth.dll src\main\resources\supercollider\scsynth\windows\x86\ugens'
  file.puts 'copy /y ..\supercollider\windows\scsynth-x86-release\ugens\*.scx src\main\resources\supercollider\scsynth\windows\x86\ugens'
  file.puts 'copy /y ..\supercollider\windows\scsynth-x86-release\ugens\*.dll src\main\resources\supercollider\scsynth\windows\x86\ugens'
end

if arch == 'x86' && debug == true
  file.puts 'del /q src\main\resources\supercollider\scsynth\windows\x86\*.*'
  file.puts 'del /q src\main\resources\supercollider\scsynth\windows\x86\ugens\*.*'    
  file.puts 'copy /y scsynth_jna.dll src\main\resources\supercollider\scsynth\windows\x86'
  file.puts 'copy /y ..\supercollider\windows\scsynth-x86-debug\libsndfile-1.dll src\main\resources\supercollider\scsynth\windows\x86'  
  
  file.puts 'copy /y ..\supercollider\windows\scsynth-x86-debug\scsynth.dll src\main\resources\supercollider\scsynth\windows\x86\ugens'
  file.puts 'copy /y ..\supercollider\windows\scsynth-x86-debug\ugens\*.scx src\main\resources\supercollider\scsynth\windows\x86\ugens'
  file.puts 'copy /y ..\supercollider\windows\scsynth-x86-debug\ugens\*.dll src\main\resources\supercollider\scsynth\windows\x86\ugens'
end

file.close
