#ifndef _MQL_DEFINE_
#define _MQL_DEFINE_

#include "..\STD\Define\StdDefine.mqh"

/*
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

#define __sf StringFormat

//#define LOG (__CLOG(__FUNCTION__)).Log
#define _(dPtr) dPtr.Dereference()
#define _p OverloadPtr

class __CLOG{
   string cFunc;
public:
   __CLOG(string mFunc):cFunc(mFunc){}
   void Log(string mText) {PrintFormat("%s: %s",cFunc,mText);}
};


#define MINUTE          60
#define HOUR            3600
#define DAY             86400
#define WEEK            604800
#define JANUARY         2678400
#define FEBRUARY        2419200
#define FEBRUARY_BIG    2505600
#define MARCH           JANUARY
#define APRIL           2592000
#define MAY             JANUARY
#define JUNE            APRIL
#define JULY            JANUARY
#define AUGUST          JANUARY
#define SEPTEMBER       APRIL
#define OCTOBER         JANUARY
#define NOVEMBER        APRIL
#define DECEMBER        JANUARY
#define QUATER_1        7776000
#define QUATER_1_BIG    7862400
#define QUATER_2        7862400
#define QUATER_3        7948800
#define QUATER_4        QUATER_3
#define HALF_YEAR_1     15638400
#define HALF_YEAR_1_BIG 15724800
#define HALF_YEAR_2     15897600
#define YEAR            31536000
#define YEAR_BIG        31622400

enum ECompare{
   LESS=-1,
   EQUALLY=0,
   MORE=1
};
*/
#endif