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

struct JnaStartOptions
{
	int32 udpPortNum;
	int32 tcpPortNum;
	int32 verbosity;
        const char* UGensPluginPath;
};

extern "C" {
	SC_DLLEXPORT World* ScJnaStart(JnaStartOptions *inOptions);
	SC_DLLEXPORT void ScJnaCleanup();
        SC_DLLEXPORT struct SndBuf * ScJnaCopySndBuf(World *world, uint32 index);
}

#endif // _SCSYNTH_JNA__
