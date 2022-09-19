/**
 * @description REST API for Job Scheduling
 * @author Harpreet Singh
 * @date 17-Sep-2022
 */
@RestResource(urlMapping='/SkedJobScheduling/v1/*')
global with sharing class skedJobSchedulingRest {

    /*
    * Sample JSON input parameter *
    {
        "duration": 60,
        "endDate": "2022-09-19",
        "eventIds": [],
        "homeId": null,
        "intEndTime": 1700,
        "intStartTime": 1600,
        "latitude": 49.0447731,
        "longitude": -122.7018055,
        "regionId": "a0X4x000004sXWwEAM",
        "startDate": "2022-09-19",
        "timezone": "Canada/Pacific"
    }
    */
    /**
     * @description POST request handler for REST request.
     * This method handles two requests /availableResources and /bookingData and likewise returns data.
     * @author Harpreet Singh
     * @date 16-Sep-2022
     * @param RestRequest.requestBody
     * @return RestResponse.responseBody
     */
    @HttpPost
    global static void doPost() {

        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;

        try {
            // Get JSON from requestBody and deserialise it to Criteria
            skedJobSchedulingModel.Criteria criteria
                = (skedJobSchedulingModel.Criteria) JSON.deserialize(
                    req.requestBody.toString(),
                    skedJobSchedulingModel.Criteria.class
            );

            switch on req.requestURI.substringAfterLast('/') {
                when 'availableResources' { criteria.includeResourceInfo = true; }
                when 'bookingData' { criteria.includeResourceInfo = false; }
                when else { criteria.includeResourceInfo = false; }
            }

            skedJobSchedulingCtrlHandler handler = new skedJobSchedulingCtrlHandler();
            skedResponse sResp = handler.getAvailableResources(criteria);

            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(sResp));
        }
        catch (Exception ex) {
            skedExceptionLogger.logException(ex, 'skedJobSchedulingRest', 'doPost');
            skedExceptionLogger.flush();

            res.statusCode = 204;
            res.responseBody = Blob.valueOf(ex.getStackTraceString());
        }
    }
}
