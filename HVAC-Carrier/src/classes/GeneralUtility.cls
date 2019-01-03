public class GeneralUtility {

    public static Set<String> getAllCommunityProfilesList(){
        Set<String> setOfCommunityProfiles = new Set<String>();
        String communityProfiles = Label.All_Partner_Profiles;
        if(communityProfiles!=null && communityProfiles.length()>0 && communityProfiles.contains(',')){
            List<String> listOfCommunityProfiles = communityProfiles.split(',');
            setOfCommunityProfiles.addAll(listOfCommunityProfiles);
        }
        System.debug('#setOfCommunityProfiles:'+setOfCommunityProfiles);
        return setOfCommunityProfiles;
    }
}