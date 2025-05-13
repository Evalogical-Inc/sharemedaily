import 'package:flutter/material.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/screens/profile/edit_list.dart';
import 'package:quotify/screens/profile/favorite_list.dart';
import 'package:quotify/screens/profile/widgets/profile_header.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? args;
  const ProfileScreen({super.key, this.args});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setInitialTab();
    });
  }

  setInitialTab() {
    tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.args == null ? 0 : 1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2, // Two tabs
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                //SliverAppBar for Profile Header (Collapsible)
                const SliverAppBar(
                  expandedHeight: 130, // Adjust height as needed
                  pinned: false,
                  floating: false,
                  flexibleSpace:
                      FlexibleSpaceBar(background: ProfileHeaderWidget()),
                ),
                //Sticky TabBar
                SliverPersistentHeader(
                  floating: true,
                  pinned: true, // Sticks to the top when scrolling
                  delegate: _StickyTabBarDelegate(
                    TabBar(
                      controller: tabController,
                      labelColor: Theme.of(context).indicatorColor,
                      unselectedLabelColor: AppColors.defaultGrey,
                      indicatorWeight: 1,
                      indicatorColor: Theme.of(context).indicatorColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: const [
                        Tab(icon: Icon(Icons.favorite)),
                        Tab(icon: Icon(Icons.edit)),
                      ],
                    ),
                  ),
                ),
              ];
            },
            //TabBarView with Dummy Data
            body: TabBarView(
              controller: tabController,
              children: const [
                // FavoriteGrid(favoriteItems: favoriteItems),
                FavoriteList(), // Dummy posts list
                // PhotoGrid(), // Dummy photo grid
                EditList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Sticky TabBar Delegate (Keeps the TabBar stuck at the top)
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _StickyTabBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context)
          .scaffoldBackgroundColor, // Background color of the TabBar
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate oldDelegate) {
    return true;
  }
}

//Dummy ListView for Posts Tab
class PostList extends StatelessWidget {
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20, // 20 dummy posts
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.article),
          title: Text("Post #$index"),
          subtitle: const Text("This is a sample post description."),
        );
      },
    );
  }
}

// Dummy GridView for Photos Tab
class PhotoGrid extends StatelessWidget {
  const PhotoGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 images per row
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 30, // 30 dummy images
      itemBuilder: (context, index) {
        return Container(
          color: Colors.blueAccent,
          child: Center(
            child: Text(
              "📷 $index",
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}

class TabIcon extends StatelessWidget {
  final Icon selectedIcon;
  final Icon unselectedIcon;
  final int tabIndex;

  TabIcon({
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Access the TabController to check the selected tab
    final TabController? controller = DefaultTabController.of(context);

    if (controller == null) {
      return unselectedIcon; // Fallback if TabController is not found
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Check if the current tab index matches this tab
        bool isSelected = controller.index == tabIndex;

        return isSelected ? selectedIcon : unselectedIcon;
      },
    );
  }
}
