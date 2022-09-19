# sfdc-be-training
Repository for my exercise on skedulo training

### Hands-on exercises

1.  :white_check_mark: Update the test class skedDateTimeUtils_Practice, fill in the code and make sure test cases are Passed.
	- Class updated:
		- `skedDateTimeUtils_Practice`

1.  :white_check_mark: Implement a trigger logic to send an SMS to the related Job contact’s phone number when a Job is completed.
	- Code created / updated
		- Apex Trigger:
			- `skedJobTrigger.trigger` - Job Trigger
		- Apex Class
			- `skedJobHandler` - Handler class for Job Trigger
			- `skedTriggerHandler` - Base class for all Trigger Handlers
			- `skedJobUtils` - Utility class for Job. Contains the actual code to send SMS.
			- `skedUtils` - New method to fetch SMS Region Code from Country
			- `skedExceptionLogger` - Inserts Exception / Error logs into Custom Object
		- Custom Object
			- `Exception_Log__c` - Stores Exception / Error logs
		- Custom Metadata
			- `skedJobConfig__mdt` - Configuration data for Job. Currently has only 1 entry for SMS text.

1.  :white_check_mark: Update the test class skedObjectSelector_Practice, fill in the code and make sure test cases are Passed.
	- Class updated:
		- `skedObjectSelector_Practice`

1.  :white_check_mark: Expose the getAvailableResources() method (skedJobSchedulingCtrlHandler class) as a custom SF REST (POST) API that receives the same parameters (request body is in json format) as the Apex Remote version.
	- Class created:
		- `skedJobSchedulingRest` - Handles `/SkedJobScheduling/v1/*` to return `bookingData` and `availableResources` based on JSON input.

1.  :white_check_mark: Customize the resource availability calculation logic to include Shift records as busy events.
	- Classes updated:
		- `skedBaseModels` - New virtual class created for `skill` and `resourceSkill`
		- `skedModels` - New virtual class created for `skill` and `resourceSkill`. These extend the classes in `skedBaseModels`
		- `skedResourceAvailabilityBase` - (1) Updated method `getResourceWithAvailabilities` to include `sked__Resource_Shifts__r` data as part of SOQL. (2) Updated method `loadResourceEvents` to iterate through `sked__Resource_Shifts__r` and add events for resourceShift too.


