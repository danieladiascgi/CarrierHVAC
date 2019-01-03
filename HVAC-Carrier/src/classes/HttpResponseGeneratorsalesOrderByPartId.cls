@isTest
global class HttpResponseGeneratorsalesOrderByPartId implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
      //  System.assertEquals('http://example.com/example/test', req.getEndpoint());
      //  System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"id":64190438,"orderType":"S1","customerId":271151,"customerPurchaseOrderId":"9420839","creationDate":"2018-05-01","holdCode":null,"lines":null}]');
        res.setStatusCode(200);
        return res;
    }


}