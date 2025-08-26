/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 25/01/2024
* @Description : LWC Apex Code of Calendet Attendence Component Test Class.
******************************************************************/
@isTest
private class CalenderTest {
    /**************************************************************************************************************************
	* @description : This method is test setup method .
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/ 
    @testSetup
    static void createRecord(){
      Attendence_User__c userRec =  DataFactory.returnAttendenceUserRec();
      Database.insert(userRec, false);
      Attendence_Record__c attenRec =  DataFactory.returnAttendenRec(userRec.Id);     
      Database.insert(attenRec, false); 
    }
    
	/**************************************************************************************************************************
	* @description : This method is test clenderAtendnceTest.
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/    
    @isTest
    static void clenderAtendnceTest(){
        Test.startTest();
        Map<String, List<Object>> calenderMap = Calender.returnHolidays();
        System.assert(!calenderMap.isEmpty());
        Attendence_Record__c recListAt = [SELECT Attendence_User_Name__r.Name, Attendence_Date__c, Attendence_User_Name__c, Sick_Leave__c, Present_Absent__c, Half_Day__c, Floater_Leave__c, Absent__c FROM Attendence_Record__c LIMIT 1];
        String attuser1 = recListAt.Attendence_User_Name__c+'-present-2024-01-20'; 
        String attuser2 = recListAt.Attendence_User_Name__c+'-abs-2024-01-20'; 
        String attuser3 = recListAt.Attendence_User_Name__c+'-fl-2024-01-20'; 
        String attuser4 = recListAt.Attendence_User_Name__c+'-sl-2024-01-20'; 
        String attuser5 = recListAt.Attendence_User_Name__c+'-hd-2024-01-20'; 
        List<String> strList = new List<String>();
        strList.add(attuser1);
        strList.add(attuser2);
        strList.add(attuser3);
        strList.add(attuser4);
        strList.add(attuser5);
        List<Attendence_Record__c> attendenceRecList = Calender.createRecord(strList);
        System.assert(!attendenceRecList.isEmpty());
       /** List<Attendence_Record__c> attendenceRecListAb = Calender.createRecord(strList);
        System.assert(!attendenceRecListAb.isEmpty());
        List<Attendence_Record__c> attendenceRecListSL = Calender.createRecord(strList);
        System.assert(!attendenceRecListSL.isEmpty());
        List<Attendence_Record__c> attendenceRecListHD = Calender.createRecord(strList);
        System.assert(!attendenceRecListHD.isEmpty());
        List<Attendence_Record__c> attendenceRecListFL = Calender.createRecord(strList);
        System.assert(!attendenceRecListFL.isEmpty());**/
        List<Object> wrrperList =  Calender.returnAttendenceWrapper(0, new List<Integer>{6,7,14,13,20,21,27,28}, 31);
        System.assert(!wrrperList.isEmpty());
        List<Object> wrrperListNeg =  Calender.returnAttendenceWrapper(10, new List<Integer>{6,7,14,13,20,21,27,28}, 31);
        System.assert(wrrperListNeg.isEmpty()); //Negative Test       
        Date dt = date.newInstance(2024, 01, 20);
        List<Attendence_Record__c> recList = Calender.retriveData(dt);        
        System.assert(!recList.isEmpty());       
        List<Attendence_User__c> userList = Calender.attendenceUser(dt);     
       // System.assert(!userList.isEmpty());
        System.debug(userList);
        List<Attendence_Record__c> userRec = Calender.deleteData(dt);
        System.assert(!userRec.isEmpty());
        Test.stopTest();
    }
}