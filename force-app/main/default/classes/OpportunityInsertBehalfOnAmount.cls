public Class OpportunityInsertBehalfOnAmount{
    public static void beforeInsertmethod(List<Opportunity> opportunityList){
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id, Integer> accountIdAmmountMap = new Map<Id, Integer>();
        for(Opportunity iterateOpp : opportunityList){
            if(iterateOpp.Amount < 2000){
                iterateOpp.addError('the Opportunity have less than 2000 amount');
            }
            accountIdSet.add(iterateOpp.AccountId);
        }
        
        if(!accountIdSet.isEmpty()){
            for(Opportunity iterateOpp : [SELECT Id, AccountId, Amount FROM Opportunity WHERE AccountId IN :accountIdSet AND Amount != NULL]){
                Integer count = 0;
                if(accountIdAmmountMap.containsKey(iterateOpp.AccountId)){
                    count = accountIdAmmountMap.get(iterateOpp.AccountId);
                }
                accountIdAmmountMap.put(iterateOpp.AccountId, Integer.valueOf(iterateOpp.Amount)+count);
            }
        }
        
        for(Opportunity iterateOpp : opportunityList){
            if(accountIdAmmountMap.containsKey(iterateOpp.AccountId)){
                iterateOpp.Amount = iterateOpp.Amount+accountIdAmmountMap.get(iterateOpp.AccountId);
            }
        }
        
    }
    
    
    public static void beforeUpdatemethod(List<Opportunity> opportunityList){
        
        
    }
    
}