import 'package:chinese_number/chinese_number.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/pages/task/calendar_page.dart/calendar_page.dart';
import 'package:startup_namer/util/navigator_util.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final List<VoidCallback>? onActionPressed;

  CustomAppBar({
    Key? key,
    this.actions,
    this.onActionPressed,
  })  : assert(actions == null ||
            onActionPressed == null ||
            actions.length == onActionPressed.length),
        super(key: key);

  final DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextButton(
        onPressed: () => NavigatorUtil.push(context, const CalendarPage()),
        child: Text(
          '${_dateTime.year}年${_dateTime.month}月${_dateTime.day}日 星期${_dateTime.weekday.toSimplifiedChineseNumber()}',
          style: const TextStyle(color: Colors.black, fontSize: 17.0),
        ),
      ),
      actions: actions != null
          ? List.generate(actions!.length, (index) {
              return IconButton(
                icon: actions![index],
                onPressed: onActionPressed?[index],
              );
            })
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
