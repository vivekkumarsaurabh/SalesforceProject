public class DateClass {
    public static void dateMethods(){
        
        //addDays(additional Days)
        Date date1=Date.newInstance(2023,09,12);
        System.debug(date1.addDays(2));
        
       //addMonths(additional Months) 
         Date date2=Date.newInstance(2023,09,12);
        System.debug(date2.addMonths(2));
        
        //addYears(additionalYear)
          Date date3=Date.newInstance(2023,09,12);
        System.debug(date3.addYears(2));
        
        //day()
          Date date4=Date.newInstance(2023,09,12);
        System.debug(date4.day());
        
        //dayOfYear()
          Date date5=Date.newInstance(2023,09,12);
          System.debug(date5.dayOfYear()); //255
       
        //daysBetween()
        Date date6=Date.newInstance(2023,09,12);
        Date date7=Date.newInstance(2023,09,15);
        System.debug(date6.daysBetween(date7)); 
        
        
        //daysInMonth(year,month)
        System.debug(date.daysInMonth(2023,9));
        
        //format()
         Date date8=Date.newInstance(2023,09,12);
        System.debug(date8.format());
        
        //isLeapYear()
        
        System.debug(Date.isLeapYear(2024));
        
        //isSameDay()
        Date date10=Date.today();
        Date date11=Date.newInstance(2023, 09, 12);
        System.debug(date10.isSameDay(date11));
        
        //month()
          Date date12=Date.newInstance(2023, 09, 12);
         System.debug(date12.month());
        
        //monthsBetween(secondDate)
                Date date13=Date.newInstance(2023, 09, 12);
                Date date14=Date.newInstance(2024, 05, 12);
             System.debug(date13.monthsBetween(date14));
        
        //newInstance(year,month,day)
        Date date15=Date.newInstance(2023,09,12);
       
        System.debug(date15);
        
        //parse(StringDate)
        Date date16=date.Parse('12/09/2023');
        String da=String.valueOf(date16);
        System.debug(da);
            
        //today()
        Date date17=Date.today();
         System.debug(date17);
        
        //toStartOfMonth()
        Date date18=date.newInstance(2023,09,12);
        //Date firstdate=date18.toStartOfMonth();
        System.debug(date18.toStartOfMonth());
        
        //toStartOfWeek()
        Date date19=Date.newInstance(2023,09,16);
        Date weekStart = date19.toStartOfWeek();
        System.debug(weekStart);
        
        //valueOf(startDate)
         String date20='2023-09-23 11:18:00';
        System.debug(date20);
        
        //vaueOf(fieldvalue)
        //
        //
        
        
        //year()
         Date date22=date.newInstance(2023,09,12);
        System.debug(date22.year());
        
        String str111='12.09.2023';
        String[] dt=str111.split('\\.');
       /**integer dd=integer.valueOf(dt[0]);
         integer mm=integer.valueOf(dt[1]);
         integer yy=integer.valueOf(dt[2]);
        List<String> str0=new List<String>{dt[0],dt[1],dt[2]}; **/
          System.debug(String.join(dt,'/'));
          //System.debug(String.join(str0,'/'));    
        //Date dd11=date.newInstance(yy, mm, dd);
        //Date dd11=

         //Date dd11=date.parse(dt[0]'/'dt[1]'/'dt[2]);
       // System.debug(dd11);
    }
    
}