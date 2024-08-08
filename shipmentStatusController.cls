public class shipmentStatusController {
    @AuraEnabled(cacheable=true)
    public static String getStatus(String recordId) {
        try {
            // Fetch the shipment record
            Customer_Shippment__c shipment = [SELECT Name, Tracking_Number__c FROM Customer_Shippment__c WHERE Id = :recordId LIMIT 1];

            // Convert Tracking_Number__c to a String
            String trackingNumber = String.valueOf(shipment.Tracking_Number__c);

            // Check if the shipment record or its Tracking_Number__c field is empty
            if (shipment == null || String.isEmpty(trackingNumber)) {
                throw new AuraHandledException('Tracking number cannot be found or is empty.');
            }

            // Create and configure the HTTP request
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://merzcommunities--mel.sandbox.my.salesforce-sites.com/services/apexrest/mockShipmentStatus?trackingNumber=' + EncodingUtil.urlEncode(trackingNumber, 'UTF-8'));
            req.setMethod('GET');
            
            // Send the HTTP request and get the response
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            // Check the response status and return the response body or throw an error
            if (res.getStatusCode() == 200) {
                return res.getBody();
            } else {
                throw new AuraHandledException('Error: ' + res.getStatus());
            }
        } catch (Exception e) {
            // Log the error for debugging purposes
            System.debug('Error in getStatus: ' + e.getMessage());
            throw new AuraHandledException('An unexpected error occurred. Please try again later.');
        }
    }
}