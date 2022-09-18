#ifndef _C_MQL4_CUSTOM_INDICATOR_
#define _C_MQL4_CUSTOM_INDICATOR_

#include "CMQL4IndicatorBase.mqh"

template<typename Type>
class CMQL4CastomIndicator:public CMQL4IndicatorBase<Type>{
protected:
   string cFullName;
   CMQL4CastomIndicator(string mFullName,string mSymbol,ENUM_TIMEFRAMES mFrame):
      CMQL4IndicatorBase<Type>(mSymbol,mFrame),cFullName(mFullName){}
public:
   string FullName() const {return cFullName;}
};

#endif