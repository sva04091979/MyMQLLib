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
   TRAL_EQUITY      //Equity
};

enum ENUM_TRAL_TYPE {TRAL_TYPE_CURRENCY,TRAL_TYPE_PERCENT};

struct SBallanceControlParam{
   double sl;
   double tp;
   double tralTrigger;
   double tralSize;
   ENUM_TRAL_START_BALLANCE_TYPE type;
   ENUM_TRAL_TYPE tralType;
   SBallanceControlParam(){}
   SBallanceControlParam(double _sl, double _tp, double _tralTrigger, double _tralSize, ENUM_TRAL_START_BALLANCE_TYPE _type, ENUM_TRAL_TYPE _tralType):
      sl(_sl),tp(_tp),tralTrigger(_tralTrigger),tralSize(_tralSize),type(_type),tralType(_tralType){}
   void Set(double _sl, double _tp, double _tralTrigger, double _tralSize, ENUM_TRAL_START_BALLANCE_TYPE _type, ENUM_TRAL_TYPE _tralType){
      sl=_sl;
      tp=_tp;
      tralTrigger=_tralTrigger;
      tralSize=_tralSize;
      type=_type;
      tralType=_tralType;}
   bool operator==(const SBallanceControlParam &other){
      return sl==other.sl                    &&
             tp==other.tp                    &&
             tralTrigger==other.tralTrigger  &&
             tralSize==other.tralSize        &&
             type==other.type                &&
             tralType==other.tralType;}
};

class CBallanceControl
{
protected:
   SBallanceControlParam cParam;
   double         cStartBallance;
   double         cMaxEquity;
   double         cProfitOut;
   double         cStopOut;
   double         cTralTrigger;
   double         cTralSize;
   double         cTralStop;
   uint            cFlag;
   ENUM_TRAL_TYPE cTralType;
public:
                  CBallanceControl():cStartBallance(0.0),cProfitOut(0.0),cStopOut(0.0),cTralTrigger(0.0),cTralSize(0.0),cTralStop(0.0),cFlag(0){}
                  CBallanceControl(double mSL,
                                   double mTP,
                                   double mTralTrigger,
                                   double mTralSize,
                                   double mStartBallance=0.0,
                                   ENUM_TRAL_START_BALLANCE_TYPE mType=TRAL_EQUITY,
                                   ENUM_TRAL_TYPE mTralType=TRAL_TYPE_CURRENCY){Reset(mSL,mTP,mTralTrigger,mTralSize,mStartBallance,mType,mTralType);}
                 ~CBallanceControl(){}
   void           Reset(double mSL,
                        double mTP,
                        double mTralTrigger,
                        double mTralSize,
                        double mStartBallance=0.0,
                        ENUM_TRAL_START_BALLANCE_TYPE mType=TRAL_EQUITY,
                        ENUM_TRAL_TYPE mTralType=TRAL_TYPE_CURRENCY);
   void           SetNewParam(double mSL,
                              double mTP,
                              double mTralTrigger,
                              double mTralSize,
                              double mStartBallance=0.0,
                              ENUM_TRAL_START_BALLANCE_TYPE mType=TRAL_EQUITY,
                              ENUM_TRAL_TYPE mTralType=TRAL_TYPE_CURRENCY);
   virtual bool   Check();
   bool           Check(uint &mFlag);
   bool           CheckTral(const double &mEquity);
   double         GetProfitStop()   {return cProfitOut;}
   double         GetStopOut()   {return cStopOut;}   
   double         GetTrigger()   {return cTralTrigger;}
   double         GetStop()      {return cTralStop;}
   string         GetReason();
private:
   double         SetGetBallance(ENUM_TRAL_START_BALLANCE_TYPE mType);
};
//--------------------------------------------------------------
void CBallanceControl::Reset(double mSL,
                             double mTP,
                             double mTralTrigger,
                             double mTralSize,
                             double mStartBallance=0.000000,
                             ENUM_TRAL_START_BALLANCE_TYPE mType=TRAL_EQUITY,
                             ENUM_TRAL_TYPE mTralType=TRAL_TYPE_CURRENCY){
   cParam.Set(mSL,mTP,mTralTrigger,mTralSize,mType,mTralType);
   cStartBallance=mStartBallance<=0.0?mType==TRAL_BALLANCE?AccountInfoDouble(ACCOUNT_BALANCE):AccountInfoDouble(ACCOUNT_EQUITY):mStartBallance;
   cMaxEquity=cStartBallance;
   cTralStop=0.0;
   cProfitOut=mTP<=0.0?0.0:mTralType==TRAL_TYPE_CURRENCY?cStartBallance+mTP:cStartBallance*(1+mTP/100.0);
   cStopOut=mSL<=0.0?0.0:mTralType==TRAL_TYPE_CURRENCY?cStartBallance-mSL:cStartBallance*(1-mSL/100.0);
   cTralTrigger=mTralTrigger<=0.0||mTralSize<=0.0?0.0:mTralType==TRAL_TYPE_CURRENCY?cStartBallance+mTralTrigger:cStartBallance*(1+mTralTrigger/100.0);
   cTralSize=mTralSize<=0.0?0.0:mTralSize;
   cFlag=0;
   cTralType=mTralType;}
//--------------------------------------------------------------
void CBallanceControl::SetNewParam(double mSL,
                                   double mTP,
                                   double mTralTrigger,
                                   double mTralSize,
                                   double mStartBallance=0.000000,
                                   ENUM_TRAL_START_BALLANCE_TYPE mType=TRAL_EQUITY,
                                   ENUM_TRAL_TYPE mTralType=TRAL_TYPE_CURRENCY){
   SBallanceControlParam param(mSL,mTP,mTralTrigger,mTralSize,mType,mTralType);
   if (param==cParam) return;
   else Reset(mSL,mTP,mTralTrigger,mTralSize,mStartBallance,mType,mTralType);}
//--------------------------------------------------------------
bool CBallanceControl::Check(){
   cFlag&=~BALLANCE_CONTROL_CHANGE_STOP;
   if (!(bool(cFlag&BALLANCE_STOP))){
      double equity=EQUITY;
      cMaxEquity=MathMax(cMaxEquity,equity);
      if (cProfitOut!=0.0&&equity>=cProfitOut) cFlag|=BALLANCE_CONTROL_TP;
      if (cStopOut!=0.0&&equity<=cStopOut) cFlag|=BALLANCE_CONTROL_SL;
      if (CheckTral(equity)) cFlag|=BALLANCE_CONTROL_TRAL;}
   return bool(cFlag&BALLANCE_STOP);}
//--------------------------------------------------------------
bool CBallanceControl::Check(uint &mFlag){
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