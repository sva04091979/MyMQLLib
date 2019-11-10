#ifndef _C_BYTES_MESSAGE_
#define _C_BYTES_MESSAGE_

#include "..\Array\CList.mqh"

template<typename T>
union UValue{
   T     value;
   char  array[sizeof(T)];
};

interface IBytesMessage{
   int CreateBytesMessage(char &mArray[]);
   int GetBytesSize();
   void SetMessage(char &mArray[]);
};
///////////////////////////////////////////////////////////////////////
template<typename T>
class CBytesMessage:public IBytesMessage
{
   UValue<T>   uVal;
public:
               CBytesMessage(){}
               CBytesMessage(T mVal){uVal.value=mVal;}
   int         CreateBytesMessage(char &mArray[]);
   int         GetBytesSize()   {return sizeof(T);}
   void        SetMessage(char &mArray[]) {ArrayCopy(uVal.array,mArray);}
   void        operator = (T mVal) {uVal.value=mVal;}
   T Get()     {return uVal.value;}
};
//--------------------------------------------------------------------
template<typename T>
int CBytesMessage::CreateBytesMessage(char &mArray[]){
   ArrayResize(mArray,sizeof(T));
   return ArrayCopy(mArray,uVal.array);}
/////////////////////////////////////////////////////////////////////////
class CStringMessage:public IBytesMessage
{
   string cMessage;
   char   cArray[];
   UValue<int> cArraySize;
public:
         CStringMessage(string mText):cMessage(mText){cArraySize.value=StringToCharArray(mText,cArray,0,WHOLE_ARRAY,CP_UTF8);}
         CStringMessage():cMessage(NULL){}
   int CreateBytesMessage (char &mArray[]);
   int GetBytesSize() {return cArraySize.value+sizeof(int);}
   void SetMessage(char &mArray[]) {cMessage=CharArrayToString(mArray,0,WHOLE_ARRAY,CP_UTF8);}
   void operator = (string mVal) {cArraySize.value=StringToCharArray(cMessage=mVal,cArray,0,WHOLE_ARRAY,CP_UTF8);}
   string Get()   {return cMessage;}
};
//-----------------------------------------------------------------
int CStringMessage::CreateBytesMessage(char &mArray[]){
   ArrayResize(mArray,sizeof(int)+cArraySize.value);
   int dataSize=ArrayCopy(mArray,cArraySize.array)+ArrayCopy(mArray,cArray,sizeof(int));
   return dataSize;}
///////////////////////////////////////////////////////////////////////////////////////////////////
#define C_LIST CList<IBytesMessage>

class CMessageList:protected C_LIST
{
   int            cBytesSize;
public:
                  CMessageList():C_LIST(),cBytesSize(0){}
   int            GetBytesSize() {return cBytesSize;}
   bool           _PushBack(IBytesMessage* mMessage);
   bool           _PushFirst(IBytesMessage* mMessage);
   bool           _PushBack(CMessageList* mList,bool mIsDelete=false);
   bool           _Push(IBytesMessage* mMessage,int mPos);
   bool           _IsEmpty() {return IsEmpty();}
   int            _GetCount() {return GetSize();}
   IBytesMessage* _Begine() {return Begine();}
   IBytesMessage* _Next() {return Next();}
   IBytesMessage* _Move() {if (It()!=NULL) cBytesSize-=It().GetBytesSize(); return Move();}
};
//------------------------------------------------------------
bool CMessageList::_PushBack(IBytesMessage* mMessage){
   cBytesSize+=mMessage.GetBytesSize();
   return PushBack(mMessage)==mMessage;}
//-------------------------------------------------------------
bool CMessageList::_PushFirst(IBytesMessage* mMessage){
   cBytesSize+=mMessage.GetBytesSize();
   return PushFirst(mMessage)==mMessage;}
//------------------------------------------------------------
bool CMessageList::_Push(IBytesMessage* mMessage,int mPos){
   cBytesSize+=mMessage.GetBytesSize();
   return Push(mMessage,mPos)==mMessage;}
//------------------------------------------------------------
bool CMessageList::_PushBack(CMessageList* mList,bool mIsDelete=false){
   for (mList._Begine();!mList.IsEmpty();)
      if (!_PushBack(mList._Move())) {if (mIsDelete) delete mList; return false;}
   if (mIsDelete) delete mList;
   return true;}

#undef C_LIST

#endif