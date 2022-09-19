/**
 * @description Utility class for Job.
 * @author Harpreet Singh
 * @date 13.SEP.2022
 */
public with sharing class skedJobUtils {

    /**
    * @description After Insert handler for Job trigger
    * @author Harpreet Singh
    * @date 13.SEP.2022
    * @param List of new job records
    * @param Map of older version of job records
    */
    public static void sendJobCompletionSms(List<sked__Job__c> newJobList, Map<Id, sked__Job__c> oldJobMap) {
        Map<Id, sked__Job__c> contactIdToCompletedJobMap = new Map<Id, sked__Job__c>();
        String clsName = 'skedJobUtils';
        String methodName = 'sendJobCompletionSms';

        try {
            // Subset - Jobs with Status changed to Completed
            for (sked__Job__c job : newJobList) {
                if ( (job.sked__Job_Status__c == 'Complete')
                        &&  ((oldJobMap.get(job.Id) == null)
                            || job.sked__Job_Status__c != oldJobMap.get(job.Id).sked__Job_Status__c )) {

                    if (job.sked__Contact__c != null) {
                        contactIdToCompletedJobMap.put(job.sked__Contact__c, job);
                    }
                }
            }

            if (contactIdToCompletedJobMap.size() > 0) {
                // Fetch Contacts related to subset Jobs
                List<Contact> contactList
                    = [SELECT Id, MobilePhone, MailingCountry, FirstName, LastName
                        FROM Contact
                        WHERE Id IN :contactIdToCompletedJobMap.keySet()
                            AND MobilePhone != NULL];

                if (contactList.size() > 0) {

                    // Send SMS
                    for (Contact cont : contactList) {
                        String smsMessage = skedJobUtils.getJobCompletionMsg(contactIdToCompletedJobMap.get(cont.Id), cont);
                        if (smsMessage != null) {

                            // Send SMS
                            // Important: Although this trigger code is bulkified,
                            // however, API code to send SMS is not bulkified.
                            // Hence it is sent for each Job & its Contact.
                            skedJobUtils.sendSMS(
                                cont.MobilePhone,
                                skedUtils.getCountryCodeFromCountry(cont.MailingCountry),
                                smsMessage);

                        } else {
                            skedExceptionLogger.logError('SMS Message on Job Completion not set', clsName, methodName);
                        }
                    }
                }
            }
        }
        catch (Exception ex) {
            skedExceptionLogger.logException(ex, clsName, methodName);
        }
        // Make sure to flush to insert Exception Log data.
        skedExceptionLogger.flush();
    }


    /**
    * @description Fetch SMS Message text to be sent to Contact on job completion. It handles limited field merging
    * @author Harpreet Singh
    * @date 13.SEP.2022
    * @param job Job record
    * @param cont Contact record
    * @return message with merged data
    */
    public static String getJobCompletionMsg(sked__Job__c job, Contact cont) {
        skedJobConfig__mdt mc = skedJobConfig__mdt.getInstance('Default');

        // Field Merging can be fully generalized rather than specifying a limited number of fields to be merged.
        return mc.JobCompletionMsgText__c == null ?
                    null :
                    mc.JobCompletionMsgText__c
                    .replace('{Job.Name}', job.Name)
                    .replace('{Contact.FirstName}', cont.FirstName)
                    .replace('{Contact.LastName}', cont.LastName);
    }

    /**
    * @description Send SMS using Skedulo API
    * @author Harpreet Singh
    * @date 13.SEP.2022
    * @param mobile mobile number to which SMS to be sent
    * @param countryCode country code for mobile number
    * @param smsMessage actual text to be sent
    * @return void
    */
    @future(callout=true)
    public static void sendSMS(String mobile, String countryCode, String smsMessage) {
        // Send SMS
        sked.ApiResult.Sms response
            = sked.SkeduloAPI.sms(mobile, countryCode, smsMessage);

        if (response.isSuccess()) {
            System.debug('Message sent');
        } else {
            // System.debug('Error: ' + response.getError());
            // Log error into Exception Log
            skedExceptionLogger.logError( 'sked.SkeduloAPI.sms Response: ' + response.getError(), 'skedJobUtils', 'sendSMS');
            skedExceptionLogger.flush();
        }
    }

}
