public class OpporContractInsertAcordToRecordType {
    public static Id returnRecordTypeId(String objName, String recordTypeName){       
        Id idOfRecordType = Schema.getGlobalDescribe().get(objName).getDescribe().getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
        return idOfRecordType;
    }  
    
    public static Opportunity createOpportunity(Id idOfContract, Id recordTypeId){
        Opportunity createOppor = new Opportunity();
        createOppor.Contract__c = idOfContract;
        createOppor.Name = 'Oppor test1';
        createOppor.StageName = 'Prospecting';
        createOppor.CloseDate = date.Today();
        createOppor.RecordTypeId = recordTypeId;      
        return createOppor;
    }  
    
    public static void insrtContractOpporOnRecor(List<Contract> newContractList){   
        List<Opportunity> Opporlist = new List<Opportunity>();
        for(Contract iterateContract : newContractList){             
            if(iterateContract.RecordTypeId == returnRecordTypeId('Contract','HAVC_Install')){               
                Opportunity newOppor = createOpportunity(iterateContract.Id, returnRecordTypeId('Opportunity','HAVC_Install'));
                Opporlist.add(newOppor); 
                if(iterateContract.Are_You_Interested_In_PM__c){                   
                    Opportunity newOpporSec = createOpportunity(iterateContract.Id, returnRecordTypeId('Opportunity','HAVC_PM'));
                    Opporlist.add(newOpporSec);                                    
                }     
            }else{
                Opportunity newOpporThrd = createOpportunity(iterateContract.Id, returnRecordTypeId('Opportunity','HAVC_PM'));
                Opporlist.add(newOpporThrd); 
            }
        }
        insert Opporlist;        
    }  
    
    public static void updateContractRecord(List<Contract> newContractList){
        Map<Id, List<Id>> mapOfOpportunity = new Map<Id, List<Id>>(); 
        Set<Id> contractId = new Set<Id>();
        for(Contract itrateContract : newContractList){
            contractId.add(itrateContract.Id);
        }
        Set<Id> setOfRecordTypeOfOppor = new Set<Id>();
        setOfRecordTypeOfOppor.add(returnRecordTypeId('Opportunity','HAVC_Install'));
        setOfRecordTypeOfOppor.add(returnRecordTypeId('Opportunity','HAVC_PM'));        
        for(Opportunity itrateOpportunity : [SELECT RecordTypeId, Contract__c FROM Opportunity WHERE Contract__c IN : contractId AND RecordTypeId IN :setOfRecordTypeOfOppor]){
            List<Id> recordTypeList = new List<Id>();
            if(mapOfOpportunity.containsKey(itrateOpportunity.Contract__c)){
                recordTypeList = mapOfOpportunity.get(itrateOpportunity.Contract__c);
            }
            recordTypeList.add(itrateOpportunity.RecordTypeId);
            mapOfOpportunity.put(itrateOpportunity.Contract__c, recordTypeList);            
        }      
        
        List<Opportunity> opporList = new List<Opportunity>();        
        for(Contract itrateContract : newContractList){  
            if(mapOfOpportunity.containsKey(itrateContract.Id)){                
                if(mapOfOpportunity.get(itrateContract.Id).contains(returnRecordTypeId('Opportunity', 'HAVC_Install')) && !mapOfOpportunity.get(itrateContract.Id).contains(returnRecordTypeId('Opportunity', 'HAVC_PM'))){
                    Opportunity createOpp = createOpportunity(itrateContract.Id, returnRecordTypeId('Opportunity', 'HAVC_PM'));
                    opporList.add(createOpp);                                         
                }else if(mapOfOpportunity.get(itrateContract.Id).contains(returnRecordTypeId('Opportunity', 'HAVC_PM')) && !mapOfOpportunity.get(itrateContract.Id).contains(returnRecordTypeId('Opportunity', 'HAVC_Install'))){
                    Opportunity createOppSec = createOpportunity(itrateContract.Id, returnRecordTypeId('Opportunity', 'HAVC_Install'));
                    opporList.add(createOppSec);
                }
                
            }         
  
        }
        
        insert opporList;  
    }
    
    
}