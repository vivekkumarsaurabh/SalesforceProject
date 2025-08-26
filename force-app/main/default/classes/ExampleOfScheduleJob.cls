public class ExampleOfScheduleJob implements Schedulable {
    public void execute(SchedulableContext ctx) {
        List<Opportunity> opptys = [SELECT Id, Name, OwnerId, CloseDate FROM Opportunity WHERE IsClosed = False AND CloseDate < TODAY];       
        System.debug(opptys);
    }
    
}