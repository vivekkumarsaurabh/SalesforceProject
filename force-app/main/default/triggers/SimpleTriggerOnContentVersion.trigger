trigger SimpleTriggerOnContentVersion on ContentVersion (before insert, after insert) {
  /**  if(Trigger.isBefore && Trigger.isInsert){
        fileInsertByName.insertFileByName(Trigger.New);
    } 
    if(Trigger.isAfter && Trigger.isInsert){
        fileInsertByName.deleteFile(Trigger.New);
    }  **/
 /**  if(Trigger.isAfter && Trigger.isInsert){
        SendMailSuccessFileInsertByTrigger.successfullyInsertAfterInsertFileWithAttachFile(Trigger.new);
    }**/
    
    
       
}