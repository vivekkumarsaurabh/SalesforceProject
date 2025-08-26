public class FieldSetClass {
    public static void fieldsetmethod(){
        
        Schema.DescribeSObjectResult d = Account.sObjectType.getDescribe();
        Map<String, Schema.FieldSet> FsMap = d.fieldSets.getMap();
      /**  for(FieldSet fieldSetName:FsMap.values()){            
             system.debug(fieldSetName);  
           // System.debug(fieldSetName.getDescription());
        }**/
     /**   for(String key : FsMap.keySet()){
            System.debug(key);
        }**/
        
        List<Schema.FieldSetMember> fields =Schema.SObjectType.Account.fieldSets.getMap().get('wm_client_profile_inv_summary').getFields();
        for(FieldSetMember f: fields){
          //  System.debug(f.getLabel());
        }
        
List<Schema.FieldSetMember> fie = Schema.SObjectType.Account.fieldSets.wm_client_profile_inv_summary.getFields();
        for(FieldSetMember f: fie){
          //  System.debug(f.getDBRequired());
          //System.debug(f.getLabel());
            //System.debug(f.getSObjectField());
        }
        
        Schema.DescribeFieldResult F = Account.Rating.getDescribe();
        List<Schema.PicklistEntry> P = F.getPicklistValues();
        for(PicklistEntry pick: P){
            //System.debug(pick.getLabel());
        } 
        

        
    Schema.DescribeFieldResult fieldResult = Account.Rating.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for(Schema.PicklistEntry pickListVal : ple){
         //  System.debug(pickListVal);
		//pickListValuesList.add(pickListVal.getLabel());
		}     
        
      //  Map<String,Schema.SObjectField> mapOfField = Account.fields.getMap();
      
      //  Schema.DescribeSObjectResult res=Account.getDescribe();
        
        
        List<Schema.DescribeSObjectResult> de=Schema.DescribeSObjects(new List<String>{'Account'});
      Map<String,List<String>> mapOfPicklist=new  Map<String,List<String>>();
        
        for(DescribeSObjectResult li: de){
             Map<String,Schema.SObjectField> mapOfField = li.fields.getMap();
            
            for(String fieldName : mapOfField.keySet()){
               Schema.SObjectField field=mapOfField.get(fieldName);
               Schema.DescribeFieldResult f1=field.getDescribe();
             
               String str=String.valueOf(f1.getType());
                if(str=='PICKLIST'){
                     List<String> listOfValue=new List<String>();
                  List<Schema.PicklistEntry> res  = f1.getPicklistValues();
                    for(Schema.PicklistEntry ll:res){           
                          listOfValue.add(ll.getLabel());                
                    }
                      mapOfPicklist.put(fieldName,listOfValue);
              
                }
              
            }
        }
        
     for(String fieldName :mapOfPicklist.keySet()){
         System.debug('fieldname==>  '+fieldName+'    ====Picklist Values: =>'+mapOfPicklist.get(fieldName));
     }
                     
        
        
        
    }
}