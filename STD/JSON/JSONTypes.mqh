#include "..\Define\StdDefine.mqh"

#ifndef _STD_JSON_TYPES_
#define _STD_JSON_TYPES_

#ifdef __MQL4__
   #property strict
#endif

#ifdef __MQL5__
   #include <Generic\HashMap.mqh>
#else
   #include "Generic\HashMap.mqh"
#endif

enum STD_EJSONValueType{_eJSON_Object,_eJSON_Array,_eJSON_Number,_eJSON_String,_eJSON_Bool,_eJSON_Null};

class STD_JSONValue;
class STD_JSONString;
class STD_JSONBool;

class STD_JSONPair{
public:
   string key;
   STD_JSONValue* value;
   STD_JSONPair(){}
   STD_JSONPair(string _key,STD_JSONValue* _value):key(_key),value(_value){}
  ~STD_JSONPair(){
   DEL(value);
   }
   string ToString(){
      return "\""+key+"\":"+value.ToString();
   }
};

class STD_JSONValue{
public:
   virtual STD_EJSONValueType ValueType() const=0;
   virtual bool IsSigned() const {return false;}
   virtual bool IsNumber() const {return false;}
   virtual bool IsInteger() const {return false;}
   virtual bool IsFloatingPoint() const {return false;}
   virtual bool IsArray() const {return false;}
   virtual bool IsObject() const {return false;}
   virtual bool IsString() const {return false;}
   virtual bool IsBoolean() const {return false;}
   virtual ulong Size() const {return 1;}
   virtual string ToString() const =0;
   template<typename JSONType>
   const JSONType* Cast() const {return dynamic_cast<const JSONType*>(&this);}
   template<typename Type>
   bool GetInteger(Type& val) const {
      if(IsInteger()){
         if (IsSigned())
            val=(Type)Cast<STD_JSONLong>().Value();
         else
            val=(Type)Cast<STD_JSONULong>().Value();
         return true;
      }
      else
         return false;
   }
   template<typename Type>
   bool GetString(Type& val) const {
      if (IsString()){
         val=(Type)Cast<STD_JSONString>().Value();
         return true;
      }
      else
         return false;
   }
   template<typename Type>
   bool GetFloatingPoint(Type& val) const {
      if (IsFloatingPoint()){
         val=(Type)Cast<STD_JSONDouble>().Value();
         return true;
      }
      else
         return false;
   }
   template<typename Type>
   bool GetBoolean(Type& val) const {
      if (IsBoolean()){
         val=(Type)Cast<STD_JSONBool>().Value();
         return true;
      }
      else
         return false;
   }
};

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
template<typename Type>
class STD_JSONColection:public STD_JSONValue{
protected:
   Type* cArray[];
   uint cSize;
   uint cReserv;
public:
  ~STD_JSONColection(){
      for (uint i=0;i<cSize;++i)
         DEL(cArray[i]);
   }
   ulong Size() const override final{return cSize;}
   const Type* operator [](uint pos) const {return pos<cSize?cArray[pos]:NULL;}
protected:
   STD_JSONColection():cSize(0),cReserv(0){}
   STD_JSONColection(uint reserv):cSize(0){cReserv=ArrayResize(cArray,reserv);}
   bool AddPtr(Type* ptr){
      if (cSize>=cReserv){
         uint newReserv=MathMin(MathMax(cReserv+1,cReserv*3/2),SHORT_MAX);
         if (ArrayResize(cArray,newReserv)==-1){
            DEL(ptr);
            return false;
         }
         cReserv=newReserv;
      }
      cArray[cSize++]=ptr;
      return true;
   }
   string CollectionToString() const{
      string ret="";
      if (cSize>0){
         uint i=0;
         ret+=cArray[i].ToString();
         while(++i<cSize){
            ret+=","+cArray[i].ToString();
         }
      }
      return ret;
   }
};
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class STD_JSONObject:public STD_JSONColection<STD_JSONPair>{
   CHashMap<string,STD_JSONValue*> cMap;
public:
   STD_JSONObject():STD_JSONColection(){}
   STD_JSONObject(uint reserv):STD_JSONColection(reserv){}
   STD_EJSONValueType ValueType() const override final {return _eJSON_Object;}
   bool IsObject() const override final {return true;}
   bool operator +=(STD_JSONPair* ptr){
      if (!ptr)
         return false;
      bool res=cMap.Add(ptr.key,ptr.value);
      if (res&&!(res=AddPtr(ptr)))
         cMap.Remove(ptr.key);
      return res;
   }
   const STD_JSONValue* operator [](string key) const {
      STD_JSONValue* ret=NULL;
      return ((CHashMap<string,STD_JSONValue*>*)&cMap).TryGetValue(key,ret)?ret:NULL;
   }
   string ToString() const override {
      return "{"+CollectionToString()+"}";
   }
   bool Add(string key,STD_JSONValue* value){
      STD_JSONPair* pair=new STD_JSONPair(key,value);
      return operator +=(pair);
   }
   bool String(string key,string& result) const{
      const STD_JSONValue* it=operator[](key);
      if (!it||!it.IsString())
         return false;
      result=it.Cast<STD_JSONString>().Value();
      return true;
   }
   bool Bool(string key,bool& result) const{
      const STD_JSONValue* it=operator[](key);
      if (!it||!it.IsBoolean())
         return false;
      result=it.Cast<STD_JSONBool>().Value();
      return true;
   }
   template<typename Type>
   bool Number(string key,Type& result) const{
      const STD_JSONValue* it=operator[](key);
      if (!it||!it.IsNumber())
         return false;
      result=it.IsFloatingPoint()?(Type)it.Cast<STD_JSONDouble>().Value():
                                  it.IsSigned()?(Type)it.Cast<STD_JSONIntegral<long>>().Value():
                                                (Type)it.Cast<STD_JSONIntegral<ulong>>().Value();
      return true;        
   }
};
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class STD_JSONArray:public STD_JSONColection<STD_JSONValue>{
public:
   STD_JSONArray():STD_JSONColection(){}
   STD_JSONArray(uint reserv):STD_JSONColection(reserv){}
   STD_EJSONValueType ValueType() const override final{return _eJSON_Array;}
   bool IsArray() const override final {return true;}
   bool operator +=(STD_JSONValue* ptr){return !ptr?false:AddPtr(ptr);}
   string ToString() const override {
      return "["+CollectionToString()+"]";
   }
};
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
template<typename Type>
class STD_JSONValueStore:public STD_JSONValue{
protected:
   Type cValue;
public:
   STD_JSONValueStore(Type value):cValue(value){}
   Type Value() const {return cValue;}
};
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class STD_JSONNull:public STD_JSONValueStore<void*>{
public:
   STD_JSONNull():STD_JSONValueStore(NULL){}
   STD_EJSONValueType ValueType() const override final {return _eJSON_Null;}
   string ToString() const override {return "null";}
};
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class STD_JSONBool:public STD_JSONValueStore<bool>{
public:
   STD_JSONBool(bool value):STD_JSONValueStore(value){}
   STD_EJSONValueType ValueType() const override final {return _eJSON_Bool;}
   bool IsBoolean() const override {return true;}
   string ToString() const override {return cValue?"true":"false";}
};
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class STD_JSONString:public STD_JSONValueStore<string>{
public:
   STD_JSONString(string value):STD_JSONValueStore(value){}
   STD_EJSONValueType ValueType() const override final {return _eJSON_String;}
   bool IsString() const override final {return true;}
   string ToString() const override {return "\""+cValue+"\"";}
};
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
template<typename Type>
class STD_JSONNumber:public STD_JSONValueStore<Type>{
public:
   STD_JSONNumber(Type value):STD_JSONValueStore(value){}
   STD_EJSONValueType ValueType() const override final {return _eJSON_Number;}
   bool IsNumber() const override final {return true;}
   string ToString() const override {return (string)cValue;}
};
//////////////////////////////////////////////////////////////////////////////
class STD_JSONDouble:public STD_JSONNumber<double>{
public:
   STD_JSONDouble(double value):STD_JSONNumber(value){}
   bool IsSigned() const override {return true;}
   bool IsFloatingPoint() const override {return true;}
   string ToString() const override {return StringFormat("%s",cValue);}
};
//////////////////////////////////////////////////////////////////////////////
template<typename Type>
class STD_JSONIntegral:public STD_JSONNumber<Type>{
public:
   STD_JSONIntegral(Type value):STD_JSONNumber(value){}
   bool IsInteger() const override {return true;}
};
//////////////////////////////////////////////////////////////////////////////
class STD_JSONLong:public STD_JSONIntegral<long>{
public:
   STD_JSONLong(long value):STD_JSONIntegral(value){}
   bool IsSigned() const override {return true;}
};
//////////////////////////////////////////////////////////////////////////////
class STD_JSONULong:public STD_JSONIntegral<ulong>{
public:
   STD_JSONULong(ulong value):STD_JSONIntegral(value){}
};

#endif 