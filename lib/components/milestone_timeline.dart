import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dash/flutter_dash.dart';

import 'package:splitlegal/models/app_state.dart';

class MilestonePoint extends StatelessWidget {
  MilestoneTransition milestone;
  bool current = false;
  MilestonePoint({
    this.milestone,
    this.current = false,
  });

  @override
  Widget build(BuildContext context) {
    return milestone.completed
        ? Icon(
            Icons.check_circle,
            size: 20,
            color: Colors.white54,
          )
        : this.current
            ? Icon(
                Icons.radio_button_unchecked,
                size: 25,
                color: Colors.white,
              )
            : Icon(
                Icons.circle,
                size: 10,
                color: Colors.white54,
              );
  }
}

class MilestoneTimeline extends StatelessWidget {
  List<MilestoneTransition> milestones = [];

  MilestoneTimeline({
    this.milestones,
  });

  @override
  Widget build(BuildContext context) {
    int last = milestones.length - 1;
    int currentId = 0;

    for (var milestone in milestones) {
      if (milestone.completed) {
        currentId++;
      } else {
        break;
      }
    }
    return Column(
      children: milestones
          .asMap()
          .map(
            (i, milestone) => MapEntry(
              i,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      new SizedBox(
                        width: 30.0,
                        child: MilestonePoint(
                          milestone: milestone,
                          current: currentId == i,
                        ),
                      ),
                      Text(
                        milestone.toMilestone,
                        style: TextStyle(
                            color:
                                currentId == i ? Colors.white : Colors.white54),
                      ),
                    ],
                  ),
                  last == i
                      ? SizedBox.shrink()
                      : new SizedBox(
                          height: 40.0,
                          width: 30.0,
                          child: Dash(
                            direction: Axis.vertical,
                            length: 40,
                            dashLength: 3,
                            dashColor: Colors.white,
                          ),
                        ),
                ],
              ),
            ),
          )
          .values
          .toList(),
    );
  }
}
