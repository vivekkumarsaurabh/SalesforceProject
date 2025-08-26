@isTest
public class CreateUpdRecTimeTrackAccHourTest {
    @isTest 
    static void method(){  
        Test.startTest();
        List<Time_Tracking__c> listOfTimeTrackingFirst =  CreateUpdRecTimeTrackDataFactory.inserRecord(2, 'newTime', date.newinstance(1960, 2, 17), 10);
        List<Database.saveResult>  listOfSaveResultFirst = Database.insert(listOfTimeTrackingFirst, false); 
        for(Database.saveResult resultFirst : listOfSaveResultFirst){
            System.assert(resultFirst.isSuccess());
        }
        List<Time_Tracking__c> listOfTimeTrackingSecond =  CreateUpdRecTimeTrackDataFactory.inserRecord(5, 'newTime', date.newinstance(1960, 2, 17), 10);
        List<Database.saveResult>  listOfSaveResultSecond = Database.insert(listOfTimeTrackingSecond, false); 
        for(Database.saveResult resultSecond : listOfSaveResultSecond){
            System.assert(!resultSecond.isSuccess());
            System.assertEquals(System.label.Time_Tracking_error, resultSecond.getErrors()[0].getMessage());
        }
        
          List<Time_Tracking__c> listOfTimeTrackingThird =  CreateUpdRecTimeTrackDataFactory.inserRecord(1, 'newTime', date.newinstance(1960, 2, 27), 30);
        List<Database.saveResult>  listOfSaveResultThird = Database.insert(listOfTimeTrackingThird, false); 
        for(Database.saveResult resultSecond : listOfSaveResultThird){
            System.assert(!resultSecond.isSuccess());
            System.assertEquals(System.label.Time_Tracking_error, resultSecond.getErrors()[0].getMessage());
        }
        
        List<Time_Tracking__c> updateTimeTracking = CreateUpdRecTimeTrackDataFactory.updateRec(listOfTimeTrackingFirst, date.newinstance(1960, 2, 17), 15);
        List<Database.saveResult>  updateResult = Database.update(updateTimeTracking, false); 
        for(Database.saveResult result : updateResult){
            System.assert(!result.isSuccess());
            System.assertEquals(System.label.Time_Tracking_error, result.getErrors()[0].getMessage());
        }
        Test.stopTest(); 
    } 
}