#ifndef _I_TRAL_
#define _I_TRAL_

#include "..\CBaseTrade.mqh"

interface ITral{
   double      GetSL(double mPrice,double mSL,double mPriceOpen);
   ITral*      Init(CTradeConst* mTradeConst,int mDirection);
  };

#endif 