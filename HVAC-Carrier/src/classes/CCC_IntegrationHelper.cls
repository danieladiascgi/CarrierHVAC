/**
* @ Developer    :  Ishita Sharma
* @date_created  :  3/16/2016
* Description    :  Description: This Class contains the Callout code for PHDB Web Service : 
                    
***/

public class CCC_IntegrationHelper {
    
    Public String Response;

    public String getPHDBInformation(String Lastname, String Street,String Phone,String PhoneNo2 , String PostalCode,String FirstName,String City,String lstName, String ConfNo,String Zipcode, String instalAddress, String PhNo,String RegisNo, String email,string serialNo,string ModelNo){ 
                     
            Access_Token__c tokenValue=Access_Token__c.getValues('PHDB Smart Search');
                String token=tokenValue.PHDB_Access_Token__c;                         
                HttpRequest req1 = new HttpRequest();
                Http http = new Http();
                CCC_IntegrationEndPoint__c  CustomSettingEndPoint2 = CCC_IntegrationEndPoint__c.getValues('PHDB');
                String baseURL=CustomSettingEndPoint2.URL__c;
                //String baseURL = ' http://staging.phdbws.carrier.com/api/'; 
                String endpoint= baseURL + 'product-registration-search/';
                String requestParam='<RegistrationSearchRequest>';
                
                If(LastName!=null  &&  LastName!='' ){
                    requestParam = requestParam+'<ConsumerLastName>' + Lastname + '</ConsumerLastName>';
                }
                
                If(Street !=null && Street!=''){
                    requestParam = requestParam+'<ConsumerAddress>' + Street + '</ConsumerAddress>';
                
                    
                }
                
                If(Phone !=null && Phone!=''){
                    requestParam = requestParam+'<ConsumerPhone1>' + Phone + '</ConsumerPhone1>';
                
                    
                }
                
              If(PhoneNo2 !=null && PhoneNo2 !=''){
                    requestParam = requestParam+'<ConsumerPhone2>' + PhoneNo2 + '</ConsumerPhone2>';
                
                    
                }
                
                If(PostalCode !=null && PostalCode!=''){
                    requestParam = requestParam+'<ConsumerZip>' + PostalCode + '</ConsumerZip>';
                
                }
                
                
                 if(lstName !=null && lstName !='' ){
                     requestParam = requestParam+'<ConsumerLastName>' + lstName + '</ConsumerLastName>';
                }
                if(instalAddress!=null&& instalAddress!='' ) {
                    requestParam = requestParam+'<ConsumerAddress>' + instalAddress + '</ConsumerAddress>';
                }
                if(PhNo!=null && PhNo!='') {
                     requestParam = requestParam+'<ConsumerPhone1>' + PhNo + '</ConsumerPhone1>';
                }
                if(Zipcode!=null && Zipcode!='') {
                    requestParam = requestParam+'<ConsumerZip>' + Zipcode + '</ConsumerZip>';
                }
                if(ConfNo!=null && ConfNo!='') {
                     requestParam = requestParam+'<RegNo>' + ConfNo + '</RegNo>';
                }
                
                if(RegisNo!=null && RegisNo!='') {
                     requestParam = requestParam+'<SBRegNo>' + RegisNo + '</SBRegNo>';
                }
                
                 if(email!=null && email!='') {
                     requestParam = requestParam+'<Email>' + email + '</Email>';
                }
                
                
                if(serialNo !=null && serialNo !='') {
                     requestParam = requestParam+'<Serial>' + serialNo+ '</Serial>';
                }                
               
                if(ModelNo !=null && ModelNo !='') {
                     requestParam = requestParam+'<Model>' + ModelNo+ '</Model>';
                }
               
                requestParam=requestParam+'</RegistrationSearchRequest>';
                req1.setEndpoint(endpoint);
                req1.setMethod('POST');
                req1.setTimeout(120000);
                system.debug('req--'+requestParam); 
                req1.setBody(requestParam);
                String authorizationHeader1 = 'Bearer '+token;
                req1.setHeader('Authorization', authorizationHeader1);
                HTTPResponse res1= http.send(req1);
                
                system.debug('res1.......'+res1+'res1.....status'+res1.getStatus());
                if(res1.getStatus()!='Not Found'){
                    system.debug('res1.getBody()tatus'+res1.getBody());
                    Response=res1.getBody();
                    system.debug('res1.getBody()tatus'+Response);
                }
            
       return  Response;
    }
    
}