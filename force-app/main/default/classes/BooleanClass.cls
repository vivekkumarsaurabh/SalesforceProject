public class BooleanClass {
    public static void booleanMethods(){
        //valueOf(StringToBoolean)
        String str='true';
        System.debug(boolean.valueOf(str));
        
        integer a=5;
        integer c=a+=10;
       
        System.debug(c);
        System.debug(a);
    }
}