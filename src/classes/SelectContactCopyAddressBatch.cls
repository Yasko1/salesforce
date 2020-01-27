/**
 * Created by User on 26.12.2019.
 */

public with sharing class SelectContactCopyAddressBatch implements Database.Batchable<Contact>{

    public Iterable<Contact> start(Database.BatchableContext bc) {
        return new TaskIterable();
    }

    public void execute(Database.BatchableContext bc, List<Contact> scope){
        List<Account> accountsToUpdate = new List<Account>();
        Set<Id> idAcc = new Set<Id>();
        System.debug('Batch working, scope size is ' + scope.size());
        for(Contact cont : scope){
            if(cont.AccountId != null) {
                cont.Is_Synced__c = true;
                if(cont.Account.BillingAddress != null) {
                    cont.MailingCity = cont.Account.BillingCity;
                    cont.MailingCountry = cont.Account.BillingCountry;
                    cont.MailingPostalCode = cont.Account.BillingPostalCode;
                    cont.MailingGeocodeAccuracy = cont.Account.BillingGeocodeAccuracy;
                    cont.MailingLatitude= cont.Account.BillingLatitude;
                    cont.MailingState = cont.Account.BillingState;
                    cont.MailingStreet = cont.Account.BillingStreet;
                    if(!idAcc.contains(cont.AccountId)){
                        Account acc = new Account();
                        acc.Id = cont.Account.Id;
                        acc.Updated_By_Contact__c = true;
                        accountsToUpdate.add(acc);
                        idAcc.add(cont.AccountId);
                    }
            }
        }
    }
        update scope;
        update accountsToUpdate;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('Butch finished');
    }


}