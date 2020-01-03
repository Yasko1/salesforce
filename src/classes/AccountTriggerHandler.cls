/**
 * Created by User on 21.12.2019.
 */

public without sharing class AccountTriggerHandler {


    public static void onAfterCreate(Set<Id> idAccounts){
        AccountTriggerHelper.createTask(idAccounts);
    }

    public static void onAfterUpdate(Map<Id, Account> oldMap, Map<Id, Account> newMap){
        AccountTriggerHelper.checkCountAccountTasks(newMap.keySet());
        AccountTriggerHelper.checkChangeBilling(oldMap, newMap);
        AccountTriggerHelper.checkChangeBillingQue(oldMap, newMap);
    }

}