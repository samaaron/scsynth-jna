#include "SC_CoreAudio.h"
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

int scsynth_jna_get_device_max_output_channels(int i)
{
	int retval = 0;
	#if SC_AUDIO_API == SC_AUDIO_API_PORTAUDIO
	const PaDeviceInfo *pdi;
	const PaHostApiInfo *apiInfo;
	pdi = Pa_GetDeviceInfo( i );
	retval = pdi->maxOutputChannels;
	#endif
	#if SC_AUDIO_API == SC_AUDIO_API_COREAUDIO
	
	#endif
	return retval;
}

int scsynth_jna_get_device_max_input_channels(int i)
{
	int retval = 0;
	#if SC_AUDIO_API == SC_AUDIO_API_PORTAUDIO
	const PaDeviceInfo *pdi;
	const PaHostApiInfo *apiInfo;
	pdi = Pa_GetDeviceInfo( i );
	retval = pdi->maxInputChannels;
	#endif
	#if SC_AUDIO_API == SC_AUDIO_API_COREAUDIO
	
	#endif
	return retval;
}

const char* scsynth_jna_get_device_name(int i)
{
	char * retval = (char*)malloc(256*sizeof(char));
	#if SC_AUDIO_API == SC_AUDIO_API_PORTAUDIO
	const PaDeviceInfo *pdi;
	const PaHostApiInfo *apiInfo;
	pdi = Pa_GetDeviceInfo( i );
	apiInfo = Pa_GetHostApiInfo(pdi->hostApi);
	strcpy(retval, apiInfo->name);
	strcat(retval, " : ");
	strcat(retval, pdi->name);
	#endif
	#if SC_AUDIO_API == SC_AUDIO_API_COREAUDIO
	UInt32	count;
	OSStatus	err = kAudioHardwareNoError;
	do {
		err = AudioHardwareGetPropertyInfo(kAudioHardwarePropertyDevices, &count, 0);

		AudioDeviceID *devices = (AudioDeviceID*)malloc(count);
		err = AudioHardwareGetProperty(kAudioHardwarePropertyDevices, &count, devices);
		if (err != kAudioHardwareNoError) {
			scprintf("get kAudioHardwarePropertyDevices error %4.4s\n", (char*)&err);
			free(devices);
			break;
		}
		err = AudioDeviceGetPropertyInfo(devices[i], 0, false, kAudioDevicePropertyDeviceName, &count, 0);
		if (err != kAudioHardwareNoError) {
			scprintf("info kAudioDevicePropertyDeviceName error %4.4s A %d %08X\n", (char*)&err, i, devices[i]);
			break;
		}
		char *name = (char*)malloc(count);
		err = AudioDeviceGetProperty(devices[i], 0, false, kAudioDevicePropertyDeviceName, &count, name);
		if (err != kAudioHardwareNoError) {
			scprintf("get kAudioDevicePropertyDeviceName error %4.4s A %d %08X\n", (char*)&err, i, devices[i]);
			free(name);
			break;
		}
		strcpy(retval, name);
		free(name);
	} while(false);	
	#endif
	return retval;
}

int scsynth_jna_get_device_count()
{
	int retval = 0;
	#if SC_AUDIO_API == SC_AUDIO_API_PORTAUDIO
	retval = Pa_GetDeviceCount();
	#endif
	#if SC_AUDIO_API == SC_AUDIO_API_COREAUDIO
	UInt32	count;
	OSStatus	err = kAudioHardwareNoError;
	do {	
		err = AudioHardwareGetPropertyInfo(kAudioHardwarePropertyDevices, &count, 0);

		AudioDeviceID *devices = (AudioDeviceID*)malloc(count);
		err = AudioHardwareGetProperty(kAudioHardwarePropertyDevices, &count, devices);
		if (err != kAudioHardwareNoError) {
			scprintf("get kAudioHardwarePropertyDevices error %4.4s\n", (char*)&err);
			free(devices);
			break;
		}

		retval = count / sizeof(AudioDeviceID);
	} while(false);
	#endif
	return retval;
}

ScsynthJnaStartOptions* scsynth_jna_get_default_start_options()
{
  struct ScsynthJnaStartOptions *options = (struct ScsynthJnaStartOptions*)malloc(sizeof(struct ScsynthJnaStartOptions));
	memset(options, 0, sizeof(struct ScsynthJnaStartOptions));
  options->numControlBusChannels =               kDefaultWorldOptions.mNumControlBusChannels;       
  options->numAudioBusChannels =                 kDefaultWorldOptions.mNumAudioBusChannels;
  options->numInputBusChannels =                 kDefaultWorldOptions.mNumInputBusChannels;
  options->numOutputBusChannels =                kDefaultWorldOptions.mNumOutputBusChannels;
  options->bufLength =                           kDefaultWorldOptions.mBufLength;
  options->preferredHardwareBufferFrameSize =    kDefaultWorldOptions.mPreferredHardwareBufferFrameSize;
  options->preferredSampleRate =                 kDefaultWorldOptions.mPreferredSampleRate;
  options->numBuffers =                          kDefaultWorldOptions.mNumBuffers;
  options->maxNodes =                            kDefaultWorldOptions.mMaxNodes;
  options->maxGraphDefs =                        kDefaultWorldOptions.mMaxGraphDefs;
  options->realTimeMemorySize =                  kDefaultWorldOptions.mRealTimeMemorySize;
  options->maxWireBufs =                         kDefaultWorldOptions.mMaxWireBufs;
  options->numRGens =                            kDefaultWorldOptions.mNumRGens;
  return options;
}


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

    if( -1 != inOptions->numControlBusChannels) {
	    options.mNumControlBusChannels = inOptions->numControlBusChannels;
    }
    if( -1 != inOptions->numAudioBusChannels) {
	    options.mNumAudioBusChannels = inOptions->numAudioBusChannels;
    }
    if( -1 != inOptions->numInputBusChannels) { 
	    options.mNumInputBusChannels= inOptions->numInputBusChannels;
    }
    if( -1 != inOptions->numOutputBusChannels) { 
	    options.mNumOutputBusChannels = inOptions->numOutputBusChannels;
    }
    if( -1 != inOptions->bufLength) { 
	    options.mBufLength = inOptions->bufLength;
    }
    if( -1 != inOptions->preferredHardwareBufferFrameSize) { 
	    options.mPreferredHardwareBufferFrameSize = inOptions->preferredHardwareBufferFrameSize;
    }
    if( -1 != inOptions->preferredSampleRate) {
	    options.mPreferredSampleRate = inOptions->preferredSampleRate;
    }
    if( -1 != inOptions->numBuffers) { 
	    options.mNumBuffers = inOptions->numBuffers;
    }
    if( -1 != inOptions->maxNodes) { 
	    options.mMaxNodes = inOptions->maxNodes;
    }
    if( -1 != inOptions->maxGraphDefs) { 
	    options.mMaxGraphDefs = inOptions->maxGraphDefs;
    }
    if( -1 != inOptions->realTimeMemorySize) { 
	    options.mRealTimeMemorySize = inOptions->realTimeMemorySize;
    }
    if( -1 != inOptions->maxWireBufs) { 
	    options.mMaxWireBufs = inOptions->maxWireBufs;
    }
    if( -1 != inOptions->numRGens) { 
	    options.mNumRGens = inOptions->numRGens;
    }
    if( 0 != strcmp("", inOptions->inDeviceName )) { // not empty
	    options.mInDeviceName = inOptions->inDeviceName;
    }
    if( 0 != strcmp("", inOptions->outDeviceName )) { // not empty
	    options.mOutDeviceName = inOptions->outDeviceName;
    }

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
