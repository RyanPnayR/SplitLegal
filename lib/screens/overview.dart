import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splitlegal/components/milestone_timeline.dart';
import 'package:splitlegal/models/app_state.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => new _OverviewState();
}

class _OverviewState extends State<Overview>
    with SingleTickerProviderStateMixin {
  AppState appState;
  ThemeData theme;
  TabController controller;

  List<MilestoneTransition> milestones = [
    MilestoneTransition(
        fromMilestone: '', toMilestone: 'First Meeting', completed: true),
    MilestoneTransition(
        fromMilestone: 'First Meeting', toMilestone: 'Filled out documents'),
    MilestoneTransition(
        fromMilestone: 'Filled out documents', toMilestone: 'Final Meeting'),
    MilestoneTransition(
        fromMilestone: '', toMilestone: 'First Meeting', completed: true),
    MilestoneTransition(
        fromMilestone: 'First Meeting', toMilestone: 'Filled out documents'),
    MilestoneTransition(
        fromMilestone: 'Filled out documents', toMilestone: 'Final Meeting'),
  ];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.secondaryHeaderColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: false,
              shape: Border(bottom: BorderSide(color: Colors.white)),
              automaticallyImplyLeading: false,
              backgroundColor: theme.secondaryHeaderColor,
              toolbarHeight: 100,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 20),
                      child: Text(
                        "Your Overview",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "One place to track your progress",
                        style: TextStyle(fontSize: 30.0, color: Colors.white),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
              expandedHeight: 200.0,
              bottom: TabBar(
                indicator: UnderlineTabIndicator(
                  borderSide:
                      BorderSide(width: 4.0, color: theme.bottomAppBarColor),
                  insets: EdgeInsets.symmetric(horizontal: 60.0),
                ),
                tabs: [usersMilestoneTitle, splitLegalCurrentMilestoneTitle],
                controller: controller,
              ),
            )
          ];
        },
        body: TabBarView(
          controller: controller,
          children: [
            wrapOverviewTab(userMilestones),
            wrapOverviewTab(splitLegalCurrentMilestones),
          ],
        ),
      ),
    );
  }

  Widget wrapOverviewTab(Widget mainView) {
    return ListView(
      children: [
        mainView,
        Expanded(
          child: Container(
            height: 200,
            margin: EdgeInsets.only(top: 20),
            width: double.infinity,
            color: theme.primaryColor,
            child: Text("Hello"),
          ),
        ),
      ],
    );
  }

  Widget get usersMilestoneTitle {
    return Tab(
      text: "Where you are",
    );
  }

  Widget get userMilestones {
    return MilestoneTimeline(milestones: milestones);
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
