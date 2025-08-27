trigger TriggerOnServiceLocation on Service_Location__c (after update, after insert) {
    if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)){
        ServicesEntryCreateQuoteLineItem.createQuotationSendtoCustomer(Trigger.new);       
    }
}