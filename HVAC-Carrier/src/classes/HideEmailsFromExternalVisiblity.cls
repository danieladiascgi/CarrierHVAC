public class HideEmailsFromExternalVisiblity {
	@future
  public static void hideVednorEmailsFromExternalVisiblity(List<Id> recordIds) {
      System.debug('#Inside Future Method:'+recordIds);
      if(recordIds!=null && recordIds.size()>0){
          Id emailMessagId = recordIds.get(0);
          System.debug('#emailMessagId:'+emailMessagId);
          if(emailMessagId!=null){
              EmailMessage  msg = [Select Id, IsExternallyVisible from EmailMessage where Id=:emailMessagId];
              System.debug('#Queried Msg:'+msg);
              msg.IsExternallyVisible = false;
              update msg;
              System.debug('#Updated Message:'+msg);
          }
      }
  }
    @future
  public static void postToExpediteGroup(List<Id> expediteRecordIdLst, List<Id> emailMsgRecordIdLst) {
      if(emailMsgRecordIdLst!=null && emailMsgRecordIdLst.size()>0 && expediteRecordIdLst!=null && expediteRecordIdLst.size()>0){
          Id emailMessagId = emailMsgRecordIdLst.get(0);
          Id expediteRecordId = expediteRecordIdLst.get(0);
          System.debug('#emailMessagId:'+emailMessagId);
          System.debug('#expediteRecordId:'+expediteRecordId);
          if(emailMessagId!=null && expediteRecordId!=null){
              EmailMessage  msg = [Select Id, Subject, FromAddress, IsExternallyVisible from EmailMessage where Id=:emailMessagId];
              System.debug('#Queried Msg:'+msg);
              Expedite__c exp = [Select Id, Name, CAse_Number__c, Case_Number__r.CaseNumber from Expedite__c where Id=:expediteRecordId];
              Id chatterGroupId = [SELECT Id,Name From CollaborationGroup where Name='Expedite' limit 1].Id;
              String comment = 'A new email has been received on Expedite['+exp.Name+'] belonging to Case['+exp.Case_Number__r.CaseNumber+'] with Subject['+msg.Subject+'] from '+msg.FromAddress;
              ConnectApi.FeedElement fe = ConnectAPI.ChatterFeeds.postFeedElement(null, chatterGroupId, ConnectApi.FeedElementType.FeedItem, comment);
              System.debug('#Posted Feed:'+fe.Id);
              
          }
      }
  }
}