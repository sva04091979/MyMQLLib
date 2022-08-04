#include "..\Define\StdDefine.mqh"

#ifndef _STD_HTML_
#define _STD_HTML_

#define _tHTML STD_HTML

class STD_HTML{
   string cURL;
public:
   int Send(string method,string url,string header,uchar& request[],uchar& result[]);
};
//--------------------------------------------------------------
int _tHTML::Send(string method,string url,string header,uchar& request[],uchar& result[]){
   string resultHeader;
   int HTTPResult=WebRequest(method,url,header,60000,request,result,resultHeader);
   bool res=HTTPResult!=-1;
   if (HTTPResult!=200){
      PrintFormat("Head: %s",header);
      PrintFormat("Send: %s",CharArrayToString(request));
      PrintFormat("Answer: %i",HTTPResult);
      PrintFormat ("Res header: %s",resultHeader);
   }
   if (!res)
      PrintFormat("Error: %i",GetLastError());
   return HTTPResult;
}

#endif