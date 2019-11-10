#ifndef _CODE_FUNCTIONS_
#define _CODE_FUNCTIONS_

//---Base 64-----------------------------------------------------------
string EncodeBase64(string fData){
   uchar data[],key[],result[];
   return !StringToCharArray(fData,data)              ||
          !CryptEncode(CRYPT_BASE64,data,key,result)  ?NULL:CharArrayToString(result);}

string DecodeBase64(string fData){
   uchar data[],key[],result[];
   return !StringToCharArray(fData,data)              ||
          !CryptDecode(CRYPT_BASE64,data,key,result)  ?NULL:CharArrayToString(result);}
//-----------------------------------------------------------------------

#endif