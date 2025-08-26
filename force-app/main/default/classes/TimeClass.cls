public class TimeClass {
    public static void timeMethods(){
       
        //addHours(additional Hours)
        Time t1=Time.newInstance(1,2,3,4);
        System.debug(t1.addHours(3));
        
        //addMilliseconds(additional Millisecond)
         System.debug(t1.addMilliseconds(1400));
        
        //addMinutes(additional Minutes)
           System.debug(t1.addMinutes(12));
       
        //addSeconds(additional Second)
        
           System.debug(t1.addSeconds(5));
        
        //hour()
           System.debug(t1.hour());

          //millosecond()
             System.debug(t1.millisecond());
        
        //minute()
           System.debug(t1.minute());
    
       //Second()
          System.debug(t1.Second());        
      
    }
}