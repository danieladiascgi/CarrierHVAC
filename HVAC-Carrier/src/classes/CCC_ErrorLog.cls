/**
* @ Developer : Devendra Rathore
* @date_created :  2/22/2016
* @functions : Detail description
* @Date Modified : <3/14/2016 > Reason: <Add Class, method and statement level comments, verify all methods and
     Remove unwanted commented code and debug statements>      Developer :<Ankita Rambole>
*
*
***/

public class CCC_ErrorLog{
    /**
                * @returns custom object CCC_Error_log__c
                * @parameters an object instance of an Exception, String, Controller throwing the exception
                * @description
                *
                *
                ***/
    public CCC_Error_log__c  ErrorLogCalloutException(System.CalloutException e,String strAddinfo,String strSource){
        String errorMsg = e.getMessage();
        if(errorMsg.length()>255){ //if the length of message is greater than 255 then print substring uptil 253 in errorMsg
            errorMsg = errorMsg.substring(0, 253);
        }
        String stackTrace = e.getStackTraceString();
        
        if(stackTrace.length()>255){ //if the length of message is greater than 255 then print substring uptil 253 in stackTrace
            stackTrace = stackTrace.substring(0, 253);
        }
         CCC_Error_log__c log = new  CCC_Error_log__c (CCC_Additional_Information__c=strAddinfo,
                                                        CCC_Logging_User__c=UserInfo.getUserId(),
                                                        CCC_Source__c= strSource,
                                                        CCC_Line_no__c= e.getLineNumber(), 
                                                        CCC_Message__c = e.getMessage(),
                                                        CCC_Type__c = e.getTypeName(),
                                                        CCC_Stack_Trace__c= stackTrace);
         Insert log;
         return log;
    }
   /**
                * @returns: custom object  CCC_Error_log__c
                * @parameters: an object instance of an Exception, String, Controller throwing the exception
                * @description
                *
                *
                ***/
    public CCC_Error_log__c ErrorLogException(Exception e,String strAddinfo,String strSource){
        String errorMsg = e.getMessage();
        if(errorMsg.length()>255){ //if the length of message is greater than 255 then print substring uptil 253 in errorMsg
            errorMsg = errorMsg.substring(0, 253);
        }
        String stackTrace = e.getStackTraceString();
        
        if(stackTrace.length()>255){ //if the length of message is greater than 255 then print substring uptil 253 in stackTrace
            stackTrace = stackTrace.substring(0, 253);
        }
        CCC_Error_log__c log = new  CCC_Error_log__c (CCC_Additional_Information__c=strAddinfo,
                                                        CCC_Logging_User__c=UserInfo.getUserId(),
                                                        CCC_Source__c= strSource,
                                                        CCC_Line_no__c= e.getLineNumber(),
                                                        CCC_Message__c = errorMsg,
                                                        CCC_Type__c = e.getTypeName(),
                                                        CCC_Stack_Trace__c= stackTrace); 
        // Insert log;
         return log;
    }
}