#ifndef _STD_I_FORWARD_ITERATOR_
#define _STD_I_FORWARD_ITERATOR_

#include "IIterator.mqh"

#define _tForwardNode __std(_CForwardWrape)

#define _tdecl_ForwardIterator __decl(_SForwardIterator)
#define _tdecl_ForwardProxy __decl(_CForwardWrape)

#define _Typenames ContainerType,_tdecl_ForwardProxy<ContainerType,NodeType,T>,NodeType,T

NAMESPACE(STD)

template<typename ContainerType,typename NodeType,typename T>
class _tdecl_ForwardProxy{
   ContainerType* cContainer;
   NodeType* cNode;
public:
   static NodeType* NewNode(const _tdecl_ForwardProxy<ContainerType,NodeType,T> &mWrape,NodeType* mNext) {return _tdecl_ForwardNode<T,NodeType>::NewNode(mWrape.cNode,mNext);}
   _tdecl_ForwardProxy(const _tdecl_ForwardProxy<ContainerType,NodeType,T> &mOther){this=mOther;}
   _tdecl_ForwardProxy(ContainerType* mContainer,NodeType* mNode):cContainer(mContainer),cNode(mNode){}
   _tdecl_ForwardProxy<ContainerType,NodeType,T> EraceNext() const;
   _tdecl_ForwardProxy<ContainerType,NodeType,T> Insert(const T &mVal) const;
   T Dereference() const {return _(cNode);}
   void operator ++() {cNode=cNode.Next();}
   void operator =(NodeType* mNode) {cNode=mNode;}
   bool CheckContainer(const ContainerType &mContainer) const {return &mContainer==cContainer;}
   bool IsEnd() const {return cNode.IsEnd();}
   bool IsLast() const {return cNode.IsLast();}
   bool operator ==(const _tdecl_ForwardProxy<ContainerType,NodeType,T> &mOther) {return cContainer==mOther.cContainer&&cNode==mOther.cNode;}
   bool operator !=(const _tdecl_ForwardProxy<ContainerType,NodeType,T> &mOther) {return cContainer!=mOther.cContainer||cNode!=mOther.cNode;}
};
//---------------------------------------------------------------------------------------------
template<typename ContainerType,typename NodeType,typename T>
_tdecl_ForwardProxy<ContainerType,NodeType,T> _tdecl_ForwardProxy::EraceNext() const{
   NodeType* next=cNode.EraceNext();
   _tdecl_ForwardProxy<ContainerType,NodeType,T> ret(cContainer,next);
   return ret;
}
//---------------------------------------------------------------------------------------------
template<typename ContainerType,typename NodeType,typename T>
_tdecl_ForwardProxy<ContainerType,NodeType,T>
_tdecl_ForwardProxy::Insert(const T &mVal) const{
   NodeType* next=cNode.Insert(mVal);
   _tdecl_ForwardProxy<ContainerType,NodeType,T> ret(cContainer,next);
   return ret;
}
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
template<typename ContainerType,typename Iterator, typename NodeType,typename T>
struct _tdecl_ForwardIterator:public _tdecl_Iterator<_Typenames>{
protected:
   _tdecl_ForwardIterator(NodeType* mNode,ContainerType* mContainer):_tdecl_Iterator<_Typenames>(mNode,mContainer){}
   _tdecl_ForwardIterator(const Iterator &other):_tdecl_Iterator<_Typenames>(other.Wrape()){}
public:
   _tdecl_ForwardProxy<ContainerType,NodeType,T>* operator ++() {++cWrape; return &cWrape;}
   _tdecl_ForwardProxy<ContainerType,NodeType,T> operator ++(int) {_tdecl_ForwardProxy<ContainerType,NodeType,T> ret(cWrape); ++cWrape; return ret;}
};

END_SPACE

#undef _Typenames

#endif