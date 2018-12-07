({
	toggleEdit : function(component, value) {
		component.get('v.body').forEach(function(cmp) {
			cmp.get('v.body').forEach(function(cmpItem) {
				cmpItem.set('v.isEdit', value);
			});
		});
		component.set('v.isEdit', value);
	},
	save: function(component) {
		component.getEvent('SaveEdit').fire();
	},
	cancel: function(component) {
		component.getEvent('CancelEdit').fire();
	},
	validate: function(component) {
		var isDisabled = false;
		component.get('v.body').forEach(function(cmp) {
			cmp.get('v.body').forEach(function(cmpItem) {
				if(!cmpItem.get('v.isValid')) {
					isDisabled = true;
				}
			});
		});
		component.set('v.isDisabled', isDisabled);
	}
})