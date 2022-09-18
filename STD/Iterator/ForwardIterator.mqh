#ifndef _STD_I_FORWARD_ITERATOR_
#define _STD_I_FORWARD_ITERATOR_

#include "IIterator.mqh"
#include "Proxy\ForwardProxy.mqh"

#define _tdeclIForwardIterator __decl(IForwardIterator)
#define __ProxyType _tdeclForwardProxy<ContainerType,NodeType,Type>

NAMESPACE(STD)
template<typename ContainerType,typename IteratorType,typename NodeType,typename Type>
struct _tdeclIForwardIterator:public _tdeclIterator<ContainerType,IteratorType,__ProxyType,NodeType,Type>{
protected:
   _tdeclIForwardIterator(NodeType* mNode,ContainerType* mContainer):_tdeclIterator<ContainerType,IteratorType,__ProxyType,NodeType,Type>(mNode,mContainer){}
   _tdeclIForwardIterator(const IteratorType &other):_tdeclIterator<ContainerType,IteratorType,__ProxyType,NodeType,Type>(other.Proxy()){}
public:
   __ProxyType* operator ++() {++cProxy; return &cProxy;}
   __ProxyType operator ++(int) {__ProxyType ret(cProxy); ++cProxy; return ret;}
};

END_SPACE

#undef __ProxyType

#endif