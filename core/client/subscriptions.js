export const allReady = (subscriptions = []) =>
    subscriptions.reduce((acc, cur) => cur.ready() && acc, true);
