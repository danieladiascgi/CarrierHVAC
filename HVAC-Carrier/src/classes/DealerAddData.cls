public class DealerAddData {
    
    @AuraEnabled
    public static List<QuoteFields> generateDealerAddData(){
        List<QuoteFields> currList = new List<QuoteFields>();
        Integer x;
        String des = 'Quisque in velit risus. Fusce vulputate eu ante sed cursus. Pellentesque a nisi nec mi venenatis faucibus.';
        for (x=100;x<=105;x++){
            QuoteFields q = new QuoteFields();
            q.Name = 'Quote'+String.valueOf(x);
            q.Quote_number = '123456'+String.valueOf(x);
            q.Quote_Reference_Number = String.valueOf(x);
            q.Effective_Date = system.Date.today();
            system.debug('Check Date1'+q.Effective_Date);
            q.Expired_Date = system.Date.today()+100;
            system.debug('Check Date2'+q.Expired_Date);
            q.Quote_Description = 'Description for Quote '+ String.valueOf(x);
            
            q.Sell_Price = x;
            q.Buy_Price = x;
            q.Margin = x;
            q.Distributor_Gross = x;
            q.Description = des + String.valueOf(x);
            
            currList.add(q);
        }
        return currList;
    }
    
}