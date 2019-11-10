#ifndef _C_BAR_
#define _C_BAR_

class CBar{
   MqlRates    cRate;
public:
               CBar(MqlRates &mRate)   {cRate=mRate;}
               CBar(int mPos);
   double      GetHigh()   {return cRate.high;}
   double      GetLow()   {return cRate.low;}
   double      GetOpen()   {return cRate.open;}
   double      GetClose()   {return cRate.close;}
   long        GetVolume() {return cRate.tick_volume;}
   datetime    GetTime()   {return cRate.time;}
   int         GetType()   {return cRate.close==cRate.open?0:cRate.close<cRate.open?-1:1;}
   double      GetSize()   {return cRate.high-cRate.low;}
   double      GetBody()   {return cRate.close-cRate.open;}
   double      GetBodySize()  {return MathAbs(GetBody());}
   double      GetUpTail() {return cRate.high-MathMax(cRate.open,cRate.close);}
   double      GetDownTail()  {return MathMin(cRate.open,cRate.close)-cRate.low;}
};
//---------------------------------------------------------------------------------
void CBar::CBar(int mPos){
   MqlRates rate[1];
   CopyRates(NULL,0,mPos,1,rate);
   cRate=rate[0];}

#endif