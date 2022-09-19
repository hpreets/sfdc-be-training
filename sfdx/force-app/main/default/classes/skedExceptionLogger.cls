/**
* @description Exception Logger class to store all exceptions at a common places in a custom object Exception_Log__c
* @author Harpreet Singh
* @date 13.Sep.2022
**/
public without sharing class skedExceptionLogger {
    private static Exception_Log__c[] listExceptionLogs { get; set; }

    static {
        listExceptionLogs = new List<Exception_Log__c>{};
    }

    /**
     * @description method to log the exception along with all the details from it
     * @author Harpreet Singh
     * @date 13.Sep.2022
     * @param ex Exception that requires be logged
     * @param className Name of the class logging the exception/error
     * @param methodName Name of the method logging the exception/error
     * @return void
     **/
    public static void logException(
        Exception ex,
        String className,
        String methodName
    ) {
        // create and get the database log record
        Exception_Log__c logRec = createLogRecord(
            className,
            methodName,
            ex.getMessage(),
            ex.getTypeName(),
            ex.getStackTraceString()
        );

        //skip log insertion if exception occured in constructor, as @future and DML operations are not allowed in constructor.
        if (className != methodName) {
            listExceptionLogs.add(logRec);
        }
    }



    /**
     * @description method to log the API or other errors along with all the details from it
     * @author Harpreet Singh
     * @date 13.Sep.2022
     * @param errorDetails Error received from API or other sources
     * @param className Name of the class logging the exception/error
     * @param methodName Name of the method logging the exception/error
     * @return void
     **/
    public static void logError(
        String errorDetails,
        String className,
        String methodName
    ) {
        // create and get the database log record
        Exception_Log__c logRec = createLogRecord(
            className,
            methodName,
            null,
            null,
            errorDetails
        );

        //skip log insertion if exception occured in constructor, as @future and DML operations are not allowed in constructor.
        if (className != methodName) {
            listExceptionLogs.add(logRec);
        }
    }


    /**
     * @description method to create the Exception_Log__c based on the error attributes
     * @author Harpreet Singh
     * @date 13.Sep.2022
     * @param className Name of the class logging the exception/error
     * @param methodName Name of the method logging the exception/error
     * @param exMsg error/exception message
     * @param exceptionType type of the exception
     * @param stackTrace stack track providing more details of the exception
     * @return Exception_Log__c instance
     **/
    private static Exception_Log__c createLogRecord(
        String className,
        String methodName,
        String exMsg,
        String exceptionType,
        String stackTrace
    ) {
        Exception_Log__c exceptionLog = new Exception_Log__c();
        exceptionLog.Running_User__c = Userinfo.getUserId();
        exceptionLog.Class_Name__c = className;
        exceptionLog.Method_Name__c = methodName;
        exceptionLog.Exception_Message__c = exMsg;
        exceptionLog.Exception_Type__c = exceptionType;
        exceptionLog.StackTrace_Message__c = stackTrace;
        return exceptionLog;
    }


    /**
     * @description method to flush/insert all the logged error as a single DML transcation
     * @author Harpreet Singh
     * @date 13.Sep.2022
     * @return void
     **/
    public static void flush() {
        if (Limits.getLimitDMLStatements() < 1) {
            System.debug('*********No Of DML Statement Limit Reached.********');
        }

        if (!listExceptionLogs.isEmpty()) {
            if (!System.isFuture()  &&  !System.isBatch()  &&  Limits.getFutureCalls() < 1) {
                String serializedLogs = JSON.serialize(listExceptionLogs);
                flushInFuture(serializedLogs);
            } else {
                try {
                    insert listExceptionLogs;
                } catch (Exception ex) {
                    System.debug(
                        LoggingLevel.ERROR,
                        'Error during inserting error logs:' + ex.getMessage()
                    );
                }
            }

            listExceptionLogs = new List<Exception_Log__c>{};
        }
    }


    /**
     * @description method to flush/insert all the logged error as a single DML
     * transcation in a future method
     * @author Harpreet Singh
     * @date 13.Sep.2022
     * @param serializedLogs list of error logs formatted as a JSON string
     * @return void
     **/
    @future
    private static void flushInFuture(String serializedLogs) {
        List<Exception_Log__c> deSerializedLogs = (List<Exception_Log__c>) JSON.deserialize(
            serializedLogs,
            List<Exception_Log__c>.class
        );
        try {
            insert deSerializedLogs;
        } catch (Exception ex) {
            System.debug(
                LoggingLevel.ERROR,
                'Error during inserting error logs:' + ex.getMessage()
            );
        }
    }
}
