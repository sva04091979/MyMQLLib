#ifndef _C_MA_
#define _C_MA_

#ifdef __MQL5__
   #include "MQL5\CMQL5MA.mqh"
   #define MA CMQL5MA  
#else
   #include "MQL4\CMQL4MA.mqh"
   #define MA CMQL4MA   
#endif

#endif