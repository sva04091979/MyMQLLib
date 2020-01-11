#ifndef _MQL_DEFINE_
#define _MQL_DEFINE_

#define EQUITY AccountInfoDouble(ACCOUNT_EQUITY)
#define BALLANCE AccountInfoDouble(ACCOUNT_BALANCE)
#define TOTAL_PROFIT AccountInfoDouble(ACCOUNT_PROFIT)
#ifdef _DEBUG
   #define DEL(dObj) do if (dObj!=NULL) delete dObj; while(false)
   #define DELETE(dObj) do if (dObj!=NULL) {delete dObj; dObj=NULL;} while(false)
#else
   #define DEL(dObj) delete dObj
   #define DELETE(dObj) do {delete dObj; dObj=NULL;} while(false)
#endif

#endif