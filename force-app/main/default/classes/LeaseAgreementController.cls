public with sharing class LeaseAgreementController {
    
    @AuraEnabled(cacheable=true)
public static Lease_Agreement__c getLeaseAgreement(Id leaseId) {

    return [

        SELECT Id,
               Name,
               Terms__c,
               Agreed_Monthly_Rent__c,
               Start_Date__c,
               End_Date__c,
               Tenant__r.Name,
               Property__r.Name
        FROM Lease_Agreement__c
        WHERE Id = :leaseId
        LIMIT 1
    ];
}

}