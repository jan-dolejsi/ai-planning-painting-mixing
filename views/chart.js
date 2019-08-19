function daysToMilliseconds(days) {
    return days * 24 * 60 * 60 * 1000;
}
function addMinutes(dt, minutes) {
    return new Date(dt.getTime() + minutes*60000);
}
function toStartTime(jobStarted, planStep) {
    return addMinutes(jobStarted, planStep.time);
}
function toEndTime(jobStarted, planStep) {
    return addMinutes(jobStarted, planStep.time + planStep.duration);
}
function toPercentDone(jobStarted, planStep) {
    if (new Date().getTime() < toStartTime(jobStarted, planStep).getTime()) {
        // the task has not started yet
        return 0;
    }
    else if (new Date().getTime() > toEndTime(jobStarted, planStep).getTime()) {
        // the task already finished
        return 100;
    }
    else {
        return (new Date().getMinutes() - toStartTime(jobStarted, planStep).getMinutes()) 
            / planStep.duration * 100;
    }
}
