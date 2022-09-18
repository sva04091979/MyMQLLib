#ifndef _STD_I_FORWARD_LIST_
#define _STD_I_FORWARD_LIST_

#include "IContainer.mqh"

#define _tdeclIForwardList __decl(IForwardList)

NAMESPACE(STD)

template<typename ContainerType,typename IteratorType,typename ProxyType,typename NodeType,typename NodeTypeEnd,typename Type>
class _tdeclIForwardList:public _tdeclContainer{
protected:
   ProxyType cEnd;
   NodeType* cFront;
protected:
   _tdeclIForwardList():cEnd((ContainerType*)&this,EndNode()),cFront(EndNode()){}
   _tdeclIForwardList(Type &mArr[]);
   _tdeclIForwardList(ContainerType &mOther);
  ~_tdeclIForwardList() {Clear();}
   static NodeTypeEnd* EndNode();
public:
   IteratorType Begin() {IteratorType ret(cFront,&this); return ret;}
   const ProxyType* End() const {return &cEnd;}
   ProxyType EraceAfter(const IteratorType &mIt) {return EraceAfter(mIt.Proxy());}
   ProxyType EraceAfter(const ProxyType &mWrape);
   ProxyType InsertAfter(const IteratorType &mIt,const Type &mVal) {return InsertAfter(mIt.Proxy(),mVal);}
   ProxyType InsertAfter(const ProxyType &mWrape,const Type &mVal);
   Type Front() const {return _(cFront);}
   void PushFront(Type &obj);
   Type PopFront();
   void Swap(ContainerType &mOther);
   void Clear();
   void ClearAfter(const IteratorType &mIt) {ClearAfter(mIt.Proxy());}
   void ClearAfter(const ProxyType &mWrape);

};
//----------------------------------------------------------
template<typename ContainerType,typename IteratorType,typename ProxyType,typename NodeType,typename NodeTypeEnd,typename Type>
static NodeTypeEnd* _tdeclIForwardList::EndNode(){
   static NodeTypeEnd instance;
   return &instance;}
//---------------------------------------------------------
template<typename ContainerType,typename IteratorType,typename ProxyType,typename NodeType,typename NodeTypeEnd,typename Type>
_tdeclIForwardList::_tdeclIForwardList(Type &mArr[]):
   cEnd(&this,EndNode()),cFront(EndNode()){
   cEnd=ProxyType(&this,cFront);
   int count=ArraySize(mArr);
   if (!count) return;
   NodeType* first=new NodeType(mArr[0],NULL);
   NodeType* node=first;
   for (int i=1;i<count;++i){
      node.Next(new NodeType(mArr[i],NULL));
      node=node.Next();}
   node.Next(cFront);
   cFront=first;
   cSize=count;
}
//---------------------------------------------------------
template<typename ContainerType,typename IteratorType,typename ProxyType,typename NodeType,typename NodeTypeEnd,typename Type>
_tdeclIForwardList::_tdeclIForwardList(ContainerType &mOther):
   cEnd(&this,EndNode()),cFront(EndNode()){
   if (mOther.IsEmpty()) return;
   cSize=mOther.Size();
   IteratorType it=mOther.Begin();
   NodeType* first=ProxyType::NewNode(it.Proxy(),NULL);
   NodeType* node=first;
   ++it;
   while(!it.IsEnd()){
      node.Next(ProxyType::NewNode(it.Proxy(),NULL));
      node=node.Next();
      ++it;}
   node.Next(cFront);
   cFront=first;
}
//---------------------------------------------------------
template<typename ContainerType,typename IteratorType,typename ProxyType,typename NodeType,typename NodeTypeEnd,typename Type>
void _tdeclIForwardList::PushFront(Type &obj){
   ++cSize;
   cFront=new NodeType(obj,cFront);}
//----------------------------------------------------------
template<typename ContainerType,typename IteratorType,typename ProxyType,typename NodeType,typename NodeTypeEnd,typename Type>
Type _tdeclIForwardList::PopFront(){
   if (cFront.IsEnd()) return _(cFront.Next());
   else{
      --cSize;
      Type ret=_(cFront);
      cFront=cFront.Free();
      return ret;}
}
//----------------------------------------------------------
template<typename ContainerType,typename IteratorType,typename ProxyType,typename NodeType,typename NodeTypeEnd,typename Type>
void _tdeclIForwardList::Swap(ContainerType &mOther){
   _tSizeT size=cSize;
   _tdeclIForwardList<ContainerType,IteratorType,ProxyType,NodeType,NodeTypeEnd,Type>* ptr=&mOther;
   NodeType* front=cFront;
   cSize=ptr.cSize;
   cFront=ptr.cFront;
   ptr.cSize=size;
   ptr.cFront=front;
}
//--------------------------------------------------------------
template<typename ContainerType,typename IteratorType,typename ProxyType,typename NodeType,typename NodeTypeEnd,typename Type>
ProxyType _tdeclIForwardList::EraceAfter(const ProxyType &mWrape){
   if (!mWrape.CheckContainer((ContainerType*)&this)) {ABORT("Wrong container");}
   if (mWrape.IsEnd()||mWrape.IsLast()) return mWrape;
   else{
      --cSize;
      return mWrape.EraceAfter();}
}
//--------------------------------------------------------------
template<typename ContainerType,typename IteratorType,typename ProxyType,typename NodeType,typename NodeTypeEnd,typename Type>
ProxyType _tdeclIForwardList::InsertAfter(const ProxyType &mWrape,const Type &mVal){
   if (!mWrape.CheckContainer((ContainerType*)&this)) {ABORT("Wrong container");}
   if (mWrape.IsEnd()) ABORT("This operation is not alloed whith end iterator");
   else{
      ++cSize;
      return mWrape.InsertAfter(mVal);}
   return mWrape;
}
//-------------------------------------------------------------------------------
template<typename ContainerType,typename IteratorType,typename ProxyType,typename NodeType,typename NodeTypeEnd,typename Type>
void _tdeclIForwardList::Clear(){
   cSize=0;
   while (!cFront.IsEnd()) cFront=cFront.Free();
}
//--------------------------------------------------------------
template<typename ContainerType,typename IteratorType,typename ProxyType,typename NodeType,typename NodeTypeEnd,typename Type>
void _tdeclIForwardList::ClearAfter(const ProxyType &mWrape){
   if (!mWrape.CheckContainer((ContainerType*)&this)) {ABORT("Wrong container");}
   if (mWrape.IsEnd()||mWrape.IsLast()) return;
   else{
      --cSize;
      for(ProxyType wrape=mWrape.EraceAfter();
          !wrape.IsEnd();
          wrape=mWrape.EraceAfter()) --cSize;}
}

END_SPACE

#endif