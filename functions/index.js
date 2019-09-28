const functions = require('firebase-functions');
const admin = require('firebase-admin');

// initialize admin and db instance
admin.initializeApp();
const db = admin.database();

// Constants
const YEAR_IN_SECONDS = 31536000; //assuming 365 days a year, not 365.25

// Parameters for delivering death time at different probabilities and threshold
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

// Cloud function entrypoints
exports.onUserCreate = functions.database.ref('/user/{userId}')
    .onCreate(async (snap, context) => {
        const userId = context.params.userId;
        const deathTime = generateDeathTimeInSeconds();
        console.log("Generated death time for user ", userId, " at ", deathTime);
        return snap.ref.child('deathTime').set(deathTime);
    });

// generate a random death epoch time by defined threshold
function generateDeathTimeInEpoch() {

    // set initial values of the min max values of thresholds
    var min = THRESHOLD_MIN;
    var max = THRESHOLD_MAX;

    // randomly select a threshold
    var thresholdIdx = randomNumberBetween(0, 4);

    // get min max values for the selected threshold
    min = THRESHOLDS[thresholdIdx];
    max = THRESHOLDS[thresholdIdx + 1];

    var timeNow = Math.floor(Date.now() / 1000);

    // return a random number within the selected threshold
    return timeNow + randomNumberBetween(min, max);
}

// generates a random number between num1 and num2
function randomNumberBetween(num1, num2) {
    return Math.floor(Math.random() * num2) + num1;
}

