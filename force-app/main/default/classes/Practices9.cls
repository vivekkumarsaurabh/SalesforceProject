public class Practices9 {

    public static void methodss(){
    
        //clone()
    /**    List<Account> kk=[SELECT Name FROM Account WHERE Name='Ram\'s'];
      List<Account> pp=kk.clone();
        System.debug(pp); **/
        
       // insert pp;
        
        //FOR VIEW
        
        List<Account> acc=[SELECT Id, Name FROM Account LIMIT 2 FOR VIEW];
        for(Account acc1:acc){
           // System.debug(acc); 
        }
     /**   Account acc2=[SELECT Name FROM Account WHERE Name='Ram\'s' FOR UPDATE];
         acc2.Name='Ram\'sVivek';
        
        update acc2;**/
      
        
  /**    Account acc12=new Account(Name='NewAcc');
           insert acc12;
        Contact co=new Contact(LastName='ContactAcc');
        co.AccountId=acc12.id;
      
        insert co;**/
        
    
        
    //Account Create and Related Contact Create 
    /**    List<Account>AccList = new List<Account>();
        for(Integer i=1; i<=5; i++){
            Account acc10= new Account();
            acc10.Name = 'Vi'+ i ;
            AccList.add(acc10);
        } insert AccList;
        List<Contact> conList= new List<Contact>();
  
        Integer k=0;
      for(Account acc15 : AccList){
            Contact con = new contact();
            con.LastName = 'Ku'+k;
            con.AccountId = acc15.Id;
            conList.add(con);
          k++;
        } insert conList; **/
        
       
        
      /**  List<Contact> li=[SELECT Contact.Account.Name,Account.Name FROM Contact LIMIT 5];
        for(Contact k:li){
            System.debug(k);
        }**/
        
     /** List<sObject> ll=[SELECT Name, (SELECT LastName,assign_to_Contact__c FROM Contacts) FROM Account];
        for(sObject c: ll){
            System.debug(c);
        }**/
        
        //Custom Object Parent to Child
     List<Account> o= [SELECT Name, (SELECT LastName,assign_to_Contact__c FROM Contacts) FROM Account LIMIT 10];
        integer count=0;
        for(Account k:o){
             System.debug(k);
            count++;
        }
      
        
        
        //Parent-to-Child behalf of relationshipName.FieldName
     /**  List<Hospital2__c> hos=[SELECT Name,(SELECT Name FROM doctors1__r) FROM Hospital2__c];
        
        for(Hospital2__c j: hos)
            System.debug(j);**/
       
        
        //Child-to-Parent  childName.ParentName__r.Field
    /**    List<Doctor__c> do1=[SELECT Name,Doctor__c.Hospital2__r.Name FROM Doctor__c];
        for(Doctor__c c: do1){
            System.debug(c);
        }**/
        
  //   List<Event> d=[SELECT Id, What.Name FROM Event];
      //  System.debug(d);
  //  List<Event> d1=[SELECT TYPEOF What WHEN Account THEN Phone, NumberOfEmployees WHEN Opportunity THEN Amount, CloseDate ELSE Name, Email END FROM Event];
   //    System.debug(d1);
        
       // multi-level ERROR Parent-to-Child Because 1-level Access
   //    List<sObject> d2=[SELECT Name,(SELECT LastName, (SELECT Id FROM Cases) FROM Contacts) FROM Account];
       // System.debug(d2);
        
      //multi - level Child-to-Parent
   //   List<Case> ca=[SELECT Id,Case.Contact.Account.Rating  FROM Case]; 
      //  System.debug(ca);
      //  
      List<sObject> l4=[SELECT COUNT_DISTINCT(Name)CountDistinct, Count(Name) TotalName FROM Account];
       // System.debug(l4);
       String str='SELECT Name FROM Account';
        List<sObject> acc2=Database.query(str);
       // System.debug(acc2);
        
        
        
        
        
        
     
  
    }
    {
        List<Employee__c> employeeRecord = [SELECT Name,Employee__c.Office__r.Name,Employee__c.Office__r.Floor__r.Name,Employee__c.Office__r.Floor__r.Building__r.Name FROM Employee__c];
        for(Employee__c em : employeeRecord){
        System.debug('EM Name ==> '+em.Name );
        System.debug('OF Name ==> '+ em.Office__r.Name );
        System.debug('FL Name ==> '+ em.Office__r.Floor__r.Name );
        System.debug('BD Name ==> '+em.Office__r.Floor__r.Building__r.Name );
        }
    }
    
   
}