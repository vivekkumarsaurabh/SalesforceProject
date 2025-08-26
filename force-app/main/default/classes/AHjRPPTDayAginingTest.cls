@isTest
private class AHjRPPTDayAginingTest {
    @isTest
    static void testFotFourRecord(){
        Test.startTest();
        List<PT__c> listOfPtRec = new List<PT__c>();
        AHJ__c createAHJRec = DataFactory.returnAHJ('NewAHJ1');
        insert createAHJRec;
        RP__c createRPRec = DataFactory.returnRP('NewRp1', createAHJRec.Id);
        insert createRPRec;
        PT__c createPtRec = DataFactory.returnPT('NewPt', createRPRec.Id);        
        PT__c createPtRec2 = DataFactory.returnPT('NewPt2', createRPRec.Id);
        
        RP__c createRPRec2 = DataFactory.returnRP('NewRp2', createAHJRec.Id);
        insert createRPRec2;
        PT__c createPtRec3 = DataFactory.returnPT('NewPt3', createRPRec2.Id);
        PT__c createPtRec4 = DataFactory.returnPT('NewPt4', createRPRec2.Id);
        listOfPtRec.add(createPtRec);
        listOfPtRec.add(createPtRec2);
        listOfPtRec.add(createPtRec3);
        listOfPtRec.add(createPtRec4);
        insert listOfPtRec;
        
        AHjRPPTFindDayAging runBatch = new AHjRPPTFindDayAging();
        Database.executeBatch(runBatch);
        
        Test.stopTest();
        Decimal dayAgin = 0;
        for(AHJ__c iterateDayAgn :  [SELECT Day_Aging__c FROM AHJ__c]){
            dayAgin += iterateDayAgn.Day_Aging__c;
        }        
        System.assertEquals(4, dayAgin);
    }
    
    @isTest
    static void testmorethanFiveRecord(){
        Test.startTest();
        AHJ__c createAHJRec2 = DataFactory.returnAHJ('NewAHJ2');
        insert createAHJRec2;
        RP__c createRPRec = DataFactory.returnRP('NewRp1', createAHJRec2.Id);
        insert createRPRec;
        List<PT__c> listOfPtRec = new List<PT__c>();
        PT__c createPtRec = DataFactory.returnPT('NewPt', createRPRec.Id);         
        PT__c createPtRec2 = DataFactory.returnPT('NewPt2', createRPRec.Id);
        
        
        RP__c createRPRec2 = DataFactory.returnRP('NewRp2', createAHJRec2.Id);  
        insert createRPRec2;
        PT__c createPtRec3 = DataFactory.returnPT('NewPt3', createRPRec2.Id);         
        PT__c createPtRec4 = DataFactory.returnPT('NewPt4', createRPRec2.Id);
        
        RP__c createRPRec3 = DataFactory.returnRP('NewRp3', createAHJRec2.Id);
        insert createRPRec3;
        PT__c createPtRec5 = DataFactory.returnPT('NewPt5', createRPRec3.Id);
        PT__c createPtRec6 = DataFactory.returnPT('NewPt6', createRPRec3.Id);
        listOfPtRec.add(createPtRec);
        listOfPtRec.add(createPtRec2);
        listOfPtRec.add(createPtRec3);
        listOfPtRec.add(createPtRec4);
        listOfPtRec.add(createPtRec5);
        listOfPtRec.add(createPtRec6);
        insert listOfPtRec;
        AHjRPPTFindDayAging runBatch = new AHjRPPTFindDayAging();
        Database.executeBatch(runBatch);
        
        Test.stopTest();
        Decimal dayAgin = 0;
        for(AHJ__c iterateDayAgn :  [SELECT Day_Aging__c FROM AHJ__c]){
            dayAgin += iterateDayAgn.Day_Aging__c;
        }        
        System.assertEquals(5, dayAgin);
        
    }
    
    
}