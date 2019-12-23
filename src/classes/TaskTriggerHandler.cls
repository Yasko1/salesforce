/**
 * Created by User on 22.12.2019.
 */

public with sharing class TaskTriggerHandler {
    final static String COMPLETED = 'Completed';
    final static Integer COUNT_TASK = 3;

    public static void checkTaskAccount(List<Task> listTasks){
        List<User> userList = [SELECT Id FROM User];
        Map<String, Integer> mapUsers = new Map<String, Integer>();
        for(User user : userList){
            String id = user.Id;
            Integer count = [SELECT COUNT() FROM Task WHERE Owner.Id =: id];
            mapUsers.put(id, count);
        }
        for(Task task: listTasks){
            Integer count = mapUsers.get(task.OwnerId);
            if(count >= COUNT_TASK){
                Boolean status = true;
                Set<String> keyUser = mapUsers.keySet();
                List<String> listKeys = new List<String>();
                for(String x : keyUser){
                    listKeys.add(x);
                }
                while (status){
                    for(Integer i = 0; i < mapUsers.size(); i++){
                        Integer currentCount = mapUsers.get(listKeys.get(i));
                        if(currentCount < COUNT_TASK){
                            task.OwnerId = listKeys.get(i);
                            mapUsers.put(listKeys.get(i), ++currentCount);
                            status = false;
                        }
                    }
                }
            }
        }
    }



    public static void onAfterUpdate(List<Task> listTasks){
        List<Account> listAccounts = new List<Account>();
        for(Task task : listTasks){
            if(task.Status.equals(COMPLETED)){
                String ids = task.WhatId;
                Account account = [SELECT Id, Plans_Discussed__c FROM Account WHERE Id =: task.WhatId];
                account.Plans_Discussed__c = true;
                listAccounts.add(account);
            }
        }
        update listAccounts;
    }

}