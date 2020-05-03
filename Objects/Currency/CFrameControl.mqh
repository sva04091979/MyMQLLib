#ifndef _C_FRAME_CONTROL_
#define _C_FRAME_CONTROL_

#include "..\..\Functions\MathFunctions.mqh"

class CFrameControl
  {
private:
   string            cSymbol;
   int               cDigits;
   ENUM_TIMEFRAMES   cFrame;
   datetime          cTime;
public:
                     CFrameControl():cSymbol(NULL),cDigits(_Digits),cFrame(0),cTime(0){}
                     CFrameControl(string mSymbol,ENUM_TIMEFRAMES mFrame=0,bool mIsFirstTickNewBarTrue=true);
   void              Reset();
   void              Reset(string mSymbol,ENUM_TIMEFRAMES mFrame=0,bool mIsFirstTickNewBarTrue=true);
   bool              IsNewBar();
   uint              CheckNewBars();
   string            GetSymbol()                                        {return cSymbol==NULL?_Symbol:cSymbol;}
   ENUM_TIMEFRAMES   GetFrame()                                         {return cFrame==0?(ENUM_TIMEFRAMES)Period():cFrame;}
   double            GetAsk()                                           {return SymbolInfoDouble(cSymbol,SYMBOL_ASK);}
   double            GetBid()                                           {return SymbolInfoDouble(cSymbol,SYMBOL_BID);}
   double            GetHigh(int mPos=0)                                {return iHigh(cSymbol,cFrame,mPos);}
   double            GetLow(int mPos=0)                                 {return iLow(cSymbol,cFrame,mPos);}
   double            GetOpen(int mPos=0)                                {return iOpen(cSymbol,cFrame,mPos);}
   double            GetClose(int mPos=0)                               {return iClose(cSymbol,cFrame,mPos);}
   datetime          GetTime(int mPos=0)                                {return iTime(cSymbol,cFrame,mPos);}
   int               GetBars()                                          {return iBars(cSymbol,cFrame);}
   int               GetBarShift(datetime mTime,bool mExact)            {return iBarShift(cSymbol,cFrame,mTime,mExact);}
   int               GetBarShift(datetime mTime)                        {return iBarShift(cSymbol,cFrame,mTime,true);}
   int               GetBarShiftN(datetime mTime);
   int               GetBarShiftP(datetime mTime)                       {return GetBarShift(mTime,false);}
   int               GetDirection(int mPos)                             {return CompareDouble(GetClose(mPos),GetOpen(mPos),cDigits);}
   int               GetDigits()                                        {return cDigits;}
   double            GetPrice(int mShift,ENUM_APPLIED_PRICE mMode);
  };
//---------------------------------------------------------------------------------------------------
CFrameControl::CFrameControl(string mSymbol,ENUM_TIMEFRAMES mFrame=0,bool mIsFirstTickNewBarTrue=true):
   cSymbol(mSymbol),cDigits((int)SymbolInfoInteger(mSymbol,SYMBOL_DIGITS)),cFrame(mFrame),cTime(mIsFirstTickNewBarTrue?0:TimeCurrent()){}
//-----------------------------------------------------------------------------------------------------
void CFrameControl::Reset(){
   cSymbol=NULL;
   cDigits=_Digits;
   cFrame=0;
   cTime=0;}
//------------------------------------------------------------------------------------------------------
void CFrameControl::Reset(string mSymbol,ENUM_TIMEFRAMES mFrame=0,bool mIsFirstTickNewBarTrue=true){
   cSymbol=mSymbol;
   cDigits=(int)SymbolInfoInteger(mSymbol,SYMBOL_DIGITS);
   cFrame=mFrame;
   cTime=mIsFirstTickNewBarTrue?0:TimeCurrent();}
//-----------------------------------------------------------------------------------------------------
bool CFrameControl::IsNewBar(void){
   datetime time=GetTime();
   if (!time) return false;
   if (cTime<time) {cTime=time; return true;}
   return false;}
//---------------------------------------------------------------------------------------------------
int CFrameControl::GetBarShiftN(datetime mTime){
   int res=GetBarShift(mTime,true);
   return res<0?GetBarShift(mTime,false)+1:res;}
//---------------------------------------------------------------------------------------------------
double CFrameControl::GetPrice(int mShift,ENUM_APPLIED_PRICE mMode){
   switch(mMode){
      default:             return 0.0;
      case PRICE_OPEN:     return GetOpen(mShift);
      case PRICE_CLOSE:    return GetClose(mShift);
      case PRICE_HIGH:     return GetHigh(mShift);
      case PRICE_LOW:      return GetLow(mShift);
      case PRICE_MEDIAN:   return (GetHigh()+GetLow())/2.0;
      case PRICE_TYPICAL:  return (GetHigh()+GetLow()+GetClose())/3.0;
      case PRICE_WEIGHTED: return (GetHigh()+GetLow()+2.0*GetClose())/4.0;}}
//---------------------------------------------------------------------------------------------------
uint CFrameControl::CheckNewBars(){
   int ret=!cTime?GetBars():GetBarShift(cTime);
   if (ret>0) cTime=GetTime();
   return ret>0?(uint)ret:0;}

#endif 