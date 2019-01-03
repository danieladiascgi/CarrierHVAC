public class WebServiceProductsReq {
    
    public List<Products> products;
    
    public class Products {
        public String Name;
        public Boolean Active;
        public String Brand;
        public String External_ID;
        public String Material_Number;
    }
    
    
    public static WebServiceProductsReq parse(String json) {
        return (WebServiceProductsReq) System.JSON.deserialize(json, WebServiceProductsReq.class);
    }
}