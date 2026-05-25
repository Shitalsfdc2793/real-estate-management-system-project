public with sharing class PropertyGeocodingService {
    
    @future(callout=true)
        public static void geocodeProperty(Id propertyId){
            Property__c prop =[Select Id, Address__c, 
                               City__c, State__c, Country__c
                               FROM Property__c
                               WHERE Id = :propertyId
                               LIMIT 1];
            
            String address = EncodingUtil.urlEncode(
            prop.Address__c + ',' +
            prop.City__c + ',' +
            prop.State__c + ',' +
            prop.Country__c,
            'UTF-8'
        );
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(
            'https://nominatim.openstreetmap.org/search?q=' +
            address +
            '&format=json&limit=1'
        );
            req.SetMethod('GET');
            HttpResponse res = http.send(req);
            if(res.getStatusCode() == 200) {

            List<Object> results =
                (List<Object>) JSON.deserializeUntyped(res.getBody());

            if(!results.isEmpty()) {

                Map<String,Object> result =
                    (Map<String,Object>) results[0];

                prop.Latitude__c =
                    Decimal.valueOf((String) result.get('lat'));

                prop.Longitude__c =
                    Decimal.valueOf((String) result.get('lon'));

                update prop;
            }
            
        }
    }
    
}