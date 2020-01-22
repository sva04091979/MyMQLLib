#ifndef _STOP_
#define _STOP_

#include "Start.mqh"

void Deinit(const int reason){
   switch(reason){
      case REASON_PARAMETERS:    ChangeParam(); break;
      case REASON_PROGRAM:
      case REASON_REMOVE:
      case REASON_RECOMPILE:
      case REASON_INITFAILED:
      case REASON_CLOSE:
      case REASON_CHARTCLOSE:    Stop(); break;
      case REASON_TEMPLATE:
      case REASON_ACCOUNT:       Restart(); break;
      case REASON_CHARTCHANGE:   Start(START_FLAG_CHARTCHANGE);}}
//-------------------------------------------------------------------
void ChangeParam(){
   Start(START_FLAG_CHANGE_PARAM);}
//-------------------------------------------------------------------
void Restart(){
   Stop();
   Start(START_FLAG_RESTART);}
//-------------------------------------------------------------------
void Stop(){}

#endif 