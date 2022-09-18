#ifndef _C_WEB_SOCKET_
#define _C_WEB_SOCKET_

#include "..\..\Define\WinApiDefine\SocketDefine.mqh"

#import "kernel32.dll"
   DWORD GetLastError();
   HRESULT WebSocketCreateServerHandle(WEB_SOCKET_PROPERTY &pProperties[],
                                       ULONG ulPropertyCount,
                                       WEB_SOCKET_HANDLE &phWebSocket);
#import

#define C_WEB_SOCCET_FLAG_SERVER 0x1
#define C_WEB_SOCCET_FLAG_CLIENT 0x2

enum ENUM_SOCKET_CREATE_TYPE{
   SOCKET_CREATE_SERVER,
   SOCKET_CREATE_CLIENT
};

class CWebSocket
  {
   int               cFlag;
   WEB_SOCKET_HANDLE cHndl;
public:
                     CWebSocket(ENUM_SOCKET_CREATE_TYPE mCreateType);
  };
//-------------------------------------------------------------------------
CWebSocket::CWebSocket(ENUM_SOCKET_CREATE_TYPE mCreateType){
   if (mCreateType==SOCKET_CREATE_SERVER){
      cFlag|=C_WEB_SOCCET_FLAG_SERVER
      if (
   }   
   else{
      cFlag|=C_WEB_SOCCET_FLAG_CLIENT;
   }
   
}

#endif