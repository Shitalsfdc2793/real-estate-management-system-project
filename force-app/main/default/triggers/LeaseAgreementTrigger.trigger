trigger LeaseAgreementTrigger on Lease_Agreement__c (after insert) {
    
    List<Task> tasks = new List<Task>();

    for(Lease_Agreement__c lease : Trigger.new) {

        tasks.add(new Task(
            Subject = 'Generate Lease Agreement',
            WhatId = lease.Id,
            Status = 'Not Started',
            Priority = 'High'
        ));
    }

    insert tasks;

}