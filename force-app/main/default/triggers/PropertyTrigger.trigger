trigger PropertyTrigger on Property__c (after insert, after update) {

    for(Property__c prop : Trigger.new) {

        PropertyGeocodingService.geocodeProperty(prop.Id);
    }

}