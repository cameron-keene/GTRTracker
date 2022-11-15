import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import "package:gtrtracker/models/GeoActivity.dart";
import 'package:gtrtracker/models/Goal.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class totalTimePerDay {
  final DateTime time;
  int total;

  totalTimePerDay(this.time, this.total);
}

class IntervalData {
  //class to define basic unit of perceived productivity graph
  int duration;
  int min;
  int max;

  IntervalData(this.duration, this.min, this.max);
}

Future<List<GeoActivity>> getActivitiesOrderedByActivityTime() async {
  List<GeoActivity> activities = [];

  try {
    activities = await Amplify.DataStore.query(
      GeoActivity.classType,
      sortBy: [GeoActivity.ACTIVITYTIME.ascending()],
    ); //need sorted list for chart input
    print("numgoals: " + activities.length.toString());
  } catch (e) {
    print("Could not query DataStore: " + e.toString());
  }

  return activities;
}

Future<List<GeoActivity>> getActivitiesOrderedByActivityDuration() async {
  List<GeoActivity> activities = [];

  try {
    activities = await Amplify.DataStore.query(
      GeoActivity.classType,
      sortBy: [GeoActivity.DURATION.ascending()],
    ); //need sorted list for chart input
    print("numgoals: " + activities.length.toString());
  } catch (e) {
    print("Could not query DataStore: " + e.toString());
  }

  return activities;
}

List<totalTimePerDay> activityTotalPerDay(List<GeoActivity> activities) {
  //iterates through all activities, add new days where they dont exist + total, adds to total where day exists.
  //assumes input of an activity list ordered by activity date in ascending order *****
  List<totalTimePerDay> totals = [];

  // activities.forEach((element) {
  //   if (totals.isEmpty) {
  //     //start case
  //     totals.add(totalTimePerDay(DateTime(element.activityTime),
  //         element.duration)); //figuring out temporal time to date time
  //   } else if (totals[totals.length - 1].time == element.activityTime) {
  //     //activity on same day as previous
  //     totals[totals.length - 1].total += element.duration;
  //   } else {
  //     //activity on different day as previous
  //     totals.add(totalTimePerDay(element.activityTime, element.duration));
  //   }
  // });

  return totals;
}

List<IntervalData> getProductivityIntervals(List<GeoActivity> activities) {
//given a list of activities return list of intervaldata objects that maps min
//and max productivities for activities with a certain length
//assumes input of list ordered by duration ascending ****
  List<IntervalData> intervals = [];

  activities.forEach((element) {
    if (intervals.isEmpty) {
      IntervalData firstListElement = IntervalData(
          (element.duration ~/ 10 * 10),
          element.productivity.toInt(),
          element.productivity.toInt());
      intervals.add(firstListElement);
    }

    if (element.duration < 10 &&
        intervals[intervals.length - 1].duration != 10) {
      //new bin
      intervals.add(IntervalData((element.duration ~/ 10 * 10),
          element.productivity.toInt(), element.productivity.toInt()));
    } else if (element.duration < 10 &&
        intervals[intervals.length - 1].duration == 10) {
      //update min or max
      intervalMinMaxUpdate(intervals[intervals.length - 1], element);
    }
    if (element.duration < 20 &&
        intervals[intervals.length - 1].duration != 20) {
      //new bin
      intervals.add(IntervalData((element.duration ~/ 10 * 10),
          element.productivity.toInt(), element.productivity.toInt()));
    } else if (element.duration < 20 &&
        intervals[intervals.length - 1].duration == 20) {
      //update min or max
      intervalMinMaxUpdate(intervals[intervals.length - 1], element);
    } else if (element.duration < 30 &&
        intervals[intervals.length - 1].duration != 30) {
      //new bin
      intervals.add(IntervalData((element.duration ~/ 10 * 10),
          element.productivity.toInt(), element.productivity.toInt()));
    } else if (element.duration < 30 &&
        intervals[intervals.length - 1].duration == 30) {
      //update min or max
      intervalMinMaxUpdate(intervals[intervals.length - 1], element);
    } else if (element.duration < 40 &&
        intervals[intervals.length - 1].duration != 40) {
      //new bin
      intervals.add(IntervalData((element.duration ~/ 10 * 10),
          element.productivity.toInt(), element.productivity.toInt()));
    } else if (element.duration < 40 &&
        intervals[intervals.length - 1].duration == 40) {
      //update min or max
      intervalMinMaxUpdate(intervals[intervals.length - 1], element);
    } else if (element.duration < 50 &&
        intervals[intervals.length - 1].duration != 50) {
      //new bin
      intervals.add(IntervalData((element.duration ~/ 10 * 10),
          element.productivity.toInt(), element.productivity.toInt()));
    } else if (element.duration < 50 &&
        intervals[intervals.length - 1].duration == 50) {
      //update min or max
      intervalMinMaxUpdate(intervals[intervals.length - 1], element);
    } else if (element.duration < 60 &&
        intervals[intervals.length - 1].duration != 60) {
      //new bin
      intervals.add(IntervalData((element.duration ~/ 10 * 10),
          element.productivity.toInt(), element.productivity.toInt()));
    } else if (element.duration < 60 &&
        intervals[intervals.length - 1].duration == 60) {
      //update min or max
      intervalMinMaxUpdate(intervals[intervals.length - 1], element);
    } else if (element.duration < 70 &&
        intervals[intervals.length - 1].duration != 70) {
      //new bin
      intervals.add(IntervalData((element.duration ~/ 10 * 10),
          element.productivity.toInt(), element.productivity.toInt()));
    } else {
      //update min or max
      intervalMinMaxUpdate(intervals[intervals.length - 1], element);
    }
  });

//pseudocode
/* 
what is the activity duration?
setup bins - case statement for range (10 mins)
  if object with duration range does not exist create one(min, max) set both to current element duration
  if less than min set new min
  if more than max set new max
*/

  return intervals;
}

IntervalData intervalMinMaxUpdate(IntervalData previous, GeoActivity act) {
  //updates interval productivity
  int maxi = max(previous.max, act.productivity.toInt());
  int mini = min(previous.min, act.productivity.toInt());

  return IntervalData(previous.duration, mini, maxi);
}

Future<List<totalTimePerDay>> getTotalTimes() async {
  List<totalTimePerDay> dataPoints = [];
  List<GeoActivity> activities = await getActivitiesOrderedByActivityTime();
  dataPoints = activityTotalPerDay(activities);

  return dataPoints;
}

Future<List<IntervalData>> getIntervals() async {
  List<IntervalData> intervals = [];
  List<GeoActivity> activities = await getActivitiesOrderedByActivityDuration();
  intervals = getProductivityIntervals(activities);

  return intervals;
}
