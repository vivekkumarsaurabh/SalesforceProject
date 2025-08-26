@isTest
public class OpportunityScenarioHelperTest {
    @isTest
    public static void testCases(){
        Account acc = new Account(Name = 'test Account', Rating = 'Hot');
        insert acc;
        
        Opportunity opp = new Opportunity(Name= 'Opportunity test', stageName= 'Prospective', CloseDate = System.today(), AccountId  = acc.Id);
        insert opp;
        Opportunity opp2 = new Opportunity(Name= 'Opportunity test', stageName= 'Prospective', CloseDate = System.today(), TL_Control_Screen__c = 'Failed', AccountId  = acc.Id);
        insert opp2;

        Opportunity oppRec = [SELECT Id, TL_Hold_status__c, TL_Control_Screen__c  FROM Opportunity WHERE Id = :opp.Id];
        System.debug('aftet Opp TL_Control_Screen__c ===>'+oppRec.TL_Control_Screen__c);
		System.debug('aftet Opp TL_Hold_status__c ===>'+oppRec.TL_Hold_status__c);
        
        Account accRec = [Select Id, TL_Line_Level_Hold_Status__c FROM Account WHERE Id = :acc.Id LIMIT 1];
        System.debug('after insert ==>'+accRec.TL_Line_Level_Hold_Status__c);
        
        Test.startTest();
		
		opp.TL_Control_Screen__c = 'Failed';
        update opp;
        Account accRecUpdate1 = [Select Id, TL_Line_Level_Hold_Status__c FROM Account WHERE Id = :acc.Id LIMIT 1];
        System.debug('after Update 1 ==>'+accRecUpdate1.TL_Line_Level_Hold_Status__c);

       /* opp.TL_Control_Screen__c = null;
        update opp;
 		Account accRecUpdate2 = [Select Id, TL_Line_Level_Hold_Status__c FROM Account WHERE Id = :acc.Id LIMIT 1];
        System.debug('after Update 2 ==>'+accRecUpdate2.TL_Line_Level_Hold_Status__c);*/

        opp2.TL_Control_Screen__c = 'Passed';
        update opp2;
 		Account accRecUpdate3 = [Select Id, TL_Line_Level_Hold_Status__c FROM Account WHERE Id = :acc.Id LIMIT 1];
        System.debug('after Update 3 ==>'+accRecUpdate3.TL_Line_Level_Hold_Status__c);
        Test.stopTest();
    }
}