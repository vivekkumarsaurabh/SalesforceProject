trigger TriggerOnQuote on Quote (after update) {
  /**  if(Trigger.isAfter && Trigger.isUpdate){
     ServicesEntryCreateQuoteLineItem.sendMailafterUpdateQuote(Trigger.New);
    }**/
}