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
  final DateTime time;
  int max;
  int min;

  IntervalData(this.time, this.max, this.min);
}

Future<List<GeoActivity>> getActivities() async {
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

List<totalTimePerDay> activityTotalPerDay(List<GeoActivity> activities) {
  //iterates through all activities, add new days where they dont exist + total, adds to total where day exists.
  //assumes input of an activity list ordered by activity date in ascending order
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
//and max productivities for activities started within a given hour
  List<IntervalData> intervals = [];

//pseudocode

  return intervals;
}

Future<List<totalTimePerDay>> getTotalTimes() async {
  List<totalTimePerDay> dataPoints = [];
  List<GeoActivity> activities = await getActivities();
  dataPoints = activityTotalPerDay(activities);

  return dataPoints;
}

Future<List<IntervalData>> getIntervals() async {
  List<IntervalData> intervals = [];
  List<GeoActivity> activities = await getActivities();

  return intervals;
}
