template<typename Type>
class TPrice:public Type{
   double cPrice;
public:
   double Price() {return cPrice=Get(OBJPROP_PRICE);}
   bool Price(double price);
   bool Show(int subW) override;
protected:
   void Init() override; 
};
//----------------------------------------------------
template<typename Type>
void TPrice::Init(){
   Type::Init();
   cPrice=Get(OBJPROP_PRICE);
}
//----------------------------------------------------
template<typename Type>
bool TPrice::Price(double price){
   bool ret=Set(OBJPROP_PRICE,price);
   if (ret)
      cPrice=price;
   return ret;
}
//----------------------------------------------------
template<typename Type>
bool TPrice::Show(int subW){
   bool ret=Type::Show(subW);
   if (ret){
      Price(cPrice);
   }
   return ret;
}
