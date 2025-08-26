public class CreateUpdateOpportOnStage {
    public static void createOpporOnStage(List<Opportunity> NewOpporlist){
        for(Opportunity oppIterate : NewOpporlist){
            if(oppIterate.StageName != 'Prospecting'){
                oppIterate.addError('Opportunity stage Name is not Prospecting');
            }
        }
    }
    
    public static Map<String,String> mapOfStageName = new Map<String,String>{ //create dynamic map
        'Prospecting'=>'Qualification',
            'Qualification'=>'Needs Analysis',
            'Needs Analysis'=>'Value Proposition',
            'Value Proposition'=>'Id. Decision Makers',
            'Id. Decision Makers'=>'Perception Analysis',
            'Perception Analysis'=>'Proposal/Price Quote',
            'Proposal/Price Quote'=>'Negotiation/Review',
            'Negotiation/Review'=>'Closed Won',
            'Closed Won'=>'Closed Lost'        
            };
                
                public static void updateOpporOnStage(List<Opportunity> newOpporlist, Map<Id, Opportunity> oldOpporMap){ 
                    for(Opportunity IterateOppor: newOpporlist){                       
                        if(IterateOppor.StageName != mapOfStageName.get(oldOpporMap.get(IterateOppor.Id).StageName)){                          
                            IterateOppor.addError('Opportunity must be  '+mapOfStageName.get(oldOpporMap.get(IterateOppor.Id).StageName));
                        }
                    }
                }
    
}