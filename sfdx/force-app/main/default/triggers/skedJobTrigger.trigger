/**
 * @description Job Trigger.
 * @author Harpreet Singh
 * @date 13.SEP.2022
 */
trigger skedJobTrigger on sked__Job__c (
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    new skedJobHandler().run();
}