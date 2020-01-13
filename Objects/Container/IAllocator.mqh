#ifndef _I_ALLOCATOR_
#define _I_ALLOCATOR_

#ifndef USING_STD
   namespace STD{
#endif

class IAllocator
  {
public:
                     IAllocator(void);
                    ~IAllocator(void);
  };

#ifndef USING_STD
   }
#endif 

#endif