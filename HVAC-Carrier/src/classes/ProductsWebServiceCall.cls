@RestResource(urlMapping='/Products/*')
global class ProductsWebServiceCall {
    
    global static String sample = '{ "products": [ { "Name": "SampleTestProduct1", "Active": true, "Brand": "Bryant", "External_ID": "10345aagft687", "Material_Number": "Prod569876ddtfguh" }, { "Name": "SampleTestProduct2", "Active": false, "Brand": "Literature", "External_ID": "10345udgsdf6555", "Material_Number": "Prod56sd9876tfguh" } ] }';
    
    @HttpPut
    global static ResponseWrapper upsertProducts() {   
        
        ResponseWrapper responseJSON = new ResponseWrapper();
        responseJSON.status = 'Success';
        responseJSON.message = 'Records are updated';
        List<Carrier_Products__c> carrierProducts = new List<Carrier_Products__c>();
        
        try{
            RestRequest request = RestContext.request;            
            WebServiceProductsReq params = WebServiceProductsReq.parse(request.requestBody.toString());
            List<WebServiceProductsReq.Products> products = params.products;
            
            List<Carrier_Products__c> carrierPrd = new List<Carrier_Products__c>();
            set<String> brandNames = new set<String>();
            map<String,Id> brandNameVsBrandId = new map<String,Id>();
            for(WebServiceProductsReq.Products product:products){
                brandNames.add(product.Brand);
            }
            for(Brand__c brand:[SELECT Id,Name FROM Brand__c WHERE Name IN:brandNames]){
                brandNameVsBrandId.put(brand.Name,brand.Id);
            }
            
            for(WebServiceProductsReq.Products product:products){
                Carrier_Products__c carrierProduct  	=   new Carrier_Products__c();
                carrierProduct.Name                 	=   product.Name;
                carrierProduct.Active__c            	=   product.Active;
                if(brandNameVsBrandId.containsKey(product.Brand)){
                    carrierProduct.Brand__c             =   brandNameVsBrandId.get(product.Brand);
                }
                carrierProduct.Material_Description__c  =   product.Material_Number;
                carrierProduct.ExtID__c       			=   product.External_ID;
                
                carrierProducts.add(carrierProduct);
            }
            system.debug('carrierProducts: '+carrierProducts);
            if(carrierProducts.size()>0){
                Database.UpsertResult [] cr = Database.upsert(carrierProducts,Carrier_Products__c.fields.ExtID__c,false);                    
            }
        }
        catch(exception ex){
            system.debug('ExMsg: '+ex.getMessage());
            if(ex == null){
                
            }else{
                responseJSON.status = 'Failed';
                responseJSON.message = ex.getMessage();
            }
        }
        return responseJSON;
    }
    
    global class ResponseWrapper {        
        global String status {get;set;} 
        global String message {get;set;}
    }
}