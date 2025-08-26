public class LongClass {
    public static void longMethods(){
        
        //format()
        Long myLong=422737242;
        System.debug(myLong.format());
        
        //intvalue()
        
        System.debug(myLong.intValue());
        
        //valueOf(StringToLong)
        Long l1=Long.valueOf('42273724928');
        System.debug(l1);
      
    }
}