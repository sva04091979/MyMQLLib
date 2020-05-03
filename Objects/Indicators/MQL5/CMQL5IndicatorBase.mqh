#ifndef _C_MQL5_INDICATOR_BASE_
#define _C_MQL5_INDICATOR_BASE_

#include <MyMQLLib\Objects\CFlag.mqh>

#define INDICATOR_FLAG_INIT 0x1
#define INDICATOR_FLAG_HISTORY_FAIL 0x2
#define INDICATOR_FLAG_SHOW 0x4

class IIndicatorBuffer{
protected:
   double   cBuffer[];
   int      cMaxIndex;
   int      cHndl;
   int      cBufferNumber;
public:
            IIndicatorBuffer(int mHndl,int mSize,int mBufferNumber);
   virtual bool IsOk()   {return true;}
   virtual void BufferCopy(int mBarsShift)=0;
   double operator [](int mPos) {return cBuffer[cMaxIndex-mPos];}
   int   BufferSize()   {return ArraySize(cBuffer);}
protected:
   void ReAlloc(long mNewSize);
   void Shift(int mShift) {for (int i=0,stop=ArraySize(cBuffer)-mShift;i<stop;++i) cBuffer[i]=cBuffer[i+mShift];}
  };
//-------------------------------------------------------------
IIndicatorBuffer::IIndicatorBuffer(int mHndl,int mSize,int mBufferNumber):
   cMaxIndex(mSize-1),
   cHndl(mHndl),
   cBufferNumber(mBufferNumber){
   if (mSize>0) ArrayResize(cBuffer,mSize);}
//-------------------------------------------------------------
void IIndicatorBuffer::ReAlloc(long mNewSize){
   int size=ArraySize(cBuffer),
       newSize=ArrayResize(cBuffer,mNewSize>INT_MAX?INT_MAX:(int)mNewSize);
   if (newSize<0) Shift(int(mNewSize-size));
   else{
      cMaxIndex=newSize-1;
      if (newSize<mNewSize) Shift(int(mNewSize-newSize));}}
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
class CDefaultBuffer:public IIndicatorBuffer{
public:
   CDefaultBuffer(int mHndl,int mBufferNumber);
   void BufferCopy(int mBarsShift);
};
//--------------------------------------------------------------
CDefaultBuffer::CDefaultBuffer(int mHndl,int mBufferNumber):
   IIndicatorBuffer(mHndl,0,mBufferNumber){}
//--------------------------------------------------------------
void CDefaultBuffer::BufferCopy(int mBarsShift){
   if (mBarsShift<0) cMaxIndex=CopyBuffer(cHndl,cBufferNumber,TimeCurrent(),D'01.01.1970',cBuffer)-1;
   else{
      if (mBarsShift>0) ReAlloc((long)cMaxIndex+mBarsShift+1);
      CopyBuffer(cHndl,cBufferNumber,0,mBarsShift+1,cBuffer);}}
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
class CFixedBuffer:public IIndicatorBuffer{
   int cSize;
public:
   CFixedBuffer(int mHndl,int mBufferNumber,int mBufferSize);
   void BufferCopy(int mBarsShift);
};
//--------------------------------------------------------------
CFixedBuffer::CFixedBuffer(int mHndl,int mBufferNumber,int mBufferSize):
   IIndicatorBuffer(mHndl,mBufferSize,mBufferNumber),cSize(mBufferSize){}
//--------------------------------------------------------------
void CFixedBuffer::BufferCopy(int mBarsShift){
   int count=mBarsShift<0||cSize<=mBarsShift?cSize:mBarsShift+1;
   if (mBarsShift>0) Shift(mBarsShift);
   CopyBuffer(cHndl,cBufferNumber,0,count,cBuffer);}
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
class CMQL5IndicatorBase{
protected:
   CFlag             cState;
   IIndicatorBuffer* cBuffers[];
   string            cSymbol;
   string            cName;
   ENUM_TIMEFRAMES   cPeriod;
   int               cSubWindow;
   int               cBuffersCount;
   int               cHndl;
   int               cBufferSize;
   datetime          cLastTime;
public:
                     CMQL5IndicatorBase(int mHndl,string mSymbol,ENUM_TIMEFRAMES mPeriod,int mBuffersCount,int mBufferSize);
                    ~CMQL5IndicatorBase(){
                        for (int i=0;i<cBuffersCount;delete cBuffers[i++]);
                        ChartIndicatorDelete(0,cSubWindow,cName);
                        IndicatorRelease(cHndl);}
   IIndicatorBuffer* operator [](int mPos) {return cBuffers[mPos];}
   void              Show(int subWindow);
   string            Symbol() {return cSymbol;}
   string            Name() {return cName;}
   ENUM_TIMEFRAMES   TimeFrame() {return cPeriod;}
   int               BuffersCount() {return cBuffersCount;}
   int               Handle() {return cHndl;}
   int               BufferSize()   {return !cBufferSize?cBuffers[0].BufferSize():cBufferSize;}
   bool              CheckBuffers() {return CheckBuffers(TimeCurrent());}
   bool              CheckBuffers(datetime mTime);
private:
   bool              CreateBuffers();
};
//------------------------------------------------------------------------------
CMQL5IndicatorBase::CMQL5IndicatorBase(int mHndl,string mSymbol,ENUM_TIMEFRAMES mPeriod,int mBuffersCount,int mBufferSize):
   cSymbol(mSymbol==NULL?_Symbol:mSymbol),
   cName(NULL),
   cPeriod(mPeriod),
   cSubWindow(0),
   cBuffersCount(mBuffersCount),
   cHndl(mHndl),
   cBufferSize(mBufferSize),
   cLastTime(0){
   if (cHndl!=INVALID_HANDLE                                &&
       ArrayResize(cBuffers,mBuffersCount)==mBuffersCount   &&
       CreateBuffers())                                     cState+=INDICATOR_FLAG_INIT;}
//-------------------------------------------------------------------------------
bool CMQL5IndicatorBase::CreateBuffers(){
   bool isOk=true;
   for (int i=0;i<cBuffersCount;++i){
      cBuffers[i]=!cBufferSize?(IIndicatorBuffer*)new CDefaultBuffer(cHndl,i):(IIndicatorBuffer*)new CFixedBuffer(cHndl,i,cBufferSize);
      if (!cBuffers[i].IsOk()) isOk=false;}
   return isOk;}
//-------------------------------------------------------------------------------
bool CMQL5IndicatorBase::CheckBuffers(datetime mTime){
   if (!cState.Check(INDICATOR_FLAG_INIT)) return false;
   if (!cState.Check(INDICATOR_FLAG_HISTORY_FAIL)&&mTime<=cLastTime) return true;
   ResetLastError();
   int barShift=iBarShift(cSymbol,cPeriod,cLastTime,true);
   for (int i=0;i<cBuffersCount;cBuffers[i++].BufferCopy(barShift));
   if (!_LastError){
      cLastTime=TimeCurrent();
      cState-=INDICATOR_FLAG_HISTORY_FAIL;}
   else cState+=INDICATOR_FLAG_HISTORY_FAIL;
   return !_LastError;}
//--------------------------------------------------------------------------------
void CMQL5IndicatorBase::Show(int subWindow){
   if (!cState.Check(INDICATOR_FLAG_SHOW)&&ChartIndicatorAdd(0,subWindow,cHndl)){
      cSubWindow=subWindow;
      cName=ChartIndicatorName(0,cSubWindow,ChartIndicatorsTotal(0,cSubWindow)-1);
      cState+=INDICATOR_FLAG_SHOW;}}

#endif