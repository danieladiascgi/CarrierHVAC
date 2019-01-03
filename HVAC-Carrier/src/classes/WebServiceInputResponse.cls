public class WebServiceInputResponse {    
    
     @AuraEnabled
    public static WebServiceInputResponse.SalesDeal_Details displayInputData(String inputParams){   
        
        HttpResponse res = KQuotesWebServiceCall.requestData(inputParams);
        WebServiceInputResponse params = WebServiceInputResponse.parse(res.getBody());
        
        String inputParams1 = '{ "KQuoteResponse": { "Response": { "SalesDeal_Details": { "Sales_Deal": "0006007438", "Sales_Deal_Desc": "Claim Rewrite Test1_ICP", "Distributor": "0000110905", "Price_List": "5A", "HDR_Valid_From_Date": 20180716, "HDR_Valid_To_Date": 20181231, "KD_Level": 1600, "KD_Level_Desc": "RESIDENTIAL SUPER MEGA", "REF_QUOTE": "K06J8553", "Dealer_Details": { "Dealer": "HVP999999", "DLR_Valid_From_Date": 20180716, "DLR_Valid_To_Date": 20181231 }, "Material_Details": [ { "Material_Entered": "N4A324AKG", "Brand": "UCF", "Sell_Price": " 662", "Buy_Price": " 543", "ITEM_Valid_From_Date": 20180716, "ITEM_Valid_To_Date": 20181231 }, { "Material_Entered": "CAS151HAA0A00A", "Brand": "UTX", "Sell_Price": " 3800", "Buy_Price": " 3750", "ITEM_Valid_From_Date": 20180716, "ITEM_Valid_To_Date": 20181231 } ] } } } }';
        WebServiceInputResponse params1 = WebServiceInputResponse.parse(inputParams);
        Map<String,WebServiceInputResponse.SalesDeal_Details> salesDealIdVsSalesDealDetail =  new Map<String,WebServiceInputResponse.SalesDeal_Details>();
        WebServiceInputResponse KQres = params1;
        WebServiceInputResponse.SalesDeal_Details salesDealDetail = KQres.KQuoteResponse.Response.SalesDeal_Details;
        String key = salesDealDetail.Sales_Deal;
        salesDealIdVsSalesDealDetail.put(key,salesDealDetail);
        KQuotesWebService_Resolve.CheckStatus(res.getStatusCode());   
        
        return salesDealDetail;
    }
    
    
    public class Response {
        @AuraEnabled
        public SalesDeal_Details SalesDeal_Details;
    }
    
    public class KQuoteResponse {
        @AuraEnabled
        public Response Response;
    }
    
    public class Dealer_Details {
        @AuraEnabled
        public String Dealer;
        @AuraEnabled
        public String DLR_Valid_From_Date;
        @AuraEnabled
        public String DLR_Valid_To_Date;
    }
    
    public class SalesDeal_Details {
        @AuraEnabled
        public String Sales_Deal;
        @AuraEnabled
        public String Sales_Deal_Desc;
        @AuraEnabled
        public String Distributor;
        @AuraEnabled
        public String Price_List;
        @AuraEnabled
        public String HDR_Valid_From_Date;
        @AuraEnabled
        public String HDR_Valid_To_Date;
        @AuraEnabled
        public String KD_Level;
        @AuraEnabled
        public String KD_Level_Desc;
        @AuraEnabled
        public String REF_QUOTE;
        @AuraEnabled
        public Dealer_Details Dealer_Details;
        @AuraEnabled
        public List<Material_Details> Material_Details;
    }
    @AuraEnabled
    public KQuoteResponse KQuoteResponse;
    
    public class Material_Details {
        @AuraEnabled
        public String Material_Entered;
        @AuraEnabled
        public String Brand;
        @AuraEnabled
        public String Sell_Price;
        @AuraEnabled
        public String Buy_Price;
        @AuraEnabled
        public String ITEM_Valid_From_Date;
        @AuraEnabled
        public String ITEM_Valid_To_Date;
    }
    
    @AuraEnabled
    public static WebServiceInputResponse parse(String json) {
        return (WebServiceInputResponse) System.JSON.deserialize(json, WebServiceInputResponse.class);
    }    
    
}