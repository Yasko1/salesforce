/**
 * Created by User on 25.12.2019.
 */

global class TaskIterator implements Iterator<Contact>{

    List<Contact> contacts{get; set;}
    Integer index{get; set;}
    static final String SELECT_ALL_CONTACT = 'SELECT Id, Account.BillingAddress, Account.BillingCity, Account.BillingCountry, ' +
            'MailingAddress, Account.BillingPostalCode, Account.BillingGeocodeAccuracy, Account.BillingLatitude,' +
            ' Account.BillingState, Account.BillingStreet, Role__c FROM Contact WHERE Is_Synced__c = false';
    public TaskIterator(){
        System.debug('BATCH STARTED');
        contacts = Database.query(SELECT_ALL_CONTACT);
        System.debug('list contacts size is ' + contacts.size());
        index = 0;
    }


    global boolean hasNext(){
        return (index < contacts.size());
    }

    global Contact next(){
        return contacts[index++];
    }

}