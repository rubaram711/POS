import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/home_controller.dart';
import '../../Locale_Memory/save_user_info_locally.dart';
import '../../const/Sizes.dart';
import '../../const/colors.dart';

class AppBarEntry {
  const AppBarEntry(this.title, this.route,
      [this.children = const <AppBarEntry>[]]);
  final String title;
  final String route;
  final List<AppBarEntry> children;
}

// Data to display.
const List<AppBarEntry> data = <AppBarEntry>[
  AppBarEntry(
    'Dine In',
    "/",
  ),
  AppBarEntry(
    'Take Away',
    "/",
  ),
  AppBarEntry(
    'Deliver',
    "/",
  ),
  AppBarEntry(
    'Cancel',
    "/",
  ),
];

const List<AppBarEntry> adminList = <AppBarEntry>[
  AppBarEntry('logout', '/'),
];

class AdminSectionInHomeAppBar extends StatefulWidget {
  const AdminSectionInHomeAppBar({super.key});

  @override
  State<AdminSectionInHomeAppBar> createState() =>
      _AdminSectionInHomeAppBarState();
}

class _AdminSectionInHomeAppBarState extends State<AdminSectionInHomeAppBar> {
  var name = '';
  getInfoFromPref() async {
    name = await getNameFromPref();
  }

  @override
  void initState() {
    getInfoFromPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // GlobalKey accKey = GlobalKey();
    return Row(
      children: [
        Container(
          height: 31,
          width: 31,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            image: DecorationImage(
              image: AssetImage('images/adminPic.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        gapW10,
        Text(
          name == '' ? 'Admin' : name,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: TypographyColor.titleTable),
        ),
        gapW16,
      ],
    );
  }
}

class AppBarItem extends StatelessWidget {
  const AppBarItem(this.entry, {super.key, required this.context});

  final AppBarEntry entry;
  final BuildContext context;
  Widget _buildTiles(AppBarEntry root) {
    final HomeController homeController = Get.find();
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
          child: InkWell(
              focusColor: Colors.white,
              hoverColor: Colors.white,
              onTap: () {
                homeController.selectedAppBarItem.value = root.title;
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    margin: const EdgeInsets.only(
                      bottom: 3,
                    ),
                    decoration: BoxDecoration(
                        color: homeController.selectedAppBarItem.value ==
                                root.title
                            ? Others.bg
                            : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          color: homeController.selectedAppBarItem.value ==
                                  root.title
                              ? Colors.grey.withAlpha((0.5 * 255).toInt())
                              : Colors.white,
                        )),
                    child: Text(
                      root.title,
                      style: TextStyle(
                          fontSize: 13,
                          color: homeController.selectedAppBarItem.value ==
                                  root.title
                              ? Primary.primary
                              : TypographyColor.titleTable),
                    ),
                  ),
                  homeController.selectedAppBarItem.value == root.title
                      ? Icon(
                          Icons.circle,
                          color: Primary.primary,
                          size: 8,
                        )
                      : const SizedBox()
                ],
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

class HomeAppBarMenus extends StatefulWidget {
  const HomeAppBarMenus({super.key, required this.isDesktop});
  final bool isDesktop;
  @override
  State<HomeAppBarMenus> createState() => _HomeAppBarMenusState();
}

class _HomeAppBarMenusState extends State<HomeAppBarMenus> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isDesktop
          ? MediaQuery.of(context).size.width * 0.4
          : MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.085,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        itemBuilder: (BuildContext context, int index) => AppBarItem(
          data[index],
          context: context,
        ),
        itemCount: data.length,
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    return Obx(() {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height * 0.085,
        width: !homeController.isOpened.value
            ? MediaQuery.of(context).size.width - 70
            : MediaQuery.of(context).size.width - 70,
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rooster POS',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox()
            // HomeAppBarMenus(isDesktop: true),
            // AdminSectionInHomeAppBar()
          ],
        ),
      );
    });
  }
}
