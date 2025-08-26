public class Practice2 {
    public static Integer val=100;
    
    
    public void method(){
        //val=200;
        //List<Schema.FieldSetMember> fieldSetMemberList = Schema.SObjectType.Contact.fieldSets.getMap().get('LastName').getFields();
        //List<Schema.sObjectField> listStr = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().values();
        // Set<String> listStr = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().keySet();
        Set<String> allFields = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().keySet();
        String header = String.join(allFields,',');
          //System.debug(header);
        // System.debug(listStr);
        
      String listOfCOn ='SELECT '+header+' FROM Contact';
      List<Contact> licon =  Database.query(listOfCOn);
        
      for(Contact i : licon){
            System.debug(i);
        }
    }
    public void method2(){
        //System.debug(val);
        String k = 'vk,fk,dd';
        if(k.contains(',')){
            k = '%'+k+'%';
            System.debug(k);
        }
    }
    
    Static{
        System.debug('vivek');
    }
    Static{
        System.debug('kumar');
    }
}