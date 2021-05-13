#include "..\..\Define\StdDefine.mqh"

#ifndef _STD_MQL5_INDICATOR_BASE_
#define _STD_MQL5_INDICATOR_BASE_

#define _tIndicatorData __std(MQL5_IndicatorData)
#define _tIndicatorSingleData __std(MQL5_SingleBufferData)
#define _tIndicatorMultiData __std(MQL5_MultiBufferData)
#define _tIndicatorBuffer __std(MQL5_IndicatorBuffer)
#define _tIndicatorBase __std(MQL5_IndicatorBase)
#define _tIndicatorOneBuffer __std(MQL5_IndicatorOneBuffer)
#define _tIndicatorMultiBuffer __std(MQL5_IndicatorMultiBuffer)

template<typename DataType,typename AccessType>
class _tIndicatorData{
protected:
   int cHndl;
   int cBarsCalculated;
   _tIndicatorData(int hndl):cHndl(hndl),cBarsCalculated(-1){}
public:
   virtual void AsSeries(bool asSeries)=0;
   virtual uint BuffCount()=0;
   virtual int Size()=0;
   virtual AccessType operator [](int i)=0;
   virtual DataType* Data(uint begin,uint count)=0;
   virtual DataType* Data(datetime begin,datetime end)=0;
   virtual DataType* Data(datetime begin,uint count)=0;
   virtual bool AsSeries()=0;
   int Handle()   {return cHndl;}
   int BarsCalculated() {return cBarsCalculated;}
protected:
   void SetBarsCount() {cBarsCalculated=::BarsCalculated(cHndl);}
};
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
template<typename DataType>
class _tIndicatorSingleData:public _tIndicatorData<DataType,double>{
protected:
   _tIndicatorBuffer cBuff;
   _tIndicatorSingleData(int hndl):_tIndicatorData<DataType,double>(hndl){}
public:
   void AsSeries(bool asSeries) override final {cBuff.AsSeries(asSeries);}
   uint BuffCount() override final {return 1;}
   int Size() {return cBuff.Size();}
   double operator [](int i) override final {return cBuff[i];}
   DataType* Data(uint begin,uint count)            {SetBarsCount(); cBuff.MakeData(cHndl,begin,count); return &this;}
   DataType* Data(datetime begin,datetime end)      {SetBarsCount(); cBuff.MakeData(cHndl,begin,end); return &this;}
   DataType* Data(datetime begin,uint count)        {SetBarsCount(); cBuff.MakeData(cHndl,begin,count); return &this;}
   bool AsSeries() override final {return cBuff.AsSeries();}
};
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
/*
template<typename DataType>
class _tIndicatorMultiData:public _tIndicatorData<DataType,_tIndicatorBuffer*>{
protected:
   _tIndicatorBuffer cBuff[];
   uint cCount;
   bool cAsSeries;
   _tIndicatorMultiData(int hndl):_tIndicatorData<DataType,_tIndicatorBuffer>(hndl),cCount(0){}
   _tIndicatorMultiData(int hndl,uint buffCount);
public:
   void AsSeries(bool asSeries) override final;
   uint BuffCount() override final {return cCount;}
   int Bars(int i) {return cBuff[i].Size();}
   _tIndicatorBuffer* operator [](int i) override final {return &cBuff[i];}
   DataType* Data(uint begin,uint count)            {cBuff.MakeData(begin,count); return &this;}
   DataType* Data(datetime begin,datetime end)      {cBuff.MakeData(begin,end); return &this;}
   DataType* Data(datetime begin,uint count)        {cBuff.MakeData(begin,count); return &this;}
   bool operator !() {return !cCount||cCount!=ArraySize(cBuff);}
   bool AsSeries() override final {return cAsSeries;}
};
//--------------------------------------------------------------
template<typename DataType>
_tIndicatorMultiData::_tIndicatorMultiData(int hndl,uint buffCount):
   _tIndicatorData<DataType,_tIndicatorBuffer>(hndl){
   if ((int)buffCount==ArrayResize(cBuff,buffCount)){
      cCount=buffCount;
      for (uint i=0;i<buffCount;++i)
         cBuff[i].Id(i);
   }
   else cCount=0;
}
//--------------------------------------------------------------
template<typename DataType>
void _tIndicatorMultiData::AsSeries(bool asSeries){
   cAsSeries=asSeries;
   for (int i=0,size=ArraySize(cBuff);i<size;++i)
      cBuff[i].AsSeries(asSeries);
}
*/
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
class _tIndicatorBuffer{
   double cBuff[];
   uint cId;
   int cSize;
public:
   _tIndicatorBuffer();
   void Id(uint id) {cId=id;}
   void AsSeries(bool asSeries) {ArraySetAsSeries(cBuff,asSeries);}
   int Size() const {return cSize;}
   double operator[](int i) {return cBuff[i];}
   void MakeData(int hndl,uint begin,uint count)         {cSize=CopyBuffer(hndl,cId,begin,count,cBuff);}
   void MakeData(int hndl,datetime begin,datetime end)   {cSize=CopyBuffer(hndl,cId,begin,end,cBuff);}
   void MakeData(int hndl,datetime begin,uint count)     {cSize=CopyBuffer(hndl,cId,begin,count,cBuff);}
   bool AsSeries() {return ArrayIsSeries(cBuff);}
};
//--------------------------------------------------------------
_tIndicatorBuffer::_tIndicatorBuffer():
   cSize(0){
   ArraySetAsSeries(cBuff,true);}
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
template<typename DataType,typename AccessType>
class _tIndicatorBase{
protected:
   DataType          cData;
   string            cSymbol;
   string            cName;
   ENUM_TIMEFRAMES   cPeriod;
   int               cSubWindow;
                     _tIndicatorBase(int mHndl,string mSymbol,ENUM_TIMEFRAMES mPeriod);
public:
                    ~_tIndicatorBase(){
                        if (cName!=NULL) ChartIndicatorDelete(0,cSubWindow,cName);
                        IndicatorRelease(cData.Handle());}
   DataType*         Data()                                 {return &cData;}                    
   DataType*         MakeData(uint count=0)                 {return MakeData(0,!count?BarsCalculated():count);}
   DataType*         MakeData(uint begin,uint count)        {return cData.Data(begin,count);}
   DataType*         MakeData(datetime begin,datetime end)  {return cData.Data(begin,end);}
   DataType*         MakeData(datetime begin,uint count)    {return cData.Data(begin,count);}
   DataType*         MakeData(uint begin,datetime end);
   void              Show(int subWindow);
   void              AsSeries(bool asSeries)                {cData.AsSeries(asSeries);}
   string            Symbol()                               {return cSymbol;}
   string            Name()                                 {return cName;}
   ENUM_TIMEFRAMES   TimeFrame()                            {return cPeriod;}
   uint              BuffCount()                            {return cData.BuffCount();}
   int               Handle()                               {return cData.Handle();}
   int               BarsCalculated()                       {return cData.BarsCalculated();}
   bool              AsSeries()                             {return cData.AsSeries();}
   AccessType        operator [](int i)                     {return cData[i];}       
};
//------------------------------------------------------------------------------
template<typename DataType,typename AccessType>
_tIndicatorBase::_tIndicatorBase(int mHndl,string mSymbol,ENUM_TIMEFRAMES mPeriod):
   cData(mHndl),
   cSymbol(mSymbol==NULL?_Symbol:mSymbol),
   cName(NULL),
   cPeriod(mPeriod),
   cSubWindow(-1){}
//--------------------------------------------------------------------------------
template<typename DataType,typename AccessType>
void _tIndicatorBase::Show(int subWindow){
   if (cSubWindow<0&&ChartIndicatorAdd(0,subWindow,cData.Handle())){
      cSubWindow=subWindow;
      cName=ChartIndicatorName(0,cSubWindow,ChartIndicatorsTotal(0,cSubWindow)-1);
   }
}
//---------------------------------------------------------------------------------
template<typename DataType,typename AccessType>
DataType* _tIndicatorBase::MakeData(uint begin,datetime end){
   datetime _begin=!begin?TimeCurrent():iTime(cSymbol,cPeriod,begin-1);
   return cData.Data(_begin,end);
}
////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
template<typename DataType>
class _tIndicatorOneBuffer:public _tIndicatorBase<DataType,double>{
protected:
   _tIndicatorOneBuffer(int hndl,string symbol,ENUM_TIMEFRAMES period):
      _tIndicatorBase<DataType,double>(hndl,symbol,period){}
};

#endif