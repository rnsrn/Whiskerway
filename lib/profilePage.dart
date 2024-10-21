import 'package:flutter/material.dart';
import 'package:flutter_mobile_whiskerway/cons.dart';
import 'package:flutter_mobile_whiskerway/editprofile.dart';
import 'package:flutter_mobile_whiskerway/home.dart';
import 'package:flutter_mobile_whiskerway/login.dart';
import 'package:flutter_mobile_whiskerway/mapPin.dart';
import 'package:flutter_mobile_whiskerway/mating.dart';
import 'package:flutter_mobile_whiskerway/messageChat.dart';
import 'package:flutter_mobile_whiskerway/plusCircle.dart';
import 'package:flutter_mobile_whiskerway/viewpets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mongo_dart/mongo_dart.dart' as mdb;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    getMyData();
  }

  int mycount = 0;

  bool hasLoaded = false;

  Map myData = {};

  final box = GetStorage();
  Future<void> getMyData() async {
    var db = await mdb.Db.create(MONGO_URL);
    await db.open();

    var collection = db.collection('users');

    // Example query to find pets with a specific condition
    var query = mdb.where
        .eq('email', box.read('email')); // Replace with your query condition

    // Fetch documents that match the query
    var pets = await collection.find(query).toList();

    setState(() {
      myData = pets.first;
      hasLoaded = true;
    });

    // Print or process the results

    await db.close();
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
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 8),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 30,
                padding: const EdgeInsets.only(right: 8),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
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
                    "Profile",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              const Spacer(),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('View Pets'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Viewpets()));
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
                              builder: (context) => const LoginPage()));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: hasLoaded
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 70,
                    child: Icon(
                      Icons.person_2_outlined,
                      size: 90,
                    ),
                  ),
                  // TextButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => HomePageEditProfile()));
                  //     },
                  //     child: const Text("Edit Profile",
                  //         style: TextStyle(
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.grey,
                  //         ))),
                  const SizedBox(
                      height: 30), // Add spacing between avatar and inputs
                  inputFile(label: "First Name", text: myData['firstname']),
                  inputFile(label: "Last Name", text: myData['lastname']),
                  inputFile(label: "Email", text: myData['email']),
                  inputFile(
                      label: "Password",
                      obscureText: true,
                      suffixIcon: Icons.visibility_off,
                      text: '*****'),

                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      width: 200, // Adjust the width here
                      padding: const EdgeInsets.only(top: 3, right: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  )
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget inputFile(
      {label, obscureText = false, IconData? suffixIcon, String text = ''}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: TextEditingController(text: text),
          enabled: false,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: obscureText ? Icon(suffixIcon) : null,
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
              borderSide: BorderSide(color: Colors.green),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}

/////////////bottom navbar

class HomePageProfile extends StatefulWidget {
  const HomePageProfile({super.key});

  @override
  State<HomePageProfile> createState() => _HomePageProfileState();
}

class _HomePageProfileState extends State<HomePageProfile> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const ProfilePage(), // Example of actual widget
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
