public with sharing class insertAccRecLWC {    
@AuraEnabled
    public static void createAccRecord(String name, String rating){
        System.debug(name+rating);
        Account createRec = new Account();
        createRec.Name = name;
        createRec.Rating = rating;
      insert createRec;        
    }
}