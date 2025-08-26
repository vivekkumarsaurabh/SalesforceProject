public class QueueableClassExample implements Queueable{
    public void execute(System.QueueableContext batch){
        CreateContactCsvOnAcc ob = new CreateContactCsvOnAcc();
        Database.executeBatch(ob);
    }

}