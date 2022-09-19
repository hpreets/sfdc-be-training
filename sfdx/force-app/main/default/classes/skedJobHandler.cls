/**
 * @description Handler class for Job trigger.
 * @author Harpreet Singh
 * @date 13.SEP.2022
 */
public with sharing class skedJobHandler extends skedTriggerHandler {

    private static final String CLASS_NAME = 'skedJobHandler';
    public skedJobHandler() {
        super(CLASS_NAME);
    }

    /**
    * @description After Insert handler for Job trigger
    * @author Harpreet Singh
    * @date 13.SEP.2022
    */
    protected override void afterInsert() {
        List<sked__Job__c> newJobList = (List<sked__Job__c>) Trigger.new;
        Map<Id, sked__Job__c> oldJobMap = (Map<Id, sked__Job__c>) Trigger.oldMap;

        skedJobUtils.sendJobCompletionSms(newJobList, oldJobMap);
    }

    /**
    * @description After Update handler for Job trigger
    * @author Harpreet Singh
    * @date 13.SEP.2022
    */
    protected override void afterUpdate() {
        List<sked__Job__c> newJobList = (List<sked__Job__c>) Trigger.new;
        Map<Id, sked__Job__c> oldJobMap = (Map<Id, sked__Job__c>) Trigger.oldMap;

        skedJobUtils.sendJobCompletionSms(newJobList, oldJobMap);
    }
}
