public class dateFormatDateLiterals {

    public static void dateliteralsMethods(){
        //  List<Account> li=[SELECT Id FROM Account WHERE CreatedDate = TODAY];
        //  
        //  
  //  List<Opportunity> li=[SELECT Id FROM Opportunity WHERE CloseDate <= TOMORROW];    
    
       // List<sObject> li=[SELECT Id FROM Account WHERE CreatedDate = LAST_WEEK];
        
        
       // List<sObject> li=[SELECT Id FROM Account WHERE CreatedDate = LAST_90_DAYS];
     
      //  List<sObject> li=[SELECT Id FROM Account WHERE CreatedDate = LAST_N_DAYS:20];
            
       // List<sObject> li =[SELECT CALENDAR_YEAR(CreatedDate) amt,SUM(Amount) sumOfAmt FROM Opportunity GROUP BY CALENDAR_YEAR(CreatedDate)];
        
      //  List<sObject> li=[SELECT Name,DAY_IN_MONTH(CreatedDate) FROM Opportunity GROUP BY DAY_IN_MONTH(CreatedDate),Name];
        
    //  List<sObject> li =[SELECT FORMAT(amount) Amt, Format(lastModifiedDate) editDate FROM Opportunity editDate='7/2/2015 3:11 AM'];
    List<sObject> li =[SELECT LeadSource, Rating,GROUPING(LeadSource) grpLS, GROUPING(Rating) grpRating,COUNT(Name) cnt FROM Lead GROUP BY ROLLUP(LeadSource, Rating)];
        for(sObject l: li){
                System.debug(l);
        }
    
        
        
        
    }

    
}