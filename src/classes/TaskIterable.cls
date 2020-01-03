/**
 * Created by User on 26.12.2019.
 */

public with sharing class TaskIterable implements Iterable<Contact>{
    public Iterator<Contact> Iterator(){
        return new TaskIterator();
    }
}