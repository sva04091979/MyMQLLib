#ifndef _C_LOT_SIZE_
#define _C_LOT_SIZE_

#include "CConvert.mqh"

enum ENUM_BALLANCE_TYPE
  {
   BALLANCE_TYPE_BALLANCE=ACCOUNT_BALANCE,
   BALLANCE_TYPE_EQITY=ACCOUNT_EQUITY,
   BALLANCE_TYPE_MARGIN_FREE=ACCOUNT_MARGIN_FREE
  };

class CLotSize:public CConvert
  {
public:
                     CLotSize(void):CConvert(_Symbol){}
                     CLotSize(string mSymbol):CConvert(mSymbol){}
   double            GetLotPercentBallanceRisk(double mRisk,double mDeltaPrice) {return GetLotPercentRisk(AccountInfoDouble(ACCOUNT_BALANCE),mRisk,mDeltaPrice);}
   double            GetLotPercentBallanceRisk(double mRisk,int mDeltaPrice) {return GetLotPercentRisk(AccountInfoDouble(ACCOUNT_BALANCE),mRisk,mDeltaPrice);}
   double            GetLotPercentEquityRisk(double mRisk,double mDeltaPrice) {return GetLotPercentRisk(AccountInfoDouble(ACCOUNT_EQUITY),mRisk,mDeltaPrice);}
   double            GetLotPercentEquityRisk(double mRisk,int mDeltaPrice) {return GetLotPercentRisk(AccountInfoDouble(ACCOUNT_EQUITY),mRisk,mDeltaPrice);}
   double            GetLotPercentFreeMarginRisk(double mRisk,double mDeltaPrice) {return GetLotPercentRisk(AccountInfoDouble(ACCOUNT_MARGIN_FREE),mRisk,mDeltaPrice);}
   double            GetLotPercentFreeMarginRisk(double mRisk,int mDeltaPrice) {return GetLotPercentRisk(AccountInfoDouble(ACCOUNT_MARGIN_FREE),mRisk,mDeltaPrice);}
   double            GetLotPercentRisk(ENUM_BALLANCE_TYPE mBallanceType,double mBallance,double mRisk,double mDeltaPrice)  {return GetLotPercentRisk(AccountInfoDouble((ENUM_ACCOUNT_INFO_DOUBLE)mBallanceType),mRisk,mDeltaPrice);}
   double            GetLotPercentRisk(ENUM_BALLANCE_TYPE mBallanceType,double mBallance,double mRisk,int mDeltaPrice)  {return GetLotPercentRisk(AccountInfoDouble((ENUM_ACCOUNT_INFO_DOUBLE)mBallanceType),mRisk,mDeltaPrice);}
   double            GetLotPercentRisk(double mBallance,double mRisk,double mDeltaPrice)  {return MathAbs(mBallance*mRisk/GetPointPrice((int)MathRound(mDeltaPrice/cPoint)));}
   double            GetLotPercentRisk(double mBallance,double mRisk,int mDeltaPrice)  {return MathAbs(mBallance*mRisk/GetPointPrice(mDeltaPrice));}
  };

#endif