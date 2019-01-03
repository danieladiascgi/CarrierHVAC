/********************************************************************************************************************** 
* Project      : Carrier - HVAC & SAP Web Services  
* Description  : Utility for methods relating to integrations
* Methods      : returnServiceParams(); returns the endpoint and parameters necessary for an integration relative to 
                 which environment code is running(Sandbox vs production).
* Author       : Vamshi Takallapally
* Date         : 12/11/2018 KQuotesWebService_Resolve
**********************************************************************************************************************/
public class KQuotesWebService_Resolve {
    
    public static String STATUS_OK = 'Success response.';
    public static String STATUS_BAD = 'Bad Request: The client has sent a request object that the server could not parse.  Often malformed JSON.';
    public static String STATUS_FORBIDDEN = 'Forbidden:  Used for when user is not authorized to do the operation.   In this case, the server understood the operation request, but the user does not have rights in SpringCM to do this operation.  If the user does not have security to see the object or the object does not exist, a 404 will be returned.';
    public static String STATUS_NOTFOUND = 'Not Found: Use when object does not exists.  This will also be returned in the case where it might exist in SpringCM, but the user does not have access to it based on their security profile.  In this case the error message returned will be "Object does not exist or the user does not have access rights".';
    public static String STATUS_ISE = 'Internal Server Error: This is returned in the case of an unexpected server.  This is generally not a client issue and indicates a system error that must be addressed by SpringCM.';
    
    public static void CheckStatus(Integer STATUS_CODE){
        if(STATUS_CODE==200){
            SendEmailWithStatus(STATUS_OK);
        }
        if(STATUS_CODE==400){
            SendEmailWithStatus(STATUS_BAD);
        }
        if(STATUS_CODE==403){
            SendEmailWithStatus(STATUS_FORBIDDEN);
        }
        if(STATUS_CODE==404){
            SendEmailWithStatus(STATUS_NOTFOUND);
        }
        if(STATUS_CODE==500){
            SendEmailWithStatus(STATUS_ISE);
        }
        if(STATUS_CODE!=null){
            SendEmailWithStatus('Error Unknown');
        }
    }
    
    public static void SendEmailWithStatus(String body)
    {	
        User u = [SELECT u.Id,u.Name,u.Email from User u WHERE u.id='0050m000001DDgr'];
        String subject = 'WebService Response';       
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        email.setSubject( subject );
        
        email.setToAddresses( new String[] {u.Email} );
        email.setPlainTextBody( body );
        
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
    }
    
}