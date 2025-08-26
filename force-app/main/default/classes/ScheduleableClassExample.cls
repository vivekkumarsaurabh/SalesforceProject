public class ScheduleableClassExample implements Schedulable{
    public void execute(System.SchedulableContext con){
         CreateContactCsvOnAcc ob = new CreateContactCsvOnAcc();
        Database.executeBatch(ob);

    }
}