#ifndef _C_DEAL_
#define _C_DEAL_

#include "COrder.mqh"

#ifdef __MQL5__
   #define SET _SET,MQL5_SET
#else
   #define SET _SET
#endif

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
   #ifdef __MQL5__
      double            cDealSwap;
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
   #ifdef __MQL5__
                     CDeal(ulong mTicket,CTradeConst* mTradeConst);
                     CDeal(CTradeConst* tradeConst,ulong positionID);
      long_type      GetDealTicket()   {return cDealTicket;}
      double         GetDealSwap()     {return cDealSwap;}
      virtual bool   TradeTransaction(const MqlTradeTransaction& trans,
                                      const MqlTradeRequest& request,
                                      const MqlTradeResult& result);
   #else
                     CDeal(CTradeConst* mTradeConst);
   #endif 
  };
//------------------------------------------------------------------------
CDeal::CDeal(SET):
   COrder(SET_IN),cDealTime(0),cDealPrice(0.0),cDealComission(0.0)
   #ifdef __MQL5__
      ,cDealSwap(0.0),
      cDealTicket(0)
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
      if (!OrderSelect(_ticket,SELECT_BY_TICKET)||
          OrderType()>1) return cFlag;
      cDealTime=OrderOpenTime();
      cDealPrice=OrderOpenPrice();
      cDealComission=OrderCommission();
      cOrderType%=2;
   #endif
   cFlag|=DEAL_FULL;
   return cFlag;}
//---------------------------------------------------------------------------
#ifdef __MQL5__
   CDeal::CDeal(ulong mTicket,CTradeConst* mTradeConst):COrder(mTicket,mTradeConst),cDealTicket(mTicket){
      cDealTime=(datetime)HistoryDealGetInteger(mTicket,DEAL_TIME);
      cDealPrice=HistoryDealGetDouble(mTicket,DEAL_PRICE);
      cDealVolume=HistoryDealGetDouble(mTicket,DEAL_VOLUME);
      cIdent=HistoryDealGetInteger(mTicket,DEAL_POSITION_ID);
      cFlag|=DEAL_FULL;}
//-----------------------------------------------------------------------------
   CDeal::CDeal(CTradeConst *tradeConst,ulong positionID):
      COrder(tradeConst,positionID){
      bool isOk=false;
      cDealSwap=0.0;
      ulong ticket=0;
      if (HistorySelectByPosition(positionID)){
         for (uint i=0,count=HistoryDealsTotal();i<count;++i){
            ticket=HistoryDealGetTicket(i);
            if (!ticket) continue;
            if (HistoryDealGetInteger(ticket,DEAL_ORDER)==positionID){
               isOk=true;
               break;
            }
         }
      }
      if (isOk){
         cDealTime=(datetime)HistoryDealGetInteger(ticket,DEAL_TIME);
         cDealPrice=HistoryDealGetDouble(ticket,DEAL_PRICE);
         cDealComission=HistoryDealGetDouble(ticket,DEAL_COMMISSION);
         cDealTicket=ticket;
         cDealVolume=HistoryDealGetDouble(ticket,DEAL_VOLUME);
         cFlag|=DEAL_FULL;
      }
      else{
         cDealTime=0;
         cDealPrice=0.0;
         cDealComission=0.0;
         cDealTicket=0;
         cDealVolume=0.0;
      }
   }
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
#else
   CDeal::CDeal(CTradeConst* mTradeConst):
      COrder(mTradeConst),
      cDealTime(OrderOpenTime()),
      cDealPrice(OrderOpenPrice()),
      cDealComission(OrderCommission())
      {if (!cDealTime) return;
      else cFlag|=DEAL_FULL;}
#endif

#undef SET
#undef _ticket

#endif