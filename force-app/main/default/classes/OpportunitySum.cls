public class OpportunitySum {    
    public static void getSum(){
        Map<String, Double> oppOpenMap = new Map<String, Double>();
        Map<String, Double> oppCloseMap = new Map<String, Double>();       
        Map<String, String> accCloseOpenMap = new Map<String, String>();
        for(Opportunity iterateOpp : [SELECT AccountId, StageName, Amount FROM Opportunity WHERE AccountId != NULL AND Amount != NULL AND StageName != NULL]){       
            Double amount;            
            if(iterateOpp.StageName.contains('Closed')){               
                if(oppCloseMap.containsKey(iterateOpp.AccountId)){
                    amount = oppCloseMap.get(iterateOpp.AccountId);
                }                              
                oppCloseMap.put(iterateOpp.AccountId, amount+=Double.valueOf(iterateOpp.Amount));   
            }else{
                if(oppOpenMap.containsKey(iterateOpp.AccountId)){
                    amount = oppOpenMap.get(iterateOpp.AccountId);
                } 
                oppOpenMap.put(iterateOpp.AccountId, amount+=Double.valueOf(iterateOpp.Amount));
            }
        }
        
        Map<String, String> accOpenCloseMap = new Map<String, String>();        
        for(String iterateOpp : oppOpenMap.keySet()){
            if(oppCloseMap.containsKey(iterateOpp)){
                String amt = String.valueOf(oppOpenMap.get(iterateOpp))+'-'+ String.valueOf(oppCloseMap.get(iterateOpp));
                accOpenCloseMap.put(iterateOpp, amt);
            }else{
                String amt = String.valueOf(oppOpenMap.get(iterateOpp))+'-'+'0';
                accOpenCloseMap.put(iterateOpp, amt); 
            }
        }
        System.debug('AccOpenCloseMap===>'+accOpenCloseMap);
    }
    
    public static void openSum(){
        Map<Id, String> openCloseMap = new Map<Id, String>();
        for(AggregateResult iterateOpp : [SELECT AccountId, StageName, SUM(Amount) FROM Opportunity GROUP By AccountId, StageName Having AccountId != NULL AND SUM(Amount)>0]){
            String amount;
            Double closeAmt = 0.0;
            Double openAmt = 0.0;            
            if(openCloseMap.containsKey(String.valueOf(iterateOpp.get('AccountId')))){             
                amount = String.valueOf(openCloseMap.get(String.valueOf(iterateOpp.get('AccountId'))));               
            }
            if(amount != NULL){
                if(String.valueOf(iterateOpp.get('StageName')).contains('Closed')){              
                    List<String> amt = amount.split('-');
                    Double closeval = Double.valueOf(amt[1]);
                    closeAmt = closeval+Double.valueOf(iterateOpp.get('expr0'));  
                    amount = amt[0]+'-'+closeAmt;
                }else{
                    List<String> amt = amount.split('-');
                    Double openVal = Double.valueOf(amt[0]);
                    openAmt = openVal + Double.valueOf(iterateOpp.get('expr0'));
                    amount = openAmt+'-'+amt[1];
                }                 
            }else{                
                if(String.valueOf(iterateOpp.get('StageName')).contains('Closed')){
                    closeAmt = Double.valueOf(iterateOpp.get('expr0'));
                }else{ 
                    openAmt = Double.valueOf(iterateOpp.get('expr0'));
                } 
                amount = String.valueOf(openAmt)+'-'+String.valueOf(closeAmt);               
            } 
            openCloseMap.put(String.valueOf(iterateOpp.get('AccountId')), amount);
        }
        System.debug('openCloseMap====>'+openCloseMap);
    }
    
    
    public static void opportunitySumOfOpenClose(){
        Map<Id, String> openCloseMap = new Map<Id, String>();
        for(AggregateResult iterateOpp : [SELECT AccountId, StageName, SUM(Amount) FROM Opportunity GROUP By AccountId, StageName Having AccountId != NULL AND SUM(Amount)>0]){
            String amount = 0.0+'-'+0.0;
            if(openCloseMap.containsKey(String.valueOf(iterateOpp.get('AccountId')))){             
                amount = String.valueOf(openCloseMap.get(String.valueOf(iterateOpp.get('AccountId'))));               
            }
            if(String.valueOf(iterateOpp.get('StageName')).contains('Closed')){   
                amount = amount.split('-')[0]+'-'+String.valueOf(Double.valueOf(amount.split('-')[1])+Double.valueOf(iterateOpp.get('expr0')));
            }else{
                amount = String.valueOf(Double.valueOf(amount.split('-')[0])+Double.valueOf(iterateOpp.get('expr0')))+'-'+String.valueOf(amount.split('-')[1]);
            }  
            openCloseMap.put(String.valueOf(iterateOpp.get('AccountId')), amount);
        }
        System.debug('openCloseMap====>'+openCloseMap);
    } 
    
    public static void moreshorter(){        
        Map<Id, String> openCloseMap = new Map<Id, String>();
        for (AggregateResult iterateOpp : [SELECT AccountId, StageName, SUM(Amount) FROM Opportunity GROUP BY AccountId, StageName HAVING AccountId != NULL AND SUM(Amount) > 0]) {
            String amount = openCloseMap.containsKey(String.valueOf(iterateOpp.get('AccountId'))) ? openCloseMap.get(String.valueOf(iterateOpp.get('AccountId'))) : '0.0-0.0';    
            Double openAmount = Double.valueOf(amount.split('-')[0]);
            Double closeAmount = Double.valueOf(amount.split('-')[1]);    
            if (String.valueOf(iterateOpp.get('StageName')).contains('Closed')) {
                closeAmount += Double.valueOf(iterateOpp.get('expr0'));
            } else {
                openAmount += Double.valueOf(iterateOpp.get('expr0'));
            }    
            amount = openAmount + '-' + closeAmount;
            openCloseMap.put(String.valueOf(iterateOpp.get('AccountId')), amount);
        }
        System.debug('openCloseMap--->'+openCloseMap);
    }
    
    public static void opportunitySumOfOpenCloseMoreShorter(){
        Map<Id, String> openCloseMap = new Map<Id, String>();
        for(AggregateResult iterateOpp : [SELECT AccountId, StageName, SUM(Amount) FROM Opportunity GROUP By AccountId, StageName Having AccountId != NULL AND SUM(Amount)>0]){
            String amount = openCloseMap.containsKey(String.valueOf(iterateOpp.get('AccountId'))) ? openCloseMap.get(String.valueOf(iterateOpp.get('AccountId'))) : '0.0-0.0'; 
            if(String.valueOf(iterateOpp.get('StageName')).contains('Closed')){   
                amount = amount.split('-')[0]+'-'+String.valueOf(Double.valueOf(amount.split('-')[1])+Double.valueOf(iterateOpp.get('expr0')));
            }else{
                amount = String.valueOf(Double.valueOf(amount.split('-')[0])+Double.valueOf(iterateOpp.get('expr0')))+'-'+String.valueOf(amount.split('-')[1]);
            }  
            openCloseMap.put(String.valueOf(iterateOpp.get('AccountId')), amount);
        }
        System.debug('openCloseMap====>'+openCloseMap);
    } 
}