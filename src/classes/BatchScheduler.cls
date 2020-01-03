/**
 * Created by User on 04.01.2020.
 */

public with sharing class BatchScheduler implements Schedulable{

//    BatchScheduler scheduler = new BatchScheduler();
//    String period = '0 30 1 1 1 ?';
//    System.schedule('Start batches', period, scheduler);

    public void execute(SchedulableContext context){
        Database.executeBatch(new SelectTasksBatchJob());
        Database.executeBatch(new SelectContactCopyAddressBatch());
    }

}