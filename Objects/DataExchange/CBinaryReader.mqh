#ifndef _C_BINARY_READER_
#define _C_BINARY_READER_

class CBinaryReader{
   uchar    str[];
   int      cSize;
   int      cMaxSize;
   int      cPos;
public:
   CBinaryReader(uchar &array[],int count):cSize(ArrayCopy(str,array,0,0,count)),cPos(0){cMaxSize=cSize;}
   int      Pos() {return cPos;}
   void     Seek(int mPos) {cPos=mPos;}
   bool     IsEnd(int size=0) {return cPos+size>=cSize;}
   int      GetArray(char &arr[],int count) {int res=ArrayCopy(arr,str,0,cPos,count); cPos+=count; return res;}
   template<typename T>
   T        Get(){
      union UN{
         T     val;
         uchar arr[sizeof(T)];
      } value;
      for (int i=0;i<sizeof(T);value.arr[i++]=str[cPos++]);
      return value.val;}
};
//----------------------------------------------------------------


#endif