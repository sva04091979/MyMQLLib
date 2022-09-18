#ifndef _STD_C_TIMER_
#define _STD_C_TIMER_

#include <STD\Define\StdDefine.mqh>

#ifdef USING_STD
   #define _tTimer __std(CTimer)
   #define _tTimerEvent __std(CTimerEvent)
   #define _tTimerInfo __std(STimerInfo)
#endif

NAMESPACE(STD)

struct STimerInfo{
   ulong   lastTimer;
   ulong   delta;
   ulong   step;
   _tSizeT count;
   STimerInfo(){Free();}
   STimerInfo(ulong _timer):lastTimer(_timer),delta(0),count(0){}
   STimerInfo(STimerInfo &other) {this=other;}
   void Reset(ulong mTimer,ulong mStep){
      lastTimer=mTimer;
      delta=0;
      step=mStep;
      count=0;}
   void Reset() {Reset(GetMicrosecondCount(),step);}
   void Free() {ZeroMemory(this);}
   bool operator !() {return !count;}
   _tSizeT Control(ulong mTimer){
      delta=mTimer-lastTimer;
      count=delta/step;
      if (count>0){
         lastTimer+=count*step;
         delta=mTimer-lastTimer;}
      return count;}
};

interface ITimerEvent;

class CTimer{
protected:
   typedef void (*TimerFunc)(STimerInfo& info);
   STimerInfo cInfo;
   TimerFunc cFunc;
   ITimerEvent* cEvent;
   _tSizeT cCount;
public:
   CTimer():cFunc(NULL),cEvent(NULL),cCount(0){}
   void Free() {cInfo.Free(); cFunc=NULL; cEvent=NULL; cCount=0;}
   CTimer* Reset(ulong mTimer,ulong mStep) {cInfo.Reset(mTimer,mStep); cCount=0; return &this;}
   CTimer* SetTimer() {return SetTimer(GetMicrosecondCount());}
   CTimer* SetTimer(ulong mTimer) {cInfo.lastTimer=mTimer; return &this;}
   CTimer* Step(ulong mStep) {cInfo.step=mStep; return &this;}
   CTimer* Function(TimerFunc mFunc) {cFunc=mFunc; return &this;}
   CTimer* Event(ITimerEvent* mEvent) {cEvent=mEvent; return &this;}
   ulong LastTimer() const {return cInfo.lastTimer;}
   ulong LastCheckTimer() const {return cInfo.lastTimer+cInfo.delta;}
   ulong Step() const {return cInfo.step;}
   STimerInfo LastInfo() const {return cInfo;}
   _tSizeT Control() {return Control(GetMicrosecondCount());}
   _tSizeT Control(ulong mTimer);
   _tSizeT GetLastCount();
   bool operator !() const {return !cInfo.lastTimer||!cInfo.step;}
};
//------------------------------------------------------------------------------
_tSizeT CTimer::Control(ulong mTimer){
   _tSizeT ret=cInfo.Control(mTimer);
   if (ret>0){
      cCount+=ret;
      if (cFunc!=NULL) cFunc(cInfo);
      if (cEvent!=NULL) cEvent.TimerEvent(cInfo);}
   return ret;}
//-------------------------------------------------------------------------------
_tSizeT CTimer::GetLastCount(){
   if (!cCount) return 0;
   _tSizeT ret=cCount;
   cCount=0;
   return ret;}
/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////
interface ITimerEvent{
   void TimerEvent(STimerInfo &mInfo);
};

template<typename Type>
class CTimerEvent:public ITimerEvent{
   Type*   cObj;
   CTimer* cTimer;
   void TimerEvent(STimerInfo &mInfo) override {cObj.TimerEvent(mInfo);}
public:
   CTimerEvent():cObj(NULL),cTimer(NULL){}
   CTimerEvent(Type* mObj,CTimer* mTimer):cObj(mObj),cTimer(mTimer){cTimer.Event(&this);}
   void Set(Type* mObj,CTimer* mTimer) {cObj=mObj; cTimer=mTimer; cTimer.Event(&this);}
};

END_SPACE

#endif