#ifndef _C_PIPE_
#define _C_PIPE_

#include <MyMQLLib\Objects\CFlag.mqh>

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
   uint  Read(uchar &arr[]);
   uint  Write(uchar &arr[],int mSize);
private:
   void  ProcessError(string mFunc);
};
//-------------------------------------------------------
CPipe::CPipe(string mName,int mFlag):
   cName(mName),
   cOpenFlag(mFlag){
   ResetLastError();
   if (INVALID_HANDLE!=(cHndl=FileOpen(cName,mFlag))) cFlag+=_FLAG_PIPE_OK;
   ProcessError(__FUNCTION__);}
//-------------------------------------------------------
bool CPipe::OpenPipe(){
   if (cHndl!=INVALID_HANDLE) return true;
   ResetLastError();
   if (INVALID_HANDLE!=(cHndl=FileOpen(cName,cOpenFlag))) cFlag+=_FLAG_PIPE_OK;
   ProcessError(__FUNCTION__);
   return cHndl!=INVALID_HANDLE;}
//-------------------------------------------------------
bool CPipe::CheckConnect(){
   if (cHndl==INVALID_HANDLE&&!OpenPipe()) return false;
   ResetLastError();
   ulong tmp=FileSize(cHndl);
   if (_LastError!=0){
      cLastError=_LastError;
      ProcessError(__FUNCTION__);}
   return !_LastError;}
//-------------------------------------------------------
uint CPipe::Read(uchar &arr[]){
   ResetLastError();
   uint size=FileReadArray(cHndl,arr);
   ProcessError(__FUNCTION__);
   return size;}
//-------------------------------------------------------
uint CPipe::Write(uchar &arr[],int mSize){
   ResetLastError();
   uint size=FileWriteArray(cHndl,arr,0,mSize);
   FileFlush(cHndl);
   ProcessError(__FUNCTION__);
   return size;}
//------------------------------------------------------
void CPipe::ProcessError(string mFunc){
   if (!_LastError) return;
   cLastError=_LastError;
   #ifdef _DEBUG
      Print("Error: ",_LastError," in ",mFunc);
   #endif
}

#undef _FLAG_PIPE_OK
#undef _FLAG_PIPE_CONNECT

#endif