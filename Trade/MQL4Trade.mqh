#include "../Define/StdDefine.mqh"

#ifndef _STD_MQL4_TRADE_
#define _STD_MQL4_TRADE_

#include "ITrade.mqh"

#define _tTrade STD_MQL4Trade

class STD_MQL4Trade:public STD_ITrade{
   double cVolume;
   double cSL;
   double cTP;
public:
   STD_MQL4Trade();
   STD_MQL4Trade(const STD_MQL4Trade& other) {this=other;}
   double Volume() const override {return cVolume;}
   double SL() const override {return cSL;}
   double TP() const override {return cTP;}
   bool Control() override;
   bool Remove() override;
private:
   bool _OrderControl();
   bool _PositionControl();
};
//-------------------------------------------------
STD_MQL4Trade::STD_MQL4Trade(void):cVolume(0.0),cSL(0.0),cTP(0.0){}
//-------------------------------------------------
bool STD_MQL4Trade::Control(void){
   if (!cIdent)
      cIdent=_Start();
   if (!cIdent)
      return false;
   return IsOpen()?_OrderControl():_PositionControl();
}
//--------------------------------------------------
bool STD_MQL4Trade::Remove(void){
   if (IsActivate())
      return false;
   double price=TradePrice();
   return OrderClose(cIdent,cVolume,0.0,SHORT_MAX);
}

#endif