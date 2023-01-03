template<typename Type>
class TPrice:public Type{
   double cPrice;
public:
   double Price() {return cPrice=Get(OBJPROP_PRICE);}
   bool Price(double price);
   bool Show(int subW) override;
   int Y();
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
//----------------------------------------------------
template<typename Type>
int TPrice::Y(){
   int x=0;
   int y=0;
   int sub=0;
   ChartTimePriceToXY(0,sub,0,cPrice,x,y);
   return y;
}