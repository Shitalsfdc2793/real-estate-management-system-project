public with sharing class PropertyController {
    
    @AuraEnabled(cacheable=true)
    public static Property__c getProperty(Id propertyId) {

        return [
            SELECT Id,
                   Name,
                   Latitude__c,
                   Longitude__c
            FROM Property__c
            WHERE Id = :propertyId
            LIMIT 1
        ];
    }

}