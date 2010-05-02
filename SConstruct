# -*- python -*- =======================================================
# FILE:         SConstruct
import sys, os

env = Environment()

sourceFiles = Split("""
../supercollider/common/Source/common/SC_AllocPool.cpp
../supercollider/common/Source/common/SC_DirUtils.cpp
../supercollider/common/Source/common/sc_popen.cpp
../supercollider/common/Source/common/SC_Sem.cpp
../supercollider/common/Source/common/SC_StringBuffer.cpp
../supercollider/common/Source/common/SC_StringParser.cpp
../supercollider/common/Source/common/scsynthsend.cpp
../supercollider/common/Source/server/Rendezvous.cpp
../supercollider/common/Source/server/Samp.cpp
../supercollider/common/Source/server/SC_BufGen.cpp
../supercollider/common/Source/server/SC_Carbon.cpp
../supercollider/common/Source/server/SC_Complex.cpp
../supercollider/common/Source/server/SC_ComPort.cpp
../supercollider/common/Source/server/SC_CoreAudio.cpp
../supercollider/common/Source/server/SC_Errors.cpp
../supercollider/common/Source/server/SC_Graph.cpp
../supercollider/common/Source/server/SC_GraphDef.cpp
../supercollider/common/Source/server/SC_Group.cpp
../supercollider/common/Source/server/SC_Lib_Cintf.cpp
../supercollider/common/Source/server/SC_Lib.cpp
../supercollider/common/Source/server/SC_MiscCmds.cpp
../supercollider/common/Source/server/SC_Node.cpp
../supercollider/common/Source/server/SC_Rate.cpp
../supercollider/common/Source/server/SC_SequencedCommand.cpp
../supercollider/common/Source/server/SC_Str4.cpp
../supercollider/common/Source/server/SC_SyncCondition.cpp
../supercollider/common/Source/server/SC_Unit.cpp
../supercollider/common/Source/server/SC_UnitDef.cpp
../supercollider/common/Source/server/SC_World.cpp
../supercollider/common/Source/server/SC_Jack.cpp
./src/scsynth-jna.cpp
""")

env.Append(CPPPATH = ['../supercollider/common/Headers/common',
                      '../supercollider/common/Headers/plugin_interface', 
                      '../supercollider/common/Headers/server', 
                      './include'])

# LINUX
env.Append(CPPPATH = ["../supercollider/common/include/nova-simd"])

env.Append(CPPDEFINES={'NOVA_SIMD' : '1',
		'SC_LINUX' : '1',
		'NDEBUG' : '1',
		'_REENTRANT' : '1',
		'SC_PLUGIN_EXT' : '\\".so\\"',
		'SC_PLUGIN_LOAD_SYM' : '\\"load\\"',
		'SC_PLUGIN_DIR' : '\\"/usr/local/lib/SuperCollider/plugins\\"',
		'SC_MEMORY_ALIGNMENT' : '16',
		'SC_JACK_USE_DLL' : 'False',
		'SC_JACK_DEBUG_DLL' : 'False',
		'SC_AUDIO_API' : 'SC_AUDIO_API_JACK'})
# "-march=i686", 
env.Append(CCFLAGS=["-Wno-unknown-pragmas", "-O3", "-ffast-math", "-fno-finite-math-only", "-fstrength-reduce", "-msse", "-mfpmath=sse", "-msse2"])
env.Append(LINKFLAGS = '-ljack -lrt -lpthread -ldl -lm -lsndfile ')
# END LINUX

env.SharedLibrary(target = "scsynth_jna", source = sourceFiles)

