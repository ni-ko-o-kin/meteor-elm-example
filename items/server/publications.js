import { Meteor } from 'meteor/meteor';

import { Items } from '/items/collections';

Meteor.publish({
    'items.list': function() {
        return Items.find();
    },
});
