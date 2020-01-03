/**
 * Created by User on 25.12.2019.
 */

global with sharing class DeleteTaskBatch implements Database.Batchable<sObject>{


    final String SELECT_ALL_TASKS = 'SELECT Id FROM Task';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(SELECT_ALL_TASKS);
    }

    global void execute(Database.BatchableContext bc, List<Task> scope){
        System.debug('Batch started');
        delete scope;
        System.debug('Tasks was deleted from batch');
    }

    global void finish(Database.BatchableContext bc){

    }
}