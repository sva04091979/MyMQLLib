#ifndef _STD_C_JSON_
#define _STD_C_JSON_

#ifdef USING_STD
   #define json STD::CJSon
#endif

#define JSON_VALUE(dVal) Value(#dVal,dVal)
#define JSON_STRUCT(dVal) Struct(#dVal,dVal)
#define JSON_ARRAY(dVal) Array(#dVal,dVal)
#define JSON_ARRAY_STRUCT(dVal) ArrayStruct(#dVal,dVal)

namespace STD{

class CJSon{
   string text;
   bool isFinish;
public:
   CJSon():text("{"),isFinish(false){}
   CJSon* Manual(string key,void*) {text+="\""+key+"\":null,"; return &this;}
   template<typename T>
   CJSon* Manual(string key,T _text) {text+="\""+key+"\":"+_Text(_text)+","; return &this;}
   template<typename T>
   CJSon* Value(string key,T value) {text+="\""+key+"\":"+_Text(value)+","; return &this;}
   template<typename T>
   CJSon* Struct(string key,T &value) {text+="\""+key+"\":"+_StructText(value)+","; return &this;}
   template<typename T>
   CJSon* Struct(string key,T* value) {text+="\""+key+"\":"+_StructText(value)+","; return &this;}
   template<typename T>
   CJSon* Array(string key,T &value[]){
      text+="\""+key+"\":[";
      for (int i=0,count=ArraySize(value);i<count;text+=_Text(value[i++])+",");
      StringSetCharacter(text,StringLen(text)-1,']');
      text+=",";
      return &this;}
   template<typename T>
   CJSon* ArrayStruct(string key,T &value[]){
      text+="\""+key+"\":[";
      for (int i=0,count=ArraySize(value);i<count;text+=_StructText(value[i++])+",");
      StringSetCharacter(text,StringLen(text)-1,']');
      text+=",";
      return &this;}
   string Finish(){
      if (!isFinish){
         isFinish=true;
         StringSetCharacter(text,StringLen(text)-1,'}');}
      return text;}
private:
   string _Text(string value) {return "\""+value+"\"";}
   template<typename T>
   string _Text(T value) {return (string)value;}
   template<typename T>
   string _StructText(T &value) {return value.JSon();}
   template<typename T>
   string _StructText(T* value) {return !CheckPointer(value)?"null":value.JSon();}
};

}

#endif