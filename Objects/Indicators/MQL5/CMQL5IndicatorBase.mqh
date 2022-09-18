#ifndef _C_MQL5_INDICATOR_BASE_
#define _C_MQL5_INDICATOR_BASE_

#include <MyMQLLib\Objects\CFlag.mqh>

#define INDICATOR_FLAG_INIT 0x1
#define INDICATOR_FLAG_SHOW 0x2

class IIndicatorBuffer{
protected:
   double   cBuffer[];
   int      cHndl;
   int      cBufferNumber;
public:
   IIndicatorBuffer(int hndl,int mBufferNumber);
   void ChangeParam(int hndl) {cHndl=hndl;}
   int BufferCopy(int mBars);
   int BufferCopy(datetime timeFrom, datetime timeTo);
   double operator [](int mPos) const {return cBuffer[mPos];}
   int   BufferSize()   {return ArraySize(cBuffer);}
  };
//-------------------------------------------------------------
IIndicatorBuffer::IIndicatorBuffer(int hndl,int mBufferNumber):
   cHndl(hndl),
   cBufferNumber(mBufferNumber){
      ArraySetAsSeries(cBuffer,true);
   }
//--------------------------------------------------------------
int IIndicatorBuffer::BufferCopy(int mBars){
   return CopyBuffer(cHndl,cBufferNumber,0,mBars,cBuffer);}
//--------------------------------------------------------------
int IIndicatorBuffer::BufferCopy(datetime timeFrom, datetime timeTo){
   return CopyBuffer(cHndl,cBufferNumber,timeFrom,timeTo,cBuffer);}
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
public:
                     CMQL5IndicatorBase(int mHndl,string mSymbol,ENUM_TIMEFRAMES mPeriod,int mBuffersCount);
                    ~CMQL5IndicatorBase(){
                        for (int i=0;i<cBuffersCount;delete cBuffers[i++]);
                        IndicatorRelease(cHndl);
                        if (cName!=NULL){
                           ChartIndicatorDelete(0,cSubWindow,cName);
                        }
                     }
   void              ChangeParam(int hndl,string mSymbol,ENUM_TIMEFRAMES mPeriod);
   IIndicatorBuffer* operator [](int mPos) const {return cBuffers[mPos];}
   bool              Show(int subWindow);
   string            Symbol() {return cSymbol;}
   string            Name() {return cName;}
   ENUM_TIMEFRAMES   TimeFrame() {return cPeriod;}
   int               BuffersCount() {return cBuffersCount;}
   int               Handle() {return cHndl;}
   int               BufferSize()   {return cBuffers[0].BufferSize();}
   int               IndicatorControl();
private:
   void              CreateBuffers();
};
//------------------------------------------------------------------------------
CMQL5IndicatorBase::CMQL5IndicatorBase(int mHndl,string mSymbol,ENUM_TIMEFRAMES mPeriod,int mBuffersCount):
   cSymbol(mSymbol==NULL?_Symbol:mSymbol),
   cName(NULL),
   cPeriod(mPeriod),
   cSubWindow(0),
   cBuffersCount(mBuffersCount),
   cHndl(mHndl){
   if (cHndl!=INVALID_HANDLE                                &&
       ArrayResize(cBuffers,mBuffersCount)==mBuffersCount){
         cState+=INDICATOR_FLAG_INIT;
         CreateBuffers();
   }
}
//----------------------------------------------------------
void CMQL5IndicatorBase::ChangeParam(int hndl,string mSymbol,ENUM_TIMEFRAMES mPeriod){
   for (int i=0;i<cBuffersCount;cBuffers[i++].ChangeParam(hndl));
   if (cName!=NULL){
      ChartIndicatorDelete(0,cSubWindow,cName);
   }
   IndicatorRelease(cHndl);
   cHndl=hndl;
   if (cName!=NULL)
      Show(cSubWindow);
}

//-------------------------------------------------------------------------------
void CMQL5IndicatorBase::CreateBuffers(){
   for (int i=0;i<cBuffersCount;++i)
      cBuffers[i]=new IIndicatorBuffer(cHndl,i);
}
//-------------------------------------------------------------------------------
bool CMQL5IndicatorBase::Show(int subWindow){
   bool ret=ChartIndicatorAdd(0,subWindow,cHndl);
   if (ret){
      cSubWindow=subWindow;
      cName=ChartIndicatorName(0,subWindow,ChartIndicatorsTotal(0,subWindow)-1);
   }
   return ret;
}
//--------------------------------------------------------------------------------
int CMQL5IndicatorBase::IndicatorControl(void){
   int bars=Bars(cSymbol,cPeriod);
   int ret=INT_MAX;
   for(int i=0;i<cBuffersCount;++i)
      ret=MathMin(ret,cBuffers[i].BufferCopy(bars));
   return ret;
}

#endif