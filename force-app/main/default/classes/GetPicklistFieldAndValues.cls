public class GetPicklistFieldAndValues {
    public static void getPicklistFieldValues(){
        List<Schema.DescribeSObjectResult> getField=Schema.DescribeSObjects(new List<String>{'Account'});
        Map<String,List<String>> mapOfPicklist=new  Map<String,List<String>>();        
        for(DescribeSObjectResult singlefield: getField){            
            Map<String,Schema.SObjectField> mapOfField = singlefield.fields.getMap(); 
            
            for(String fieldName : mapOfField.keySet()){
                
                Schema.SObjectField field=mapOfField.get(fieldName);
                
                Schema.DescribeFieldResult fielddescribe=field.getDescribe();
                
                if(fielddescribe.getType()==Schema.DisplayType.PICKLIST){
                    
                    List<String> listOfValue=new List<String>();
                    
                    List<Schema.PicklistEntry>getallValues =fielddescribe.getPicklistValues();
               
                    for(Schema.PicklistEntry listOfsiglepicklistvalues:getallValues){ 
                        
                        listOfValue.add(listOfsiglepicklistvalues.getLabel());                
                    }
                    mapOfPicklist.put(fieldName,listOfValue);
                    
                }
                
            }
        }
        
       /** for(String fieldName :mapOfPicklist.keySet()){
            System.debug('fieldname==>  '+fieldName+'    ====Picklist Values: =>'+mapOfPicklist.get(fieldName));
        }**/
    }
}