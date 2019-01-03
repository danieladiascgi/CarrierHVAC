public class LiveChatButtonController {
    //public String Email{get; set;}
    public String payload{get; set;}
    public String buttonId{get; set;}
    public String contactFirstName{get; set;}
    public String contactLastName{get; set;}
    public String contactEmail{get; set;}
    public String hvacId{get; set;}
    public String caseNumber{get; set;}
    public String purpose{get; set;}
    public String subPurpose{get; set;}
    public String partNumber{get; set;}
    public String orderNumber{get; set;}

    public LiveChatButtonController(){
         payload = ApexPages.currentPage().getParameters().get('value');
        buttonId = ApexPages.currentPage().getParameters().get('buttonId');
            if(payload!=null && payload.length()>0){
                parsePayloadAndGetValues(payload);    
            }
        caseNumber = ApexPages.currentPage().getParameters().get('caseNumber');
        purpose = ApexPages.currentPage().getParameters().get('purpose');
        subPurpose = ApexPages.currentPage().getParameters().get('subPurpose');
        partNumber = ApexPages.currentPage().getParameters().get('partNumber');
        orderNumber = ApexPages.currentPage().getParameters().get('orderNumber');
        if(caseNumber==null){
            caseNumber = '';
        }
        if(purpose==null){
            purpose = '';
        }
        if(subPurpose==null){
            subPurpose = '';
        }
        if(partNumber==null){
            partNumber = '';
        }
        if(orderNumber==null){
            orderNumber = '';
        }
        
    }
    public void parsePayloadAndGetValues(String payload){
        System.debug('#payload:'+payload);
        //payload = 'SRqDbdPlQI4BhfL93IzdXWVeWjRSdpZ7MxgZEv2n0TOREYkGeT+EQ2j+WQnd6F+uq3+4z8R2XzRe7npIVLWQ7bC6m5Z1yTC6NoYp2dS6VCgslsj77eHd3/knM0PEuQkw1AI5CCoaF2sNnZ+v357XicN7ez6pAycJjwo6Y4dsgAU=';
        if(payload.contains(' ')){
            payload = payload.replaceAll(' ', '+');
        }
        System.debug('#payload after:'+payload);
        JWTDecryptFinal decrypt = new JWTDecryptFinal();
        //this.contactFirstName = decrypt.getFirstName(payload);
        this.contactFirstName = decrypt.getFirstNameDecrypt(payload);
        
        System.debug('#contactFN:'+contactFirstName);
        //this.contactLastName = decrypt.getLastName(payload);
        this.contactLastName = decrypt.getLastNameDecrypt(payload);
        
        //this.contactEmail = decrypt.getEmail(payload);
        this.contactEmail = decrypt.getEmailDecrypt(payload);
        
        this.hvacId = decrypt.getHVACIDDecrypt(payload);
        System.debug('#Hvac ID:'+this.hvacId);
        
        
    }
}