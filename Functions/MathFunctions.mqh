#ifndef _MATH_FUNCTIONS_
#define _MATH_FUNCTIONS_

#include <MyMQLLib\Define\MQLDefine.mqh>

//----Сравнивает два чила с плавающей точкой-----------------------
__std(ECompare) CompareDouble(double fFirst,double fSecond,int digits){
   double res=NormalizeDouble(fFirst-fSecond,digits);
   return res==0.0?__std(EQUALLY):res>0.0?__std(MORE):__std(LESS);}
   
__std(ECompare) CompareDouble(float fFirst,float fSecond,int digits){
   float res=(float)NormalizeDouble(fFirst-fSecond,digits);
   return res==0.f?__std(EQUALLY):res>0.0?__std(MORE):__std(LESS);}
   
__std(ECompare) CompareDouble(double fFirst,float fSecond,int digits){
   double res=NormalizeDouble(fFirst-fSecond,digits);
   return res==0.0?__std(EQUALLY):res>0.0?__std(MORE):__std(LESS);}
   
__std(ECompare) CompareDouble(float fFirst,double fSecond,int digits){
   double res=NormalizeDouble(fFirst-fSecond,digits);
   return res==0.0?__std(EQUALLY):res>0.0?__std(MORE):__std(LESS);}
//-----------------------------------------------------------------

#endif 