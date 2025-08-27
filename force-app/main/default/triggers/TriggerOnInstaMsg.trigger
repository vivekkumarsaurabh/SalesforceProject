trigger TriggerOnInstaMsg on InstaMsg__c (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        system.debug('daaata==>'+Trigger.New);
        AlgoInsta.insertMsgTriggerHandler(Trigger.New);
    }
}