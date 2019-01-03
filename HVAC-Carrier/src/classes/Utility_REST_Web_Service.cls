/******************************************************************************* 
* Project      : Carrier Residential HVAC - Web Services  
* Description  : Utility for methods relating to integrations
* Methods      : makeCallout(); makes a callout and returns the returns the response.
* Author       : Vamshi Takallapally
* Date         : 12/11/2018
*******************************************************************************/
public class Utility_REST_Web_Service {    
    
    public static HttpResponse makeCallout(String service, String reqUrl, String reqBody1){
        
        Map<string,string> serviceParameters = WebServiceIntegration_Util.returnServiceParams(service);
        String endPointURL = serviceParameters.get('EndPointURL')+'&'+reqUrl;
        String userName = serviceParameters.get('Username');
        String password = serviceParameters.get('Password');
        String reqBody = '';
            
        HttpRequest req;
        HttpResponse res;
        Http h = new Http();
        req = new HttpRequest();
        req.setEndpoint(endPointURL);
        req.setBody(reqBody);
        req.setHeader('Content-Type', 'application/json; charset=utf-8');
        req.setheader('Authorization', 'usernamePassword');
        req.setMethod('serviceMethod');
        req.setTimeout(integer.ValueOf('timeout'));
        res = h.send(req);
        return res;
    } 
    
    public static String createUrlQueryString(RequestInputParams params) {
        String queryStr = '';
        if(String.isNotBlank(params.SALES_DEAL)){
            queryStr = addContainsFilter(queryStr, 'and', 'SalesDeals', params.SALES_DEAL);
        }
        if(String.isNotBlank(params.DISTRIBUTOR)){
            queryStr = addContainsFilter(queryStr, 'and', 'Distributor', params.DISTRIBUTOR);
        }
        if(params.HEADER_VALID_FROM_DATE!=null){
            queryStr = addEqualsFilter(queryStr, 'and', 'FromDate', String.valueOf(params.HEADER_VALID_FROM_DATE));
        }
        if(params.HEADER_VALID_TO_DATE!=null){
            queryStr = addEqualsFilter(queryStr, 'and', 'ToDate', String.valueOf(params.HEADER_VALID_TO_DATE));
        }
        if(String.isNotBlank(params.MATERIAL_ENTERED)){
            queryStr = addEqualsFilter(queryStr, 'and', 'MaterialEntered', params.MATERIAL_ENTERED);
        }
        if(String.isNotBlank(params.DEALER)){
            queryStr = addContainsFilter(queryStr, 'and', 'Dealer', params.DEALER);
        }
        if(String.isNotBlank(params.BRAND)) {
            queryStr = addContainsFilter(queryStr, 'and', 'Brand', params.BRAND);
        }
        String finalstring = oDataEncode(queryStr);
        System.debug('Final URL String: '+finalstring);
        return finalstring;
    }
    
    public static String oDataEncode(String str) {
        String retstring = str.replaceAll('\\*','\\\\*');
        retstring = EncodingUtil.urlEncode(retstring,'utf-8');
        return retstring;
    }
    
    public static String addEqualsFilter(String filterString, String boolOp, String field, String val) {
        val = String.escapeSingleQuotes(val);
        if (String.isBlank(filterString)) {
            return field + ' eq \'' + val + '\'';
        }
        return filterString + ' ' + boolOp + ' ' + field + ' eq \'' + val + '\'';
    }
    
    public static String addContainsFilter(String filterString, String boolOp, String field, String val) {
        val = String.escapeSingleQuotes(val);
        if (String.isBlank(filterString)) {
            return 'contains('+field+',\''+val+'\')';
        }
        return filterString + ' ' + boolOp + ' contains('+field+',\''+val+'\')';
    }
    
    public class RequestInputParams{
        public String SALES_DEAL;
        public String DISTRIBUTOR;
        public Date HEADER_VALID_FROM_DATE;
        public Date HEADER_VALID_TO_DATE;
        public String DEALER;
        public String BRAND;
        public String MATERIAL_ENTERED;
    }    
    
    public class ResponseOutputParams{
        public String SALES_DEAL;
        public String SALES_DEAL_DESC;
        public String DISTRIBUTOR;
        public String RELEASE_STATUS;
        public String PRICE_LIST;
        public Date HDR_VALID_FROM_DATE;
        public Date HDR_VALID_TO_DATE;
        public String KD_LEVEL;
        public String KD_LEVEL_DESC;
        public String DEALER;        
        public Date DLR_VALID_FROM_DATE;
        public Date DLR_VALID_TO_DATE;
        public String MATERIAL_ENTERED;        
        public String BRAND;
        public Decimal SELL_PRICE;
        public Decimal BUY_PRICE;
        public Date ITEM_VALID_FROM_DATE;
        public Date ITEM_VALID_TO_DATE;
    } 
}