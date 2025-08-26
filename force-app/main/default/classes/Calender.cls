/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 19/01/2023
* @Description : LWC Apex Code of Calender.
******************************************************************/
public class Calender {
    /**************************************************************************************************************************
	* @description : This method is retrive all sObject.
	* @param : N/A.
	* @return : Map<String, List<HolidayWrapper>>.
	***************************************************************************************************************************/    
    @AuraEnabled
    public static Map<String, List<HolidayWrapper>> returnHolidays(){
        Map<String, List<HolidayWrapper>> holidayMap = new Map<String, List<HolidayWrapper>>();
        for(Holiday iterateHoliday : [SELECT Name, ActivityDate FROM Holiday]){         
            String keys = String.valueOf(iterateHoliday.ActivityDate.year())+'-'+String.valueOf(iterateHoliday.ActivityDate.month()-1);
            List<HolidayWrapper> holidayWrapper = new List<HolidayWrapper>();
            if(holidayMap.containsKey(keys)){
                holidayWrapper = holidayMap.get(keys);                
            }
            HolidayWrapper createWrapper = new HolidayWrapper();
            createWrapper.dateHoliday = String.valueOf(iterateHoliday.ActivityDate.day());
            createWrapper.holidayName = iterateHoliday.Name;
            holidayWrapper.add(createWrapper);            
            holidayMap.put(keys, holidayWrapper);
        }
        return holidayMap;
    }
    
    /**************************************************************************************************************************
	* @description : This method is insert date in attendence record. 
	* @param : List<String> attendList.
	* @return : N/A.
	***************************************************************************************************************************/     
    @AuraEnabled 
    public static List<Attendence_Record__c> createRecord(List<String> attendList){ 
        List<Attendence_Record__c> attendenceRecList = new List<Attendence_Record__c>();   
        for(String iterateStr : attendList){
            Attendence_Record__c createRec = new Attendence_Record__c();
            List<String> itemInList = iterateStr.split('-');
            createRec.Attendence_User_Name__c = itemInList[0]; 
            String dt = itemInList[4]+'/'+itemInList[3]+'/'+itemInList[2];
            createRec.Attendence_Date__c = date.parse(dt);
            if(itemInList[1] == 'present'){
                createRec.Present_Absent__c = true;
            }else if(itemInList[1] == 'hd'){
                createRec.Half_Day__c = true;
            }else if(itemInList[1] == 'fl'){
                createRec.Floater_Leave__c = true; 
            }else if(itemInList[1] == 'sl'){
                createRec.Sick_Leave__c = true;
            }else{
                createRec.Absent__c = true;  
            }             
            attendenceRecList.add(createRec);          
        }
        
        if(attendenceRecList.size() != 0){
            insert  attendenceRecList; 
        }
        return attendenceRecList;
        
    }
    
    @AuraEnabled 
    public static List<AttendenceWrapper> returnAttendenceWrapper(Integer month, List<Integer> listdays, Integer daysInMonth){    
        Date firstdt = date.newInstance(2024, month+1, 1);
        Date lastdt = date.newInstance(2024, month+1, daysInMonth);
        List<AttendenceWrapper> attendenceWrpList = new List<AttendenceWrapper>();         
        List<Attendence_Record__c> attendRecList = [SELECT Attendence_User_Name__r.Name, Attendence_Date__c, Attendence_User_Name__c, Sick_Leave__c, Present_Absent__c, Half_Day__c, Floater_Leave__c, Absent__c FROM Attendence_Record__c WHERE Attendence_Date__c >= :firstdt AND Attendence_Date__c <= :lastdt];
        if(attendRecList.isEmpty()){
            return attendenceWrpList;
        }
        Map<Id, Integer> sickLeaveMap = new Map<Id, Integer>();
        Map<Id, Integer> presentMap = new Map<Id, Integer>();
        Map<Id, Integer> absentMap = new Map<Id, Integer>();
        Map<Id, Integer> halfDayMap = new Map<Id, Integer>();
        Map<Id, Integer> floaterLeaveMap = new Map<Id, Integer>();
        for(Attendence_Record__c iterateRec : attendRecList){
            if(iterateRec.Sick_Leave__c == true){
                Integer count = 0;
                if(sickLeaveMap.containsKey(iterateRec.Attendence_User_Name__c)){
                    count = sickLeaveMap.get(iterateRec.Attendence_User_Name__c);
                }
                sickLeaveMap.put(iterateRec.Attendence_User_Name__c, count + 1);
            }
            if(iterateRec.Present_Absent__c == true){
                Integer count = 0;
                if(presentMap.containsKey(iterateRec.Attendence_User_Name__c)){
                    count = presentMap.get(iterateRec.Attendence_User_Name__c);
                }
                presentMap.put(iterateRec.Attendence_User_Name__c, count + 1);
            }            
            if(iterateRec.Absent__c == true){
                Integer count = 0;
                if(absentMap.containsKey(iterateRec.Attendence_User_Name__c)){
                    count = absentMap.get(iterateRec.Attendence_User_Name__c);
                }
                absentMap.put(iterateRec.Attendence_User_Name__c, count + 1);
            }
            if(iterateRec.Half_Day__c == true){
                Integer count = 0;
                if(halfDayMap.containsKey(iterateRec.Attendence_User_Name__c)){
                    count = halfDayMap.get(iterateRec.Attendence_User_Name__c);
                }
                halfDayMap.put(iterateRec.Attendence_User_Name__c, count + 1);
            }
            if(iterateRec.Floater_Leave__c == true){
                Integer count = 0;
                if(floaterLeaveMap.containsKey(iterateRec.Attendence_User_Name__c)){
                    count = floaterLeaveMap.get(iterateRec.Attendence_User_Name__c);
                }
                floaterLeaveMap.put(iterateRec.Attendence_User_Name__c, count + 1);
            }           
        }   
       
        for(Attendence_User__c iterateUser : [SELECT Id, Name,(SELECT Attendence_Date__c, AttendenceValue__c FROM Attendence_Record__r WHERE Attendence_Date__c >= :firstdt AND Attendence_Date__c <= :lastdt) FROM Attendence_User__c]){
            Set<Integer> wrraperSet = new Set<Integer>();
            List<DateWrraper> dtList = new List<DateWrraper>();
            for(Attendence_Record__c iterateRec : iterateUser.Attendence_Record__r){                
                Integer dt =  Integer.valueOf(iterateRec.Attendence_Date__c.day());
                DateWrraper createDtWraper = new DateWrraper();
                createDtWraper.dateOfDay = dt;
                if(iterateRec.AttendenceValue__c == 'P'){
                    createDtWraper.colorClassName = 'presentColor';
                }
                if(iterateRec.AttendenceValue__c == 'SL'){
                    createDtWraper.colorClassName = 'sickLeaveColor'; 
                }
                if(iterateRec.AttendenceValue__c == 'Ab'){
                    createDtWraper.colorClassName = 'absentColor'; 
                }
                if(iterateRec.AttendenceValue__c == 'p/2'){
                    createDtWraper.colorClassName = 'halfDayColor'; 
                }
                if(iterateRec.AttendenceValue__c == 'FL'){
                   createDtWraper.colorClassName = 'floaterLeaveColor'; 
                }
                createDtWraper.dayAttend = iterateRec.AttendenceValue__c;
                wrraperSet.add(dt);               
                dtList.add(createDtWraper);
            }
            AttendenceWrapper createDateWppr = new AttendenceWrapper();
            createDateWppr.idofUser = iterateUser.Id;
            createDateWppr.name = iterateUser.Name;
            if(halfDayMap.containsKey(iterateUser.Id)){
                createDateWppr.halfDay = halfDayMap.get(iterateUser.Id);
            }else{
                createDateWppr.halfDay = 0;
            }
            if(floaterLeaveMap.containsKey(iterateUser.Id)){
                createDateWppr.floaterLeave = floaterLeaveMap.get(iterateUser.Id);
            }else{
                createDateWppr.floaterLeave = 0;
            }
            if(absentMap.containsKey(iterateUser.Id)){
                createDateWppr.absent = absentMap.get(iterateUser.Id);
            }else{
                createDateWppr.absent = 0;
            }            
            if(presentMap.containsKey(iterateUser.Id)){
                createDateWppr.present = presentMap.get(iterateUser.Id);
            }else{
                createDateWppr.present = 0;
            }
            if(sickLeaveMap.containsKey(iterateUser.Id)){
                createDateWppr.sickLeave = sickLeaveMap.get(iterateUser.Id);
            }else{
                createDateWppr.sickLeave = 0;
            } 
            wrraperSet.addAll(listdays);
            for(Integer i=1; i<=daysInMonth; i++){                
                if(!wrraperSet.contains(i)){
                    DateWrraper createDtWraper = new DateWrraper();
                    createDtWraper.dateOfDay = i;
                    createDtWraper.dayAttend = ' ';  
                    dtList.add(createDtWraper);
                }                 
            }
            createDateWppr.dtWrpperList = dtList;
            attendenceWrpList.add(createDateWppr);
        }
        //System.debug('wrraperList-->'+attendenceWrpList);
        return attendenceWrpList;
    }
    
    @AuraEnabled 
    public static List<Attendence_Record__c> deleteData(date dt){      
        List<Attendence_Record__c> recList = [SELECT Id FROM Attendence_Record__c WHERE Attendence_Date__c =:dt];        
        delete recList;
        return recList;
    }
      
    /**************************************************************************************************************************
	* @description : This method is retriveData behalf on date.
	* @param : date dt.
	* @return : List<Attendence_Record__c>.
	***************************************************************************************************************************/      
    @AuraEnabled
    public static List<Attendence_Record__c> retriveData(date dt){ 
        return [SELECT Attendence_User_Name__c, Attendence_User_Name__r.Name, Floater_Leave__c, Half_Day__c, Present_Absent__c, Sick_Leave__c, 	Absent__c FROM Attendence_Record__c WHERE Attendence_Date__c = :dt];
    } 
    /**************************************************************************************************************************
	* @description : This method is for attendenceUser.
	* @param : date createDate.
	* @return : List<Attendence_User__c>.
	***************************************************************************************************************************/  
    @AuraEnabled
    public static List<Attendence_User__c> attendenceUser(date createDate){
       return [SELECT Name, Id FROM Attendence_User__c WHERE day_only(CreatedDate)<=:createDate];          
    }    
        
    public class AttendenceWrapper{
        @AuraEnabled public String idofUser;
        @AuraEnabled public String name;
        @AuraEnabled public Integer halfDay;
        @AuraEnabled public Integer present;
        @AuraEnabled public Integer absent;
        @AuraEnabled public Integer sickLeave;
        @AuraEnabled public Integer floaterLeave;
        @AuraEnabled public List<DateWrraper> dtWrpperList;
    }
    
    public class DateWrraper{
        @AuraEnabled public Integer dateOfDay;
        @AuraEnabled public String dayAttend;
        @AuraEnabled public String colorClassName;
    } 
    
    public class HolidayWrapper{
        @AuraEnabled public String dateHoliday;
        @AuraEnabled public String holidayName;
    }
}