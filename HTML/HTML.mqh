#include "..\Define\StdDefine.mqh"

#ifndef _STD_HTML_
#define _STD_HTML_

#define _tHTML STD_HTML

class STD_HTML{
   string cURL;
public:
   bool Send(string method,string url,string header,uchar& request[],uchar& result[]);
};
//--------------------------------------------------------------
bool _tHTML::Send(string method,string url,string header,uchar& request[],uchar& result[]){
   string resultHeader;
   int HTTPResult=WebRequest(method,url,header,60000,request,result,resultHeader);
   bool ret=HTTPResult!=-1;
   PrintFormat("Answer: %i",HTTPResult);
   if (!ret)
      PrintFormat("Error: %i",GetLastError());
   PrintFormat ("Res header: %s",resultHeader);
   return ret;
}

#endif