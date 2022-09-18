#ifndef _C_WIN_API_MUTEX_
#define _C_WIN_API_MUTEX_

#include "..\..\..\Define\WinApiDefine\WinApiHeader.mqh"

#define MUTEX_CREATE_ERROR 0x1
#define MUTEX_ALLREADY_EXIST 0x2

#import "kernel32.dll"
   int CreateMutexW(int lpMutexAttributes,bool fIsLock,LPWSTR fName);
   int OpenMutexW(int lpMutexAttributes,bool fIsLock,LPWSTR fName);
   uint WaitForSingleObject(HANDLE fHandle,DWORD fTimeOut);
   bool ReleaseMutex(HANDLE fHndl);
#import

enum ENUM_MUTEX_CREATE_TYPE{CREATE_MUTEX,CREATE_MUTEX_NO_EXIST,OPEN_MUTEX};

class CWinApiMutex
  {
   string            cName;
   HANDLE            cHndl;
   uint              cLockCount;
   int               cFlag;
   DWORD             cLastError;
public:
                     CWinApiMutex(string mName,ENUM_MUTEX_CREATE_TYPE mConnectType,bool mIsLock=false);
                    ~CWinApiMutex(void)   {if (cHndl!=INVALID_HANDLE) CloseHandle(cHndl);}
   bool              Lock(uint mTimeOut=INFINITE);
   bool              UnLock();
   bool              Check()  {return !(cFlag&MUTEX_CREATE_ERROR);}
   DWORD             GetError()  {return cLastError;}
  };
//-----------------------------------------------------------------------
void CWinApiMutex::CWinApiMutex(string mName,ENUM_MUTEX_CREATE_TYPE mConnectType,bool mIsLock=false):
   cName(mName),
   cHndl(mConnectType==OPEN_MUTEX?OpenMutexW(NULL,mIsLock,mName):CreateMutexW(NULL,mIsLock,mName)),
   cFlag(0),
   cLastError(0){
   cLastError=kernel32::GetLastError();
   if (cHndl==INVALID_HANDLE) {cFlag|=MUTEX_CREATE_ERROR; return;}
   if (cLastError==ERROR_ALREADY_EXISTS){
      cFlag|=MUTEX_ALLREADY_EXIST;
      if (mConnectType==CREATE_MUTEX_NO_EXIST){
         cFlag|=MUTEX_CREATE_ERROR;
         if (CloseHandle(cHndl)) cHndl=INVALID_HANDLE;
         return;}}
   cLockCount=!mIsLock?0:1;}
//--------------------------------------------------------------------------
bool CWinApiMutex::Lock(uint mTimeOut=INFINITE){
   if (bool(cFlag&MUTEX_CREATE_ERROR)){
      if (cHndl!=INVALID_HANDLE&&CloseHandle(cHndl)) cHndl=INVALID_HANDLE;
      return false;}
   if (WaitForSingleObject(cHndl,mTimeOut)==0) {++cLockCount; return true;}
   else return false;}
//--------------------------------------------------------------------------
bool CWinApiMutex::UnLock(void){
   bool res=ReleaseMutex(cHndl);
   cLastError=kernel32::GetLastError();
   if (res) {--cLockCount; return true;}
   else return false;}

#endif