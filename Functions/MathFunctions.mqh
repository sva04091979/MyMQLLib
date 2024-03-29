#ifndef _MATH_FUNCTIONS_
#define _MATH_FUNCTIONS_

#include "..\Define\MQLDefine.mqh"

#define MORE _eMore
#define EQUALLY _eEqual
#define LESS _eLess
//----Сравнивает два чила с плавающей точкой-----------------------
_tECompare CompareDouble(double fFirst,double fSecond,int digits){
   double res=NormalizeDouble(fFirst-fSecond,digits);
   return res==0.0?EQUALLY:res>0.0?MORE:LESS;}
   
_tECompare CompareDouble(float fFirst,float fSecond,int digits){
   float res=(float)NormalizeDouble(fFirst-fSecond,digits);
   return res==0.f?EQUALLY:res>0.0?MORE:LESS;}
   
_tECompare CompareDouble(double fFirst,float fSecond,int digits){
   double res=NormalizeDouble(fFirst-fSecond,digits);
   return res==0.0?EQUALLY:res>0.0?MORE:LESS;}
   
_tECompare CompareDouble(float fFirst,double fSecond,int digits){
   double res=NormalizeDouble(fFirst-fSecond,digits);
   return res==0.0?EQUALLY:res>0.0?MORE:LESS;}
//-----------------------------------------------------------------

#endif 