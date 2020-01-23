#ifndef _C_TRADE_TIME_
#define _C_TRADE_TIME_

#include "..\..\Functions\TimeFunctions.mqh"

#define TRADE_TIME_FLAG_NEW_DAY 0x1

class CTradeTime{
protected:
   bool              cIsTrue;
   int               cFlag;
   int               cDay;
   datetime          cTimeCurrent;
   datetime          cTradeTime[2];
public:
                     CTradeTime(string mTimeStart,string mTimeStop);
   bool              IsNewDay() {bool res=bool(cFlag&TRADE_TIME_FLAG_NEW_DAY); cFlag&=~TRADE_TIME_FLAG_NEW_DAY; return res;}
   bool              IsTrueFormat() {return cIsTrue;}
   bool              IsTradeAlloed(datetime mTime=0);
private:
   bool              StringToTimeStruct(string mTimeStart,string mTimeStop,MqlDateTime &mTimeCurStruct,int mId);
   void              Control(datetime mTime);
   bool              CheckTime();
  };
//+------------------------------------------------------------------+
CTradeTime::CTradeTime(string mTimeStart,string mTimeStop):
   cFlag(TRADE_TIME_FLAG_NEW_DAY),cIsTrue(true),cTimeCurrent(TimeCurrent()){
   MqlDateTime mTimeStruct;
   if (!TimeToStruct(cTimeCurrent,mTimeStruct)) {cTimeCurrent=0; cIsTrue=false; return;}
   cDay=mTimeStruct.day_of_week;
   for (int i=0;i<2;i++)
      if (!StringToTimeStruct(mTimeStart,mTimeStop,mTimeStruct,i)) {cTimeCurrent=0; cIsTrue=false; return;}
   if (cTradeTime[0]==cTradeTime[1]) return;
   if (cTimeCurrent>cTradeTime[0]&&cTimeCurrent>=cTradeTime[1]){
      if(cTradeTime[0]<cTradeTime[1]) {cTradeTime[0]+=TIME_DAY; return;}
      if(cTradeTime[0]>cTradeTime[1]) {cTradeTime[1]+=TIME_DAY; return;}}
   if (cTimeCurrent<=cTradeTime[0]&&cTimeCurrent<cTradeTime[1]){
      if(cTradeTime[0]<cTradeTime[1]) {cTradeTime[1]-=TIME_DAY; return;}
      if(cTradeTime[0]>cTradeTime[1]) {cTradeTime[0]-=TIME_DAY; return;}}}   
//--------------------------------------------------------------------------------------   
bool CTradeTime::StringToTimeStruct(string mTimeStart,string mTimeStop,MqlDateTime &mTimeCurStruct,int mId){
   if (mId>=ArraySize(cTradeTime)) return false;
   MqlDateTime mTimeStruct=mTimeCurStruct;
   string mData[],
          mText=mId==0?mTimeStart:mTimeStop;
   int mSize=StringSplit(mText,StringGetCharacter(":",0),mData);
   if (mSize>3||mSize<0) return false;
   for (int i=0;i<mSize;i++)
      switch (StringLen(mData[i])){
         default: return false;
         case 0:  mData[i]="00"; break;
         case 1:  mData[i]="0"+mData[i]; break;
         case 2:  break;}
   if (mSize>0){
      mTimeStruct.hour=(int)StringToInteger(mData[0]);
      if (mTimeStruct.hour<0||mTimeStruct.hour>23||IntegerToString(mTimeStruct.hour,2,'0')!=mData[0]) return false;}
   else mTimeStruct.hour=0;
   if (mSize>1){
      mTimeStruct.min=(int)StringToInteger(mData[1]);
      if (mTimeStruct.min<0||mTimeStruct.min>59||IntegerToString(mTimeStruct.min,2,'0')!=mData[1]) return false;}
   else mTimeStruct.min=0;
   if (mSize>2){
      mTimeStruct.sec=(int)StringToInteger(mData[2]);
      if (mTimeStruct.sec<0||mTimeStruct.sec>59||IntegerToString(mTimeStruct.sec,2,'0')!=mData[2]) return false;}
   else mTimeStruct.sec=0;
   cTradeTime[mId]=StructToTime(mTimeStruct);
   return true;}
//+------------------------------------------------------------------+
bool CTradeTime::IsTradeAlloed(datetime mTime=0){
   if (!cIsTrue) return false; else Control(mTime);
   return cTimeCurrent&&(cTradeTime[0]==cTradeTime[1]||cTimeCurrent<cTradeTime[1]);}
//--------------------------------------------------------------------
void CTradeTime::Control(datetime mTime){
   cTimeCurrent=!mTime?TimeCurrent():mTime;
   MqlDateTime time;
   TimeToStruct(cTimeCurrent,time);
   if (cDay!=time.day_of_week){
      cFlag|=TRADE_TIME_FLAG_NEW_DAY;
      cDay=time.day_of_week;}
   if (!cTimeCurrent) return;
   while (!CheckTime()){
      if (cTimeCurrent>=cTradeTime[0]&&cTradeTime[1]<cTradeTime[0]) cTradeTime[1]+=TIME_DAY;
      if (cTimeCurrent>=cTradeTime[1]&&cTradeTime[0]<cTradeTime[1]) cTradeTime[0]+=TIME_DAY;}}
//-----------------------------------------------------------------------
bool CTradeTime::CheckTime(void){
   return cTradeTime[0]==cTradeTime[1]                              ||
          (cTimeCurrent>=cTradeTime[0]&&cTimeCurrent<cTradeTime[1]) ||
          (cTimeCurrent>=cTradeTime[1]&&cTimeCurrent<cTradeTime[0]);}
  
#endif 