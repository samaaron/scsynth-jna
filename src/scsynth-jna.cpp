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

#ifdef SC_WIN32
// according to this page: http://www.mkssoftware.com/docs/man3/setlinebuf.3.asp
// setlinebuf is equivalent to the setvbuf call below.
inline int setlinebuf(FILE *stream)
{
    return setvbuf( stream, (char*)0, _IONBF, 0 );
}

#endif

struct SndBuf * scsynth_jna_copy_sndbuf(World *world, uint32 index)
{
	bool didChange;
	struct SndBuf* buf = (struct SndBuf*) malloc(sizeof(struct SndBuf));
        memset(buf, 0, sizeof(struct SndBuf));
	int serverErr = World_CopySndBuf(world, index, buf, false, didChange);
	return buf;
}


int scsynth_jna_init()
{
#ifdef SC_WIN32
#ifdef SC_WIN32_STATIC_PTHREADS
    // initialize statically linked pthreads library
    pthread_win32_process_attach_np();
#endif

    // initialize winsock
    WSAData wsaData;
	  int nCode;
    if ((nCode = WSAStartup(MAKEWORD(1, 1), &wsaData)) != 0) {
		    scprintf( "WSAStartup() failed with error code %d.\n", nCode );
        return -1;
    }
#endif
    return 0;
}

World* scsynth_jna_start(ScsynthJnaStartOptions *inOptions)
{
    setlinebuf(stdout);

	WorldOptions options = kDefaultWorldOptions;
	
	options.mVerbosity = inOptions->verbosity;
  options.mUGensPluginPath = inOptions->UGensPluginPath;

	struct World *world = World_New(&options);
	if (!world) return 0;
	
	if(options.mVerbosity >=0){
		scprintf("SuperCollider 3 server ready..\n");
	}
  
	fflush(stdout);
	
	return world;
}

void scsynth_jna_cleanup()
{  
#ifdef SC_WIN32
    // clean up winsock
    WSACleanup();

#ifdef SC_WIN32_STATIC_PTHREADS
    // clean up statically linked pthreads
    pthread_win32_process_detach_np();
#endif
#endif
}
