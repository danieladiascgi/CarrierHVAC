public class Send_To_Junk_Controller {
   public Boolean refreshPage {get; set;}
   public Send_To_Junk_Controller(ApexPages.StandardController stdController){
     //  refreshPage=true;
   }
   public PageReference ChangeOwner()
   {
       String id1;
       id1 = ApexPages.currentPage().getParameters().get('id');
       System.debug('case'+id1);
       Case c =[select Id,OwnerId from Case  where id =: id1];
       c.OwnerId = [select Id from Group where Name='Junk Email' and Type = 'Queue'].Id;
       System.debug('Queue'+ c.OwnerId);
       Update c;
     //  refreshPage=true;
       PageReference nextPage = new PageReference('/' + c.Id);
       nextPage.setRedirect(true);
       return nextPage;
      
    }
}