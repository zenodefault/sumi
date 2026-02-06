import 'package:flutter/widgets.dart';
import 'package:hugeicons/hugeicons.dart';

class AppIcons {
  // Navigation + global actions
  static final List<List<dynamic>> dashboard = HugeIcons.strokeRoundedGrid;
  static final List<List<dynamic>> analytics = HugeIcons.strokeRoundedAnalytics01;
  static final List<List<dynamic>> anatomy =
      HugeIcons.strokeRoundedBodyPartMuscle;
  static final List<List<dynamic>> calories = HugeIcons.strokeRoundedFire;
  static final List<List<dynamic>> habits = HugeIcons.strokeRoundedCheckmarkCircle01;
  static final List<List<dynamic>> home = HugeIcons.strokeRoundedHome01;
  static final List<List<dynamic>> settings = HugeIcons.strokeRoundedSettings01;
  static final List<List<dynamic>> user = HugeIcons.strokeRoundedUser;
  static final List<List<dynamic>> favorite = HugeIcons.strokeRoundedFavourite;

  // Common controls
  static final List<List<dynamic>> add = HugeIcons.strokeRoundedAdd01;
  static final List<List<dynamic>> edit = HugeIcons.strokeRoundedEdit01;
  static final List<List<dynamic>> save = HugeIcons.strokeRoundedFloppyDisk;
  static final List<List<dynamic>> delete = HugeIcons.strokeRoundedDelete02;
  static final List<List<dynamic>> search = HugeIcons.strokeRoundedSearch01;
  static final List<List<dynamic>> clear = HugeIcons.strokeRoundedCancel01;
  static final List<List<dynamic>> check =
      HugeIcons.strokeRoundedCheckmarkCircle01;
  static final List<List<dynamic>> info = HugeIcons.strokeRoundedInformationCircle;
  static final List<List<dynamic>> help = HugeIcons.strokeRoundedHelpCircle;
  static final List<List<dynamic>> more = HugeIcons.strokeRoundedMoreVertical;
  static final List<List<dynamic>> time = HugeIcons.strokeRoundedClock01;
  static final List<List<dynamic>> notification =
      HugeIcons.strokeRoundedNotification01;

  // Directional
  static final List<List<dynamic>> arrowLeft = HugeIcons.strokeRoundedArrowLeft01;
  static final List<List<dynamic>> arrowRight =
      HugeIcons.strokeRoundedArrowRight01;
  static final List<List<dynamic>> arrowUp = HugeIcons.strokeRoundedArrowUp01;
  static final List<List<dynamic>> chevronRight =
      HugeIcons.strokeRoundedArrowRight01;

  // Workouts + habits
  static final List<List<dynamic>> dumbbell = HugeIcons.strokeRoundedDumbbell01;
  static final List<List<dynamic>> run = HugeIcons.strokeRoundedWorkoutRun;
  static final List<List<dynamic>> gymnastics = HugeIcons.strokeRoundedGymnastic;
  static final List<List<dynamic>> sports = HugeIcons.strokeRoundedWorkoutSport;
  static final List<List<dynamic>> motorsport = HugeIcons.strokeRoundedRacingFlag;
  static final List<List<dynamic>> trendUp = HugeIcons.strokeRoundedChartUp;
  static final List<List<dynamic>> streak = HugeIcons.strokeRoundedFire;
  static final List<List<dynamic>> calendar = HugeIcons.strokeRoundedCalendar01;
  static final List<List<dynamic>> play = HugeIcons.strokeRoundedPlayCircle;
  static final List<List<dynamic>> list = HugeIcons.strokeRoundedListView;

  // Misc
  static final List<List<dynamic>> chart = HugeIcons.strokeRoundedChartLineData01;
  static final List<List<dynamic>> flag = HugeIcons.strokeRoundedFlag01;
  static final List<List<dynamic>> food = HugeIcons.strokeRoundedSpoonAndFork;
  static final List<List<dynamic>> expand = HugeIcons.strokeRoundedExpander;
  static final List<List<dynamic>> collapse = HugeIcons.strokeRoundedMenuCollapse;
}

class AppIcon extends StatelessWidget {
  final List<List<dynamic>> icon;
  final double? size;
  final Color? color;
  final double? strokeWidth;

  AppIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return HugeIcon(
      icon: icon,
      size: size,
      color: color,
      strokeWidth: strokeWidth,
    );
  }
}
