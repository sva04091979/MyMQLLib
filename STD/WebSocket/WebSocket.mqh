#ifdef __MQL5__

#include "..\Define\StdDefine.mqh"

#ifndef _STD_WEB_SOCKET_
#define _STD_WEB_SOCKET_

#define _tWS STD_WebSocket

class _tWS{
   int cHndl;
public:
   _tWS();
   _tWS(const string server,uint port,uint timeout);
   ~_tWS();
   bool IsValid() const {return cHndl!=INVALID_HANDLE;}
   bool IsConnected() const {return IsValid()&&SocketIsConnected(cHndl);}
   bool Create();
   bool Close();
   bool Connect(const string server,uint port,uint timeout);
   bool Send(string text);
   bool HasData() {return DataSize()>1;}
   uint DataSize() {return SocketIsReadable(cHndl);}
   string Read();
};
//----------------------------------------------------------------
_tWS::_tWS(){
   cHndl=SocketCreate(SOCKET_DEFAULT);
}
//----------------------------------------------------------------
_tWS::_tWS(const string server,uint port,uint timeout){
   cHndl=SocketCreate(SOCKET_DEFAULT);
   if (IsValid())
      Connect(server,port,timeout);
}
//---------------------------------------------------------------
_tWS::~_tWS(){
   Close();
};
//---------------------------------------------------------------
bool _tWS::Create(){
   if (!IsValid()){
      cHndl=SocketCreate(SOCKET_DEFAULT);
      return cHndl!=INVALID_HANDLE;
   }
   else
      return false;
}
//-------------------------------------------------------------------
bool _tWS::Close(){
   bool res=true;
   if (IsValid()){
      res=SocketClose(cHndl);
      if (res)
         cHndl=INVALID_HANDLE;
   }
   return res;
}
//-------------------------------------------------------------------
bool _tWS::Connect(const string server,uint port,uint timeout){
   return SocketConnect(cHndl,server,port,timeout);
}
//-------------------------------------------------------------------
bool _tWS::Send(string text){
   uchar buffer[];
   StringToCharArray(text,buffer,0,WHOLE_ARRAY,CP_UTF8);
   int res=SocketSend(cHndl,buffer,ArraySize(buffer));
   Print(res);
   return res!=-1;
}
//--------------------------------------------------------------------
string _tWS::Read(){
   string ret="";
//   Print("++++++++++++++++++++");
   while(DataSize()>1){
//   Print("+");
//      Print(HasData());
      uchar buffer[4048];
      SocketRead(cHndl,buffer,MathMin(DataSize(),4048),10000);
      ret+=CharArrayToString(buffer,0,WHOLE_ARRAY,CP_UTF8);
   }
   return ret;
}

#endif

#endif //__MQL5__