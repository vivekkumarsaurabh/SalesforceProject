public class Practices8 {

    public static void methodExample(){
        List<Task> lo=[SELECT Id, Status, Subject, TYPEOF who WHEN Contact THEN Name WHEN Lead THEN Name, Phone END FROM TASK];
       
        //System.debug(lo);
        for(Task k: lo){
            //System.debug(k);
        }
        
        //ORDER BY Ascending
     /**   List<Account> acc=[SELECT Id, Name FROM Account ORDER BY Name ASC];
        for(Account ac : acc){
            System.debug(ac);
        }
        **/
     Integer l=[SELECT COUNT() FROM Account];
      //  System.debug(l);
        
        //ORDER BY Decending
       /**   List<Account> acc=[SELECT Id, Name FROM Account ORDER BY Name DESC];
        for(Account ac : acc){
            System.debug(ac);
        } **/
        
        //ORDER BY Rating
        
      /**     List<Account> acc=[SELECT Id, Name,CreatedDate,Rating FROM Account ORDER BY CreatedDate];
        for(Account ac : acc){
            System.debug(ac);
        } **/
        
        //LIMIT
      /**         List<Contact> con=[SELECT Id, Name FROM Contact WHERE Name LIKE 'C%' LIMIT 5];
        for(Contact co : con){
            System.debug(co);
        }  **/
        
      List<Account> j=[SELECT Name,Rating FROM Account WHERE Rating='Hot' ORDER BY Name ASC NULLS LAST LIMIT 125];
        for(Account ac: j){
         //   System.debug(ac);
        }

       
        /**List<Account> o=[SELECT Id, Name FROM Account WHERE Name LIKE 'V___k'];
        for(Account g : o){
            System.debug(g);
        }**/
        
/**        List<String> str=new List<String>{'a%','b%'};
            List<Account> klist=[SELECT Id, Name FROM Account WHERE Name LIKE:str];
        for(Account d: klist){
            System.debug(d);
        }**/
           
        List<Account> s=[SELECT Id,Name,BillingCity FROM Account WHERE Name Like 'vi%' AND(BillingCity='Patna,Bihar') ];
        //System.debug(s);
        
         List<Account> a=[SELECT Id,Name,BillingCity FROM Account WHERE BillingState IN ('Muzaffarpur','Patna')];
      //  System.debug(a);
        
        
      List<Account> k=[SELECT Id, Name FROM Account WHERE Id IN (SELECT AccountId FROM Opportunity WHERE StageName = 'Closed Lost')];
       //System.debug(k); 
        
        List<Account> o=[SELECT Id,Name FROM Account WHERE CreatedDate=YESTERDAY];
       // System.debug(o);
        
        //What.Type
       /** List<Task> ss=[SELECT Id,Opportunity.Name FROM Task WHERE What.Type IN ('Account', 'Opportunity')];
        for(Task t : ss){
           System.debug(t); 
        }**/
        
        
        //Multi-Picklist
       List<Hospital__c> s1=[SELECT Id, Name FROM Hospital__c WHERE Disease__c = 'Polio;Malaria'];
      //  System.debug(s1);

     List<Hospital__c> s2=[SELECT Id, Name  FROM Hospital__c WHERE Patient__c = null];
        //System.debug(s2);
 
      //  List<Hospital__c> s3=[SELECT Id, Name FROM Hospital__c WITH DATA CATEGORY Patient_Address__c AT ];
        
           Integer s4=[SELECT Count() FROM Hospital__c];
        //System.debug(s4);
        
 /**     List<sObject> s5=[SELECT Rating, COUNT(Name) Myrating FROM Account GROUP BY Rating];
        for(sObject k1:s5){
            System.debug(k1);
        }
        
      //GROUP BY ROLLUP
        List<sObject> s6=[SELECT LeadSource, GeocodeAccuracy, COUNT(Name) cnt FROM Lead GROUP BY ROLLUP(LeadSource, GeocodeAccuracy)];
        for(sObject kk: s6){
            System.debug(kk);
        }
        **/
        
        //GROUP
    List<sObject> s7=[SELECT Type, Name,GROUPING(Type) grpType, GROUPING(Name) grpCty,COUNT(id) accts FROM Account GROUP BY CUBE(Type, Name)
ORDER BY GROUPING(Type), GROUPING(Name)];
       // for(sObject k7: s7){
         //   System.debug(k7);}
         //   
         
        
       
     /**   List<sObject> s8=[SELECT Name n, MAX(Amount) max FROM Opportunity GROUP BY Name];
        for(sObject l1: s8)
              System.debug(l1);  
         **/
        
      /**  List<sObject> s9=[SELECT Id,Name,Rating FROM Account GROUP BY ROLLUP(Id,Name,Rating)];
        for(sObject l3: s9){
            System.debug(l3);
        }
**/        
     /**    List<sObject> s10=[SELECT Id FROM Account GROUP BY Name];
        for(sObject l4: s10){
            System.debug(l4);
        }
        
        **/
        
   /**  List<sObject> s11=[SELECT Name,GROUPING(Rating)grp ,GROUPING(Name) na FROM Account GROUP BY CUBE(Name, Rating) HAVING Count(Id) > 1];
        for(sObject d: s11){
         //   System.debug(d);
        }
        
         List<sObject> s12=[SELECT Name FROM Account GROUP BY Name HAVING Name='Vivek'];
        for(sObject d: s12){
            System.debug(d);
        }**/
        
    // String str='\'Vivek\'';
    // System.debug(str);
    
        List<Account> s13=[SELECT Name, RecordType.DeveloperName  FROM Account WHERE RecordType.DeveloperName='Account_data'];
        for(Account c: s13){
           // System.debug(c);
        }
        List<sObject> s14=[SELECT Room_Type__c,SUM(Patient__c) s  FROM Hospital__c GROUP BY Room_Type__c];
        for(sObject f:s14){
            //System.debug(f.get('s'));
           // System.debug(f);
        }
        
        List<sObject> s15=[SELECT Room_Type__c,Patient_Email__c,SUM(Patient__c) k,SUM(Doc_Ammount__c) s FROM Hospital__c GROUP BY ROLLUP (Room_Type__c,Patient_Email__c)];
        for(sObject g: s15){
            System.debug(g);
        }  
        
        List<sObject> s16=[SELECT Room_Type__c,Patient_Email__c,SUM(Patient__c) k,SUM(Doc_Ammount__c) s FROM Hospital__c GROUP BY CUBE (Room_Type__c,Patient_Email__c)];
        for(sObject k23:s16){
          //  System.debug(k23);
        }
        
        
        
           
    } 
}