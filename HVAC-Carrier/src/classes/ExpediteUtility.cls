public class ExpediteUtility {
    public static String getCurrentLoggedInUserProfile(){
        String returnProfileName = '';
        if(UserInfo.getProfileId()!=null){
            Id profileId = UserInfo.getProfileId();
            if(profileId!=null){
                returnProfileName =  [SELECT Id, Name FROM Profile where Id=:profileId].Name;
            }
        }
        return  returnProfileName;
    }
    public static Boolean checkIfCurrentLoggedInUserIsExpedite(){
        Boolean isExpediteOrSystemAdmin = false;
        String profileName = getCurrentLoggedInUserProfile();
        System.debug('#Profile Name:'+profileName);
        if(profileName!=null && profileName.length()>0 && (profileName.contains('Expedite') || profileName=='System Administrator')){
            System.debug('Yes Matched!!');
            isExpediteOrSystemAdmin = true;
        }
        return isExpediteOrSystemAdmin;
    }
}