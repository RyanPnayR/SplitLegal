import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splitlegal/components/milestone_timeline.dart';
import 'package:splitlegal/models/app_state.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => new _OverviewState();
}

class _OverviewState extends State<Overview> {
  AppState appState;
  ThemeData theme;
  List<MilestoneTransition> milestones = [
    MilestoneTransition(
        fromMilestone: '', toMilestone: 'First Meeting', completed: true),
    MilestoneTransition(
        fromMilestone: 'First Meeting', toMilestone: 'Filled out documents'),
    MilestoneTransition(
        fromMilestone: 'Filled out documents', toMilestone: 'Final Meeting'),
    MilestoneTransition(
        fromMilestone: 'Final Meeting',
        toMilestone: 'Final documents delivered'),
  ];
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: theme.secondaryHeaderColor,
          appBar: AppBar(
            shape: Border(bottom: BorderSide(color: Colors.white)),
            automaticallyImplyLeading: false,
            backgroundColor: theme.secondaryHeaderColor,
            toolbarHeight: 150,
            elevation: 0,
            title: Container(
              margin: EdgeInsets.only(left: 40),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.start,
                direction: Axis.vertical,
                spacing: 10,
                children: [
                  Text(
                    "Your Overview",
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    width: 300,
                    child: Text(
                      "One place to track your progress",
                      style: TextStyle(fontSize: 30),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            bottom: TabBar(
              indicator: UnderlineTabIndicator(
                borderSide:
                    BorderSide(width: 4.0, color: theme.bottomAppBarColor),
                insets: EdgeInsets.symmetric(horizontal: 60.0),
              ),
              tabs: [usersMilestoneTitle, splitLegalCurrentMilestoneTitle],
            ),
          ),
          body: Column(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: TabBarView(
                  children: [
                    userMilestones,
                    splitLegalCurrentMilestones,
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: theme.primaryColor,
                child: Text("Hello"),
              ),
            ],
          )),
    );
  }

  Widget get usersMilestoneTitle {
    return Tab(
      text: "Where you are",
    );
  }

  Widget get userMilestones {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 50),
      child: MilestoneTimeline(milestones: milestones),
    );
  }

  Widget get splitLegalCurrentMilestoneTitle {
    return Tab(
      text: "What we are working on",
    );
  }

  Widget get splitLegalCurrentMilestones {
    return Column(
      children: [Text("Bonjor")],
    );
  }
}
