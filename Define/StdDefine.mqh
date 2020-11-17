#ifndef _STD_DEFINE_
#define _STD_DEFINE_

#ifdef __MQL5__
   #define NAMESPACE(dName) namespace dName {
   #define END_SPACE }
   #define __std(dName) STD::dName
   #define __decl(dName) dName
   #define _tSizeT ulong
   #define _tPtrDiffT long
#else
   #define NAMESPACE(dName)
   #define END_SPACE
   #define __std(dName) STD_##dName
   #define __decl(dName) __std(dName)
   #define _tSizeT uint
   #define _tPtrDiffT int
#endif

#define EQUITY AccountInfoDouble(ACCOUNT_EQUITY)
#define BALLANCE AccountInfoDouble(ACCOUNT_BALANCE)
#define TOTAL_PROFIT AccountInfoDouble(ACCOUNT_PROFIT)
#define FREE_MARGIN AccountInfoDouble(ACCOUNT_MARGIN_FREE)
#define MARGIN_LEVEL AccountInfoDouble(ACCOUNT_MARGIN_LEVEL)
#define ASK SymbolInfoDouble(NULL,SYMBOL_ASK)
#define BID SymbolInfoDouble(NULL,SYMBOL_BID)
#define OPEN(i) iOpen(NULL,PERIOD_CURRENT,i)
#define CLOSE(i) iClose(NULL,PERIOD_CURRENT,i)
#define HIGH(i) iHigh(NULL,PERIOD_CURRENT,i)
#define LOW(i) iLow(NULL,PERIOD_CURRENT,i)
#define VOLUME(i) iVolume(NULL,PERIOD_CURRENT,i)
#define SPREAD int(SymbolInfoInteger(NULL,SYMBOL_SPREAD))

#define DEBUG_BREAK(dCondition) do if (dCondition) DebugBreak(); while(false)

#ifdef _DEBUG
   #define DEL(dObj) do if (CheckPointer(dObj)==POINTER_DYNAMIC) delete dObj; while(false)
   #define DELETE(dObj) do if (CheckPointer(dObj)==POINTER_DYNAMIC) {delete dObj; dObj=NULL;} while(false)
#else
   #define DEL(dObj) delete dObj
   #define DELETE(dObj) do {delete dObj; dObj=NULL;} while(false)
#endif

#define _(dPtr) (dPtr).Dereference()
#define _p(dPtr) dPtr.OverloadPtr()
#define __sf StringFormat

#define ABORT(dText) __std(Abort)(__FILE__,__LINE__,dText)

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

#define _rv(dVal) (__std(FRVWrape(dVal))).cVal

#define _tECompare __std(ECompare)
#define _tdeclECompare __decl(ECompare)
#define _tEDirect __std(EDirect)
#define _tdeclEDirect __decl(EDirect)
#define _fMove __std(Move)
#define _fdeclMove __decl(Move)
#define _fSwap __std(Swap)
#define _fdeclSwap __decl(Swap)

NAMESPACE(STD)

void __decl(Abort)(string mFile,int mLine,string mText){
   PrintFormat("Abort at file %s, line %i, reason: \"%s\"",mFile,mLine,mText);
   int __a=0;
   int __b=1/__a;}

#define _eLess __std(LESS)
#define _eEqual __std(EQUAL)
#define _eMore __std(MORE)
enum _tdeclECompare{
   __decl(LESS)=-1,
   __decl(EQUAL)=0,
   __decl(MORE)=1
};

#define _eUp __std(UP)
#define _eDown __std(DOWN)
#define _eNoDirect __std(NO_DIRECT)
enum _tdeclEDirect{
   __decl(DOWN)=-1,
   __decl(NO_DIRECT)=0,
   __decl(UP)=1
};

template<typename T>
T* _fdeclMove(T* &mPtr){
   T* ret=mPtr;
   mPtr=NULL;
   return ret;}

template<typename T1,typename T2>
void _fdeclSwap(T1 &l,T2 &r){
   T1 tmp=l;
   l=r;
   r=tmp;}

template<typename T>
class __decl(RVWrape){
public:
   T cVal;
   __decl(RVWrape)(T mVal):cVal(mVal){}
   __decl(RVWrape)(__decl(RVWrape)<T> &mOther){this=mOther;}
};

template<typename T>
__decl(RVWrape)<T> __decl(FRVWrape)(T fVal){return __decl(RVWrape<T>)(fVal);}

END_SPACE

#endif