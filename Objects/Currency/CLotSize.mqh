#ifndef _C_LOT_SIZE_
#define _C_LOT_SIZE_

#include "CConvert.mqh"

enum ENUM_VOLUME_TYPE
  {
   VOLUME_TYPE_RISK_PERCENT_BALLANCE,
   VOLUME_TYPE_RISK_PERCENT_EQUITY
  };

class CLotSize
  {
   CConvert*         cCurrency;
public:
                     CLotSize(void):cCurrency(new CConvert(_Symbol)){}
                     CLotSize(string mSymbol):cCurrency(new CConvert(mSymbol)){}
                     CLotSize(CConvert* mCurrency):cCurrency(mCurrency){}
                    ~CLotSize(void) {delete cCurrency;}
   double            GetLotPercentBallanceRisk(double mRisk,double mDeltaPrice) {return GetLotPercentRisk(AccountInfoDouble(ACCOUNT_BALANCE),mRisk,mDeltaPrice);}
   double            GetLotPercentBallanceRisk(double mRisk,int mDeltaPrice) {return GetLotPercentRisk(AccountInfoDouble(ACCOUNT_BALANCE),mRisk,mDeltaPrice);}
   double            GetLotPercentEquityRisk(double mRisk,double mDeltaPrice) {return GetLotPercentRisk(AccountInfoDouble(ACCOUNT_EQUITY),mRisk,mDeltaPrice);}
   double            GetLotPercentEquityRisk(double mRisk,int mDeltaPrice) {return GetLotPercentRisk(AccountInfoDouble(ACCOUNT_EQUITY),mRisk,mDeltaPrice);}
   double            GetLotPercentFreeMarginRisk(double mRisk,double mDeltaPrice) {return GetLotPercentRisk(AccountInfoDouble(ACCOUNT_MARGIN_FREE),mRisk,mDeltaPrice);}
   double            GetLotPercentFreeMarginRisk(double mRisk,int mDeltaPrice) {return GetLotPercentRisk(AccountInfoDouble(ACCOUNT_MARGIN_FREE),mRisk,mDeltaPrice);}
   double            GetLotPercentRisk(ENUM_BALLANCE_TYPE mBallanceType,double mBallance,double mRisk,double mDeltaPrice)  {return GetLotPercentRisk(AccountInfoDouble((ENUM_ACCOUNT_INFO_DOUBLE)mBallanceType),mRisk,mDeltaPrice);}
   double            GetLotPercentRisk(ENUM_BALLANCE_TYPE mBallanceType,double mBallance,double mRisk,int mDeltaPrice)  {return GetLotPercentRisk(AccountInfoDouble((ENUM_ACCOUNT_INFO_DOUBLE)mBallanceType),mRisk,mDeltaPrice);}
   double            GetLotPercentRisk(double mBallance,double mRisk,double mDeltaPrice)  {return MathAbs(mBallance*mRisk/cCurrency.GetPointPrice((int)MathRound(mDeltaPrice/cCurrency.GetPoint())));}
   double            GetLotPercentRisk(double mBallance,double mRisk,int mDeltaPrice)  {return MathAbs(mBallance*mRisk/cCurrency.GetPointPrice(mDeltaPrice));}
  };

#endif