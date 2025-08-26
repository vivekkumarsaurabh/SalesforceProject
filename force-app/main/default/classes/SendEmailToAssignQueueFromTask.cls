/*
* @Description : This class is used for track history of objects;
* @author      : Vivek Kumar Saurabh
* @date        : 16/01/2025
*@modified by  : Vivek Kumar Saurabh
*@modified date: 16/01/2025
*/
public class SendEmailToAssignQueueFromTask {
     /*
	* @description : This method is a trigger method for sending mail to assign queue from task.
	* @param : List<Task> taskList (getting trigger.new (task object)). 
	* @return : N/A.
 	*/ 
    public static void sendMailToQueue(List<Task> taskList){
         Set<Id> taskIdSet = new Set<Id>();
        Set<Id> taskOwnerIdSet = new Set<Id>();
        Map<Id, GROUP> taskOwnerGroupMap = new Map<Id, GROUP>();
        List< Messaging.SingleEmailMessage> emailMessageList = new List< Messaging.SingleEmailMessage>();
        for(Task iterateTaskItem : taskList){
            if((Trigger.oldMap != NULL && (Trigger.oldMap.get(iterateTaskItem.Id).get('OwnerId') != iterateTaskItem.OwnerId) && (String.valueOf(iterateTaskItem.OwnerId.getsobjecttype()) == 'Group')) || ((String.valueOf(iterateTaskItem.OwnerId.getsobjecttype()) == 'Group') && Trigger.isInsert)){                
                taskIdSet.add(iterateTaskItem.Id);
                taskOwnerIdSet.add(iterateTaskItem.OwnerId);
            }            
        }
        if(taskOwnerIdSet != NULL){
            for(Group iterateGroup : [SELECT Id, Name, Type, Email FROM Group WHERE Id IN :taskOwnerIdSet]){
                taskOwnerGroupMap.put(iterateGroup.Id, iterateGroup);
            }
        }    
        if(taskOwnerGroupMap != NULL){
            for(Task iterateTask : taskList){
                if((Trigger.oldMap != NULL && (Trigger.oldMap.get(iterateTask.Id).get('OwnerId') != iterateTask.OwnerId) && (String.valueOf(iterateTask.OwnerId.getsobjecttype()) == 'Group')) || ((String.valueOf(iterateTask.OwnerId.getsobjecttype()) == 'Group') && Trigger.isInsert)){                
                    if(taskOwnerGroupMap.get(iterateTask.OwnerId).get('Type') == 'Queue'){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        String[] toAddresses = new String[] {String.valueOf(taskOwnerGroupMap.get(iterateTask.OwnerId).get('Email'))};
                        mail.setToAddresses(toAddresses);
                        mail.setSubject('Task Assign to Queue');
                        mail.setPlainTextBody('Hello '+taskOwnerGroupMap.get(iterateTask.OwnerId).get('Name')+' (Queue),  you have assign Task and that task Id is '+iterateTask.Id);
                        emailMessageList.add(mail); 
                    }
                }
            }                
        }
        if(!emailMessageList.isEmpty()){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(emailMessageList);
        }
    }
}