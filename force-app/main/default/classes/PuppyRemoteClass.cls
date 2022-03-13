global without sharing class PuppyRemoteClass implements vlocity_ins.VlocityOpenInterface {

    private static String RETRIEVE_PUPPIES = 'retrievePuppies';

    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {
        if(methodName == RETRIEVE_PUPPIES) {
            return retrievePuppies(input, output);
        }

        return false;
    }

    private static Boolean retrievePuppies(Map<String,Object> input, Map<String,Object> output) {
        // Initialise output map
        if (output == null){
            output = new Map<String, Object>();
        }

        // Get input from IP
        Id volunteerId = (Id) input.get('VolunteerId');
        Integer volunteerAge = Integer.valueOf(input.get('VolunteerAge'));

        // Check custom permission
        Boolean hasPerm = FeatureManagement.checkPermission('ViewAllPuppies');

        // Retrieve all, or just my own, puppies
        List<Puppy__c> puppies;        
        if(volunteerAge >= 18 || hasPerm) {
            puppies = [
                SELECT Id, Name
                FROM Puppy__c
            ];
        } else {
            puppies = [
                SELECT Id, Name
                FROM Puppy__c
                WHERE Carer__c = :volunteerId
            ];
        }

        output.put('Puppies', puppies);
        return true;
    }

}
