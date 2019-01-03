global without sharing class CaseCommentsDetailController {
   @AuraEnabled
   public static CaseComment eachcmt{get;set;}
   
   
    
    @AuraEnabled
   public static CaseComment getCaseCommentRecToBePassed(String CaseCmtRecId){
       system.debug('eachcmt'+CaseCmtRecId);
    CaseComment eachcmt1 = [select Id,CommentBody,IsPublished, CreatedDate, CreatedBy.Name from CaseComment where Id=:CaseCmtRecId limit 1];
     system.debug('eachcmt'+eachcmt1);
       return eachcmt1;
   }   
   

}