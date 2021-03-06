#ifndef _WIN_API_HEADER_
#define _WIN_API_HEADER_

#include "WinApiConst.mqh"
#include "WinApiErrorCode.mqh"
#include "WinApiTypes.mqh"

#import "kernel32.dll"
   BOOL CloseHandle(HANDLE fHndl);
   DWORD GetLastError();
#import

#import "Ntdll.dll"
   long memcpy(   char  &Destination[],
                  const VOID_PTR Source,
                  uint Length);
   //------------------------------------------------------------------------------
   long memcpy(   VOID_PTR  Destination,
                  const char &Source[],
                  uint Length);
#import

#endif