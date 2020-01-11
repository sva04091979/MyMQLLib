#ifndef _C_CLASSIC_TRAL_
#define _C_CLASSIC_TRAL_

#include "ITral.mqh"

class CClassicTral : public ITral
  {
private:
   int               cTralPips;
   int               cTralStepPips;
   int               cBreakEvenTriggerPips;
   int               cBreakEvenPips;
   double            cTral;
   double            cTralStep;
   double            cBreakEvenTrigger;
   double            cBreakEven;
protected:
   CTradeConst*      cTradeConst;
   int               cDirection;
public:
                     CClassicTral(int mTral,int mTralStep=0,int mBreakEvenTrigger=INT_MIN,int mBrekEven=INT_MIN);
   double            GetSL(double mPrice,double mSL,double mPriceOpen);
   CClassicTral*     Init(CTradeConst* mTradeConst,int mDirection);
private:
   double            BreackEvenControl(double mPrice,double mSL);
   double            TralControl(double mPrice,double mSL);
   double            NormalizePrice(double mPrice)    {return NormalizeDouble(MathRound(mPrice/_tickSize)*_tickSize,_digits);}
  };
CClassicTral::CClassicTral(int mTral,int mTralStep=0,int mBreakEvenTrigger=INT_MIN,int mBreakEven=INT_MIN):
   cTralPips(mTral<0?0:mTral),cTralStepPips(mTralStep<0?0:mTralStep),cBreakEvenTriggerPips(mBreakEvenTrigger),cBreakEvenPips(mBreakEven),cBreakEvenTrigger(EMPTY_VALUE),cBreakEven(EMPTY_VALUE){}
//-------------------------------------------------------------------------------------------
CClassicTral* CClassicTral::Init(CTradeConst* mTradeConst,int mDirection){
   cTradeConst=mTradeConst;
   cDirection=mDirection;
   cTral=NormalizePrice(cTralPips*_point);
   cTralStep=NormalizePrice(cTralStepPips*_point);
   return GetPointer(this);}
//----------------------------------------------------------------------------------------------------
double CClassicTral::GetSL(double mPrice,double mSL,double mPriceOpen){
   if (cBreakEvenTrigger==EMPTY_VALUE) cBreakEvenTrigger=mPriceOpen+cDirection*cBreakEvenTriggerPips*_point;
   if (cBreakEven==EMPTY_VALUE) cBreakEven=mPriceOpen+cDirection*cBreakEvenPips*_point;
   return cBreakEvenTriggerPips!=INT_MIN&&cBreakEvenPips!=INT_MIN&&(!mSL||ComparePrice(mSL,cBreakEven,cDirection,_digits)<0)?BreackEvenControl(mPrice,mSL):TralControl(mPrice,mSL);}
//----------------------------------------------------------------------------------------------------
double CClassicTral::BreackEvenControl(double mPrice,double mSL){
   return ComparePrice(mPrice,cBreakEvenTrigger,cDirection,_digits)<0?mSL:cBreakEven;}
//---------------------------------------------------------------------------------------------------
double CClassicTral::TralControl(double mPrice,double mSL){
   if (!cTralPips) return mSL;
   double res=!mSL||CompareDouble(cDirection*(mPrice-mSL),cTral,_digits)>=0?NormalizePrice(mPrice-cDirection*cTral):mSL;
   return !mSL||CompareDouble(cDirection*(res-mSL),cTralStep,_digits)>=0?res:mSL;
}