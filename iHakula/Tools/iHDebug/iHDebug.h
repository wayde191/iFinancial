//
//  iHDebug.h
//  iHakula
//
//  Created by Wayde Sun on 2/21/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#ifndef iHakula_iHDebug_h
#define iHakula_iHDebug_h

#define iHDEBUG             1
#define iHMAXLOGLEVEL       2
#define iHLOGLEVEL_INFO     2
#define iHLOGLEVEL_WARNING  3
#define iHLOGLEVEL_ERROR    4

#ifndef iHMAXLOGLEVEL

#ifdef DEBUG
    #define iHMAXLOGLEVEL iHLOGLEVEL_INFO
#else
    #define iHMAXLOGLEVEL iHLOGLEVEL_ERROR
#endif

#endif

// The general purpose logger. This ignores logging levels.
#ifdef iHDEBUG
  #define iHDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
  #define iHDPRINT(xx, ...)  ((void)0)
#endif

// Prints the current method's name.
#define iHDPRINTMETHODNAME() iHDPRINT(@"%s", __PRETTY_FUNCTION__)

// Log-level based logging macros.
#if iHLOGLEVEL_ERROR <= iHMAXLOGLEVEL
  #define iHDERROR(xx, ...)  iHDPRINT(xx, ##__VA_ARGS__)
#else
  #define iHDERROR(xx, ...)  ((void)0)
#endif

#if iHLOGLEVEL_WARNING <= iHMAXLOGLEVEL
  #define iHDWARNING(xx, ...)  iHDPRINT(xx, ##__VA_ARGS__)
#else
  #define iHDWARNING(xx, ...)  ((void)0)
#endif

#if iHLOGLEVEL_INFO <= iHMAXLOGLEVEL
  #define iHDINFO(xx, ...)  iHDPRINT(xx, ##__VA_ARGS__)
#else
  #define iHDINFO(xx, ...)  ((void)0)
#endif

#ifdef iHDEBUG
  #define iHDCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
                                                  iHDPRINT(xx, ##__VA_ARGS__); \
                                                } \
                                              } ((void)0)
#else
  #define iHDCONDITIONLOG(condition, xx, ...) ((void)0)
#endif


#define iHAssert(condition, ...)                                       \
do {                                                                      \
    if (!(condition)) {                                                     \
        [[NSAssertionHandler currentHandler]                                  \
            handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
                                file:[NSString stringWithUTF8String:__FILE__]  \
                            lineNumber:__LINE__                                  \
                            description:__VA_ARGS__];                             \
    }                                                                       \
} while(0)

#endif
