global class QuoteFields {
    
    @AuraEnabled
	global String Name; 
    @AuraEnabled
	global String Quote_number;
    @AuraEnabled
    global String Quote_Reference_Number;
	@AuraEnabled
    global Date Effective_Date;
	@AuraEnabled
    global Date Expired_Date;
	@AuraEnabled
    global String Quote_Description;
    
    @AuraEnabled
    global Decimal Sell_Price;
	@AuraEnabled
    global Decimal Buy_Price;
	@AuraEnabled
    global Integer Margin;
	@AuraEnabled
    global Integer Distributor_Gross;
    @AuraEnabled
    global String Description;
    

}