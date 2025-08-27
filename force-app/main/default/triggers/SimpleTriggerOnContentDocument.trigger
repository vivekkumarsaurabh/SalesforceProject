trigger SimpleTriggerOnContentDocument on ContentDocument (after insert) {
   /** if(Trigger.isBefore && Trigger.isDelete){
         CountUploadFilesUsingTrigger.deleteUpdateField(Trigger.old);
    }**/
  /**  if(Trigger.isAfter && Trigger.isInsert){
       fileInsertByName.deleteFileAfter(Trigger.new);
    }**/
    
  /**  if(Trigger.isAfter && Trigger.isInsert){
        SendMailSuccessFileInsertByTrigger.successfullyInsertAfterInsertFile(Trigger.new);
    }**/
  /** if(Trigger.isAfter && Trigger.isInsert){
        SendMailSuccessFileInsertByTrigger.successfullyInsertAfterInsertFileWithAttachFile(Trigger.new);
    }**/
}