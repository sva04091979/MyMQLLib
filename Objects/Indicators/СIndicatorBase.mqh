#ifndef _C_INDICATOR_BASE_
#define _C_INDICATOR_BASE_

class CBuffer{
public:
   double buf[];
   CBuffer() {ArraySetAsSeries(buf,true);}
   bool Create(int mSize)  {return mSize==ArrayResize(buf,mSize);}
   bool Copy(double &newBuf[]) {return ArraySize(newBuf)==ArrayCopy(buf,newBuf);}
   double Get(int mPos) {return buf[mPos];}
};

class CIndicatorBase
  {
protected:
   CBuffer           cBuffers[];
   string            cSymbol;
   int               cDigits;
   ENUM_TIMEFRAMES   cPeriod;
   int               cBuffersCount;
   int               cHndl;
   int               cBufferSize;
   datetime          cLastTime;
   bool              cIsBuffersOk;
public:
                     CIndicatorBase(int mHndl,string mSymbol,ENUM_TIMEFRAMES mPeriod,int mBuffersCount,int mBufferSize);
                    ~CIndicatorBase()  {if (cHndl!=INVALID_HANDLE) IndicatorRelease(cHndl);}
   bool              NewBuffersSize(int mNewSize);
protected:
   double            GetBuffer(int mNumber,int mPos,bool mIsCheck);
   bool              CheckBuffer();
private:
   bool              CopyBuffers(datetime mTime);
   bool              BufferCopy(int mNumber,int mCount);
   bool              CreateBuffers();
  };
//+------------------------------------------------------------------+
CIndicatorBase::CIndicatorBase(int mHndl,string mSymbol,ENUM_TIMEFRAMES mPeriod,int mBuffersCount,int mBufferSize):
   cHndl(mHndl),cSymbol(mSymbol==NULL?_Symbol:mSymbol),cDigits((int)SymbolInfoInteger(mSymbol,SYMBOL_DIGITS)),
   cPeriod(mPeriod==PERIOD_CURRENT?Period():mPeriod),cBuffersCount(mBuffersCount),
   cBufferSize(mBufferSize),cIsBuffersOk(false){
   datetime time=TimeCurrent();
   if (cHndl==INVALID_HANDLE  || 
       !CreateBuffers()       ||
       !CopyBuffers(time))    cLastTime=0;}
//--------------------------------------------------------------------------------------------
bool CIndicatorBase::CreateBuffers(void){
   if (cBuffersCount!=ArrayResize(cBuffers,cBuffersCount)) return cIsBuffersOk=false;
   if (!cBufferSize) return cIsBuffersOk=true;
   for (int i=0;i<cBuffersCount;)
      if (!cBuffers[i++].Create(cBufferSize)) return cIsBuffersOk=false;
   return cIsBuffersOk=true;}
//--------------------------------------------------------------------------------------------
bool CIndicatorBase::CopyBuffers(datetime mTime){
   if (!cIsBuffersOk&&!CreateBuffers()) return false;
   ResetLastError();
   int count=!cBufferSize?iBars(cSymbol,cPeriod):cBufferSize;
   if (_LastError) return false;
   for (int i=0;i<cBuffersCount;)
      if (!BufferCopy(i++,count)) {cLastTime=0; return false;}
   cLastTime=mTime;
   return true;}
//-------------------------------------------------------------------------------------------
bool CIndicatorBase::BufferCopy(int mNumber,int mCount){
   double buf[];
   bool res=mCount==CopyBuffer(cHndl,mNumber,0,mCount,buf)&&!_LastError;
   return res&&cBuffers[mNumber].Copy(buf);}
//--------------------------------------------------------------------------------------------
bool CIndicatorBase::CheckBuffer(){
   datetime time=TimeCurrent();
   return time==cLastTime||CopyBuffers(time);}
//-----------------------------------------------------------------------------------------
double CIndicatorBase::GetBuffer(int mNumber,int mPos,bool mIsCheck){
   return (mIsCheck||!cLastTime)&&!CheckBuffer()?EMPTY_VALUE:cBuffers[mNumber].Get(mPos);}
//------------------------------------------------------------------------------------------
bool CIndicatorBase::NewBuffersSize(int mNewSize){
   cLastTime=0;
   cBufferSize=mNewSize;
   if (!cBufferSize) return cIsBuffersOk=true;
   for (int i=0;i<cBufferSize;)
      if (!cBuffers[i++].Create(cBufferSize)) return cIsBuffersOk=false;
   return cIsBuffersOk=true;}
//-------------------------------------------------------------------------------------------


#endif