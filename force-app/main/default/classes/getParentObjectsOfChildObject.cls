public class getParentObjectsOfChildObject {
    
    public static void getParentObjectOfChildObj(){        
        Map<String,Schema.SObjectType> getAllObject= Schema.getGlobalDescribe();
        Map<String,List<sObjectType>> getAllParentObject=new  Map<String,List<sObjectType>>();         
        for(String childObject: getAllObject.keySet()){            
            for(Schema.SobjectField getField: getAllObject.get(childObject).getDescribe().fields.getMap().Values())
            {   
                List<SObjectType> listofParentObject=new List<SObjectType>();
                if(getField.getDescribe().getType() == Schema.DisplayType.REFERENCE)
                {
                    if(getAllParentObject.containsKey(childObject)){                
                        listofParentObject=getAllParentObject.get(childObject);  
                    }                    
                  for(SObjectType singleObject:getField.getDescribe().getReferenceTo()){
                        listofParentObject.add(singleObject);  
                    }
                    getAllParentObject.put(ChildObject,getField.getDescribe().getReferenceTo());                    
                } 
            }                 
       }   
        for(String Key : getAllParentObject.keySet()){
            System.debug('childObject ==>  '+key+'  Parent Objects ==>'+getAllParentObject.get(key));
        }        
    }
    
    public static void getAllParentObjectDynamic(List<String> ObjectName){
        Map<String,List<SObjectType>> mapOfparentObjects=new  Map<String,List<SObjectType>>();
        for(String singleObj: ObjectName){
            List<String> listofParentObject=new List<String>();
            SObjectType sObj=Schema.getGlobalDescribe().get(singleObj);
            List<SObjectType> sOb=new List<SObjectType>();
            for(Schema.SobjectField getField: sObj.getDescribe().fields.getMap().Values())
            {
                if(getField.getDescribe().getType() == Schema.DisplayType.REFERENCE)
                {
                    sOb.addAll(getField.getDescribe().getReferenceTo());                               
                }
            }
            List<SObjectType> listOfcontanObject=new List<SObjectType>();
            for(String singlenm: ObjectName){
                SObjectType var=((SObject)Type.forName(singlenm).newInstance()).getSObjectType();
                if(sOb.contains(var)){
                    listOfcontanObject.add(var);
                }
            }          
            listofParentObject.clear();
            mapOfparentObjects.put(singleObj,listOfcontanObject);            
        }
        for(String key : mapOfparentObjects.keySet()){
            System.debug(key+'===>'+mapOfparentObjects.get(key));
        }
        
    }
}