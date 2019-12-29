#ifndef _TIME_FUNCTIONS_
#define _TIME_FUNCTIONS_

#define TIME_DAY  86400
#define TIME_WEEK 604800

MqlDateTime TextToTimeStruct(string fTextTime){
   #define RETURN_FALSE_TIME do {TimeToStruct(0,time); return time;} while(false)
   MqlDateTime time;
   if (!TimeCurrent(time)) RETURN_FALSE_TIME;
   string data[];
   int size=StringSplit(fTextTime,':',data);
   if (size>3||size<0) RETURN_FALSE_TIME;
   for (int i=0;i<size;++i)
      switch (StringLen(data[i])){
         default: RETURN_FALSE_TIME;
         case 0:  data[i]="00"; break;
         case 1:  data[i]="0"+data[i]; break;
         case 2:  break;}
   if (size>0){
      time.hour=(int)StringToInteger(data[0]);
      if (time.hour<0||time.hour>23||IntegerToString(time.hour,2,'0')!=data[0]) RETURN_FALSE_TIME;}
   else time.hour=0;
   if (size>1){
      time.min=(int)StringToInteger(data[1]);
      if (time.min<0||time.min>59||IntegerToString(time.min,2,'0')!=data[1]) RETURN_FALSE_TIME;}
   else time.min=0;
   if (size>2){
      time.sec=(int)StringToInteger(data[2]);
      if (time.sec<0||time.sec>59||IntegerToString(time.sec,2,'0')!=data[2]) RETURN_FALSE_TIME;}
   else time.sec=0;
   return time;
   #undef RETURN_FALSE_TIME
}
//------------------------------------------------------------------------------------------
datetime TextToTime(string fTextTime){
   MqlDateTime time=TextToTimeStruct(fTextTime);
   return StructToTime(time);}
//-------------------------------------------------------------------------------------------
uint TextToSecons(string fTextTime){
   MqlDateTime time=TextToTimeStruct(fTextTime);
   return time.hour*3600+time.min*60+time.sec;}

#endif