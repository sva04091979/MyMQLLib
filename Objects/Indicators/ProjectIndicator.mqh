#ifndef _C_PROJECT_INDICATOR_
#define _C_PROJECT_INDICATOR_

#ifdef __MQL5__
   #include "MQL5\CMQL5ProjectIndicator.mqh"
   #define ProjectIndicator CMQL5ProjectIndicator  
#else
   #include "MQL4\CMQL4ProjectIndicator.mqh"
   #define ProjectIndicator CMQL4ProjectIndicator  
#endif

#endif