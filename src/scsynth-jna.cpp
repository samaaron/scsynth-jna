#include "SC_WorldOptions.h"
#include "scsynth-jna.h"

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <math.h>
#include "clz.h"
#include <stdexcept>
#ifdef SC_WIN32
#include <pthread.h>
#include <winsock2.h>
#else
#include <dlfcn.h>
#include <sys/wait.h>
#endif

#include "SC_SndBuf.h"


void (*dyn_SetPrintFunc)(PrintFunc);
struct World* (*dyn_World_New)(WorldOptions *);
void (*dyn_World_Cleanup)(World *);
void (*dyn_World_NonRealTimeSynthesis)(struct World *, WorldOptions *);
int (*dyn_World_OpenUDP)(struct World *, int );
int (*dyn_World_OpenTCP)(struct World *, int , int , int );
void (*dyn_World_WaitForQuit)(struct World *);
bool (*dyn_World_SendPacket)(struct World *, int , char *, ReplyFunc );
bool (*dyn_World_SendPacketWithContext)(struct World *, int , char *, ReplyFunc , void *);
int (*dyn_World_CopySndBuf)(World *, uint32 , struct SndBuf *, bool , bool &);
int (*dyn_scprintf)(const char *, ...);

#ifdef SC_WIN32

// according to this page: http://www.mkssoftware.com/docs/man3/setlinebuf.3.asp
// setlinebuf is equivalent to the setvbuf call below.
inline int setlinebuf(FILE *stream)
{
    return setvbuf( stream, (char*)0, _IONBF, 0 );
}

#endif

struct SndBuf * ScJnaCopySndBuf(World *world, uint32 index)
{
	bool didChange;
	struct SndBuf* buf = (struct SndBuf*) malloc(sizeof(struct SndBuf));
        memset(buf, 0, sizeof(struct SndBuf));
	int serverErr = dyn_World_CopySndBuf(world, index, buf, false, didChange);
	return buf;
}


#ifdef SC_WIN32
HINSTANCE scsynth_library;
#else
void* scsynth_library;
#endif
// TODO: free sndbuf function

World* ScJnaStart(JnaStartOptions *inOptions)
{
    setlinebuf(stdout);

#ifdef SC_WIN32

    scsynth_library = LoadLibrary( inOptions->libScSynthPath );
    if (!scsynth_library) 
      {
	    if(inOptions->verbosity >=0)
	    {
               fprintf (stderr, "loading library failed %s\n", inOptions->libScSynthPath);
            }
	    return 0;        
      }

    dyn_SetPrintFunc =                (void (*)(PrintFunc))                                         GetProcAddress(scsynth_library, "SetPrintFunc");
    dyn_World_New =                   (struct World* (*)(WorldOptions *))                           GetProcAddress(scsynth_library, "World_New");
    dyn_World_Cleanup =               (void (*)(World *))                                           GetProcAddress(scsynth_library, "World_Cleanup");
    dyn_World_NonRealTimeSynthesis =  (void (*)(struct World *, WorldOptions *))                    GetProcAddress(scsynth_library, "World_NonRealTimeSynthesis");
    dyn_World_OpenUDP =               (int (*)(struct World *, int ))                               GetProcAddress(scsynth_library, "World_OpenUDP");
    dyn_World_OpenTCP =               (int (*)(struct World *, int , int , int ))                   GetProcAddress(scsynth_library, "World_OpenTCP");
    dyn_World_WaitForQuit =           (void (*)(struct World *))                                    GetProcAddress(scsynth_library, "World_WaitForQuit");
    dyn_World_SendPacket =            (bool (*)(struct World *, int , char *, ReplyFunc ))          GetProcAddress(scsynth_library, "World_SendPacket");
    dyn_World_SendPacketWithContext = (bool (*)(struct World *, int , char *, ReplyFunc , void *))  GetProcAddress(scsynth_library, "World_SendPacketWithContext");
    dyn_World_CopySndBuf =            (int (*)(World *, uint32 , struct SndBuf *, bool , bool &))   GetProcAddress(scsynth_library, "World_CopySndBuf");
    dyn_scprintf =                    (int (*)(const char *, ...))                                  GetProcAddress(scsynth_library, "scprintf");

    if (!dyn_scprintf) 
    {
      if(inOptions->verbosity >=0)
        {
          fprintf (stderr, "loading scsynth functions library failed\n");
        }
      return 0;
    }

#else
   
    scsynth_library = dlopen(inOptions->libScSynthPath, RTLD_LAZY);
    if(scsynth_library == NULL) {
	    if(inOptions->verbosity >=0)
	    {
               fprintf (stderr, "dlopen failed %s\n", inOptions->libScSynthPath);
            }
	    return 0;
    }

    dlerror();

    dyn_SetPrintFunc =                (void (*)(PrintFunc))                                         dlsym(scsynth_library, "SetPrintFunc");
    dyn_World_New =                   (struct World* (*)(WorldOptions *))                           dlsym(scsynth_library, "World_New");
    dyn_World_Cleanup =               (void (*)(World *))                                           dlsym(scsynth_library, "World_Cleanup");
    dyn_World_NonRealTimeSynthesis =  (void (*)(struct World *, WorldOptions *))                    dlsym(scsynth_library, "World_NonRealTimeSynthesis");
    dyn_World_OpenUDP =               (int (*)(struct World *, int ))                               dlsym(scsynth_library, "World_OpenUDP");
    dyn_World_OpenTCP =               (int (*)(struct World *, int , int , int ))                   dlsym(scsynth_library, "World_OpenTCP");
    dyn_World_WaitForQuit =           (void (*)(struct World *))                                    dlsym(scsynth_library, "World_WaitForQuit");
    dyn_World_SendPacket =            (bool (*)(struct World *, int , char *, ReplyFunc ))          dlsym(scsynth_library, "World_SendPacket");
    dyn_World_SendPacketWithContext = (bool (*)(struct World *, int , char *, ReplyFunc , void *))  dlsym(scsynth_library, "World_SendPacketWithContext");
    dyn_World_CopySndBuf =            (int (*)(World *, uint32 , struct SndBuf *, bool , bool &))   dlsym(scsynth_library, "World_CopySndBuf");
    dyn_scprintf =                    (int (*)(const char *, ...))                                  dlsym(scsynth_library, "scprintf");

    char *error;
    if ((error = dlerror()) != NULL)  {
        if(inOptions->verbosity >=0)
        {
	    fprintf (stderr, "%s\n", error);
        }
        return 0;
    }
    
#endif

#ifdef SC_WIN32
#ifdef SC_WIN32_STATIC_PTHREADS
    // initialize statically linked pthreads library
    pthread_win32_process_attach_np();
#endif

    // initialize winsock
    WSAData wsaData;
	int nCode;
    if ((nCode = WSAStartup(MAKEWORD(1, 1), &wsaData)) != 0) {
		dyn_scprintf( "WSAStartup() failed with error code %d.\n", nCode );
        return 0;
    }
#endif

	int udpPortNum = inOptions->udpPortNum;
	int tcpPortNum = inOptions->tcpPortNum;

	WorldOptions options = kDefaultWorldOptions;
	
	options.mVerbosity = inOptions->verbosity;
        options.mUGensPluginPath = inOptions->UGensPluginPath;

	struct World *world = dyn_World_New(&options);
	if (!world) return 0;

	/*
	if (!options.mRealTime) {
		try {
			World_NonRealTimeSynthesis(world, &options);
		} catch (std::exception& exc) {
			scprintf("%s\n", exc.what());
			exitCode = 0;
		}
		return 0;
	}
	*/

	if (udpPortNum >= 0) {
		if (!dyn_World_OpenUDP(world, udpPortNum)) {
			dyn_World_Cleanup(world);
			return 0;
		}
	}
	if (tcpPortNum >= 0) {
		if (!dyn_World_OpenTCP(world, tcpPortNum, options.mMaxLogins, 8)) {
			dyn_World_Cleanup(world);
			return 0;
		}
	}

#ifdef SC_DARWIN
    //dyn_World_OpenMachPorts(world, options.mServerPortName, options.mReplyPortName);
#endif
	
	if(options.mVerbosity >=0){
		dyn_scprintf("SuperCollider 3 server ready..\n");
	}
	fflush(stdout);
	
	return world;
}

void ScJnaCleanup()
{  
#ifdef SC_WIN32
    // clean up winsock
    WSACleanup();

#ifdef SC_WIN32_STATIC_PTHREADS
    // clean up statically linked pthreads
    pthread_win32_process_detach_np();
#endif
#endif
#ifdef SC_WIN32
    FreeLibrary(scsynth_library);
#else
    dlclose(scsynth_library);
#endif
}
