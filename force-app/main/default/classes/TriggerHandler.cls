/*
* @Description : Trigger Handler class.
* @author      : Vivek Kumar Saurabh
* @date        : 27/05/2024
*/
public class TriggerHandler {    
     public void afterUpdateHandler(){
        ObjectHistoryTracking.trackObjectHistory();
    }
}