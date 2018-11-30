({
    step1: function(component, event) {
        var tab1 = component.find('step1Id');
        var TabOneData = component.find('stepOneDataId');
        
        var tab2 = component.find('step2Id');
        var TabTwoData = component.find('stepTwoDataId');
        
        var tab3 = component.find('step3Id');
        var TabThreeData = component.find('stepThreeDataId');
        
        var tab4 = component.find('step4Id');
        var TabFourData = component.find('stepFourDataId');
        //oi
        $A.util.addClass(tab1, 'slds-active');
        $A.util.removeClass(TabOneData, 'slds-hide');
        $A.util.addClass(TabOneData, 'slds-show');
        // oi
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
        
        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-show');
        $A.util.addClass(TabFourData, 'slds-hide');
    },
    
    step2: function(component, event) {
        var tab1 = component.find('step1Id');
        var TabOneData = component.find('stepOneDataId');
        
        var tab2 = component.find('step2Id');
        var TabTwoData = component.find('stepTwoDataId');
        
        var tab3 = component.find('step3Id');
        var TabThreeData = component.find('stepThreeDataId');
        
        var tab4 = component.find('step4Id');
        var TabFourData = component.find('stepFourDataId');
        //oi
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOneData, 'slds-show');
        $A.util.addClass(TabOneData, 'slds-hide');
        // oi
        $A.util.addClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-hide');
        $A.util.addClass(TabTwoData, 'slds-show');
        
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
        
        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-show');
        $A.util.addClass(TabFourData, 'slds-hide');
    },
    
    step3: function(component, event) {
        var tab1 = component.find('step1Id');
        var TabOneData = component.find('stepOneDataId');
        
        var tab2 = component.find('step2Id');
        var TabTwoData = component.find('stepTwoDataId');
        
        var tab3 = component.find('step3Id');
        var TabThreeData = component.find('stepThreeDataId');
        
        var tab4 = component.find('step4Id');
        var TabFourData = component.find('stepFourDataId');
        //show and Active fruits tab
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOneData, 'slds-show');
        $A.util.addClass(TabOneData, 'slds-hide');
        // Hide and deactivate others tab
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        
        $A.util.addClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-hide');
        $A.util.addClass(TabThreeData, 'slds-show');
        
        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-show');
        $A.util.addClass(TabFourData, 'slds-hide');
    },
    
    step4: function(component, event) {
        var tab1 = component.find('step1Id');
        var TabOneData = component.find('stepOneDataId');
        
        var tab2 = component.find('step2Id');
        var TabTwoData = component.find('stepTwoDataId');
        
        var tab3 = component.find('step3Id');
        var TabThreeData = component.find('stepThreeDataId');
        
        var tab4 = component.find('step4Id');
        var TabFourData = component.find('stepFourDataId');
        //show and Active fruits tab
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOneData, 'slds-show');
        $A.util.addClass(TabOneData, 'slds-hide');
        // Hide and deactivate others tab
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
        
        $A.util.addClass(tab4, 'slds-active');
        $A.util.removeClass(TabFourData, 'slds-hide');
        $A.util.addClass(TabFourData, 'slds-show');
    },
    
})