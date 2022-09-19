public class skedObjectSelectorFieldMapping {
    public Map<Schema.sObjectType, Set<String>> mapObjectType2Fields = new Map<Schema.sObjectType, Set<String>>{
        sked__Job__c.sObjectType => new Set<String>{
            'Id', 'Name', 'sked__Type__c', 'sked__Address__c', 'sked__Start__c', 'sked__Contact__c',
            'sked__Finish__c', 'sked__Job_Status__c', 'sked__Timezone__c', 'sked__Location__c', 'sked__Contact__c',
            'sked__Duration__c', 'sked__Region__c', 'sked__Region__r.Id', 'sked__Region__r.Name', 'sked__Region__r.sked__Timezone__c',
            'sked__Description__c', 'sked__Recurring_Schedule__c', 'sked__GeoLocation__latitude__s', 'sked__GeoLocation__longitude__s'
        },
        sked__Job_Tag__c.sObjectType => new Set<String>{
            'Id', 'sked__Tag__c', 'sked__Tag__r.Name', 'sked__Tag__r.Id', 'sked__Job__c', 'sked__Required__c', 'sked__Weighting__c'
        },
        sked__Job_Allocation__c.sObjectType => new Set<String>{
            'Id', 'sked__Status__c', 'sked__Start__c','sked__Set_End__c','sked__Duration__c','sked__Resource__c','sked__Job__c', 'sked__End1__c',
            'sked__Job__r.Name', 'sked__Job__r.sked__Timezone__c', 'sked__Job__r.sked__Job_Status__c', 'sked__Job__r.sked__Location__c', 'sked__Job__r.sked__Location__r.Name'
        },
        sked__Location__c.sObjectType => new Set<String>{
            'Id', 'Name', 'sked__Type__c', 'sked__Address__c', 'sked__GeoLocation__c', 'sked__GeoLocation__Latitude__s', 'sked__GeoLocation__Longitude__s'
        },
        sked__Resource__c.sObjectType => new Set<String>{
             'Id', 'Name', 'sked__Primary_Region__c', 'sked__Primary_Region__r.Name', 'sked__Category__c', 'sked__Notification_Type__c',
             'sked__User__c', 'sked__User__r.SmallPhotoUrl', 'sked__Primary_Region__r.sked__Timezone__c',
             'sked__Employment_Type__c', 'sked__GeoLocation__c','sked__GeoLocation__Longitude__s','sked__GeoLocation__Latitude__s',
             'sked__Resource_Type__c', 'sked__Home_Address__c', 'sked__Email__c'
        },
        sked__Activity__c.sObjectType => new Set<String>{
            'Id', 'Name', 'sked__Notes__c', 'sked__End__c', 'sked__Start__c', 'sked__Type__c', 'sked__Address__c', 'sked__Timezone__c', 'sked__Resource__r.Id', 'sked__Resource__r.Name',
            'sked__GeoLocation__c', 'sked__GeoLocation__Latitude__s', 'sked__GeoLocation__Longitude__s', 'sked__Resource__c', 'sked__Location__c', 'sked__Location__r.Name'
        },
        sked__Availability__c.sObjectType => new Set<String>{
            'Id', 'Name', 'sked__Is_Available__c', 'sked__Start__c', 'sked__Finish__c', 'sked__Type__c', 'sked__Status__c','sked__Notes__c',
            'sked__Timezone__c','sked__Resource__c'
        },
        sked__Availability_Template_Resource__c.sObjectType => new Set<String> {
            'Id', 'Name', 'sked__Availability_Template__c', 'sked__Resource__c'
        },
        sked__Availability_Template__c.sObjectType => new Set<String> {
            'Id', 'Name', 'sked__Start__c', 'sked__Finish__c', 'sked__Global__c'
        },
        sked__Availability_Template_Entry__c.sObjectType => new Set<String> {
            'id', 'name', 'sked__Availability_Template__c', 'sked__Finish_Time__c', 'sked__Is_Available__c', 'sked__Start_Time__c', 'sked__Weekday__c'
        },
        sked__Resource_Tag__c.sObjectType => new Set<String> {
            'Id','Name', 'sked__Tag__c', 'sked__Resource__c', 'sked__Expiry_Date__c'
        },
        sked__Resource_Shift__c.sObjectType => new Set<String>{
            'Id', 'Name', 'sked__Resource__c', 'sked__Shift__r.Name', 'sked__Shift__r.sked__Start__c', 'sked__Shift__r.sked__End1__c'
        },
        sked__Region__c.sObjectType => new Set<String>{
            'Id', 'Name', 'sked__Timezone__c'
        }
    };
}