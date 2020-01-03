/**
 * Created by User on 23.12.2019.
 */

public with sharing class UpdateContactChangeAcc implements Queueable {
    private Set<Id> idAccounts;

    static final String SELECT_ACCOUNTS = 'SELECT Id,(SELECT Id FROM Contacts) FROM Account WHERE Id=:idAccounts';

    public UpdateContactChangeAcc(Set<Id> idAccounts){
        this.idAccounts = idAccounts;
    }


    public void execute(QueueableContext context){
        List<Account> allAccounts = Database.query(SELECT_ACCOUNTS);
        List<Contact> listContact = new List<Contact>();

        for(Account account : allAccounts){
            listContact.addAll(account.Contacts);
        }

        for(Contact contact : listContact){
            contact.Processed_By_Queue__c = true;
            contact.Is_Synced__c = false;
        }
        update listContact;
    }

}