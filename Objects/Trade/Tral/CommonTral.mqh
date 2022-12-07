#include "ITral.mqh"

class TTral : public ITral
  {
private:
   uint _tral;
   uint _tralTrigger;
   uint _tralStep;
   uint _breakEvenTrigger;
   int _breakEven;
   double            cTralTrigger;
   double            cTral;
   double            cTralStep;
   double            cBreakEvenTrigger;
   double            cBreakEven;
   bool  isInit;
   bool isBE;
protected:
   CTradeConst*      cTradeConst;
   int               cDirection;
public:
                     TTral(uint mTral,uint tralTrigger, uint tralStep, uint breakEvenTrigger, int mBrekEven);
   double            GetSL(double mPrice,double mSL,double mPriceOpen);
   TTral*     Init(CTradeConst* mTradeConst,int mDirection);
private:
   double            BreackEvenControl(double mPrice,double sl);
   double            TralControl(double mPrice,double sl);
   double            NormalizePrice(double mPrice)    {return NormalizeDouble(MathRound(mPrice/_tickSize)*_tickSize,_digits);}
   void Init(double price);
  };
TTral::TTral(uint mTral,uint tralTrigger, uint tralStep, uint breakEvenTrigger, int mBrekEven):
   _tral(mTral),_tralTrigger(tralTrigger),_tralStep(tralStep),_breakEvenTrigger(breakEvenTrigger),_breakEven(mBrekEven),isInit(false),isBE(false){}
//-------------------------------------------------------------------------------------------
TTral* TTral::Init(CTradeConst* mTradeConst,int mDirection){
   cTradeConst=mTradeConst;
   cDirection=mDirection;
   cTral=::NormalizePrice(_tral*mTradeConst.point,mTradeConst.tickSize,mTradeConst.digits);
   cTralStep=::NormalizePrice(_tralStep*mTradeConst.point,mTradeConst.tickSize,mTradeConst.digits);
   return GetPointer(this);}
//-----------------------------------------------------------------------------------------------------
void TTral::Init(double price){
   isInit=true;
   cTralTrigger=!_tralTrigger?0.0:(::NormalizePrice(price+cDirection*cTradeConst.point*_tralTrigger,cTradeConst.tickSize,cTradeConst.digits));
   cBreakEvenTrigger=!_breakEvenTrigger?0.0:(::NormalizePrice(price+cDirection*cTradeConst.point*_breakEvenTrigger,cTradeConst.tickSize,cTradeConst.digits));
   cBreakEven=::NormalizePrice(price+cDirection*cTradeConst.point*_breakEven,cTradeConst.tickSize,cTradeConst.digits);
   if (!_breakEvenTrigger) isBE=true;
}
//----------------------------------------------------------------------------------------------------
double TTral::GetSL(double mPrice,double mSL,double mPriceOpen){
   if (!isInit)
      Init(mPriceOpen);
   double bSL=BreackEvenControl(mPrice,mSL);
   double tSL=TralControl(mPrice,mSL);
   return cDirection>0?MathMax(mSL,MathMax(bSL,tSL)):MathMin(mSL,MathMin(bSL,tSL));
}
//----------------------------------------------------------------------------------------------------
double TTral::BreackEvenControl(double mPrice,double sl){
   if (!isBE&&ComparePrice(mPrice,cBreakEvenTrigger,cDirection,cTradeConst.digits)==MORE){
      isBE=true;
      return cBreakEven;
   }
   return !sl?cDirection>0?sl:EMPTY_VALUE:sl;
}
//---------------------------------------------------------------------------------------------------
double TTral::TralControl(double mPrice,double sl){
   if (cTral>0.0&&(!cTralTrigger||ComparePrice(mPrice,cTralTrigger,cDirection,cTradeConst.digits)==MORE)){
      if (!sl||!cTralStep||ComparePrice(mPrice,sl+cDirection*cTralStep,cDirection,cTradeConst.digits)==MORE){
         return NormalizeDouble(mPrice-cDirection*cTral,cTradeConst.digits); 
      }
   }
   return !sl?cDirection>0?sl:EMPTY_VALUE:sl;
}
