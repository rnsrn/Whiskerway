import 'package:flutter/material.dart';
import 'package:flutter_mobile_whiskerway/cons.dart';
import 'package:flutter_mobile_whiskerway/home.dart';
import 'package:flutter_mobile_whiskerway/home_screen.dart';
import 'package:flutter_mobile_whiskerway/login.dart';
import 'package:flutter_mobile_whiskerway/mating.dart';
import 'package:flutter_mobile_whiskerway/messageChat.dart';
import 'package:flutter_mobile_whiskerway/pages/clinic_details_page.dart';
import 'package:flutter_mobile_whiskerway/pages/shelter_details_page.dart';
import 'package:flutter_mobile_whiskerway/plusCircle.dart';
import 'package:flutter_mobile_whiskerway/profilePage.dart';
import 'package:flutter_mobile_whiskerway/viewpets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mongo_dart/mongo_dart.dart' as mdb;

class NearMePage extends StatefulWidget {
  const NearMePage({super.key});

  @override
  _NearMePageState createState() => _NearMePageState();
}

class _NearMePageState extends State<NearMePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild the widget when the tab changes
    });
    getDatas();
  }

  bool hasLoaded = false;

  List clinics = [];
  List shelters = [];

  Future<void> getDatas() async {
    var db = await mdb.Db.create(MONGO_URL);
    await db.open();

    var collection = db.collection('clinicdocuments');
    var collection1 = db.collection('shelter');

    // Fetch documents that match the query
    var datas = await collection.find().toList();
    var datas1 = await collection1.find().toList();

    setState(() {
      shelters = datas1;
      clinics = datas;
      hasLoaded = true;
    });

    // Print or process the results

    await db.close();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd9f1fd),
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffd9f1fd),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 4),
          child: Row(
            children: [
              IconButton(
                iconSize: 30,
                padding: const EdgeInsets.only(right: 8),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const HomePage()));
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Near Me",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Locate Nearby Facilities',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Profile'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePageProfile()),
                      );
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('View Pets'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ViewPetPage()));
                    },
                  ),
                  PopupMenuItem(
                    child: const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: hasLoaded
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              color: const Color(0xFFd9f1fd), // Match the background color
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildTab('Veterinary Clinic', fontSize: 16, index: 0),
                        const SizedBox(width: 10),
                        _buildTab('Shelter', fontSize: 16, index: 1),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildContent(false, clinics),
                        _buildContent(true, shelters),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildTab(String text, {double fontSize = 16, required int index}) {
    bool isSelected = _tabController.index == index;

    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _tabController.animateTo(index);
          });
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20), // Adjust padding
          minimumSize: const Size(80, 40),
          backgroundColor: isSelected
              ? const Color(0xff013958) // Selected button color
              : const Color(0xFF7ecef8), // Unselected button color
        ),
        child: Text(
          text,
          style: TextStyle(
            color:
                isSelected ? Colors.white : Colors.black, // Change text color
            fontSize: fontSize, // Change text size
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isShelter, List data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () {
                if (isShelter) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShelterDetailsPage(
                                data: data[index],
                              )));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClinicDetailsPage(
                                data: data[index],
                              )));
                }
              },
              child: _buildCard(data[index], isShelter)),
        );
      },
    );
  }

  Widget _buildCard(Map data, bool isShelter) {
    return SizedBox(
      height: 400,
      child: Card(
        color: const Color(0xFFd9f1fd), // Match the background color
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Image.asset(
                      'images/image 10.png',
                    ),
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // Handle Card Header click
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        isShelter ? data['shelter'] : data['vetClinic'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data['website'],
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Icon(Icons.star, size: 20),
              //     Icon(Icons.star, size: 20),
              //     Icon(Icons.star, size: 20),
              //     Icon(Icons.star, size: 20),
              //     Icon(Icons.star, size: 20),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePageNearMe extends StatefulWidget {
  const HomePageNearMe({super.key});

  @override
  State<HomePageNearMe> createState() => _HomePageNearMeState();
}

class _HomePageNearMeState extends State<HomePageNearMe> {
  int _selectedIndex = 4;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreenPage(), // Example of actual widget
    const MatingPage(), // Example of actual widget
    const PetListScreen(), // Example of actual widget
    const ChatScreen(),
    const NearMePage(), // Example of actual widget
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd9f1fd),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: GNav(
              backgroundColor: const Color(0xffd9f1fd),
              rippleColor: Colors.black,
              hoverColor: const Color(0xff013958),
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: const Color(0xff013958),
              color: Colors.black,
              tabs: const [
                GButton(icon: LineIcons.home),
                GButton(icon: LineIcons.heart),
                GButton(icon: LineIcons.plusCircle),
                //IconButton(icon: Icon(Icons.message)),
                GButton(icon: LineIcons.facebookMessenger),
                GButton(icon: LineIcons.mapPin),
                // Add more tabs here if needed
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
