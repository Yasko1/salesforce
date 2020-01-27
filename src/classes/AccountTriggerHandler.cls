/**
 * Created by User on 21.12.2019.
 */

public without sharing class AccountTriggerHandler {
    public static Boolean isFirstTime = true;


    public static void onAfterCreate(Set<Id> idAccounts){
        if(isFirstTime) {
            isFirstTime = false;
            AccountTriggerHelper.createTask(idAccounts);
        }
    }

    public static void onAfterUpdate(Map<Id, Account> oldMap, Map<Id, Account> newMap){
        if(isFirstTime) {
            isFirstTime = false;
            AccountTriggerHelper.checkCountAccountTasks(newMap.keySet());
            AccountTriggerHelper.checkChangeBilling(oldMap, newMap);
            AccountTriggerHelper.checkChangeBillingQue(oldMap, newMap);
        }
    }


}