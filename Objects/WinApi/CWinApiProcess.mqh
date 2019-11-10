#ifndef _C_WIMN_API_PROCESS_
#define _C_WIMN_API_PROCESS_

#include "..\..\Define\WinApiDefine\WinApiHeader.mqh"

#import "MQLLib.dll"
   bool StartProcess(string fFileName, string fCommandLine, DWORD fFlag, LPPROCESS_INFORMATION fProcessInfo,DWORD &fError);
#import

#import "kernel32.dll"
   BOOL TerminateProcess(  HANDLE hProcess,
                           UINT uExitCode);

   BOOL GetExitCodeProcess(   HANDLE  hProcess,
                              LPDWORD lpExitCode);
   BOOL CloseHandle(HANDLE hObject);                         
#import

#define CREATE_BREAKAWAY_FROM_JOB         0x01000000
#define CREATE_DEFAULT_ERROR_MODE         0x04000000
#define CREATE_NEW_CONSOLE                0x00000010
#define CREATE_NEW_PROCESS_GROUP          0x00000200
#define CREATE_NO_WINDOW                  0x08000000
#define CREATE_PROTECTED_PROCESS          0x00040000
#define CREATE_PRESERVE_CODE_AUTHZ_LEVEL  0x02000000
#define CREATE_SECURE_PROCESS             0x00400000
#define CREATE_SEPARATE_WOW_VDM           0x00000800
#define CREATE_SHARED_WOW_VDM             0x00001000
#define CREATE_SUSPENDED                  0x00000004
#define CREATE_UNICODE_ENVIRONMENT        0x00000400
#define DEBUG_ONLY_THIS_PROCESS           0x00000002
#define DEBUG_PROCESS                     0x00000001
#define DETACHED_PROCESS                  0x00000008
#define EXTENDED_STARTUPINFO_PRESENT      0x00080000
#define INHERIT_PARENT_AFFINITY           0x00010000

#define STILL_ACTIVE 0x103

#define PROCESS_FLAG_CREATE               0x1
#define PROCESS_FLAG_FINISH               0x2
#define PROCESS_FLAG_CHECK_ERROR          0x4
#define PROCESS_FLAG_TERMINATE_IN_DESTRUCT   0x8

class CWinApiProcess{
   PROCESS_INFORMATION  cProcessInfo;
   int                  cFlag;
   DWORD                cExitCode;
   DWORD                cLastError;
public:
                        CWinApiProcess(LPCWSTR mFileName,LPWSTR mCommandLine,int mFlag=0);
                       ~CWinApiProcess();
   bool                 CheckProcess();
   DWORD                GetExitCode()  {return cExitCode;}
   int                  GetFlag()   {return cFlag;}
   DWORD                GetError()  {return cLastError;}
};
//---------------------------------------------------------
CWinApiProcess::CWinApiProcess(LPCWSTR mFileName,LPWSTR mCommandLine,int mFlag=0):
   cFlag(mFlag),cExitCode(STILL_ACTIVE){
   if (StartProcess(mFileName,mCommandLine,mFlag,cProcessInfo,cLastError)) cFlag|=PROCESS_FLAG_CREATE;}
//------------------------------------------------------------
CWinApiProcess::~CWinApiProcess(void){
   if (bool(cFlag&PROCESS_FLAG_CREATE)                   &&
       !(cFlag&PROCESS_FLAG_FINISH)                      &&
       bool(cFlag&PROCESS_FLAG_TERMINATE_IN_DESTRUCT))   TerminateProcess(cProcessInfo.hProcess,0);
   if (bool(cFlag&PROCESS_FLAG_CREATE)) CloseHandle(cProcessInfo.hProcess);}
//-----------------------------------------------------------
bool CWinApiProcess::CheckProcess(void){
   if (!(cFlag&PROCESS_FLAG_CREATE)||bool(cFlag&PROCESS_FLAG_FINISH)){
      cFlag&=~PROCESS_FLAG_CHECK_ERROR;
      return false;}
   if (GetExitCodeProcess(cProcessInfo.hProcess,cExitCode)) cFlag&=~PROCESS_FLAG_CHECK_ERROR;
   else{
      cFlag|=PROCESS_FLAG_CHECK_ERROR;
      return false;}
   if (cExitCode!=STILL_ACTIVE){
      cFlag|=PROCESS_FLAG_FINISH;
      return false;}
   else return true;}
            
#endif