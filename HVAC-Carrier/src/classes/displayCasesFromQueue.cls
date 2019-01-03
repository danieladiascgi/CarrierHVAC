public class displayCasesFromQueue {
    List<Case> caseList{get;set;}
    Set<String> queueList=new Set<String>();
    public User getUserId;

    public displayCasesFromQueue(CCC_ViewCaseController controller) {
    
    getUserId = [select Id, username from User where Id = :UserInfo.getUserId()];
    system.debug('------------->Constructor'+getUserId);

    }
    
    public list<Case> getAccessCases()
    {
    List<GroupMember> listGroups = [Select Id, UserOrGroupId, GroupId from GroupMember where UserOrGroupId=:getUserId.Id];
    system.debug('------------->'+listGroups);
    for(GroupMember getQueue:listGroups)
    {
    queueList.add(getQueue.GroupId);
    system.debug('------------>QueueId'+queueList);
    }
    
    caseList=[Select Id,CaseNumber,Account.CCC_Account_Display_Name__c,Flags__c,ClosedDate,Account.Name, IsClosed,IsEscalated,Priority,Reason,Status,Subject,Type,CCC_Purpose__c,CCC_Sub_Purpose__c,case.Owner.name,RecordType.Name,CreatedDate from Case where Owner.Id in : queueList];
    return caseList;
    }

}