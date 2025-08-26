public with sharing class FillBillAddOfConReWIthAccAfterUpdate {
    public static void fillBillAddOfcon(List<Account> acc){   
        List<Contact> listOfContact=new List<Contact>();
        Account singleAcc=acc.get(0); 
        for(Contact singleCon:[SELECT Id,AccountId,	MailingAddress FROM Contact WHERE AccountId IN : acc]){               
            singleCon.MailingCity=singleAcc.BillingCity;   
            singleCon.MailingCountry=singleAcc.BillingCountry;
            singleCon.MailingState=singleAcc.BillingState;
            singleCon.MailingStreet=singleAcc.BillingStreet;                             
            listOfContact.add(singleCon);
        }
        update listOfContact;
    }
}