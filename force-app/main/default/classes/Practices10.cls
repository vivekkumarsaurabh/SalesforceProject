public class Practices10 {
     //Dynamic Query
    public static void methodsQuery(String ObjectName,List<String> ObjectField){
  /**     // String q='SELECT Name FROM '+str;
     // String q='SELECT Name FROM '+str+' WHERE Name ='+st;
      //  List<sObject> lis=Database.query('SELECT Name FROM '+str+' WHERE Name ='+st);
        for(sObject li: lis){
           // System.debug(li);
        }**/
        
    /**    //Using Dynamic Variable
        String s='vivek';
     // List<sObject> ll=Database.query('SELECT Id,Name FROM '+str+' WHERE Name= :s');
        for(sObject li1:ll){
          //  System.debug(li1);
        }**/
          
       /** Account a=new Account(Name='NewAcc12',Phone='1213');
        String st1=a.Name;
       // insert a;
     //   Account p=Database.query('SELECT Name,Id,Phone FROM '+str+' WHERE Name=:st1 LIMIT 1');
        //System.debug(p); **/
       
        
      // String quer='SELECT Name FROM '+obj+' WHERE Name Like \'%'+st+'%\'';
        //System.debug('quer---->'+quer);
        /*List<sObject> list3= Database.query('SELECT Name FROM '+obj+' WHERE Name Like \'%'+st+'%\'');
        for(sObject k: list3){
            System.debug(k);
        }*/
         
      
 /** List<String> qw=new List<String>{'','','vivek','','','dsfs','','','sdfs',' ', ' ',' ',' ',' '};
      String sg=qw.toString().remove('(').remove(')').remove(',');
       // System.debug(sg);
  List<String> ss=sg.split(' ');
        //System.debug(sg);
     String y=String.join(ss,',');
        System.debug(y);**/
        
       
        
       // String dd=g.toString();
       // System.debug(String.join(g,','));
     
//     String sl=f1.toString().remove('(').remove(')').remove(' ');
      
       // List<String> o=sl.split(',');
      // System.debug(o);

       // System.debug(sl);
       // 
       
       
        
        
             List<String> NewListOfField=new List<String>();
            for(String SigleField:ObjectField){
                if(!String.isBlank(SigleField))
                   NewListOfField.add(SigleField);                       
            }        
             String query='SELECT '+String.join(NewListOfField,',')+' From '+ObjectName+' LIMIT 10';         
            List<sObject> ListOfAccounts=Database.query(query);
            for(sObject SigleIttration:ListOfAccounts){
                System.debug(SigleIttration);
            }
            
            
       
    }
    public static void DynamicParentToChildQuery(String MainObjectName,String ChildObjectName,List<String> ChildFieldName,List<String> ParentFieldName){
        
                List<String> NewListOfField=new List<String>();
            for(String SigleField:ParentFieldName){
                if(!String.isBlank(SigleField))
                   NewListOfField.add(SigleField);                       
            }   
             List<String> NewListOfField2=new List<String>();
            for(String SigleField2:ChildFieldName){
                if(!String.isBlank(SigleField2))
                   NewListOfField2.add(SigleField2);                       
            }   
//SELECT Name, (SELECT LastName,assign_to_Contact__c FROM Contacts) FROM Account        
integer l=10;
        String query='SELECT '+String.join(NewListOfField,',')+',( SELECT '+String.join(NewListOfField2,',')+' FROM '+ChildObjectName+') FROM '+MainObjectName+' LIMIT 10';
        
        List<sObject> ListOfAccounts=Database.query(query);
        /** for(sObject SigleIttration:ListOfAccounts){
                System.debug(SigleIttration);
            }**/
      
        //Dynamic Itterable
       for(sObject SigleIttration:ListOfAccounts){
                System.debug('Parents  -->'+SigleIttration);
                for(sObject Items: SigleIttration.getSObjects(ChildObjectName)){
                    System.debug('Childs -->'+Items);
                }
            }
    }
    
    
    public static void DynamicChildToParent(String ObjectName,List<String> FieldNames){
               List<String> NewListOfField=new List<String>();
            for(String SigleField:FieldNames){
                if(!String.isBlank(SigleField))
                   NewListOfField.add(SigleField);                       
            }  
     
        String query='SELECT '+String.join(NewListOfField,',')+' FROM '+ObjectName;
         List<sObject> ListOfAccounts=Database.query(query);
        for(sObject Items: ListOfAccounts){
            System.debug(Items);
        }
        
    }
    
  
    
}