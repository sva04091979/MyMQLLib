#ifndef _STD_I_ITERATOR_
#define _STD_I_ITERATOR_

#include <STD\Define\StdDefine.mqh>

#define _tdeclIterator __decl(IIterator)

NAMESPACE(STD)

template<typename ContainerType,typename IteratorType,typename ProxyType,typename NodeType,typename Type>
struct _tdeclIterator{
   ProxyType cProxy;
protected:
   _tdeclIterator(const ProxyType* mProxy):cProxy(mProxy){}
   _tdeclIterator(NodeType* mNode,ContainerType* mContainer):cProxy(mContainer,mNode){}
public:
   const ProxyType* Proxy() const {return &cProxy;}
   bool CheckContainer(ContainerType &mContainer) {return cProxy.CheckContainer(mContainer);}
public:
   Type Dereference() const {return _(cProxy);}
   void operator =(IteratorType &mOther) {cProxy=mOther.Proxy();}
   void operator =(ProxyType &mProxy) {cProxy=mProxy;}
   bool operator ==(IteratorType &other) {return cProxy==other.cProxy;}
   bool operator !=(IteratorType &other) {return cProxy!=other.cProxy;}
   bool operator ==(const ProxyType &mProxy) {return cProxy==mProxy;}
   bool operator !=(const ProxyType &mProxy) {return cProxy!=mProxy;}
   bool IsEnd() {return cProxy.IsEnd();}
};

END_SPACE

#endif