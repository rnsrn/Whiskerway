import 'package:flutter/material.dart';
import 'package:flutter_mobile_whiskerway/cons.dart';
import 'package:flutter_mobile_whiskerway/home.dart';
import 'package:flutter_mobile_whiskerway/login.dart';
import 'package:flutter_mobile_whiskerway/mapPin.dart';
import 'package:flutter_mobile_whiskerway/mating.dart';
import 'package:flutter_mobile_whiskerway/messageChat.dart';
import 'package:flutter_mobile_whiskerway/pages/pet_details_page.dart';
import 'package:flutter_mobile_whiskerway/petdetails.dart';
import 'package:flutter_mobile_whiskerway/plusCircle.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart'; // for image picker
import 'package:line_icons/line_icons.dart';
import 'dart:io'; // for File handling
import 'package:mongo_dart/mongo_dart.dart' as mdb;

class Viewpets extends StatefulWidget {
  const Viewpets({super.key});

  @override
  _ViewpetsState createState() => _ViewpetsState();
}

class _ViewpetsState extends State<Viewpets> {
  @override
  void initState() {
    super.initState();
    getMyPets();
  }

  bool hasLoaded = false;

  List mypets = [];
  final box = GetStorage();
  Future<void> getMyPets() async {
    var db = await mdb.Db.create(MONGO_URL);
    await db.open();

    var collection = db.collection('users');

    // Example query to find pets with a specific condition
    var query = mdb.where
        .eq('email', box.read('email')); // Replace with your query condition

    // Fetch documents that match the query
    var pets = await collection.find(query).toList();

    setState(() {
      mypets = pets.first['pets'];
      hasLoaded = true;
    });

    // Print or process the results

    await db.close();
  }

  String? selectedType;
  String? neuteredStatus;
  String? openForDatesStatus;
  File? _image; // to hold the selected image

  // Function to pick an image
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
              const Text(
                "Pets",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              PopupMenuButton(
                itemBuilder: (context) => [
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
              padding: const EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PetPageProfile()));
                            },
                            color: const Color(0xff013958),
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text("Add Pet"),
                          ),
                        ),
                      ]),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 700,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: mypets.length,
                      itemBuilder: (context, index) {
                        return _buildSection3Card(index, mypets[index]);
                      },
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

///////////////////Section Header 3///////////////////

  Widget _buildSection3Card(int index, Map data) {
    List<String> listImage = [
      'images/dog1.jpg',
      'images/dog2.jpg',
      'images/dog3.jpg',
      'images/dog4.jpg',
      'images/dog5.jpg'
    ];

    return Dismissible(
      key: Key('$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm Delete"),
              content: Text("Are you sure you want to delete $index?"),
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
      onDismissed: (direction) {
        // Handle deletion logic here (e.g., remove from a list)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pet ${index + 1} deleted')),
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
                        data['name'],
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
                        data['breed'],
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
                IconButton(
                  iconSize: 30,
                  padding: const EdgeInsets.only(left: 150),
                  icon: const Icon(Icons.arrow_right_alt, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PetDetailsPage(
                                  data: data,
                                )));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/////////////bottom navbar

class ViewPetPage extends StatefulWidget {
  const ViewPetPage({super.key});

  @override
  State<ViewPetPage> createState() => _ViewPetPageState();
}

class _ViewPetPageState extends State<ViewPetPage> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const Viewpets(), // Example of actual widget
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
