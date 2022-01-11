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

class STD_JSONPair{
public:
   string key;
   STD_JSONValue* value;
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
   virtual bool IsIntegral() const {return false;}
   virtual bool IsFloatingPoint() const {return false;}
   virtual bool IsArray() const {return false;}
   virtual bool IsObject() const {return false;}
   virtual ulong Size() const {return 1;}
   virtual string ToString() const =0;
   template<typename JSONType>
   const JSONType* Cast() const {return dynamic_cast<const JSONType*>(&this);}
   
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
      for (uint i=0;i<cSize;delete cArray[i++]);
   }
   ulong Size() const override final{return cSize;}
   const Type* operator [](uint pos) const {return pos<cSize?cArray[pos]:NULL;}
protected:
   STD_JSONColection():cSize(0),cReserv(0){}
   STD_JSONColection(uint reserv):cSize(0){cReserv=ArrayResize(cArray,reserv);}
   bool Add(Type* ptr){
      if (cSize>=cReserv){
         uint newReserv=MathMin(MathMax(cReserv+1,cReserv*3/2),SHORT_MAX);
         if (ArrayResize(cArray,newReserv)==-1){
            delete ptr;
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
      if (res&&!(res=Add(ptr)))
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
};
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class STD_JSONArray:public STD_JSONColection<STD_JSONValue>{
public:
   STD_JSONArray():STD_JSONColection(){}
   STD_JSONArray(uint reserv):STD_JSONColection(reserv){}
   STD_EJSONValueType ValueType() const override final{return _eJSON_Array;}
   bool IsArray() const override final {return true;}
   bool operator +=(STD_JSONValue* ptr){return !ptr?false:Add(ptr);}
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
   bool IsIntegral() const override {return true;}
   string ToString() const override {return cValue?"true":"false";}
};
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
class STD_JSONString:public STD_JSONValueStore<string>{
public:
   STD_JSONString(string value):STD_JSONValueStore(value){}
   STD_EJSONValueType ValueType() const override final {return _eJSON_String;}
   string ToString() const override {return "\""+cValue+"\"";}
};
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
template<typename Type>
class STD_JSONNumber:public STD_JSONValueStore<Type>{
public:
   STD_JSONNumber(Type value):STD_JSONValueStore(value){}
   STD_EJSONValueType ValueType() const override final {return _eJSON_Number;}
   string ToString() const override {return (string)cValue;}
};
//////////////////////////////////////////////////////////////////////////////
class STD_JSONDouble:public STD_JSONNumber<double>{
public:
   STD_JSONDouble(double value):STD_JSONNumber(value){}
   bool IsSigned() const override {return true;}
   bool IsFloatingPoint() const override {return true;}
};
//////////////////////////////////////////////////////////////////////////////
template<typename Type>
class STD_JSONIntegral:public STD_JSONNumber<Type>{
public:
   STD_JSONIntegral(Type value):STD_JSONNumber(value){}
   bool IsIntegral() const override {return true;}
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