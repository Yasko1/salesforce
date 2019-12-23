/**
 * Created by User on 21.12.2019.
 */

public without sharing class AccountTriggerHandler {
  //  final static String SOQL_SELECT_ID = '[SELECT COUNT(Id), Owner.Id FROM Task GROUP BY Owner.Id]';

    public static void onAfterCreate(List<Account> accountList){

        String [] userId = new String[accountList.size()];
        String [] userName = new String[accountList.size()];
        Integer a = 0;

        for(Account account : accountList){
            userId[a] = account.Id;
            userName[a] = account.Name;
            a++;
        }

        futureCreateTask(userId, userName);
    }

    @Future
    public static void futureCreateTask(String[] userId, String[] userName){
        List<Task> listTasks = new List<Task>();

        for(Integer x = 0; x < userId.size(); x++) {
            Task task = new Task(Subject = 'Negotiations with ' + userName[x] );
            task.WhatId = userId[x];
            task.Is_Synced__c = false;
            listTasks.add(task);
        }

        insert listTasks;
    }

    public static void onAfterUpdateCheckCountTask(Set<Id> ids){
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

    public static void onAfterUpdate(Map<Id, Account> oldMap, Map<Id, Account> newMap, Set<Id> setId){
        Set<Id> changedAddressAccount = new Set<Id>();
        for(Id accId : setId){
            if(
//                    (oldMap.get(accId).BillingAddress.state) !=
//                            (newMap.get(accId).BillingAddress.state)
                                    oldMap.get(accId).Name.equals(newMap.get(accId).Name)
              )
            {
                changedAddressAccount.add(accId);
            }
        }
        changeStatusContact(changedAddressAccount);
    }

    @Future
    private static void changeStatusContact(Set<Id> setId){
        List<Contact> listContacts = new List<Contact>();
        for(Id idAcc : setId){
            Contact [] contacts = [SELECT Id FROM Contact WHERE Account.Id =: idAcc];
            if(!contacts.isEmpty()){
                for(Integer i = 0; i < contacts.size(); i++){
                    contacts[i].Processed_By_Future__c = true;
                    contacts[i].Is_Synced__c = false;
                    listContacts.add(contacts[i]);
                }
            }
        }
        update listContacts;
    }

}