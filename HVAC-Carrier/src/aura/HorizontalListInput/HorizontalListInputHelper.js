({
	validate : function(component, event) {
		if(component.get('v.isRequired') && $A.util.isEmpty(component.get('v.value'))) {
			component.set('v.isValid', false);
		} else if(!(new RegExp(component.get('v.pattern')).test(component.get('v.value')))) {
			component.set('v.isValid', false);
		} else {
			component.set('v.isValid', true);
		}
		component.getEvent('CheckInputValidity').fire();
	}
})