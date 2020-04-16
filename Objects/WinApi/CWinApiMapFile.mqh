#ifndef _C_WIN_API_MAP_FILE_
#define _C_WIN_API_MAP_FILE_

#include <MyMQLLib\Define\MQLDefine.mqh>
#include "..\..\Define\WinApiDefine\WinApiHeader.mqh"
#include "..\Sinchro\WinApi\CWinApiMutex.mqh"
#include "..\DataExchange\CBytesMessage.mqh"
#include "..\Array\CList.mqh"

#define MAP_FILE_OPEN 0x1
#define MAP_FILE_ALLREADY_EXIST 0x2

enum ENUM_MAP_OPEN{
   MAP_CREATE,
   MAP_CREATE_NO_EXIST,
   MAP_OPEN_ONLY
};

#import "kernel32.dll"
   HANDLE CreateFileMappingW( HANDLE                  hFile,
                              int                     lpFileMappingAttributes,
                              DWORD                   flProtect,
                              DWORD                   dwMaximumSizeHigh,
                              DWORD                   dwMaximumSizeLow,
                              LPCWSTR                 lpName);
   //------------------------------------------------------------------------------                           
   HANDLE OpenFileMappingW(   DWORD   dwDesiredAccess,
                              bool    bInheritHandle,
                              LPCWSTR lpName);
   //------------------------------------------------------------------------------
   VOID_PTR MapViewOfFile(  HANDLE hFileMappingObject,
                        DWORD  dwDesiredAccess,
                        DWORD  dwFileOffsetHigh,
                        DWORD  dwFileOffsetLow,
                        SIZE_T dwNumberOfBytesToMap);
#import

class CWinApiMapFile
  {
   string            cName;
   HANDLE            cHndl;
   int               cFlag;
   DWORD             cSize;
   VOID_PTR          cPtr;
   DWORD             cLastError;
public:
                     CWinApiMapFile(LPCWSTR mName,DWORD mSize,ENUM_MAP_OPEN mOpenFlag):
                        cName(mName),cFlag(0),cSize(mSize),cLastError(0)
                        {Start(mName,mSize,mOpenFlag);}
                    ~CWinApiMapFile(void) {if (cHndl!=INVALID_HANDLE) CloseHandle(cHndl);}
   bool              Start(LPCWSTR mName,DWORD mSize,ENUM_MAP_OPEN mOpenFlag);
   bool              GetMessageBytes(char &mMessage[],int fSize,uint mShift=0);
   template<typename T>
   CBytesMessage<T>* GetMessage(uint &mPos);
   template<typename T>
   CBytesMessage<T>* GetMessage(uint &mPos,CWinApiMutex* mMutex);
   bool              SendMessage(IBytesMessage &mMessage,CWinApiMutex &mMutex,uint mShift=0);
   bool              SendMessage(IBytesMessage &mMessage,uint mShift=0);
   bool              SendMessageList(CMessageList &mMessage,CWinApiMutex &mMutex,uint mShift=0);
   bool              SendMessageList(CMessageList &mMessage,uint mShift=0);
   bool              MoveMessageList(CMessageList &mMessage,CWinApiMutex &mMutex,uint mShift=0);
   bool              MoveMessageList(CMessageList &mMessage,uint mShift=0);
  };
//----------------------------------------------------------
bool CWinApiMapFile::Start(LPCWSTR mName,DWORD mSize,ENUM_MAP_OPEN mOpenFlag){
   if (bool(cFlag&MAP_FILE_OPEN)) return true;
   if ((cHndl=mOpenFlag==MAP_OPEN_ONLY?OpenFileMappingW(PAGE_READWRITE,false,mName):
                                      CreateFileMappingW(NULL,NULL,PAGE_READWRITE,0,mSize,mName))==INVALID_HANDLE) return false;
   if ((cLastError=kernel32::GetLastError())==ERROR_ALREADY_EXISTS){
      cFlag|=MAP_FILE_ALLREADY_EXIST;
      if (mOpenFlag==MAP_CREATE_NO_EXIST){
         if (CloseHandle(cHndl)) cHndl=INVALID_HANDLE;
         return false;}}
   cFlag|=MAP_FILE_OPEN;
   cPtr=MapViewOfFile(cHndl,FILE_MAP_ALL_ACCESS,0,0,cSize);
   return true;}
//-------------------------------------------------------------
bool CWinApiMapFile::GetMessageBytes(char &mMessage[],int fSize,uint mShift=0){
   if (!(cFlag&MAP_FILE_OPEN)) return false;
   if (ArrayResize(mMessage,fSize)!=fSize) return false;
   CopyMemory(mMessage,cPtr+mShift,fSize);
   return true;}
//-----------------------------------------------------------------
template<typename T>
CBytesMessage<T>* CWinApiMapFile::GetMessage(uint &mPos){
   CBytesMessage<T>* mess=new CBytesMessage<T>;
   uint pos=mPos;
   mPos+=mess.GetBytesSize();
   char array[];
   if (!GetMessageBytes(array,mess.GetBytesSize(),pos)) return NULL;
   mess.SetMessage(array);
   return mess;}
//-----------------------------------------------------------------
template<typename T>
CBytesMessage<T>* CWinApiMapFile::GetMessage(uint &mPos,CWinApiMutex* mMutex){
   mMutex.Lock();
   CBytesMessage<T>* mess=GetMessage<T>(mPos);
   mMutex.UnLock();
   return mess;}
//---------------------------------------------------------------
bool CWinApiMapFile::SendMessage(IBytesMessage &mMessage,CWinApiMutex &mMutex,uint mShift=0){
   if (!(cFlag&MAP_FILE_OPEN)) return false;
   char array[];
   int size=mMessage.CreateBytesMessage(array); 
   mMutex.Lock();
   CopyMemory(cPtr+mShift,array,size);
   mMutex.UnLock();
   return true;}
//---------------------------------------------------------------
bool CWinApiMapFile::SendMessage(IBytesMessage &mMessage,uint mShift=0){
   if (!(cFlag&MAP_FILE_OPEN)) return false;
   char array[];
   int size=mMessage.CreateBytesMessage(array); 
   CopyMemory(cPtr+mShift,array,size);
   return true;}
//------------------------------------------------------------------------
bool CWinApiMapFile::SendMessageList(CMessageList &mMessage,CWinApiMutex &mMutex,uint mShift=0){
   int pos=0;
   int i=0;
   mMutex.Lock();
   for (IBytesMessage* message=mMessage._Begine();message!=NULL;message=mMessage._Next()){
      if (!SendMessage(message,pos)) {mMutex.UnLock(); return false;}
      else pos+=message.GetBytesSize();}
   mMutex.UnLock();
   return true;}
//------------------------------------------------------------------------
bool CWinApiMapFile::SendMessageList(CMessageList &mMessage,uint mShift=0){
   int pos=0;
   int i=0;
   for (IBytesMessage* message=mMessage._Begine();message!=NULL;message=mMessage._Next()){
      if (!SendMessage(message,pos)) return false;
      else pos+=message.GetBytesSize();}
   return true;}
//------------------------------------------------------------------------
bool CWinApiMapFile::MoveMessageList(CMessageList &mMessage,CWinApiMutex &mMutex,uint mShift=0){
   int pos=0;
   int i=0;
   mMessage._Begine();
   IBytesMessage* message=NULL;
   mMutex.Lock();
   while((message=mMessage._Move())!=NULL){
      if (!SendMessage(message,pos)) {mMessage._PushFirst(message); mMutex.UnLock(); return false;}
      else pos+=message.GetBytesSize();
      DELETE(message);}
   mMutex.UnLock();
   return true;}
//------------------------------------------------------------------------
bool CWinApiMapFile::MoveMessageList(CMessageList &mMessage,uint mShift=0){
   int pos=0;
   int i=0;
   mMessage._Begine();
   IBytesMessage* message=NULL;
   while((message=mMessage._Move())!=NULL){
      if (!SendMessage(message,pos)) {mMessage._PushFirst(message); return false;}
      else pos+=message.GetBytesSize();
      DELETE(message);}
   return true;}

#endif