public with sharing class propertyPaginataionController {
    
    @AuraEnabled(cacheable=true)
    public static List<Property__c> getProperties(
        Integer pageSize,
        Integer offsetValue
    ) {

        return [
            SELECT Id,
                   Name,
                   Rent__c,
                   Status__c,
                   Furnishing_Status__c
            FROM Property__c
            LIMIT :pageSize
            OFFSET :offsetValue
        ];
    }

}