#ifndef _STD_FORWARD_ITERATOR_PROXY_
#define _STD_FORWARD_ITERATOR_PROXY_

#include <STD\Define\StdDefine.mqh>

#define _tdeclForwardProxy __decl(CForwardProxy)

NAMESPACE(STD)

template<typename ContainerType,typename NodeType,typename Type>
class _tdeclForwardProxy{
   ContainerType* cContainer;
   NodeType* cNode;
public:
   static NodeType* NewNode(const _tdeclForwardProxy<ContainerType,NodeType,Type> &mProxy,NodeType* mNext) {return NewContainerNode<NodeType>(mProxy.cNode,mNext);}
   _tdeclForwardProxy(const _tdeclForwardProxy<ContainerType,NodeType,Type> &mOther){this=mOther;}
   _tdeclForwardProxy(ContainerType* mContainer,NodeType* mNode):cContainer(mContainer),cNode(mNode){}
   _tdeclForwardProxy<ContainerType,NodeType,Type> EraceAfter() const;
   _tdeclForwardProxy<ContainerType,NodeType,Type> InsertAfter(const Type &mVal) const;
   Type Dereference() const {return _(cNode);}
   void operator ++() {cNode=cNode.Next();}
   void operator =(NodeType* mNode) {cNode=mNode;}
   bool CheckContainer(const ContainerType &mContainer) const {return &mContainer==cContainer;}
   bool IsEnd() const {return cNode.IsEnd();}
   bool IsLast() const {return cNode.IsLast();}
   bool operator ==(const _tdeclForwardProxy<ContainerType,NodeType,Type> &mOther) {return cContainer==mOther.cContainer&&cNode==mOther.cNode;}
   bool operator !=(const _tdeclForwardProxy<ContainerType,NodeType,Type> &mOther) {return cContainer!=mOther.cContainer||cNode!=mOther.cNode;}
};
//---------------------------------------------------------------------------------------------
template<typename ContainerType,typename NodeType,typename Type>
_tdeclForwardProxy<ContainerType,NodeType,Type>
_tdeclForwardProxy::EraceAfter() const{
   NodeType* next=cNode.EraceAfter();
   _tdeclForwardProxy<ContainerType,NodeType,Type> ret(cContainer,next);
   return ret;
}
//---------------------------------------------------------------------------------------------
template<typename ContainerType,typename NodeType,typename Type>
_tdeclForwardProxy<ContainerType,NodeType,Type>
_tdeclForwardProxy::InsertAfter(const Type &mVal) const{
   NodeType* next=cNode.InsertAfter(mVal);
   _tdeclForwardProxy<ContainerType,NodeType,Type> ret(cContainer,next);
   return ret;
}

END_SPACE

#endif 