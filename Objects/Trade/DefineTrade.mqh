#ifndef _D_TRADE_
#define _D_TRADE_

//Position Flags
#define ORDER_INIT         0x1
#define ORDER_PENDING      0x2
#define ORDER_MODIFY       0x4
#define ORDER_ACTIVATE     0x8
#define DEAL_FULL          0x10
#define POSITION_MODIFY       ORDER_MODIFY
#define POSITION_MUST_CLOSE   0x20
#define ORDER_MUST_REMOVE     POSITION_MUST_CLOSE
#define POSITION_CLOSED       0x40
#define ORDER_REMOVED         POSITION_CLOSED
#define POSITION_CHANGING     0x80
#define TRADE_ERROR           0x100
#define TRADE_FINISH (TRADE_ERROR|POSITION_CLOSED)
#define TRADE_CHANGE_SL       0x200
#define TRADE_CHANGE_TP       0x400
#define TRADE_CHANGED_VOLUME  0x800
#define TRADE_CHANGE_STOP     (TRADE_CHANGE_SL|TRADE_CHANGE_TP)
#define TRADE_CHANGED  (TRADE_CHANGE_STOP|TRADE_CHANGED_VOLUME)
#define TRADE_SL_CHANGE_IN_PROCESS  0x1000
#define TRADE_TP_CHANGE_IN_PROCESS  0x2000
#define TRADE_STOP_CHANGE_IN_PROCESS  (TRADE_SL_CHANGE_IN_PROCESS|TRADE_TP_CHANGE_IN_PROCESS)

//Close Flags
#define ERROR_INIT_TRADE_CONST   0x1
#define WRONG_PENDING_PRICE_SLTP 0x2
#define WRONG_PENDING_PRICE_CUR_PRICE 0x4
#define CLOSE_BY_SL              0x8
#define CLOSE_BY_TP              0x10
#define CANCEL_BY_DEVIATION      0x20

//State flags
#define FLAG_VIRTUAL_SL       0x1
#define FLAG_VIRTUAL_TP       0x2
#define FLAG_VIRTUAL_PENDING  0x4

#define IS_VIRTUAL_SL      bool(cStateFlag&FLAG_VIRTUAL_SL)
#define IS_VIRTUAL_TP      bool(cStateFlag&FLAG_VIRTUAL_TP)
#define IS_VIRTUAL_PENDING bool(cStateFlag&FLAG_VIRTUAL_PENDING)

//Types
#ifdef __MQL5__
   #define order_type   ENUM_ORDER_TYPE
   #define deal_type    ENUM_DEAL_TYPE
   #define pos_type     ENUM_POSITION_TYPE
   #define long_type    ulong
   #define int_type     uint
#else
   #define order_type   int
   #define deal_type    int
   #define pos_type     int
   #define long_type    int
   #define int_type     int
#endif

//Trade Types
#ifdef __MQL5__
   #define O_T_BUY               ORDER_TYPE_BUY
   #define O_T_SELL              ORDER_TYPE_SELL
   #define O_T_BUY_LIMIT         ORDER_TYPE_BUY_LIMIT
   #define O_T_SELL_LIMIT        ORDER_TYPE_SELL_LIMIT
   #define O_T_BUY_STOP          ORDER_TYPE_BUY_STOP
   #define O_T_SELL_STOP         ORDER_TYPE_SELL_STOP
   #define O_T_BUY_STOP_LIMIT    ORDER_TYPE_BUY_STOP_LIMIT
   #define O_T_SELL_STOP_LIMIT   ORDER_TYPE_SELL_STOP_LIMIT
#else
   #define O_T_BUY               OP_BUY
   #define O_T_SELL              OP_SELL
   #define O_T_BUY_LIMIT         OP_BUYLIMIT
   #define O_T_SELL_LIMIT        OP_SELLLIMIT
   #define O_T_BUY_STOP          OP_BUYSTOP
   #define O_T_SELL_STOP         OP_SELLSTOP
#endif

enum ENUM_TIME_TYPE
  {
   TIME_SERVER,
   TIME_LOCAL,
   TIME_GMT
  };

#endif