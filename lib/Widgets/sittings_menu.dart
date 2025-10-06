
import 'package:flutter/material.dart';

class SettingMenu extends StatelessWidget {
  const SettingMenu({super.key, required this.itemsList});
  final List<PopupMenuEntry> itemsList;
  @override
  Widget build(BuildContext context) {
    GlobalKey accMoreKey = GlobalKey();
    return InkWell(
      key: accMoreKey,
      onTap: () {
        {
          final RenderBox renderBox =
          accMoreKey.currentContext?.findRenderObject() as RenderBox;
          final Size size = renderBox.size;
          final Offset offset = renderBox.localToGlobal(Offset.zero);
          showMenu(
              context: context,
              color: Colors.white, //TypographyColor.menuBg,
              surfaceTintColor: Colors.white,
              position: RelativeRect.fromLTRB(
                  offset.dx,
                  offset.dy + size.height + 15,
                  offset.dx + size.width,
                  offset.dy + size.height),
              items: itemsList
          );
        }
      },
      child: const Icon(
        Icons.settings_rounded,
        color: Colors.grey,
      ),
    );
  }
}