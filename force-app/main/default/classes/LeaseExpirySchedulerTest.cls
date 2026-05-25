@isTest
private class LeaseExpirySchedulerTest {
    @isTest
    static void testReminderEmails() {

    Tenant__c tenant = new Tenant__c(
        Name = 'Test Tenant',
        Email__c = 'test@test.com'
    );

    insert tenant;

    Lease_Agreement__c lease =
        new Lease_Agreement__c(
            Tenant__c = tenant.Id,
            End_Date__c = System.today().addDays(30)
        );

    insert lease;

    Test.startTest();

    LeaseExpiryScheduler.sendThirtyDayReminder();

    Test.stopTest();
}

}