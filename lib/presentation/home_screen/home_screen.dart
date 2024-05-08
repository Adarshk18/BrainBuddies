import 'package:brainbd/presentation/home_screen/recent_activity_screen.dart';
import 'package:brainbd/presentation/home_screen/recommended_resources_screen.dart';
import 'package:brainbd/presentation/home_screen/study_group_screen.dart';
import 'package:brainbd/presentation/home_screen/upcoming_study_session.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import '../account_detail_scren/account_detail_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../study_material_screen/study_material_list_screen.dart';
import '../video_confrencing_screen/video_confrencing_screen.dart';
import 'calender_planner_screen.dart';
import 'discussion_forum_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  final List<Widget> _tabs = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    _tabs.addAll([
      _buildTab(HomeTab()),
      StudyMaterialsListScreen(),
      VideoConferencingScreen(),
      ProfileScreen(),
    ]);

    return Scaffold(
      appBar: CustomAppBar(
        height: 60.0,
        title: AppbarTitle(
          text: 'Brain Buddies',
        ),
        centerTitle: true,
        actions: [
          CustomIconButton(
            height: 40.0,
            width: 40.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountDetailsScreen(),
                  ),
                );
              },
              child: CustomImageView(
                imagePath: 'assets/images/img_unsplash_w7b3edub_2i.png',
              ),
            ),
          ),
        ],
      ),
      body: SlideTransition(
        position: _offsetAnimation,
        child: _tabs[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _controller.reset();
            _controller.forward();
          });
        },
        backgroundColor: Colors.grey[200],
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Study Materials',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call),
            label: 'Video Conferencing',
            backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildTab(Widget tabContent) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCircularButton(
            title: 'Upcoming Study Sessions',
            color: Colors.teal,
            icon: Icons.event,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpcomingStudySessionsScreen(),
                ),
              );
            },
          ),
          _buildCircularButton(
            title: 'Join/Create Study Groups',
            color: Colors.orange,
            icon: Icons.group,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudyGroupScreen(),
                ),
              );
            },
          ),
          _buildCircularButton(
            title: 'Discussion Forum',
            color: Colors.blueGrey,
            icon: Icons.chat,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiscussionForumScreen(),
                ),
              );
            },
          ),
          _buildCircularButton(
            title: 'Recent Activity',
            color: Colors.deepPurple,
            icon: Icons.history,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecentActivityScreen(),
                ),
              );
            },
          ),
          _buildCircularButton(
            title: 'Recommended Resources',
            color: Colors.indigo,
            icon: Icons.library_books,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecommendedResourcesScreen(),
                ),
              );
            },
          ),
          _buildCircularButton(
            title: 'Calendar/Planner',
            color: Colors.lightGreen,
            icon: Icons.calendar_today,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalendarPlannerScreen(),
                ),
              );
            },
          ),
          _buildCircularButton(
            title: 'Announcements/Notifications',
            color: Colors.amber,
            icon: Icons.notifications,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnnouncementsNotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({required String title, required Color color, required IconData icon, required Function onTap}) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 20),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12, // Decreased font size
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }


  void _showDialog(BuildContext context, String title, List<String> options) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              options.length,
                  (index) => ListTile(
                title: Text(options[index]),
                onTap: () {
                  Navigator.pop(context);
                  // Perform action based on the selected option
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Home Tab Content'),
    );
  }
}