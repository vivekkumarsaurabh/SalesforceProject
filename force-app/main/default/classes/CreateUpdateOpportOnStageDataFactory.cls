@isTest
public class CreateUpdateOpportOnStageDataFactory {  
    public static List<Opportunity> createOpp(Integer noOfOppor, String NameOfOpp, String StageName, Date dateOfOpp){
        List<Opportunity> listOfOpp = new List<Opportunity>();        
        for(integer i=1; i <= noOfOppor; i++){
            Opportunity oppCreate = new Opportunity();
            oppCreate.Name = NameOfOpp + i;
            oppCreate.StageName = StageName;
            oppCreate.CloseDate = dateOfOpp;
            listOfOpp.add(oppCreate);
        } 
        return listOfOpp;
    }
    
    public static List<Opportunity> updateOppList(Set<Id> idOfOppor, String NameOfOpp, String stageName, Date dateOfOpp){
        List<Opportunity> listOfOpp = new List<Opportunity>();
        for(Opportunity iterateOpp :  [SELECT Id FROM Opportunity WHERE Id IN : idOfOppor]){
            Opportunity updateOpp = new Opportunity();
            updateOpp.Id =  iterateOpp.Id;
            updateOpp.StageName = stageName;
            updateOpp.Name = NameOfOpp;
            updateOpp.CloseDate = dateOfOpp;
            listOfOpp.add(updateOpp);
        }
        return listOfOpp;
    }
}