import { Meteor } from 'meteor/meteor';
import { check } from 'meteor/check';

import { Items } from '/items/collections';

const STEP = 5;

Meteor.methods({
    'items.increaseCount': function(itemId) {
        check(itemId, String);

        const item = Items.findOne({ _id: itemId });

        if (!item) {
            return;
        }

        Items.update(
            { _id: itemId },
            { $set: { count: (item.count + STEP) % 255 } },
        );
    },
});
