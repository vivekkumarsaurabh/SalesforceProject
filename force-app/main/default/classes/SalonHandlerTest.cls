/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 12/02/2024
* @Description : LWC Apex Code of Salon Handler Test Class.
******************************************************************/
@isTest
public class SalonHandlerTest {
    /**************************************************************************************************************************
	* @description : This method is test setup method .
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @testSetup
    static void createRecord(){
        Salon_Man__c salonMan = DataFactory.returnSalonMan();
        Database.insert(salonMan, false);
        Salon_Categories__c cat = DataFactory.insertSalonCategory();
        Database.insert(cat, false);        
    }
    
    /**************************************************************************************************************************
	* @description : This method is test method for running method .
	* @param : N/A.
	* @return : N/A.
	***************************************************************************************************************************/
    @isTest
    static void runTestMethods(){         
        Test.startTest(); 
        List<Salon_Categories__c> catList = SalonHandler.retriveAllCategory();
        System.assert(!catList.isEmpty()); //positive Test  
        String conJson = '{"conName":"New Appoint","conEmail":"app@gmail.com","conPhone":"9087654321"}';
        Salon_Contact__c con =  SalonHandler.insertContact(conJson);
        System.assert(con != null); //positive Test 
        Salon_Man__c salonManRec = [SELECT Id, Email__c FROM Salon_Man__c LIMIT 1];
        Object objPass = SalonHandler.retriveUserPass(salonManRec.Email__c);
        List<Salon_Man__c> retrivSalonMan = SalonHandler.retriveSalonMan();
        System.assertNotEquals(null, retrivSalonMan);
        System.assert(objPass != null); //positive Test 
        List<Salon_Contact__c> conList = SalonHandler.retriveContact();
        Id conId;
        for(Salon_Contact__c iterateCon: conList){
            conId = iterateCon.Id;
        }
        System.assert(!conList.isEmpty());
        Date dt = date.newinstance(2024, 2, 2);  
        Id ids;
        for(Salon_Categories__c iterate : catList){
            ids = iterate.Id;
        }
        String JsonStr = '{"userName":"New Appoint","userEmail":"app@gmail.com","userPhone":"9087654321"}';
        String strTest = SalonHandler.createAppointment(ids, salonManRec.Id, JsonStr, dt, '10:00 am');
        System.assertEquals('Sucessfull', strTest);
        Salon_Appointment__c salAppList = [SELECT Id FROM Salon_Appointment__c LIMIT 1];
        System.assert(salAppList != null);   
        List<String> salApp = new List<String>();
        salApp.add(salAppList.Id);
        List<Salon_Appointment__c> updateStatus = SalonHandler.updateStatus(salApp);
        System.assertNotEquals(null, updateStatus);
        List<Object> objListAppTime  = SalonHandler.retriveAllAppoint(salonManRec.Id, dt);
        System.assertNotEquals(null, objListAppTime);
        List<Salon_Appointment__c> salonAppListApp = SalonHandler.retriveAppointment(salonManRec.Id);
        System.assertNotEquals(null, salonAppListApp); 
        List<Salon_Appointment__c> salonAppList = SalonHandler.dateFilterAppointment(dt, salonManRec.Id);
        System.assertNotEquals(null, salonAppList); 
         Object objWraperChart = SalonHandler.barChartList(salAppList.Id);
         System.assertNotEquals(null, objWraperChart);
        List<Salon_Appointment__c> delList =  SalonHandler.deleteAppointment(salAppList.Id);        
        System.assertNotEquals(null, delList);
        List<Salon_Contact__c> SalonConList = SalonHandler.deteleUserContact(conId);
        System.assertNotEquals(null, SalonConList);        
        Integer checkPast = SalonHandler.countPastAppoitment(salAppList.Id);
        System.assertEquals(0, checkPast);        
        Integer checkFuture = SalonHandler.countFutureAppoitment(salAppList.Id);
        System.assertEquals(0, checkFuture);
        Integer countCon = SalonHandler.countContact(salAppList.Id);
        System.assertEquals(0, countCon);
        Integer countAppointment = SalonHandler.countAppoitment(salAppList.Id);
        System.assertEquals(0, countAppointment);
        String strTestLast = SalonHandler.createAppointment(ids, salonManRec.Id, JsonStr, dt, '06:00 pm');
        System.assertEquals('This time is not available for more than 1 hour', strTestLast);
         String strTestOther = SalonHandler.createAppointment(ids, salonManRec.Id, JsonStr, dt, '01:00 pm');
        System.assertEquals('Sucessfull', strTestOther);
         String strTestSmaller = SalonHandler.createAppointment(ids, salonManRec.Id, JsonStr, dt, '12:00 pm');
        System.assertEquals('This time is not available for more than 1 hour', strTestSmaller);
        Test.stopTest(); 
    }
    
}