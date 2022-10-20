import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gtrtracker/models/ModelProvider.dart';

// amplify packages we will need to use
import 'package:amplify_flutter/amplify_flutter.dart';

class GoalsList extends StatelessWidget {
  const GoalsList({
    required this.goals,
    Key? key,
  }) : super(key: key);

  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    return goals.isNotEmpty
        ? ListView(
            padding: const EdgeInsets.all(8),
            children: goals.map((goal) => GoalItem(goal: goal)).toList())
        : const Center(
            child: Text('Tap button below to add a goal!'),
          );
  }
}

class GoalItem extends StatelessWidget {
  const GoalItem({
    required this.goal,
    Key? key,
  }) : super(key: key);

  final double iconSize = 24.0;
  final Goal goal;

  void _deleteGoal(BuildContext context) async {
    try {
      // to delete data from DataStore, we pass the model instance to
      // Amplify.DataStore.delete()
      await Amplify.DataStore.delete(goal);
    } catch (e) {
      print('An error occurred while deleting Goal: $e');
    }
  }

  Future<void> _toggleIsComplete() async {
    // copy the Goal we wish to update, but with updated properties
    final updatedGoal = goal.copyWith(isComplete: !goal.isComplete);
    try {
      // to update data in DataStore, we again pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(updatedGoal);
    } catch (e) {
      print('An error occurred while saving Goal: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          _toggleIsComplete();
        },
        onLongPress: () {
          _deleteGoal(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(goal.description ?? 'No description'),
                ],
              ),
            ),
            Icon(
                goal.isComplete
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                size: iconSize),
          ]),
        ),
      ),
    );
  }
}
