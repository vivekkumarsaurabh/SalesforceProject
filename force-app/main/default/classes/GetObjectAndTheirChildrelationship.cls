public class GetObjectAndTheirChildrelationship {
    
    public static void getObjectChild(){        
        Map<String,List<SObjectType>> mapOfAllObjectWithTheirChild=new Map<String,List<SObjectType>>();        
        Map<String,Schema.SObjectType> getAllObject= Schema.getGlobalDescribe();        
        for(String key: getAllObject.keySet()){
            List<ChildRelationship> listOfObject = new  List<ChildRelationship>();
            Schema.DescribeSObjectResult R = getAllObject.get(key).getDescribe();
            List<Schema.ChildRelationship> C = R.getChildRelationships();
            List<SObjectType> listOfChildObjectName =new List<SObjectType>();            
            for(Schema.ChildRelationship g1: C){
                if(g1.getChildSObject()!=NULL){
                    listOfChildObjectName.add(g1.getChildSObject());                    
                    //System.debug(g1.getRelationshipName());
                }                 
            }
            if(listOfChildObjectName.isEmpty()){                
            }else{
                mapOfAllObjectWithTheirChild.put(key,listOfChildObjectName); 
            }           
        }        
        for(String k: mapOfAllObjectWithTheirChild.keySet()){
            System.debug('Parent Class ==>'+k+'    Child Classes :  '+mapOfAllObjectWithTheirChild.get(k));
        }     
    }
    
    public static void dynamicChildObjectList(List<String> ParentObjectName){
        Map<String,List<SObjectType>> mapOfAllObjectWithTheirChild=new Map<String,List<SObjectType>>();
        for(String oneObj :ParentObjectName){
            List<String> listObj = new List<String>();
            listObj.add(oneObj);
           List<Schema.DescribeSObjectResult> listOfObject  = Schema.describeSObjects(listObj);            
            for(DescribeSObjectResult sigleObject: listOfObject){           
                List<Schema.ChildRelationship> getChild = sigleObject.getChildRelationships();                
                List<SObjectType> listOfChildObjectName =new List<SObjectType>();                
                for(Schema.ChildRelationship oneChild: getChild){                 
                    if(oneChild.getChildSObject()!=NULL){
                        listOfChildObjectName.add(oneChild.getChildSObject());
                    }        
                }                
                mapOfAllObjectWithTheirChild.put(oneObj,listOfChildObjectName); 
            }
        }          
        for(String key :mapOfAllObjectWithTheirChild.keySet()){
            System.debug(key+'==>'+mapOfAllObjectWithTheirChild.get(key));
        }
   }
    
    
    public static void getAllChildfromParent(List<String> ObjectName){
        Map<String,List<String>> mapOfAllObjectWithTheirChild=new Map<String,List<String>>();       
        for(String singleObj: ObjectName){
            SObjectType sObj=Schema.getGlobalDescribe().get(singleObj);
            Schema.DescribeSObjectResult desObj=sObj.getDescribe();
            List<Schema.ChildRelationship> chlRelation = desObj.getChildRelationships();
            List<SObjectType> listOfChildObjectName =new List<SObjectType>();            
            for(Schema.ChildRelationship child: chlRelation){                  
                 listOfChildObjectName.add(child.getchildSObject());                
            } 
            List<String> strOfObject=new List<String>();
            for(SObjectType singleObjType: listOfChildObjectName){
                String str=String.valueOf(singleObjType);
                if(ObjectName.contains(str)){
                    strOfObject.add(str);
                }                
          }
           mapOfAllObjectWithTheirChild.put(singleObj,strOfObject);
            listOfChildObjectName.clear();
        }
        for(String key: mapOfAllObjectWithTheirChild.keySet()){
            System.debug(key+'====>'+mapOfAllObjectWithTheirChild.get(key));
      }
   } 
}