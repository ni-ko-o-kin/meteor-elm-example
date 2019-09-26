import R from 'ramda';

import { Meteor } from 'meteor/meteor';

import { initPorts } from './ports';

Meteor.startup(() => {
    if (Meteor.isProduction) {
        require('/elm-client/elm-main.js');
    } else if (Meteor.isDevelopment) {
        require('meteor/elm');
    } else {
        throw new Error('neither production nor development');
    }

    const app = Elm.Main.init({
        node: document.getElementById('elm-root'),
        flags: {},
    });

    initPorts(app.ports);
});
