#ifndef _SCSYTNH_JNA_
#define _SCSYNTH_JNA__

#include <stdarg.h>
#include "SC_Types.h"

#if defined(SC_DARWIN) || defined(SC_IPHONE)
#include <CoreFoundation/CFString.h>
#endif

#include "SC_Reply.h"

#ifdef SC_WIN32
# define SC_DLLEXPORT __declspec(dllexport)
#else
# define SC_DLLEXPORT
#endif

struct ScsynthJnaStartOptions
{
	int32 verbosity;
  const char* UGensPluginPath;
};

extern "C" {
	SC_DLLEXPORT int scsynth_jna_init();
  SC_DLLEXPORT World* scsynth_jna_start(ScsynthJnaStartOptions *options);	  
  SC_DLLEXPORT void scsynth_jna_cleanup();
  SC_DLLEXPORT struct SndBuf * scsynth_jna_copy_sndbuf(World *world, uint32 index);
}

#endif // _SCSYNTH_JNA__
