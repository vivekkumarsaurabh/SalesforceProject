public class CreateWrapperClassOnAccContact {      
    public static List<AccountContactOpportunityWrapper> returnAccContactOpp(){
        List<AccountContactOpportunityWrapper> listOfAccConOpp = new  List<AccountContactOpportunityWrapper>();
        List<OpportunityWrapper> listOfOppWrap = new List<OpportunityWrapper>();        
        for(Contact iterateRecord:[SELECT Id,Name, AccountId, Account.Name, Account.Rating,(SELECT Name, StageName FROM Opportunities WHERE Name!= NULL) FROM Contact WHERE AccountId != NULL AND NAME != NULL]){
            AccountContactOpportunityWrapper createRec = new AccountContactOpportunityWrapper(iterateRecord.AccountId, iterateRecord.Account.Name, iterateRecord.Account.Rating, iterateRecord.Name, iterateRecord.Id, listOfOppWrap);
            for(Opportunity iterateOppor: iterateRecord.Opportunities){
                OpportunityWrapper createOpporWrap = new OpportunityWrapper(iterateOppor.Name, iterateOppor.StageName);                          
                listOfOppWrap.add(createOpporWrap);  
            }
            listOfAccConOpp.add(createRec); 
        }        
        return listOfAccConOpp;
    }
    
    public static void printData(){
        List<AccountContactOpportunityWrapper> listOfWrapper = returnAccContactOpp();
        System.debug('List Of Wrapper ===> '+listOfWrapper);
    }
    
    public class OpportunityWrapper{    
        public String opportunityName;
        public String stageName;
        public OpportunityWrapper(String opportunityName, String stageName){
            this.opportunityName = opportunityName;
            this.stageName = stageName;
        }        
    }
    
    public class AccountContactOpportunityWrapper{
        public String accountId;
        Public String accountName;
        public String rating;
        public String contactName;
        public String contactId;          
        public List<OpportunityWrapper> OppoWrapper;   
        public AccountContactOpportunityWrapper(String accountId, String accountName, String rating, String contactName, String contactId, List<OpportunityWrapper> OppoWrapper){
            this.accountId = accountId;
            this.accountName = accountName;
            this.rating = rating;
            this.contactName = contactName;
            this.contactId = contactId;
            this.OppoWrapper = OppoWrapper;
        }
        
    }
    
    
    
    public static List<AccountWrapper> returnAccWrapper(){
        List<AccountWrapper> listofAccWrapper = new List<AccountWrapper>();       
            AccountWrapper createWrapRec1 = new AccountWrapper();
            createWrapRec1.name = 'acc1';
            createWrapRec1.rating = 'Hot';
            AccountWrapper createWrapRec2 = new AccountWrapper();
            createWrapRec2.name = 'acc2';
            createWrapRec2.rating = 'Hot';        
            listofAccWrapper.add(createWrapRec1); 
            listofAccWrapper.add(createWrapRec2);           
        return listofAccWrapper;
    }
    
    public class AccountWrapper{
      public String name;
      public String rating;     
    }
    
    /** public static void printData2(){
	AccountWrapper listOfWrapper = returnAccWrapper();
	System.debug('List Of Wrapper ===> '+JSON.serialize(listOfWrapper));
	}**/
}