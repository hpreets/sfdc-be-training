@isTest
private class skedObjectSelector_Practice {
    @isTest
    static void practiceObjectSelector() {
        String brisbaneTimezone = 'Australia/Brisbane';

        // Data set up
        sked__Region__c region = new sked__Region__c(
            Name = 'Sydney',
            sked__Timezone__c = brisbaneTimezone,
            sked__Country_Code__c = 'AU'
        );
        insert region;

        sked__Resource__c resource = new sked__Resource__c(
            name 					= 'Test',
            sked__Resource_Type__c 	= 'Person',
            sked__Primary_Region__c = region.Id,
            sked__Category__c 		= 'Customer Service',
            sked__Country_Code__c 	= 'AU',
            sked__Home_Address__c 	= '24 Tuckett Rd, Salisbury, Queensland, AUS'
        );
        sked__Resource__c notRelevantResource = resource.clone();
        insert new List<sked__Resource__c>{resource, notRelevantResource};

        DateTime currentTime = DateTime.now();
        DateTime next7DaysTime = currentTime.addDays(7);

        // Create first activity in the past
        sked__Activity__c firstActivity = new sked__Activity__c(
            sked__Address__c 	= '28 Tuckett Rd, Salisbury, Queensland, AUS',
            sked__Type__c 		= 'Meal Break',
            sked__Start__c 		= currentTime.addDays(-7),
            sked__End__c 		= currentTime.addDays(-7).addMinutes(120),
            sked__Resource__c 	= resource.Id
        );

        sked__Activity__c secondActivity = new sked__Activity__c(
            sked__Address__c 	= '28 Tuckett Rd, Salisbury, Queensland, AUS',
            sked__Type__c 		= 'Meal Break',
            sked__Start__c 		= currentTime.addDays(2),
            sked__End__c 		= currentTime.addDays(2).addMinutes(120),
            sked__Resource__c 	= resource.Id
        );
        insert new List<sked__Activity__c>{firstActivity, secondActivity};

        Test.startTest();
        // Init new selector
        skedObjectSelector resourceSelector = skedObjectSelector.newInstance(sked__Resource__c.SObjectType);

        //-----------------------Add the code below this line-----------------------

        // Add filter to resourceSelector to filter the resource record by resource.Id
        resourceSelector.filter(' Id = \'' + resource.Id + '\'');
        System.debug('resourceSelector.getQuery() :: ' + resourceSelector.getQuery());

        // Add parent query to include the parent Primary Region fields
        resourceSelector.parentQuery('sked__Primary_Region__c');
        System.debug('resourceSelector.getQuery() :: ' + resourceSelector.getQuery());

        // Add related child activities query with the Time filter on sked__Start__c - only get activity with start time in [currentTime, next7DaysTime]
        skedObjectSelector activitySelector = resourceSelector.subQuery('sked__Activities__r');
        System.debug('resourceSelector.getQuery() :: ' + resourceSelector.getQuery());
        // activitySelector.filter(' sked__Start__c IN (' + currentTime.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') + ', ' + next7DaysTime.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') + ')');
        activitySelector.filter(' sked__Start__c >= ' + currentTime.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\''));
        activitySelector.filter(' sked__Start__c <= ' + next7DaysTime.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\''));
        System.debug('resourceSelector.getQuery() :: ' + resourceSelector.getQuery());
        //-----------------------Add the code above this line-----------------------

        List<sked__Resource__c> resources = Database.query(resourceSelector.getQuery());
        Test.stopTest();

        System.assertEquals(1, resources.size());
        System.assertEquals(region.name, resources[0].sked__Primary_Region__r.Name);
        System.assertEquals(region.sked__Timezone__c, resources[0].sked__Primary_Region__r.sked__Timezone__c);
        System.assertEquals(1, resources[0].sked__Activities__r.size());
    }
}
