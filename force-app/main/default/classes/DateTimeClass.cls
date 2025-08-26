public class DateTimeClass {
    public static void datetimeMethods(){
        //adddays()
        Datetime date1=Datetime.newInstance(2023,09,12);
        System.debug(date1.adddays(5));
        
        //addHours(additionalHours)
        Datetime date2=Datetime.newInstance(2022,09,12,5,5,4);
        System.debug(date2.addHours(3));
        
        //addMinutes(additional Minutes)
        Datetime date3=datetime.newInstance(2022,09,12,5,5,4);
        System.debug(date3.addMinutes(2).format());
        
        //addMonths(additional Months)
        Datetime date4=datetime.newInstance(2023,09,12,5,5,41);
        System.debug(date4.addMonths(2));
        
        //addSeconds(additional Seconds)
        Datetime date5=datetime.newInstance(2023,09,12,5,5,41);
        
        System.debug(date5.addSeconds(5));
        
        //addYears(additional Year)
        Datetime date6=datetime.newInstance(2023,09,12,5,5,41);
        System.debug(date6.addYears(5));
        
        //date()
        Datetime date7=datetime.newInstance(2023,09,12,5,5,41);
        System.debug(date7.date());
        
        //dateGMT()
        Datetime date8=datetime.newInstance(2023,09,12,5,5,41);
        System.debug(date8.dateGMT());
        
        //day()
        Datetime date9=datetime.newInstance(2023,09,12,5,5,41);
        System.debug(date9.day());
        
        //dayGMT()
        Datetime date10=datetime.newInstance(2023,09,12,5,5,41);
        System.debug(date10.dayGMT());
        
        //dayOfYear()
        Datetime date11=datetime.newInstance(2023,09,12,5,5,41);
        System.debug(date11.dayOfYear());
        
        //dayOfYearGMT()
        Datetime date12=datetime.newInstance(2023,09,12,5,5,41);
        System.debug(date12.dayOfYearGMT());
        
        //format()
         Datetime date13=datetime.newInstance(2023,09,12,5,5,41);
        System.debug(date13.format());
        
        //format(dateFormatString)
         Datetime date14=datetime.newInstance(2023,09,12,19,37,55);
         String date15=date14.format('yyyy-MM-dd h:mm a');
         System.debug(date15);
        
        //format(dateFormat ,TimeZone)
         Datetime date16=datetime.newInstance(2023,09,12,19,37,55);
        String strConvertedDate = date16.format('MM/dd/yyyy HH:mm:ss', 
                 'America/New_York');
        
        System.debug(strConvertedDate);
        
        //formatGMT(dateFormatString)
        Datetime date18=datetime.newInstance(2023,09,12,03,03,55);
        String str=date18.formatGmt('EEE, MMM d YYYY, hh:mm a');
        System.debug(str);
        
        //formatLong()
         Datetime date19=datetime.newInstance(2023,09,12,23,23,55);
        System.debug(date19.formatLong());
        
        //getTime()
        Datetime date20=datetime.newInstance(2023,09,23,3,3,44);
        Long dt=date20.getTime();
        System.debug(dt);
        
        //hour()
         Datetime date21=datetime.newInstance(2023,09,23,3,3,44);
        System.debug(date21.hour());
        
        //hourGmt()
         Datetime date22=datetime.newInstance(2023,09,23,3,3,44);
        System.debug(date22.hourGmt());
        
        //isSameDay(dateTocompare)
         Datetime date23=datetime.newInstance(2023,09,23,3,3,44);
         Datetime date24=datetime.newInstance(2023,09,23,3,3,45);
        System.debug(date23.isSameDay(date24));
        
        //millisecond()
         //Datetime date25=datetime.newInstance(2023,09,23,3,3,44);
         Datetime date25=Datetime.now();
        System.debug(date25.millisecond());
        
        //millisecondGmt()
         Datetime date26=datetime.newInstance(2023,09,23,3,3,44);
        System.debug(date26.millisecondGmt());
        
        
        //minute()
         Datetime date27=datetime.newInstance(2023,09,23,3,3,44);
        System.debug(date27.minute());
        
        //minuteGmt()
         Datetime date28=datetime.newInstance(2023,09,23,3,3,44);
        System.debug(date28.minuteGmt());
        
        //month()
         Datetime date29=datetime.newInstance(2023,09,23,3,3,44);
        System.debug(date29.month());
        
        //monthGmt()
         Datetime date30=datetime.newInstance(2023,09,23,3,3,44);
        System.debug(date30.monthGmt());
        
        
        //newInstance(millisecond)
         Long longtime = 1341828183000L;
         System.debug(datetime.newInstance(longtime));
        
        
        //newInstance(datetime)
         Datetime date31=datetime.newInstance(2023,09,23,3,3,44);
         System.debug(date31);
        
        //newInstance(year,month,day)
         Datetime date32=datetime.newInstance(2023,09,23,3,3,44);
        System.debug(date32);
        
        //newInstance(year,month,day,hour,minute,second)
         Datetime date33=datetime.newInstance(2023,09,23,3,3,44);
         System.debug(date33);
        
        //newInstanceGmt(date,time)
         Datetime date34=datetime.newInstance(2023,09,23,3,3,44);
         System.debug(date34);
        
        //newInstanceGmt(year,month,date)
         Datetime date35=datetime.newInstance(2023,09,23,3,3,44);
         System.debug(date35);
        
        //newInstanceGmt(year,month,date,hour,minutes,second)
         Datetime date36=datetime.newInstance(2023,09,23,3,3,44);
         System.debug(date36);
        
        
        //now()
    
         System.debug(datetime.now());
        
        //parse(dateString)
       // Datetime dt11 = DateTime.parse('10/14/2011, 11:46 AM');
          
          //System.debug(dt11);
        
        //second()
       
         Datetime date37=datetime.newInstance(2023,09,23,3,3,44);
         System.debug(date37.second());
        
        //secondGmt()
        
         Datetime date38=datetime.newInstance(2023,09,23,3,3,44);
         System.debug(date38.secondGmt());
        
        //time()
          Datetime date39=datetime.newInstance(2023,09,23,3,3,44);
         System.debug(date39.time());
        
        //timeGmt()
          Datetime date40=datetime.newInstance(2023,09,23,3,3,44);
         System.debug(date40.timeGmt());
        
        //valueOf(datetimeString)
          String str1='2023-09-12 16:23:22';
         System.debug(datetime.valueOf(str1));
        
        //year()
          Datetime date41=datetime.newInstance(2023,09,23,3,3,44);
         System.debug(date41.year());
        
        //yearGmt()
          Datetime date42=datetime.newInstance(2023,09,23,3,3,44);
         System.debug(date42.yearGmt());        
    }
}