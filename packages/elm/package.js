Package.describe({
    name: 'elm',
    version: '1.0.1',
    summary: 'include compiled js from elm',
    debugOnly: true,
});

Package.onUse(function(api) {
    api.versionsFrom('1.8.1');
    api.use('modules');
    api.mainModule('elm-main.js', 'client');
});
