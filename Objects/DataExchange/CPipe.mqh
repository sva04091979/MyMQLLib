#ifndef _C_PIPE_
#define _C_PIPE_

#include <MyMQLLib\Objects\CFlag.mqh>

#define _FLAG_PIPE_OK 0x1
#define _FLAG_PIPE_CONNECT 0x2

#ifndef _PIPE_CHECK_MESS
   #define PIPE_CHECK_MESS 0xff,0xff,0xff,0xff
#endif

class CPipe{
   CFlag       cFlag;
   uchar       cCheck[];
   string      cName;
   ulong       cTimer;
   int         cHndl;
   int         cOpenFlag;
   int         cLastError;
   int         cCheckSize;
public:
   CPipe(string mName,int flag);
   int   LastError() {return cLastError;}
   bool  IsOpen()  {return cHndl!=INVALID_HANDLE;}
   bool  OpenPipe();
   bool  IsConnect() {return cFlag.Check(_FLAG_PIPE_CONNECT);}
   bool  CheckConnect();
   void  Close()  {FileClose(cHndl); cHndl=INVALID_HANDLE; cFlag-=(_FLAG_PIPE_OK|_FLAG_PIPE_CONNECT);}
   uint  Read(uchar &arr[],bool isBlockMode);
   uint  Write(uchar &arr[],int mSize);
private:
   bool  _Check() {return cHndl!=INVALID_HANDLE||OpenPipe();}
   void  CheckChanel();
   void  ProcessError(string mFunc);
   void  ResetError()   {ResetLastError(); cLastError=0;}
};
//-------------------------------------------------------
CPipe::CPipe(string mName,int mFlag):
   cName(mName),
   cTimer(0),
   cOpenFlag(mFlag){
   uchar temp[]={PIPE_CHECK_MESS};
   cCheckSize=ArrayCopy(cCheck,temp);
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
   if (!_Check()) return false;
   ResetError();
   uint size=FileWriteArray(cHndl,cCheck);
   ProcessError(__FUNCTION__);
   if (_LastError!=0){
      if (!cFlag.Check(_FLAG_PIPE_CONNECT)) CheckChanel();}
   else cFlag+=_FLAG_PIPE_CONNECT;
   return !_LastError;}
//-------------------------------------------------------
uint CPipe::Read(uchar &arr[],bool isBlockMode){
   if (!_Check()) return 0;
   ResetError();
   uint size=0;
   if (isBlockMode||FileSize(cHndl)>0)
      size=FileReadArray(cHndl,arr);
   ProcessError(__FUNCTION__);
   return size;}
//-------------------------------------------------------
uint CPipe::Write(uchar &arr[],int mSize){
   if (!_Check()) return 0;
   ResetError();
   uint size=FileWriteArray(cHndl,arr,0,mSize);
   ProcessError(__FUNCTION__);
   return size;}
//------------------------------------------------------
void CPipe::ProcessError(string mFunc){
   if (!_LastError) return;
   cLastError=_LastError;
   switch(_LastError){
      #ifdef __MQL5__
         case ERR_CANNOT_OPEN_FILE:
      #else
         case ERR_FILE_CANNOT_OPEN:
      #endif
         cFlag-=(_FLAG_PIPE_OK|_FLAG_PIPE_CONNECT);
         break;
      #ifdef __MQL5__
         case ERR_FILE_WRITEERROR:
      #else
         case ERR_FILE_WRITE_ERROR:
      #endif
         cFlag-=_FLAG_PIPE_CONNECT;
         break;
      default:
         break;}
   #ifdef _DEBUG
      Print("Error: ",_LastError," in ",mFunc);
   #endif
}
//------------------------------------------------------
void CPipe::CheckChanel(){
   Close();
   OpenPipe();}

#undef _FLAG_PIPE_OK
#undef _FLAG_PIPE_CONNECT

#endif