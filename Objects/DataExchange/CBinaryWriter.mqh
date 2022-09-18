#ifndef _C_BINARY_WRITER_
#define _C_BINARY_WRITER_

class CBinaryWriter{
   uchar str[];
   int   cMaxSize;
   int   cSize;
   int   cPos;
public:
   CBinaryWriter(int mStartSize):cMaxSize(ArrayResize(str,mStartSize)),cSize(0),cPos(0){}
   int      Pos() {return cPos;}
   void     Seek(int mPos) {cPos=mPos;}
   int      Size()   {return cSize;}
   int      Copy(uchar &arr[]) {return ArrayCopy(arr,str,0,0,cSize);}
   void     SetArray(uchar &arr[]) {cPos+=ArrayCopy(str,arr,cPos); if (cPos>cSize) cSize=cPos;}
   template<typename T>
   void     Set(T mVal){
      union UN{
         T     val;
         uchar arr[sizeof(T)];
      } value;
      value.val=mVal;
      for (int i=0;i<sizeof(T);str[cPos++]=value.arr[i++]);
      if (cPos>cSize) cSize=cPos;}
};

#endif