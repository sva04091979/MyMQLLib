#ifndef _TRADE_FUNCTIONS_
#define _TRADE_FUNCTIONS_

#include "MathFunctions.mqh"
#include "PriceFunctions.mqh"
#include "..\Objects\Currency\CConvert.mqh"

//--Сравнивает цену с заданной, в зависимости от направления торговли---------------
_tECompare ComparePrice(double current,double equal,int direct,int digits){
   return direct>0?CompareDouble(current,equal,digits):CompareDouble(equal,current,digits);}
//--Проверяет наличие отступа текущей цены от заданной-------------------------------
double CheckPriceLevel(double current,double equal,double level,int digits){
   return NormalizeDouble(MathAbs(equal-current)-level,digits)<0.0?0.0:current;}
//-----------------------------------------------------------------------------------
double NormalizePrice(double fPrice,double fTickSize,int fDigits){
   return NormalizeDouble(MathRound(fPrice/fTickSize)*fTickSize,fDigits);}

//--Возвращает текстовое описание таймфрейма-----------------------------------------
string PeriodText(int mPeriod){
   if (mPeriod==PERIOD_CURRENT) mPeriod=Period();
   switch(mPeriod){
      default:    return NULL;
      case PERIOD_M1:  return "M1";
      case PERIOD_M5:  return "M5";
      case PERIOD_M15: return "M15";
      case PERIOD_M30: return "M30";
      case PERIOD_H1:  return "H1";
      case PERIOD_H4:  return "H4";
      case PERIOD_D1:  return "D1";
      case PERIOD_W1:  return "W1";
      case PERIOD_MN1: return "MN1";}}
//----------------------------------------------------------------------------------------------
datetime iTime(int fShift) {return iTime(NULL,PERIOD_CURRENT,fShift);}
//----------------------------------------------------------------------------------------------
ENUM_TIMEFRAMES NextFrame(){return NextFrame((ENUM_TIMEFRAMES)_Period);}
//----------------------------------------------------------------------------------------------
ENUM_TIMEFRAMES NextFrame(ENUM_TIMEFRAMES frame){
   switch(frame){
      case PERIOD_CURRENT: return NextFrame((ENUM_TIMEFRAMES)_Period);
      case PERIOD_M1:      return PERIOD_M5;
      case PERIOD_M5:      return PERIOD_M15;
      case PERIOD_M15:     return PERIOD_M30;
      case PERIOD_M30:     return PERIOD_H1;
      case PERIOD_H1:      return PERIOD_H4;
      case PERIOD_H4:      return PERIOD_D1;
      case PERIOD_D1:      return PERIOD_W1;
      case PERIOD_W1:      return PERIOD_MN1;
      default:             return frame;}}

#endif 