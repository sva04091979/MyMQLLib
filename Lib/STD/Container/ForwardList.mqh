#ifndef _STD_FORWARD_LIST_
#define _STD_FORWARD_LIST_

#include "ContainerInterface\IContainer.mqh"
#include "ContainerNode\ForwardNode.mqh"
#include <STD\Iterator\ForwardIterator.mqh>

#define _tForwardList __std(CForwardList)
#define _tdeclForwardList __decl(CForwardList)

#ifdef __MQL4__
   #define _tForwardIterator(dType) __std(SForwardIterator)<dType>
   #define _tdeclForwardIterator __decl(SForwardIterator)
#else
   #define _tForwardIterator(dType) _tForwardList<dType>::Iterator
#endif

NAMESPACE(STD)

#ifdef __MQL4__
template<typename Type>
   struct _tdeclForwardIterator:public _tdeclIForwardIterator<_tdeclForwardList<Type>,_tdeclForwardIterator<Type>,_tdeclForwardNode<Type>,Type>{
      _tdeclForwardIterator(_tdeclForwardNode<Type>* mNode,_tdeclForwardList<Type>* mContainer):
         _tdeclIForwardIterator<_tdeclForwardList<Type>,_tdeclForwardIterator<Type>,_tdeclForwardNode<Type>,Type>(mNode,mContainer){}
      _tdeclForwardIterator(const _tdeclForwardIterator<Type> &mOther):
         _tdeclIForwardIterator<_tdeclForwardList<Type>,_tdeclForwardIterator<Type>,_tdeclForwardNode<Type>,Type>(mOther){}
   };
#endif

#define __Node _tdeclForwardNode<Type>
#define __NodeEnd _tdeclForwardNodeEnd<Type>
#define __Proxy _tdeclForwardProxy<_tdeclForwardList<Type>,__Node,Type>
#ifdef __MQL4__
   #define __Iterator _tdeclForwardIterator<Type>
   #define __IteratorDecl __Iterator
#else
   #define __Iterator Iterator
   #define __IteratorDecl _tdeclForwardList<Type>::__Iterator
#endif

template<typename Type>
class _tdeclForwardList:public _tdeclContainer{
#ifdef __MQL5__
   public:
      struct Iterator:public _tdeclIForwardIterator<_tdeclForwardList<Type>,__IteratorDecl,_tdeclForwardNode<Type>,Type>{
         Iterator(_tdeclForwardNode<Type>* mNode,_tdeclForwardList<Type>* mContainer):
            _tdeclIForwardIterator<_tdeclForwardList<Type>,__IteratorDecl,_tdeclForwardNode<Type>,Type>(mNode,mContainer){}
         Iterator(const _tdeclForwardList<Type>::Iterator &mOther):
            _tdeclIForwardIterator<_tdeclForwardList<Type>,__IteratorDecl,_tdeclForwardNode<Type>,Type>(mOther){}
      };
#endif
protected:
   __Proxy cEnd;
   __Node* cFront;
protected:
   static __NodeEnd* EndNode();
public:
   _tdeclForwardList():cEnd(&this,EndNode()),cFront(EndNode()){}
   _tdeclForwardList(Type &mArr[]);
   _tdeclForwardList(_tdeclForwardList<Type> &mOther);
  ~_tdeclForwardList() {Clear();}
   __Iterator Begin() {__Iterator ret(cFront,&this); return ret;}
   const __Proxy* End() const {return &cEnd;}
   __Proxy EraceAfter(const __Iterator &mIt) {return EraceAfter(mIt.Proxy());}
   __Proxy EraceAfter(const __Proxy &mWrape);
   __Proxy InsertAfter(const __Iterator &mIt,const Type &mVal) {return InsertAfter(mIt.Proxy(),mVal);}
   __Proxy InsertAfter(const __Proxy &mWrape,const Type &mVal);
   Type Front() const {return _(cFront);}
   void PushFront(const Type &obj);
   Type PopFront();
   void Swap(_tdeclForwardList<Type> &mOther);
   void Clear();
   void ClearAfter(const __Iterator &mIt) {ClearAfter(mIt.Proxy());}
   void ClearAfter(const __Proxy &mWrape);

};
//----------------------------------------------------------
template<typename Type>
static __NodeEnd* _tdeclForwardList::EndNode(){
   static __NodeEnd instance;
   return &instance;}
//---------------------------------------------------------
template<typename Type>
_tdeclForwardList::_tdeclForwardList(Type &mArr[]):
   cEnd(&this,EndNode()),cFront(EndNode()){
   int count=ArraySize(mArr);
   if (!count) return;
   __Node* first=new __Node(mArr[0],NULL);
   __Node* node=first;
   for (int i=1;i<count;++i){
      node.Next(new __Node(mArr[i],NULL));
      node=node.Next();}
   node.Next(cFront);
   cFront=first;
   cSize=count;
}
//---------------------------------------------------------
template<typename Type>
_tdeclForwardList::_tdeclForwardList(_tdeclForwardList<Type> &mOther):
   cEnd(&this,EndNode()),cFront(EndNode()){
   if (mOther.IsEmpty()) return;
   cSize=mOther.Size();
   __Iterator it=mOther.Begin();
   __Node* first=__Proxy::NewNode(it.Proxy(),NULL);
   __Node* node=first;
   ++it;
   while(!it.IsEnd()){
      node.Next(__Proxy::NewNode(it.Proxy(),NULL));
      node=node.Next();
      ++it;}
   node.Next(cFront);
   cFront=first;
}
//---------------------------------------------------------
template<typename Type>
void _tdeclForwardList::PushFront(const Type &obj){
   ++cSize;
   cFront=new __Node(obj,cFront);}
//----------------------------------------------------------
template<typename Type>
Type _tdeclForwardList::PopFront(){
   if (cFront.IsEnd()) return _(cFront.Next());
   else{
      --cSize;
      Type ret=_(cFront);
      cFront=cFront.Free();
      return ret;}
}
//----------------------------------------------------------
template<typename Type>
void _tdeclForwardList::Swap(_tdeclForwardList<Type> &mOther){
   _tSizeT size=cSize;
   _tdeclForwardList<Type>* ptr=&mOther;
   __Node* front=cFront;
   cSize=ptr.cSize;
   cFront=ptr.cFront;
   ptr.cSize=size;
   ptr.cFront=front;
}
//--------------------------------------------------------------
template<typename Type>
__Proxy _tdeclForwardList::EraceAfter(const __Proxy &mWrape){
   if (!mWrape.CheckContainer(this)) {ABORT("Wrong container");}
   if (mWrape.IsEnd()||mWrape.IsLast()) return mWrape;
   else{
      --cSize;
      return mWrape.EraceAfter();}
}
//--------------------------------------------------------------
template<typename Type>
__Proxy _tdeclForwardList::InsertAfter(const __Proxy &mWrape,const Type &mVal){
   if (!mWrape.CheckContainer(this)) {ABORT("Wrong container");}
   if (mWrape.IsEnd()) ABORT("This operation is not alloed whith end iterator");
   else{
      ++cSize;
      return mWrape.InsertAfter(mVal);}
   return mWrape;
}
//-------------------------------------------------------------------------------
template<typename Type>
void _tdeclForwardList::Clear(){
   cSize=0;
   while (!cFront.IsEnd()) cFront=cFront.Free();
}
//--------------------------------------------------------------
template<typename Type>
void _tdeclForwardList::ClearAfter(const __Proxy &mWrape){
   if (!mWrape.CheckContainer(this)) {ABORT("Wrong container");}
   if (mWrape.IsEnd()||mWrape.IsLast()) return;
   else{
      --cSize;
      for(__Proxy wrape=mWrape.EraceAfter();
          !wrape.IsEnd();
          wrape=mWrape.EraceAfter()) --cSize;}
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

#undef __Node
#undef __NodeEnd
#undef __Proxy
#undef __Iterator
#undef __IteratorDecl

END_SPACE

#endif