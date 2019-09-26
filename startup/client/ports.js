import { Meteor } from 'meteor/meteor';
import { Tracker } from 'meteor/tracker';

import { allReady } from '/core/client';
import { Items } from '/items/collections';

export const initPorts = (ports) => {
    toElm(ports);
    fromElm(ports);
};

const fromElm = (ports) => {
    ports.increaseCount.subscribe((itemId) => {
        Meteor.call('items.increaseCount', itemId);
    });
};

const toElm = (ports) => {
    let initialLoading = true;

    Tracker.autorun(() => {
        const subs = [Meteor.subscribe('items.list')];

        if (allReady(subs)) {
            if (initialLoading) {
                ports.subscriptionsLoadingChanged.send(false);
                initialLoading = false;
            }
            ports.itemsChanged.send(Items.find().fetch());
        } else {
            if (!initialLoading) {
                ports.subscriptionsLoadingChanged.send(true);
            }
        }
    });
};
