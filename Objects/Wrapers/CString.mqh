#ifndef _C_STRING_
#define _C_STRING_

#include "..\Array\CList.mqh"

class CString
{
   string      cText;
public:
               CString():cText(NULL){}
               CString(string mText):cText(mText){}
   string      Get() {return cText;}
   string      Substr(int mPos,int mLen=0)  {return StringSubstr(cText,mPos,mLen);}
   string      GetSubstr(int mStartPos,int mEndPos)   {return Substr(mStartPos,mEndPos-mStartPos);}
   CList<CString>* Split(ushort mSep);
   int         Split(ushort mSep,string &mData[])   {return StringSplit(cText,mSep,mData);}
   int         Len() {return StringLen(cText);}
   int         Find(string mText,int mStartPos=0) {return StringFind(cText,mText,mStartPos);}
   int         Replace(string mFind,string mReplacement) {return StringReplace(cText,mFind,mReplacement);}
   bool        IsEmpty()   {return cText==NULL;}
   void        Set(string mText) {cText=mText;}
   void operator =(string mText) {cText=mText;}
   void operator =(CString &mString) {cText=mString.Get();}
   void operator +=(string mText) {cText+=mText;}
   string operator [](int mPos)  {return StringSubstr(cText,mPos,1);}
};
//-------------------------------------------------------------------------------------------
CList<CString>* CString::Split(ushort mSep){
   CList<CString>* list=new CList<CString>;
   string data[];
   int size=StringSplit(cText,mSep,data);
   for (int i=0;i<size;list.PushBack(new CString(data[i++])));
   if (!list.IsEmpty()) return list;
   delete list;
   return NULL;}
////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
bool _StringToCharArray(string fText,char &fArray[],int fStart=0,int fCount=WHOLE_ARRAY,uint fCodePage=CP_ACP){
   return StringToCharArray(fText,fArray,fStart,fCount,fCodePage)==StringLen(fText)+1;
}

#endif