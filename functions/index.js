const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.database();

const YEAR_IN_SECONDS = 31536000; //assuming 365 days a year, not 365.25
const THRESHOLD_MIN = 120; // 2 minutes
const THRESHOLD_MAX = 60 * Number(YEAR_IN_SECONDS); // 60 years
const THRESHOLDS = [
    THRESHOLD_MIN,
    1 * Number(YEAR_IN_SECONDS),
    20 * Number(YEAR_IN_SECONDS),
    35 * Number(YEAR_IN_SECONDS),
    50 * Number(YEAR_IN_SECONDS),
    THRESHOLD_MAX,
];

exports.onUserCreate = functions.database.ref('/user/{userId}')
    .onCreate(async (snap, context) => {
        const userId = context.params.userId;
        const deathTime = generateDeathTimeInSeconds();
        console.log("Generated death time for user ", userId, " at ", deathTime);
        return snap.ref.child('deathTime').set(deathTime);
    });

function generateDeathTimeInSeconds() {

    var min = THRESHOLD_MIN;
    var max = THRESHOLD_MAX;

    var thresholdIdx = randomNumberBetween(0, 4);

    min = THRESHOLDS[thresholdIdx];
    max = THRESHOLDS[thresholdIdx + 1];

    return randomNumberBetween(min, max);
}

function randomNumberBetween(num1, num2) {
    return Math.floor(Math.random() * num2) + num1;
}

