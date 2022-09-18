#ifndef _STOP_
#define _STOP_

#include "Start.mqh"

void Deinit(const int reason){
   switch(reason){
      case REASON_PARAMETERS:    ChangeParamOnDeinit(); break;
      case REASON_PROGRAM:
      case REASON_REMOVE:
      case REASON_INITFAILED:
      case REASON_CLOSE:
      case REASON_CHARTCLOSE:    Stop(); break;
      case REASON_TEMPLATE:
      case REASON_RECOMPILE:
      case REASON_ACCOUNT:       RestartOnDeinit(); break;
      case REASON_CHARTCHANGE:   ChartChangeOnDeinit();}}
//-------------------------------------------------------------------
void ChangeParamOnDeinit(){
   Start(START_FLAG_CHANGE_PARAM);}
//-----------------------------------------------------------------
void RestartOnDeinit(){
   Stop();
   Start(START_FLAG_RESTART);}
//-------------------------------------------------------------------
void ChartChangeOnDeinit(){
   Start(START_FLAG_CHARTCHANGE);}
//--------------------------------------------------------------------
void Stop(){}

#endif 