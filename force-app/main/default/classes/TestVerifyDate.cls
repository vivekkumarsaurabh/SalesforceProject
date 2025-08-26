// All test methods in this class can access all data.
@IsTest()
private class TestVerifyDate {
    
    @isTest static void testCheckDatesReturnLastDay(){
        Date d1 = date.newinstance(2023, 10, 25);        
        Date d2 = date.newinstance(2023, 10, 5); 
        Date date1return = VerifyDate.CheckDates(d1,d2);
        System.assertEquals(date.newinstance(2023, 10, 31),date1return);        
    }    
    
    @isTest
    static void testCheckDatesdate1equaldate2(){
        Date d1 = date.newinstance(2023, 10, 25);        
        Date d2 = date.newinstance(2023, 11, 25); 
        Date date1return = VerifyDate.CheckDates(d1,d2);
        System.assertEquals(date.newinstance(2023, 10, 31),date1return); 
    }
    
    @isTest static void testCheckDatesReturndate(){
        Date d1 = date.newinstance(2023, 10, 25);        
        Date d2 = date.newinstance(2023, 11, 5); 
        Date date1return = VerifyDate.CheckDates(d1,d2);
        System.assertEquals(date.newinstance(2023, 11, 5),date1return); 
    }
    
    @isTest
    static void testCheckDatesReturnday1small(){
        Date d1 = date.newinstance(2023, 10, 5);        
        Date d2 = date.newinstance(2023, 10, 25); 
        Date date1return = VerifyDate.CheckDates(d1,d2);
        System.assertEquals(date.newinstance(2023, 10, 25),date1return); 
    }
    
    
}