trigger SimpleTriggerOnContentDocumentLink on ContentDocumentLink (after insert) {
   /** if(Trigger.isAfter && Trigger.isInsert){
        CountUploadFilesUsingTrigger.countUploadedFiles(Trigger.new);
    }**/
 /**   if(Trigger.isAfter && Trigger.isDelete){
        CountUploadFilesUsingTrigger.deleteUpdateField(Trigger.old);
    }**/
   
  /**  if(Trigger.isAfter && Trigger.isInsert){
        SendMailSuccessFileInsertByTrigger.successfullyInsertAfterInsertFileWithAttachFile(Trigger.new);
    }**/

  /**  if(Trigger.isAfter && Trigger.isInsert){
        SendMailSuccessFileInsertByTrigger.AfterInsertFileAttachTable(Trigger.New);
    }**/
    
    /*if(Trigger.isAfter && Trigger.isInsert){
        GoogleDriveInsertfileintoFolder.insertFiles(Trigger.new);
    }*/
    
}