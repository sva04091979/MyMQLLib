#ifndef _STD_FORWARD_LIST_
#define _STD_FORWARD_LIST_

#include "Container.mqh"
#include "ContainerNode.mqh"
#include <STD\Iterator\IForwardIterator.mqh>

#define _tForwardList __std(CForwardList)
#define _tForwardIterator __std(SForwardIterator)

#define _tdeclForwardList __decl(CForwardList)
#define _tdeclForwardIterator __decl(SForwardIterator)
#define _tdeclForwardNode __decl(CForwardNode)
#define _tdeclForwardNodeEnd __decl(CForwardNodeEnd)

NAMESPACE(STD)

template<typename T>
class _tdeclForwardNode:public _tdecl_ForwardNode<T,_tdeclForwardNode<T>>{
protected:
  ~_tdeclForwardNode(){}
public:
   _tdeclForwardNode():_tdecl_ForwardNode<T,_tdeclForwardNode<T>>(){}
   _tdeclForwardNode(const T &mObj,_tdeclForwardNode<T>* mNext):_tdecl_ForwardNode<T,_tdeclForwardNode<T>>(mObj,mNext){}
   _tdeclForwardNode(const _tdeclForwardNode<T> &mOther):_tdecl_ForwardNode<T,_tdeclForwardNode<T>>(mOther){}
};

template<typename T>
class _tdeclForwardNodeEnd:public _tdeclForwardNode<T>{
public:
   _tdeclForwardNodeEnd():_tdeclForwardNode<T>(){}
   bool IsEnd() override const {return true;}
   bool Equal(const _tdeclForwardNode<T> &mOther) override {return mOther.IsEnd();}
};

template<typename T>
struct _tdeclForwardIterator:public _tdecl_ForwardIterator<_tdeclForwardList<T>,_tdeclForwardIterator<T>,_tdeclForwardNode<T>,T>{
   _tdeclForwardIterator(_tdeclForwardNode<T>* mNode,_tdeclForwardList<T>* mContainer):
      _tdecl_ForwardIterator<_tdeclForwardList<T>,_tdeclForwardIterator<T>,_tdeclForwardNode<T>,T>(mNode,mContainer){}
   _tdeclForwardIterator(const _tdeclForwardIterator<T> &mOther):
      _tdecl_ForwardIterator<_tdeclForwardList<T>,_tdeclForwardIterator<T>,_tdeclForwardNode<T>,T>(mOther){}
};

template<typename T>
class _tdeclForwardList:public _tdeclContainer{
protected:
   _tdecl_ForwardProxy<_tdeclForwardList<T>,_tdeclForwardNode<T>,T> cEnd;
   _tdeclForwardNode<T>* cFront;
public:
   _tdeclForwardList():cEnd(&this,EndNode()),cFront(EndNode()){}
   _tdeclForwardList(T &mArr[]);
   _tdeclForwardList(_tdeclForwardList<T> &mOther);
  ~_tdeclForwardList() {Clear();}
   _tdeclForwardIterator<T> Begin() {_tdeclForwardIterator<T> ret(cFront,&this); return ret;}
   const _tdecl_ForwardProxy<_tdeclForwardList<T>,_tdeclForwardNode<T>,T>* End() const {return &cEnd;}
   _tdecl_ForwardProxy<_tdeclForwardList<T>,_tdeclForwardNode<T>,T> EraceAfter(const _tdeclForwardIterator<T> &mIt) {return EraceAfter(mIt.Wrape());}
   _tdecl_ForwardProxy<_tdeclForwardList<T>,_tdeclForwardNode<T>,T> EraceAfter(const _tdecl_ForwardProxy<_tdeclForwardList<T>,_tdeclForwardNode<T>,T> &mWrape);
   _tdecl_ForwardProxy<_tdeclForwardList<T>,_tdeclForwardNode<T>,T> Insert(const _tdeclForwardIterator<T> &mIt,const T &mVal) {return Insert(mIt.Wrape(),mVal);}
   _tdecl_ForwardProxy<_tdeclForwardList<T>,_tdeclForwardNode<T>,T> Insert(const _tdecl_ForwardProxy<_tdeclForwardList<T>,_tdeclForwardNode<T>,T> &mWrape,const T &mVal);
   T Front() const {return _(cFront);}
   void PushFront(T &obj);
   T PopFront();
   void Swap(_tdeclForwardList<T> &mOther);
   void Clear();
   void ClearAfter(const _tdeclForwardIterator<T> &mIt) {ClearAfter(mIt.Wrape());}
   void ClearAfter(const _tdecl_ForwardProxy<_tdeclForwardList<T>,_tdeclForwardNode<T>,T> &mWrape);
protected:
   static _tdeclForwardNodeEnd<T>* EndNode(){
      static _tdeclForwardNodeEnd<T> instance;
      return &instance;
   }
};
//---------------------------------------------------------
template<typename T>
_tdeclForwardList::_tdeclForwardList(T &mArr[]):
   cEnd(&this,EndNode()),cFront(EndNode()){
   int count=ArraySize(mArr);
   if (!count) return;
   _tdeclForwardNode<T>* first=new _tdeclForwardNode<T>(mArr[0],NULL);
   _tdeclForwardNode<T>* node=first;
   for (int i=1;i<count;++i){
      node.Next(new _tdeclForwardNode<T>(mArr[i],NULL));
      node=node.Next();}
   node.Next(cFront);
   cFront=first;
   cSize=count;
}
//---------------------------------------------------------
template<typename T>
_tdeclForwardList::_tdeclForwardList(_tdeclForwardList<T> &mOther):
   cEnd(&this,EndNode()),cFront(EndNode()){
   if (mOther.IsEmpty()) return;
   cSize=mOther.Size();
   _tForwardIterator<T> it=mOther.Begin();
   _tdeclForwardNode<T>* first=_tdecl_ForwardProxy<_tdeclForwardList<T>,_tdeclForwardNode<T>,T>::NewNode(it.Wrape(),NULL);
   _tdeclForwardNode<T>* node=first;
   ++it;
   while(!it.IsEnd()){
      node.Next(_tdecl_ForwardProxy<_tdeclForwardList<T>,_tdeclForwardNode<T>,T>::NewNode(it.Wrape(),NULL));
      node=node.Next();
      ++it;}
   node.Next(cFront);
   cFront=first;
}
//---------------------------------------------------------
template<typename T>
void _tdeclForwardList::PushFront(T &obj){
   ++cSize;
   cFront=new _tdeclForwardNode<T>(obj,cFront);}
//----------------------------------------------------------
template<typename T>
T _tdeclForwardList::PopFront(){
   if (cFront.IsEnd()) return _(cFront.Next());
   else{
      --cSize;
      T ret=_(cFront);
      cFront=cFront.Free();
      return ret;}
}
//----------------------------------------------------------
template<typename T>
void _tdeclForwardList::Swap(_tdeclForwardList<T> &mOther){
   _tSizeT size=cSize;
   _tdeclForwardNode<T>* front=cFront;
   cSize=mOther.cSize;
   cFront=mOther.cFront;
   mOther.cSize=size;
   mOther.cFront=front;
}
//--------------------------------------------------------------
template<typename T>
_tdecl_ForwardProxy<_tdeclForwardList<T>,_tdeclForwardNode<T>,T> _tdeclForwardList::EraceAfter(const _tdecl_ForwardProxy<_tdeclForwardList<T>,_tdeclForwardNode<T>,T> &mWrape){
   if (!mWrape.CheckContainer(this)) {ABORT("Wrong container");}
   if (mWrape.IsEnd()||mWrape.IsLast()) return mWrape;
   else{
      --cSize;
      return mWrape.EraceNext();}
}
//--------------------------------------------------------------
template<typename T>
_tdecl_ForwardProxy<_tdeclForwardList<T>,_tdeclForwardNode<T>,T>
_tdeclForwardList::Insert(const _tdecl_ForwardProxy<_tdeclForwardList<T>,_tdeclForwardNode<T>,T> &mWrape,const T &mVal){
   if (!mWrape.CheckContainer(this)) {ABORT("Wrong container");}
   if (mWrape.IsEnd()) ABORT("This operation is not alloed whith end iterator");
   else{
      ++cSize;
      return mWrape.Insert(mVal);}
   return mWrape;
}
//-------------------------------------------------------------------------------
template<typename T>
void _tdeclForwardList::Clear(){
   cSize=0;
   while (!cFront.IsEnd()) cFront=cFront.Free();
}
//--------------------------------------------------------------
template<typename T>
void _tdeclForwardList::ClearAfter(const _tdecl_ForwardProxy<_tdeclForwardList<T>,_tdeclForwardNode<T>,T> &mWrape){
   if (!mWrape.CheckContainer(this)) {ABORT("Wrong container");}
   if (mWrape.IsEnd()||mWrape.IsLast()) return;
   else{
      --cSize;
      for(_tdecl_ForwardProxy<_tdeclForwardList<T>,_tdeclForwardNode<T>,T> wrape=mWrape.EraceNext();
          !wrape.IsEnd();
          wrape=mWrape.EraceNext()) --cSize;}
}
//--------------------------------------------------------------
template<typename T>
void _fdeclSwap(_tdeclForwardList<T> &fFirst,_tdeclForwardList<T> &fSecond){
   fFirst.Swap(fSecond);
}
//--------------------------------------------------------------
template<typename T>
void Free(_tdeclForwardList<T> &fList){
   while(!fList.IsEmpty()) delete fList.PopFront();
}

END_SPACE

struct SUnitTestForwardList{
   int a;
   SUnitTestForwardList(){}
   SUnitTestForwardList(int _a):a(_a){}
   SUnitTestForwardList(SUnitTestForwardList &mOther){this=mOther;}
   bool operator ==(SUnitTestForwardList &mOther) {return a==mOther.a;}
};
   
void UnitTestForwardList(void){
   int x[]={0,1,2,3,4,5,6,7,8,9};
   _tForwardList<int> _test(x);
   _tForwardList<int> test(_test);
   _tForwardIterator<int> it=test.Begin();
   ++it;
   it=test.Insert(++it,_rv(777));
   PrintFormat("Size=%u",test.Size());
   PrintFormat("It=%i",_(it));
   for (it=test.Begin();!it.IsEnd();++it)
      Print(_(it));
   _tForwardList<SUnitTestForwardList> test1();
   for (int i=0;i<ArraySize(x);++i){
      test1.PushFront(SUnitTestForwardList(i));
   }
   _tForwardIterator<SUnitTestForwardList> _it=test1.Begin();
   ++_it;
   _it=test1.Insert(++_it,SUnitTestForwardList(777));
   PrintFormat("Size=%u",test1.Size());
   PrintFormat("It=%i",_(_it).a);
   test1.EraceAfter(_it);
   for (_it=test1.Begin();!_it.IsEnd();++_it)
      Print(_(_it).a);
}

#endif