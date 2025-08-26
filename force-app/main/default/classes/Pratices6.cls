public class Pratices6 {
    {
       Account acc=new Account();
      acc.Name='NewAccountTest';
       
    // insert acc;
        //System.debug(acc);
        sObject rec=[SELECT id, Name FROM Account WHERE Name='VivekTest' LIMIT 1];
       ID Ids= rec.id;
   
        
        //update record
        
          //System.debug(rec.id);
       // Account a=(Account)rec;
      
       // a.Name='VivekTest';
       // update a;   
       
        //insert related record
        
      /**  Contact con=new Contact();
        con.LastName='New Contact ';
        con.AccountId=Ids;
        insert con; **/
        
       /**      List<Account> r=[SELECT id, Name FROM Account WHERE Name='VivekTest'];        
          
        for(Account c: r){
            System.debug(c);
        } **/
        
        
      /**  List<Account> accli=new List<Account>();
        accli.add(new Account(Name='gharTest'));
        
        insert accli; **/
        
    
        
        

          
        
        
         List<Account> a=[SELECT Id,Name,Rating FROM Account WHERE Name='VivekTest'];
          
        
      // System.debug(a.get(0).name);

     /**   for(Account ac: a){
            System.debug(ac.name);
        } **/
        
        
        //custom Label;
        
   /**     String str=System.Label.MyOrg;
        System.debug(str);**/
        
        //add multiple account records
        
     /**   List<Account> ll=new List<Account>();
        for(integer i=0; i<5; i++){
            ll.add(new Account(Name='TTEST'+i));
        }
            
        insert ll;
**/
        
        //add single record
       // Account onj=new Account(Name='Acc12');
        //insert onj;
        
        
        //upsert
        Account[] acc1=[SELECT ID,Name FROM Account WHERE BillingCity='Muzaffarpur'];
       // System.debug(acc1);
        for(Account d:acc1){
            d.BillingCity='Noida';
        }
        
       // Account al=new Accoun
       // t(name='AcchaAccount',BillingCity='Noida');
        //acc1.add(al);
        try{
           // upsert acc1;
        }catch(DmlException e){
            System.debug('Invalid '+e);
        }
        
        
        List<Account> kl=new List<Account>();
      
            kl.add(new Account(Name='kk'));
          kl.add(new Account(Name='ll'));
         // kl.add(new Account());
        
            //If the account have no maindatory field then that not insert rather insert as well.
      //      Database.insert(kl,false);]
           
        Account masterAcc = [SELECT Id, Name FROM Account WHERE Name='TTEST1' LIMIT 1];
       List<Account> mergeAcc = [SELECT Id, Name FROM Account WHERE Name='kk'];
     //   System.debug(masterAcc);
     //   System.debug(mergeAcc);
       // Contact con=new Contact(FirstName='Testing',LastName='Contact2');
       //  con.AccountId = mergeAcc.Id; 
       // insert con;
        
        merge masterAcc mergeAcc;
        
        
          
    }
  
   
}