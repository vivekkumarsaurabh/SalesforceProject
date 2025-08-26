/*
* @Description : This class is used to schedule our TrackAuditTrailRecordsBatch class;
* @Author      : Vivek Kumar Saurabh
* @Created Date: 03/06/2024
*@modified by  : Vivek Kumar Saurabh
*@modified date: 03/06/2024
*/
public class DailyInsertHistorySchedulerBatch implements Schedulable {
    /*
	* @description : This method is prdefined method of Schedulable Interface method.
	* @param : SchedulableContext SC.
	* @return : N/A.
	*/
    public static void execute(SchedulableContext SC){
        TrackAuditTrailRecordsBatch executeTrackAuditTrail = new TrackAuditTrailRecordsBatch();
        Database.executeBatch(executeTrackAuditTrail);
    }
}