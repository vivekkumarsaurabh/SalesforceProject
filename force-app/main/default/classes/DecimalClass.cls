public class DecimalClass {
    public static void decimalMethods(){
        
        
        //abs()
        Decimal dec1=-6.0234;
        System.debug(dec1.abs());
        
        //divide()
        Decimal dec2=19;
        System.debug(dec2.divide(100,3));
        
        //divide()
        Decimal de=19.3;
        System.debug(de.divide(100,3,System.RoundingMode.DOWN));
        
        //doubleValue()
        
        System.debug(dec2.doubleValue());
        
        
        //format()
        Decimal dec3=12.45;
        System.debug(dec3.format());
        
        //intValue()
        System.debug(dec3.intValue());
        
        //LongValue()
        System.debug(dec3.LongValue());
        
        //pow(exponext)
        System.debug(dec3.pow(2));
       
        //precision()
        System.debug(dec3.precision());
        
       //round()        
        //Decimal dec4=4.6;
        Decimal dec4=-2.77;
        System.debug(dec4.round());
        
        //round(roundingMode)
         
        
        //Scale()
         Decimal dec5=9.273352342;
        System.debug(dec5.scale());  //9 
        
        //Scale(Scale)
           System.debug(dec5.setScale(3));
        
        //SetScale(Scale,roundingMode)
         System.debug(dec5.setScale(3, System.roundingMode.DOWN));
        
        //stripTrailingZeros()
        Decimal decc=1.10000;
        System.debug(decc.stripTrailingZeros());
        
        //toPlainString()
         System.debug(decc.toPlainString());
        
        //valueOf(doubleToDecimal)
        Double dob=12.23423424324232;
        System.debug(decimal.valueOf(dob));
        
        //valueOf(LongToDecimal)
        Long l=123423L;
        System.debug(decimal.valueOf(l));

       //valueOf(StringtoDecimal) 
       String s='12.45';
        System.debug(decimal.valueOf(s));
        
        Decimal deee=8.0;
        System.debug(deee.precision());
    } 
    
    
    
    
    
    
    
    
    
    
    
    
    
}