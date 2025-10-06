import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/home_controller.dart';
import '../../const/Sizes.dart';
import '../../const/colors.dart';
class Entry {
  const Entry(this.title, this.icon, [this.children = const <Entry>[]]);
  final String title;
  final IconData icon;
  final List<Entry> children;
}


const List<Entry> data = <Entry>[
  Entry(
    'Home',
    Icons.home_outlined,
    <Entry>[
      Entry('new_quotation',Icons.home_outlined),
      Entry('quotation_summary', Icons.home_outlined),
    ],
  ),
  // Entry(
  //   'clients',
  //   "assets/images/clientsIcon.png",
  //   <Entry>[
  //     Entry('accounts', ''),
  //     Entry("add_new_client", ''),
  //   ],
  // ),
  // Entry(
  //   'stock',
  //   "assets/images/stockIcon.png",
  //   <Entry>[
  //     Entry('items', ''),
  //     Entry('create_items', ''),
  //     Entry("combos", ''),
  //     Entry('brands', ''),
  //   ],
  // ),
  // Entry(
  //   'reports',
  //   "assets/images/reportsIcon.png",
  //   <Entry>[
  //     Entry('reports1', ''),
  //     Entry("reports2", ''),
  //     Entry("reports3", ''),
  //   ],
  // ),
  // Entry(
  //   'dashboard_summary',
  //   "assets/images/dashboardIcon.png",
  // ),
  // Entry(
  //   'admin_panel',
  //   "assets/images/adminPanelIcon.png",
  //   <Entry>[
  //     Entry('lorem_ipsum', ''),
  //     Entry('lorem_ipsum', ''),
  //     Entry("lorem_ipsum", ''),
  //   ],
  // ),
  // Entry(
  //   'account_settings',
  //   "assets/images/settingsIcon.png",
  //   <Entry>[
  //     Entry('create_users', ''),
  //     Entry('category_security_level', ''),
  //     Entry("paper_template", ''),
  //     Entry("domination_name", ''),
  //   ],
  // ),
];
class ClosedSidebar extends StatefulWidget {
  const ClosedSidebar({super.key});

  @override
  State<ClosedSidebar> createState() => _ClosedSidebarState();
}

class _ClosedSidebarState extends State<ClosedSidebar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: MediaQuery.of(context).size.width * 0.045,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.045,
        // height: 200,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            gapH70,
            Expanded(
              child: ListView.builder(
                padding:
                const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                itemBuilder: (BuildContext context, int index) =>
                    ClosedSidebarItem(
                      data[index],
                      context: context,
                      onHoverFunc: () {
                        // showPopupMenu(context);
                      },
                    ),
                itemCount: data.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class ClosedSidebarItem extends StatefulWidget {
//   const ClosedSidebarItem({super.key});
//
//   @override
//   State<ClosedSidebarItem> createState() => _ClosedSidebarItemState();
// }
//
// class _ClosedSidebarItemState extends State<ClosedSidebarItem> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }


class ClosedSidebarItem extends StatelessWidget {
  const ClosedSidebarItem(this.entry,
      {super.key, required this.onHoverFunc, required this.context});

  final Entry entry;
  final Function onHoverFunc;
  final BuildContext context;
  Widget _buildTiles(Entry root) {
    final HomeController homeController = Get.find();
    GlobalKey accKey = GlobalKey();
    if (root.title == 'dashboard_summary' || root.children.isNotEmpty) {
      return Obx(
          ()=>Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Material(
              color:homeController.selectedTab.value == root.title? Primary.primary.withAlpha((0.4 * 255).toInt()):Colors.white,
              shape: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  key: accKey,
                  splashColor: Primary.primary.withAlpha((0.4 * 255).toInt()),
                  customBorder: const CircleBorder(),
                  // onHover: (val) {
                  //   if (val) {
                  //     final RenderBox renderBox =
                  //     accKey.currentContext?.findRenderObject() as RenderBox;
                  //     final Size size = renderBox.size;
                  //     final Offset offset = renderBox.localToGlobal(Offset.zero);
                  //     showMenu(
                  //       context: context,
                  //       color: Primary.primary,
                  //       shadowColor: Colors.black45,
                  //       shape: const RoundedRectangleBorder(
                  //         side: BorderSide(color: Colors.black26),
                  //         borderRadius: BorderRadius.all(
                  //           Radius.circular(00.0),
                  //         ),
                  //       ),
                  //       position: RelativeRect.fromLTRB(
                  //           offset.dx + size.width + 10,
                  //           offset.dy + size.height - 30,
                  //           offset.dx + size.width + 50,
                  //           offset.dy + size.height),
                  //       items: root.children
                  //           .map((item) => PopupMenuItem<String>(
                  //         value: item.title.tr,
                  //         onTap: () {
                  //           homeController.selectedTab.value = item.title;
                  //         },
                  //         child: Text(
                  //           item.title.tr,
                  //         ),
                  //       ))
                  //           .toList(),
                  //     );
                  //   }
                  //   // if(!val){
                  //   //   Get.back();
                  //   // }
                  // },
                  onTap: () {
                    homeController.selectedTab.value = root.title;
                    // if (val == true) {
                    // final RenderBox renderBox =
                    // accKey.currentContext?.findRenderObject() as RenderBox;
                    // final Size size = renderBox.size;
                    // final Offset offset = renderBox.localToGlobal(Offset.zero);
                    // showMenu(
                    //   context: context,
                    //   color: Primary.primary,
                    //   shadowColor: Colors.black45,
                    //   shape: const RoundedRectangleBorder(
                    //     side: BorderSide(color: Colors.black26),
                    //     borderRadius: BorderRadius.all(
                    //       Radius.circular(00.0),
                    //     ),
                    //   ),
                    //   position: RelativeRect.fromLTRB(
                    //       offset.dx + size.width + 10,
                    //       offset.dy + size.height - 30,
                    //       offset.dx + size.width + 50,
                    //       offset.dy + size.height),
                    //   items: root.children
                    //       .map((item) => PopupMenuItem<String>(
                    //     value: item.title.tr,
                    //     child: Text(
                    //       item.title.tr,
                    //     ),
                    //   ))
                    //       .toList(),
                    // );
                  },
                  child: Icon(
                    root.icon,
                    color: homeController.selectedTab.value == root.title?Primary.primary:Colors.grey,
                  ),
                ),
              ),
            ),
          )
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}



