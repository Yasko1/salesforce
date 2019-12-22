/**
 * Created by User on 21.12.2019.
 */

public without sharing class AccountTriggerHandler {
  //  final static String SOQL_SELECT_ID = '[SELECT COUNT(Id), Owner.Id FROM Task GROUP BY Owner.Id]';

    public static void onAfterCreate(List<Account> accountList){
        List<Task> listTasks = new List<Task>();
        for(Account account : accountList) {
            Task task = new Task(Subject = 'Negotiations with ' + account.Name);
            task.WhatId = account.Id;
            listTasks.add(task);
        }

        insert listTasks;
    }

    public static void onAfterUpdate(List<Account> accountList){
        List<User> userList = [SELECT Id FROM User];
        Map<String, Integer> freeUsers = new Map<String, Integer>();
        for(User user : userList){
            String id = user.Id;
            Integer count = [SELECT COUNT() FROM Task WHERE Owner.Id =: id];
            freeUsers.put(id, count);
        }


//        Map<Integer, String> mapParam = [SELECT COUNT(Id), Owner.Id FROM Task GROUP BY Owner.Id];
//        for(Account account : accountList){
//
//        }
      //  update car_part;
    }

    public static void afterInsert(){
        Task task = new Task();
        task.Subject = 'Negotiations with QQQQQ';

        insert task;
    }

}