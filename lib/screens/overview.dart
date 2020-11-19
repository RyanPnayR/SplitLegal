import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:splitlegal/components/milestone_timeline.dart';
import 'package:splitlegal/models/app_state.dart';
import 'package:splitlegal/screens/home_screen.dart';

import '../app_state_container.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => new _OverviewState();
}

class _OverviewState extends State<Overview>
    with SingleTickerProviderStateMixin {
  AppState appState;
  ThemeData theme;
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    appState = container.state;
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
    return Container(
      width: double.infinity,
      color: theme.primaryColor,
      child: ListView(
        children: [
          Container(
            color: theme.secondaryHeaderColor,
            padding: EdgeInsets.all(25),
            child: mainView,
          ),
          Container(
              width: double.infinity,
              color: theme.primaryColor,
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Next Steps",
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  NextStepsButton(
                    taskCount: appState.currentRequest.tasks
                        .where((element) => element.status == 'current')
                        .length,
                  ),
                  OverviewTaskBox(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Have any questions?",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    letterSpacing: 1),
                              ),
                            ],
                          ),
                          Text(
                            "Send us an email",
                            style: TextStyle(
                                fontSize: 14,
                                color: theme.bottomAppBarColor,
                                letterSpacing: 1),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget get usersMilestoneTitle {
    return Tab(
      text: "Where you are",
    );
  }

  Widget get userMilestones {
    return MilestoneTimeline(milestones: appState.currentRequest.milestones);
  }

  Widget get splitLegalCurrentMilestoneTitle {
    return Tab(
      text: "What we are working on",
    );
  }

  Widget get splitLegalCurrentMilestones {
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: theme.secondaryHeaderColor,
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
                spreadRadius: 5,
                offset: new Offset(0, 1.0),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              backgroundColor: theme.secondaryHeaderColor,
              childrenPadding: EdgeInsets.all(20),
              tilePadding: EdgeInsets.only(top: 10, left: 20),
              title: Text(
                "Reviewing request",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              children: [
                Text(
                  "Currently going over the info you have submitted in your request. We will be reaching out soon to go over the documents.",
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NextStepsButton extends StatelessWidget {
  int taskCount;
  NextStepsButton({
    this.taskCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);

    return taskCount == 0
        ? OverviewTaskBox(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        "Take a break - you've earned it",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            letterSpacing: 1),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      "You’ve taken care of all your tasks and now we’re reviewing. So kick back and relax — we’ll email you when you have more tasks. Or you can just check back here.",
                      style: TextStyle(
                          fontSize: 12, color: Colors.white, letterSpacing: 1),
                    ),
                  ),
                ],
              ),
            ],
          )
        : OverviewTaskBox(
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Help get to your filling",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 1),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "Right now you have $taskCount task(s) that we need your help on.",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            letterSpacing: 1),
                      ),
                    ),
                  ]),
              MaterialButton(
                child: Text('Go to tasks'),
                onPressed: () {
                  container.state.currentPage = homeScreenPages.tasks;
                  Navigator.of(context).pushNamed('/home');
                },
                color: Theme.of(context).secondaryHeaderColor,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
                textColor: Colors.white,
                height: 30,
              ),
            ],
          );
  }
}

class OverviewTaskBox extends StatelessWidget {
  List<Widget> children;
  OverviewTaskBox({this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: new BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.rectangle,
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 3,
            spreadRadius: 5,
            offset: new Offset(0, 1.0),
          ),
        ],
      ),
      child: new Container(
        margin: new EdgeInsets.all(10),
        child: new Column(
          children: children,
        ),
      ),
    );
  }
}
