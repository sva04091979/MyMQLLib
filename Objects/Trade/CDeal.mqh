#ifndef _C_DEAL_
#define _C_DEAL_

#include "COrder.mqh"

#ifdef __MQL5__
   #define _ticket   cDealTicket
#else
   #define _ticket   cOrderTicket
#endif

class CDeal:public COrder
  {
protected:
   datetime          cDealTime;
   double            cDealPrice;
   double            cDealComission;
   double            cDealSwap;
   #ifdef __MQL5__
      long_type         cDealTicket;
      double            cDealVolume;
   #endif
public:
                     CDeal(SET);
   ulong             DealControl();
   datetime          GetDealTime()  {return cDealTime;}
   double            GetDealPrice() {return cDealPrice;}
   bool              IsOpen() {return bool(cFlag&DEAL_FULL);}
   double            GetDealComission()   {return cDealComission;}
   double            GetDealSwap()     {return cDealSwap;}
   #ifdef __MQL5__
                     CDeal(ulong mTicket,TRADE_CONST_PUSH);
      long_type      GetDealTicket()   {return cDealTicket;}
      virtual bool   TradeTransaction(const MqlTradeTransaction& trans,
                                      const MqlTradeRequest& request,
                                      const MqlTradeResult& result);
   #endif 
  };
//------------------------------------------------------------------------
CDeal::CDeal(SET):
   COrder(SET_IN),cDealTime(0),cDealPrice(0.0),cDealComission(0.0),cDealSwap(0.0)
   #ifdef __MQL5__
      ,cDealTicket(0)
   #endif
   {}
//-----------------------------------------------------------------------------
ulong CDeal::DealControl(void){
   ulong flag=OrderControl();
   if (!flag||bool(flag&DEAL_FULL)||!(flag&ORDER_ACTIVATE)) return cFlag;
   #ifdef __MQL5__
      if (OrderSelect(cOrderTicket)) return cFlag;
      if (!HistorySelect(GetTimeInitial(),TimeCurrent())) return cFlag;
      ulong ticket=0;
      for (int i=HistoryDealsTotal()-1;i>=0;--i,ticket=0){
         ticket=HistoryDealGetTicket(i);
         if (ticket&&HistoryDealGetInteger(ticket,DEAL_ORDER)==cOrderTicket) break;}
      if (!ticket) return cFlag;
      cDealTicket=ticket;
      cDealTime=(datetime)HistoryDealGetInteger(ticket,DEAL_TIME);
      cDealPrice=HistoryDealGetDouble(ticket,DEAL_PRICE);
      cDealVolume=HistoryDealGetDouble(ticket,DEAL_VOLUME);
      cDealComission=HistoryDealGetDouble(ticket,DEAL_COMMISSION);
      cDealSwap=HistoryDealGetDouble(ticket,DEAL_SWAP);
      cIdent=HistoryDealGetInteger(ticket,DEAL_POSITION_ID);
   #else
      if (!OrderSelect(_ticket,SELECT_BY_TICKET)) return cFlag;
      cDealTime=OrderOpenTime();
      cDealPrice=OrderOpenPrice();
      cDealComission=OrderCommission();
   #endif
   cFlag|=DEAL_FULL;
   return cFlag;}
//---------------------------------------------------------------------------
#ifdef __MQL5__
   CDeal::CDeal(ulong mTicket,TRADE_CONST_PUSH):COrder(mTicket,M_TRADE_CONST),cDealTicket(mTicket){
      cDealTime=(datetime)HistoryDealGetInteger(mTicket,DEAL_TIME);
      cDealPrice=HistoryDealGetDouble(mTicket,DEAL_PRICE);
      cDealVolume=HistoryDealGetDouble(mTicket,DEAL_VOLUME);
      cIdent=HistoryDealGetInteger(mTicket,DEAL_POSITION_ID);
      cFlag|=DEAL_FULL;}
//-----------------------------------------------------------------------------
   bool CDeal::TradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result){
      if (trans.type!=TRADE_TRANSACTION_DEAL_ADD||trans.order!=cOrderTicket) return false;
      cDealTicket=trans.deal;
      if (!HistoryDealSelect(cDealTicket)) return true;
      cDealTime=(datetime)HistoryDealGetInteger(cDealTicket,DEAL_TIME);
      cDealPrice=HistoryDealGetDouble(cDealTicket,DEAL_PRICE);
      cDealVolume=HistoryDealGetDouble(cDealTicket,DEAL_VOLUME);
      cDealComission=HistoryDealGetDouble(cDealTicket,DEAL_COMMISSION);
      cDealSwap=HistoryDealGetDouble(cDealTicket,DEAL_SWAP);
      if (cIsMain) cIdent=HistoryDealGetInteger(cDealTicket,DEAL_POSITION_ID);
      if (cDealTicket) cFlag|=DEAL_FULL;
      return true;}

#endif


#undef _ticket

#endif