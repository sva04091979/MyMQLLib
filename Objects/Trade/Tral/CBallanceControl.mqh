#ifndef _C_BALLANCE_CONTROLE_
#define _C_BALLANCE_CONTROLE_

#include "..\..\..\Define\MQLDefine.mqh"

#define  BALLANCE_CONTROL_TP     0x1
#define  BALLANCE_CONTROL_SL     0x2
#define  BALLANCE_CONTROL_TRAL   0x4
#define  BALLANCE_CONTROL_CHANGE_STOP  0x8

#define  BALLANCE_STOP           (BALLANCE_CONTROL_TP|BALLANCE_CONTROL_SL|BALLANCE_CONTROL_TRAL)

enum ENUM_TRAL_START_BALLANCE_TYPE{
   TRAL_BALLANCE,    //Ballance
   TRAL_EQUITY       //Equity
};

enum ENUM_TRAL_TYPE {TRAL_TYPE_CURRENCY,TRAL_TYPE_PERCENT};

class CBallanceControl
{
protected:
   double         cStartBallance;
   double         cProfitOut;
   double         cStopOut;
   double         cTralTrigger;
   double         cTralSize;
   double         cTralStop;
   int            cFlag;
   ENUM_TRAL_TYPE cTralType;
public:
                  CBallanceControl():cStartBallance(0.0),cProfitOut(0.0),cStopOut(0.0),cTralTrigger(0.0),cTralSize(0.0),cTralStop(0.0),cFlag(0){}
                  CBallanceControl(double mSL,
                                   double mTP,
                                   double mTralTrigger,
                                   double mTralSize,
                                   double mBallance=0.0,
                                   ENUM_TRAL_START_BALLANCE_TYPE mType=TRAL_EQUITY,
                                   ENUM_TRAL_TYPE mTralType=TRAL_TYPE_CURRENCY){Reset(mSL,mTP,mTralTrigger,mTralSize,mBallance,mType,mTralType);}
                 ~CBallanceControl(){}
   void           Reset(double mSL,
                        double mTP,
                        double mTralTrigger,
                        double mTralSize,
                        double mBallance=0.0,
                        ENUM_TRAL_START_BALLANCE_TYPE mType=TRAL_EQUITY,
                        ENUM_TRAL_TYPE mTralType=TRAL_TYPE_CURRENCY);
   virtual bool   Check();
   bool           Check(int &mFlag);
   bool           CheckTral(const double &mEquity);
   double         GetProfitStop()   {return cProfitOut;}
   double         GetStopOut()   {return cStopOut;}   
   double         GetTrigger()   {return cTralTrigger;}
   double         GetStop()      {return cTralStop;}
   string         GetReason();
};
//--------------------------------------------------------------
void CBallanceControl::Reset(double mSL,
                             double mTP,
                             double mTralTrigger,
                             double mTralSize,
                             double mBallance=0.000000,
                             ENUM_TRAL_START_BALLANCE_TYPE mType=1,
                             ENUM_TRAL_TYPE mTralType=TRAL_TYPE_CURRENCY){
   cStartBallance=mBallance<=0.0?mType==TRAL_BALLANCE?AccountInfoDouble(ACCOUNT_BALANCE):AccountInfoDouble(ACCOUNT_EQUITY):mBallance;
   cTralStop=0.0;
   cProfitOut=mTP<=0.0?0.0:mTralType==TRAL_TYPE_CURRENCY?cStartBallance+mTP:cStartBallance*(1+mTP/100.0);
   cStopOut=mSL<=0.0?0.0:mTralType==TRAL_TYPE_CURRENCY?cStartBallance-mSL:cStartBallance*(1-mSL/100.0);
   cTralTrigger=mTralTrigger<=0.0||mTralSize<=0.0?0.0:mTralType==TRAL_TYPE_CURRENCY?cStartBallance+mTralTrigger:cStartBallance*(1+mTralTrigger/100.0);
   cTralSize=mTralSize<=0.0?0.0:mTralSize;
   cFlag=0;
   cTralType=mTralType;}
//--------------------------------------------------------------
bool CBallanceControl::Check(){
   cFlag&=~BALLANCE_CONTROL_CHANGE_STOP;
   if (!(bool(cFlag&BALLANCE_STOP))){
      double equity=EQUITY;
      if (cProfitOut!=0.0&&equity>=cProfitOut) cFlag|=BALLANCE_CONTROL_TP;
      if (cStopOut!=0.0&&equity<=cStopOut) cFlag|=BALLANCE_CONTROL_SL;
      if (CheckTral(equity)) cFlag|=BALLANCE_CONTROL_TRAL;}
   return bool(cFlag&BALLANCE_STOP);}
//--------------------------------------------------------------
bool CBallanceControl::Check(int &mFlag){
   bool res=Check();
   mFlag=cFlag;
   return res;}
//---------------------------------------------------------------
bool CBallanceControl::CheckTral(const double &mEquity){
   if (!cTralSize) return false;
   if (!cTralStop){
      if (!cTralTrigger){
         cTralStop=cTralType==TRAL_TYPE_CURRENCY?MathMax(cStartBallance,mEquity)-cTralSize:MathMax(cStartBallance,mEquity)*(1-cTralSize/100.0);
         cFlag|=BALLANCE_CONTROL_CHANGE_STOP;}
      else if (mEquity>=cTralTrigger){
         cTralStop=cTralType==TRAL_TYPE_CURRENCY?mEquity-cTralSize:mEquity*(1-cTralSize/100.0);
         cFlag|=BALLANCE_CONTROL_CHANGE_STOP;}}
   if (!cTralStop) return false;
   if (mEquity>cTralStop){
      double temp=cTralType==TRAL_TYPE_CURRENCY?mEquity-cTralSize:mEquity*(1-cTralSize/100.0);
      if (temp>cTralStop){
         cTralStop=temp;
         cFlag|=BALLANCE_CONTROL_CHANGE_STOP;}
      return false;}
   else return true;}
//----------------------------------------------------------------
string CBallanceControl::GetReason(){
   if (bool(cFlag&BALLANCE_CONTROL_TP)) return "profit";
   else if (bool(cFlag&BALLANCE_CONTROL_SL)) return "loss";
   else if (bool(cFlag&BALLANCE_CONTROL_TRAL)) return "tral";
   else return NULL;}

#endif