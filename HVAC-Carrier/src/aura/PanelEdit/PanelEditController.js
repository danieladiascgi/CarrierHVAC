({
	doEdit: function(component, event, helper) {
		helper.toggleEdit(component, true);
	},
	doSave: function(component, event, helper) {
		helper.toggleEdit(component, false);
		helper.save(component);
	},
	doCancel: function(component, event, helper) {
		helper.toggleEdit(component, false);
		helper.cancel(component);
	},
	validate: function(component, event, helper) {
		helper.validate(component);
	}
})