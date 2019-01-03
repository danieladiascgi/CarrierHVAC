/**
* @ Developer     : Tejas jambekar
* @date_created   : 03/20/2017
* @functions      : 1. SaveCustom   - This extension class was created as part of ticket "DEF0000274" wherein user wanted a functionality to change purpose and sub-purpose of a case from Answer customer page and instead of going to Case detail everytime, The saveCustom function is invoked when "Save" button is clicked on ChangePurposeSubPurpose visualforce page and this function returns null so that page control/location is not lost unlike standard {!Save} functionality provided by Salesforce.
*                   
                    
* 
***/
public with sharing class ChangePurposeSubPurposeExt {
    public Case existingCase{get; set;}
    public ChangePurposeSubPurposeExt(ApexPages.StandardController controller){
        existingCase = (Case)controller.getRecord();
    }
    public PageReference SaveCustom(){
        update existingCase;
        return null;
    }
}