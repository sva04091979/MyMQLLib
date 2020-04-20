#ifndef _C_PIPE_
#define _C_PIPE_

#include <MyMQLLib\Objects\CFlag.mqh>

#ifdef _DEBUG

#else

#endif

#define _FLAG_PIPE_OK 0x1
#define _FLAG_PIPE_CONNECT 0x2


class CPipe{
   CFlag       cFlag;
   string      cName;
   int         cHndl;
   int         cOpenFlag;
   int         cLastError;
public:
   CPipe(string mName,int flag);
   int   LastError() {return cLastError;}
   bool  IsOpen()  {return cHndl!=INVALID_HANDLE;}
   bool  OpenPipe();
   bool  IsConnect() {return cFlag.Check(_FLAG_PIPE_CONNECT);}
   bool  CheckConnect();
   void  Close()  {FileClose(cHndl);}
   uint  Read(uchar &arr[],bool isBlockMode);
   uint  Write(uchar &arr[],int mSize);
private:
   void  ProcessError(string mFunc);
   void  ResetError()   {ResetLastError(); cLastError=0;}
};
//-------------------------------------------------------
CPipe::CPipe(string mName,int mFlag):
   cName(mName),
   cOpenFlag(mFlag){
   ResetError();
   if (INVALID_HANDLE!=(cHndl=FileOpen(cName,mFlag))) cFlag+=_FLAG_PIPE_OK;
   ProcessError(__FUNCTION__);}
//-------------------------------------------------------
bool CPipe::OpenPipe(){
   if (cHndl!=INVALID_HANDLE) return true;
   ResetError();
   if (INVALID_HANDLE!=(cHndl=FileOpen(cName,cOpenFlag))) cFlag+=_FLAG_PIPE_OK;
   ProcessError(__FUNCTION__);
   return cHndl!=INVALID_HANDLE;}
//-------------------------------------------------------
bool CPipe::CheckConnect(){
   if (cHndl==INVALID_HANDLE&&!OpenPipe()) return false;
   ResetError();
   ulong tmp=FileSize(cHndl);
   if (_LastError!=0){
      cLastError=_LastError;
      ProcessError(__FUNCTION__);}
   return !_LastError;}
//-------------------------------------------------------
uint CPipe::Read(uchar &arr[],bool isBlockMode){
   ResetError();
   uint size=0;
   if (isBlockMode||FileSize(cHndl)>0)
      size=FileReadArray(cHndl,arr);
   ProcessError(__FUNCTION__);
   return size;}
//-------------------------------------------------------
uint CPipe::Write(uchar &arr[],int mSize){
   ResetError();
   uint size=FileWriteArray(cHndl,arr,0,mSize);
   ProcessError(__FUNCTION__);
   return size;}
//------------------------------------------------------
void CPipe::ProcessError(string mFunc){
   if (!_LastError) return;
   cLastError=_LastError;
   switch(_LastError){
      case ERR_CANNOT_OPEN_FILE:
         cFlag-=(_FLAG_PIPE_OK|_FLAG_PIPE_CONNECT);
         break;
      case ERR_WRONG_FILEHANDLE:
         cFlag-=_FLAG_PIPE_CONNECT;
         break;}
   #ifdef _DEBUG
      Print("Error: ",_LastError," in ",mFunc);
   #endif
}

#undef _FLAG_PIPE_OK
#undef _FLAG_PIPE_CONNECT

#endif