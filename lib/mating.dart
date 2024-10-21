import 'package:flutter/material.dart';
import 'package:flutter_mobile_whiskerway/cons.dart';
import 'package:flutter_mobile_whiskerway/home.dart';
import 'package:flutter_mobile_whiskerway/home_screen.dart';
import 'package:flutter_mobile_whiskerway/login.dart';
import 'package:flutter_mobile_whiskerway/mapPin.dart';
import 'package:flutter_mobile_whiskerway/messageChat.dart';
import 'package:flutter_mobile_whiskerway/plusCircle.dart';
import 'package:flutter_mobile_whiskerway/profilePage.dart';
import 'package:flutter_mobile_whiskerway/viewpets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mongo_dart/mongo_dart.dart' as mdb;

class MatingPage extends StatefulWidget {
  const MatingPage({super.key});

  @override
  State<MatingPage> createState() => _MatingPageState();
}

class _MatingPageState extends State<MatingPage> {
  String _selectedButton = 'All';
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
                      "Find a Mate",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Find a mate for your pet",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
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
                              builder: (context) => HomePageProfile()),
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.only(
            top: 10,
            left: 15,
            right: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildMaterialButton('All'),
                  const SizedBox(width: 8),
                  _buildMaterialButton('Dog'),
                  const SizedBox(width: 8),
                  _buildMaterialButton('Cat'),
                ],
              ),
              const SizedBox(height: 20),
              _buildTabContent(),
            ],
          ),
        ));
  }

  Widget _buildMaterialButton(String label) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedButton = label;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _selectedButton == label
              ? const Color(0xff013958)
              : const Color(0xff7ecef8),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Text(
          label,
          style: TextStyle(
            color: _selectedButton == label ? Colors.white : Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedButton) {
      case 'All':
        return const AllTab();
      case 'Dog':
        return const AllTab();
      case 'Cat':
        return const AllTab();
      default:
        return const AllTab();
    }
  }
}

class AllTab extends StatefulWidget {
  const AllTab({super.key});

  @override
  _AllTabState createState() => _AllTabState();
}

class _AllTabState extends State<AllTab> {
  @override
  void initState() {
    super.initState();
    getPets();
  }

  bool hasLoaded = false;

  final box = GetStorage();
  // Default selected button

  List petsList = [];
  Future<void> getPets() async {
    var db = await mdb.Db.create(MONGO_URL);
    await db.open();

    var collection = db.collection('users');

    // Example query to find pets with a specific condition
    var query = mdb.where
        .eq('email', box.read('email')); // Replace with your query condition

    // Fetch documents that match the query
    var pets = await collection.find(query).toList();

    setState(() {
      petsList = pets;
      hasLoaded = true;
    });

    // Print or process the results

    await db.close();
  }

  @override
  Widget build(BuildContext context) {
    return hasLoaded
        ? Column(children: [
            for (int i = 0; i < petsList.length; i++)
              Dismissible(
                key: Key(petsList[i]['name'] ?? ''), // Unique key for each item
                direction: DismissDirection.endToStart, // Swipe left to delete
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm Delete"),
                        content: Text(
                            "Are you sure you want to delete ${petsList[i]['name'] ?? ''}?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(false); // Cancel deletion
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(true); // Confirm deletion
                            },
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  // setState(() {
                  //   allPets.remove(pet); // Remove the pet from the list
                  // });

                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('$pet deleted')),
                  // );
                },
                child: Container(
                  height: 100,
                  width: 400,
                  color: const Color(0xffd9f1fd),
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'images/dog1.jpg',
                            height: 80,
                            width: 100,
                            fit: BoxFit.scaleDown,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: Text(
                                  petsList[i]['name'] ??
                                      '', // Use pet name dynamically
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: Text(
                                  petsList[i]['breed'] ?? '',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
          ])
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

class DogTab extends StatefulWidget {
  const DogTab({super.key});

  @override
  _DogTabState createState() => _DogTabState();
}

class _DogTabState extends State<DogTab> {
  List<String> dogs = ['Dog 1', 'Dog 2']; // Example dog data

  @override
  Widget build(BuildContext context) {
    return Column(
      children: dogs.map((dog) {
        return Dismissible(
          key: Key(dog),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirm Delete"),
                  content: Text("Are you sure you want to delete $dog?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // Cancel deletion
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true); // Confirm deletion
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            setState(() {
              dogs.remove(dog);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$dog deleted')),
            );
          },
          child: Container(
            height: 100,
            width: 400,
            color: const Color(0xffd9f1fd),
            padding: const EdgeInsets.all(3.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'images/dog2.jpg',
                      height: 80,
                      width: 100,
                      fit: BoxFit.scaleDown,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Text(
                            dog,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 3),
                          child: Text(
                            'Dog Body copy description',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class CatTab extends StatelessWidget {
  const CatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 400,
          color: const Color(0xffd9f1fd),
          padding: const EdgeInsets.all(3.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'images/dog3.jpg',
                    height: 80,
                    width: 100,
                    fit: BoxFit.scaleDown,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 3),
                        child: Text(
                          'Cat Row Header',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 3),
                        child: Text(
                          'Cat Body copy description',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

/////////////bottom navbar

class HomePageMating extends StatefulWidget {
  const HomePageMating({super.key});

  @override
  State<HomePageMating> createState() => _HomePageMatingState();
}

class _HomePageMatingState extends State<HomePageMating> {
  int _selectedIndex = 1;
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
