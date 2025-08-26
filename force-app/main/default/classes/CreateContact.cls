public class CreateContact {
    public static void method(){
        List<Contact> conRec = new List<Contact>();    
        for(Integer i=1; i<=202; i++){
            Contact newCon = new Contact();
            newCon.AccountId = '0015j00001EJs4vAAD';
            newCon.LastName ='ConTest'+i;
            conRec.add(newCon);
        }
       // insert conRec; 
        
        for(Account con : [SELECT Id,(SELECT Id  FROM Contacts) FROM Account WHERE Id ='0015j00001EJs4vAAD']){
            System.debug(con.Contacts.size());
        }
    }
}