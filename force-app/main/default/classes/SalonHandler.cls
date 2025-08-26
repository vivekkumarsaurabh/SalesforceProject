/******************************************************************
* @author      : Vivek Kumar Saurabh
* @date        : 01/02/2024
* @Description : LWC Apex Code of Salon Handler Class.
******************************************************************/
public without sharing class SalonHandler {
    /**************************************************************************************************************************
	* @description : This method is return all category in salon.
	* @param : N/A.
	* @return : List<Salon_Categories__c>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<Salon_Categories__c> retriveAllCategory(){
        return [SELECT Id, Name, Price__c, Booking_Hours__c FROM Salon_Categories__c];
    }
    
    /**************************************************************************************************************************
	* @description : This method is return count of Appointment.
	* @param : N/A.
	* @return : Integer.
	***************************************************************************************************************************/
    @AuraEnabled
    public static Integer countAppoitment(String salonManId){ 
        Integer count;
        List<AggregateResult> countResult = [SELECT COUNT(ID) FROM Salon_Appointment__c WHERE Salon_Man__c =:salonManId];
        for(AggregateResult iterate : countResult){
            count = (Integer)iterate.get('expr0');
        }
        return count;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for bar chart data.
	* @param : String salonManId.
	* @return : BarChartWrapper.
	***************************************************************************************************************************/
    @AuraEnabled 
    public static BarChartWrapper  barChartList(String salonManId){
        List<Integer> categoryList = new List<Integer>();
        List<AggregateResult> barChartList = [SELECT COUNT(ID) cntId, Salon_Categories__r.Name, Salon_Man__c  FROM Salon_Appointment__c GROUP BY Salon_Categories__c,Salon_Categories__r.Name,Salon_Man__c Having  Salon_Man__c = :salonManId];  
        BarChartWrapper createBarChartWrp = new BarChartWrapper();
        List<Integer> listCount = new List<Integer>();
        List<String> listName = new List<String>();
        List<String> colorList = new List<String>();
        String color = '#E6A4E6';
        for(AggregateResult iterate : barChartList){
            Integer val = Integer.valueOf(color.substring(6,7));
            val++;
            String newColor = color.substring(0,6)+String.valueOf(val);      
            listCount.add((Integer)iterate.get('cntId')); 
            listName.add(String.valueOf(iterate.get('Name'))); 
            colorList.add(newColor);           
        }
        createBarChartWrp.countWrapperList = listCount;
        createBarChartWrp.nameWrapperList = listName;
        createBarChartWrp.colorWrapperList = colorList;
        return createBarChartWrp;
    } 
    
    /**************************************************************************************************************************
	* @description : This method is return all contact.
	* @param : N/A.
	* @return : Integer.
	***************************************************************************************************************************/
    @AuraEnabled
    public static Integer countContact(String salonManId){      
        Integer count;
        List<AggregateResult> countResult = [SELECT COUNT(ID)  FROM Salon_Contact__c];
        for(AggregateResult iterate : countResult){
            count = (Integer)iterate.get('expr0');
        }
        return count;
    }
    
    /**************************************************************************************************************************
	* @description : This method is return count of future Appointment.
	* @param : N/A.
	* @return : Integer.
	***************************************************************************************************************************/
    @AuraEnabled
    public static Integer countFutureAppoitment(String salonManId){      
        Integer count;
        List<AggregateResult> countResult = [SELECT COUNT(ID)  FROM Salon_Appointment__c WHERE Salon_Man__c =: salonManId AND Appointment_Status__c = 'New'];
        for(AggregateResult iterate : countResult){
            count = (Integer)iterate.get('expr0');
        }
        return count;
    }
    
    
    /**************************************************************************************************************************
	* @description : This method is return count of past Appointment.
	* @param : N/A.
	* @return : Integer.
	***************************************************************************************************************************/
    @AuraEnabled
    public static Integer countPastAppoitment(String salonManId){      
        Integer count;
        List<AggregateResult> countResult = [SELECT COUNT(ID)  FROM Salon_Appointment__c WHERE Salon_Man__c =: salonManId AND Appointment_Status__c = 'Completed'];
        for(AggregateResult iterate : countResult){
            count = (Integer)iterate.get('expr0');
        }
        return count;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for create User.
	* @param : String user.
	* @return : Salon_Man__c.
	***************************************************************************************************************************/
    @AuraEnabled
    public static Salon_Man__c createUserHandler(String user){
        Map<String, Object> obj =  (Map<String, Object>) JSON.deserializeUntyped(user);
        Salon_Man__c createRec = new Salon_Man__c();
        createRec.Name = JSON.serialize(obj.get('userName')).remove('"');
        createRec.Email__c = JSON.serialize(obj.get('userEmail')).remove('"');
        createRec.Phone__c = JSON.serialize(obj.get('userPhone')).remove('"');
        createRec.Password__c = JSON.serialize(obj.get('userPassword')).remove('"');
        insert createRec;
        return createRec;      
    }
    
     /**************************************************************************************************************************
	* @description : This method is send an email.
	* @param : String toAddress, String subject, String body.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static void sendEmail(String userData, date datePick, String timeSl) {
        Map<String, Object> obj =  (Map<String, Object>) JSON.deserializeUntyped(userData);
        String dt = String.valueOf(datePick).substring(0,10);  
        String userEmail = JSON.serialize(obj.get('userEmail')).remove('"');  
        System.debug('data-->'+userEmail);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{ userEmail });
        mail.setSubject('Booking Confirmed on date :'+dt+' !');             
        String body = '<h1>Your Booking has Confirmed ! </h1><br>Hello '+JSON.serialize(obj.get('userName')).remove('"')+',<br>       Your booking slot has been confirmed at '+timeSl+' on date : '+dt+' .<br> <br> -Thanku for visit <br> Stylish Salon';
        mail.setHtmlBody(body);
        Messaging.sendEmail(new List<Messaging.Email> { mail });
    }
    
    /**************************************************************************************************************************
	* @description : This method is return all Salon Man.
	* @param : N/A.
	* @return : List<Salon_Man__c>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<Salon_Man__c> retriveSalonMan(){
        return [SELECT Id, Name, Email__c, Phone__c FROM Salon_Man__c];
    }
    
    /**************************************************************************************************************************
	* @description : This method is for insert data into contact.
	* @param : String name, String email, String msg.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static Salon_Contact__c insertContact(String conData){  
      Map<String, Object> obj =  (Map<String, Object>) JSON.deserializeUntyped(conData);      
        Salon_Contact__c createRec = new Salon_Contact__c();
        createRec.User_Email__c = JSON.serialize(obj.get('conEmail')).remove('"');
        createRec.User_Message__c = JSON.serialize(obj.get('conMsg')).remove('"');
        createRec.Name = JSON.serialize(obj.get('conName')).remove('"');
        insert createRec;
        return createRec;
    }
    
    /**************************************************************************************************************************
	* @description : This method is for SalonUser Wrapper behalf of email.
	* @param : String email.
	* @return : userInfoWrapper.
	***************************************************************************************************************************/    
    @AuraEnabled
    public static userInfoWrapper retriveUserPass(String email){
        userInfoWrapper createRec = new userInfoWrapper();
        for(Salon_Man__c iterateRec : [SELECT Id, Password__c, Name FROM Salon_Man__c WHERE Email__c =:email]){           
            createRec.Name = iterateRec.Name;
            createRec.password = iterateRec.Password__c;
            createRec.Id = iterateRec.Id;
        }
        return createRec;
    }
    
    /**************************************************************************************************************************
	* @description : This method is return appointment behalf of salon man Id.
	* @param : String salonManId.
	* @return : List<Salon_Appointment__c>.	
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<Salon_Appointment__c> retriveAppointment(String salonManId){           
        return [SELECT Id, Name__c, Phone__c, Email__c, DateSlot__c, End_Time__c, Appointment_Status__c, Salon_Categories__c, Salon_Categories__r.Name, Time_Slot__c FROM Salon_Appointment__c WHERE Salon_Man__c =:salonManId ORDER BY CreatedDate DESC];
    }
    
    /**************************************************************************************************************************
	* @description : This method is return appointment behalf on date and salon Man .That is filter method.
	* @param : date dt, String salonManId.
	* @return : List<Salon_Appointment__c>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<Salon_Appointment__c> dateFilterAppointment(date dt, String salonManId){
        return [SELECT Id, Name__c, Phone__c, Email__c, DateSlot__c, Salon_Categories__c, Salon_Categories__r.Name, Time_Slot__c FROM Salon_Appointment__c WHERE Salon_Man__c =:salonManId AND DateSlot__c =:dt];
    }
    
    /**************************************************************************************************************************
	* @description : This method is return all Contact.
	* @param : N/A.
	* @return : List<Salon_Contact__c>.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<Salon_Contact__c> retriveContact(){
        return [SELECT Id, Name, User_Email__c, User_Message__c FROM Salon_Contact__c ORDER BY CreatedDate DESC];
    }
    
    /**************************************************************************************************************************
	* @description : This method is return delete all Contact.
	* @param : String deleteContId.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<Salon_Contact__c> deteleUserContact(String deleteContId){
        List<Salon_Contact__c> accRecordList = [SELECT ID, Name FROM Salon_Contact__c WHERE ID = :deleteContId LIMIT 1];
        if(!accRecordList.isEmpty()){
            delete accRecordList;
        }
        return accRecordList;
    }
    
    /**************************************************************************************************************************
	* @description : This method is update Status.
	* @param : List<String> appointList.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<Salon_Appointment__c> updateStatus(List<String> appointList){
        List<Salon_Appointment__c> updatedRecList = new List<Salon_Appointment__c>();
        for(Salon_Appointment__c iterateRec : [SELECT Id, Appointment_Status__c FROM Salon_Appointment__c WHERE Id IN :appointList]){
            Salon_Appointment__c updateRec = new Salon_Appointment__c();
            updateRec.Id = iterateRec.Id;
            updateRec.Appointment_Status__c  = 'Completed';
            updatedRecList.add(updateRec);
        }
        if(!updatedRecList.isEmpty()){
            update updatedRecList;
        }
        return updatedRecList;
    }
    
    /**************************************************************************************************************************
	* @description : This method is return all appointment time Slot wrapper list.
	* @param : Id salonMan, date datePick.
	* @return :List<timeSlotWrapper>.
	***************************************************************************************************************************/        
    @AuraEnabled
    public static List<timeSlotWrapper> retriveAllAppoint(Id salonMan, date datePick){
        List<String> timeSlotList = new List<String>{'10:00 am','11:00 am','12:00 pm','01:00 pm','02:00 pm','03:00 pm','04:00 pm','05:00 pm','06:00 pm'};
        List<String> timeSlot = new List<String>();
        Set<String> timeSlotSet = new Set<String>();
        List<timeSlotWrapper> timeSlotWprList = new List<timeSlotWrapper>(); 
        for(Salon_Appointment__c iterateRec : [SELECT Time_Slot__c, End_Time__c FROM Salon_Appointment__c WHERE Salon_Man__c = :salonMan AND DateSlot__c =:datePick]){ 
            Integer startIndex = timeSlotList.indexOf(iterateRec.Time_Slot__c);
            Integer endIndex = timeSlotList.indexOf(iterateRec.End_Time__c);           
            for(Integer i = startIndex; i < endIndex; i++){
                timeSlotSet.add(timeSlotList[i]);              
            }  
        }
        for(integer i=0; i<timeSlotList.size(); i++){
            if(timeSlotSet.contains(timeSlotList[i])){
                timeSlotList.remove(i);
                i--;
            }
        }
        for(String itrateItem : timeSlotList){
            timeSlotWrapper createWrapper = new timeSlotWrapper();
            createWrapper.label = itrateItem;
            createWrapper.value = itrateItem;
            timeSlotWprList.add(createWrapper);
        } 
        return timeSlotWprList;
    }
    
    /**************************************************************************************************************************
	* @description : This method is delete all appointment.
	* @param : String appointId.
	* @return : N/A.
	***************************************************************************************************************************/
    @AuraEnabled
    public static List<Salon_Appointment__c> deleteAppointment(String appointId){
        List<Salon_Appointment__c> accRecordList = [SELECT ID, Name FROM Salon_Appointment__c WHERE ID = :appointId LIMIT 1];
        if(!accRecordList.isEmpty()){
            delete accRecordList;
        }
        return accRecordList;
    }
    
    /**************************************************************************************************************************
	* @description : This method is createAppoitment on time.
	* @param : Id categoryId, Id salonMan, String appointUserData, date appointDate, String timeSlot.
	* @return : String.
	***************************************************************************************************************************/
    @AuraEnabled
    public static String createAppointment(Id categoryId, Id salonMan, String appointUserData, date appointDate, String timeSlot){      
        String timeBookingHour;
        String resultStr;
        List<String> timeSlotList = new List<String>{'10:00 am','11:00 am','12:00 pm','01:00 pm','02:00 pm','03:00 pm','04:00 pm','05:00 pm','06:00 pm'};
        List<String> slotBookedList = new List<String>();
        Set<String> timeSlotSet = new Set<String>();
        if(timeSlot == '06:00 pm'){
            resultStr = 'This time is not available for more than 1 hour';
            return resultStr;
        }
        //time slot booked list
        for(Salon_Appointment__c iterateRec : [SELECT Time_Slot__c, End_Time__c FROM Salon_Appointment__c WHERE Salon_Man__c = :salonMan AND DateSlot__c =:appointDate]){ 
            Integer startIndex = timeSlotList.indexOf(iterateRec.Time_Slot__c);
            Integer endIndex = timeSlotList.indexOf(iterateRec.End_Time__c);           
            for(Integer i = startIndex; i < endIndex; i++){
                timeSlotSet.add(timeSlotList[i]);              
            }  
        }        
        // taking hours       
        for(Salon_Categories__c iterateItem : [SELECT Booking_Hours__c FROM  Salon_Categories__c WHERE Id =:categoryId]){
            timeBookingHour = iterateItem.Booking_Hours__c;
        } 
        Integer hoursRound = Math.ceil(Double.valueOf(timeBookingHour.substring(0,3))).intValue();
        if(hoursRound>1){
            Integer timeConversion = Integer.valueOf(timeSlot.substring(0,2));
            String newTime;
            Boolean timeContains;
            for(Integer i=1; i<=hoursRound; i++){
                timeConversion = timeConversion+i;
                if(timeConversion > 12){
                    timeConversion = timeConversion - 12;
                    newTime = '0'+timeConversion+':00 pm'; 
                    timeContains = timeSlotSet.contains(newTime);
                }else{
                    if(timeConversion < 10){
                        newTime = '0'+timeConversion+':00 pm';
                        timeContains = timeSlotSet.contains(newTime); 
                    }else if(timeConversion == 12){ 
                        newTime = timeConversion+':00 pm';
                        timeContains = timeSlotSet.contains(newTime);
                    }else{
                        newTime = timeConversion+':00 am';
                        timeContains = timeSlotSet.contains(newTime); 
                    }
                }
                if(timeContains){
                    resultStr = 'This time is not available for more than 1 hour';
                    return resultStr;
                }else{
                    Salon_Appointment__c createAppointment = SalonHandler.createAppointmentRec(categoryId, salonMan, appointUserData, appointDate, timeSlot);
                    insert createAppointment;
                    resultStr = 'Sucessfull';
                }
            }            
        }else{
            Salon_Appointment__c createAppointment = SalonHandler.createAppointmentRec(categoryId, salonMan, appointUserData, appointDate, timeSlot);
            insert createAppointment;
            resultStr = 'Sucessfull';
        } 
        return resultStr;
    }
    
    /**************************************************************************************************************************
	* @description : This method is create Appointment.
	* @param : Id categoryId, Id salonMan, String appointUserData, date appointDate, String timeSlot.
	* @return : Salon_Appointment__c.
	***************************************************************************************************************************/
    public static Salon_Appointment__c createAppointmentRec(Id categoryId, Id salonMan, String appointUserData, date appointDate, String timeSlot){
        Map<String, Object> objAppointData =  (Map<String, Object>) JSON.deserializeUntyped(appointUserData);
        Salon_Appointment__c createRec = new Salon_Appointment__c();
        createRec.Name__c = JSON.serialize(objAppointData.get('userName')).remove('"');
        createRec.Email__c = JSON.serialize(objAppointData.get('userEmail')).remove('"');
        createRec.Phone__c = JSON.serialize(objAppointData.get('userPhone')).remove('"');
        createRec.Salon_Man__c = salonMan;
        createRec.Salon_Categories__c = categoryId;
        createRec.Time_Slot__c = timeSlot;
        createRec.DateSlot__c = appointDate; 
        createRec.Appointment_Status__c = 'New';
        return createRec;
    }
    
    public class timeSlotWrapper{
        @AuraEnabled public String label;
        @AuraEnabled public String value;
    }
    
    public class BarChartWrapper{
        @AuraEnabled public List<Integer> countWrapperList;
        @AuraEnabled public List<String> colorWrapperList;
        @AuraEnabled public List<String> nameWrapperList;
    }  
    
     
    public class userInfoWrapper{
        @AuraEnabled public String Id;
        @AuraEnabled public String Name;
        @AuraEnabled public String password;
    }
}