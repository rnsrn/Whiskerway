import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:five_pointed_star/five_pointed_star.dart';
import 'package:flutter_mobile_whiskerway/cons.dart';
import 'package:flutter_mobile_whiskerway/login.dart';
import 'package:flutter_mobile_whiskerway/mapPin.dart';
import 'package:flutter_mobile_whiskerway/mating.dart';
import 'package:flutter_mobile_whiskerway/plusCircle.dart';
import 'package:flutter_mobile_whiskerway/profilePage.dart';
import 'package:flutter_mobile_whiskerway/viewpets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mongo_dart/mongo_dart.dart' as mdb;

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({super.key});

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  @override
  void initState() {
    super.initState();
    getPets();
    getDatas();
    getMyData();
  }

  int mycount = 0;

  bool hasLoaded = false;

  String myname = '';

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
      myname = pets.first['firstname'];
      hasLoaded = true;
    });

    // Print or process the results

    await db.close();
  }

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
    });

    // Print or process the results

    await db.close();
  }

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
        automaticallyImplyLeading: false, // This removes the back arrow
        backgroundColor: const Color(0xffd9f1fd),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(
              left: 8, top: 10, bottom: 10), // Adjust the left padding here
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome,',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    myname,
                    style: const TextStyle(
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
                                    builder: (context) => const HomePageProfile()));
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
                          child: const Text('Log Out',
                              style: TextStyle(
                                color: Colors.red,
                              )),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                        )
                      ])
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        7,
                        (index) => _buildUserAvatar('Full Name'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 400,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        enlargeCenterPage: true,
                        //aspectRatio: 16 / 9,
                        height: 800, // Adjust the aspect ratio here
                      ),
                      items: List.generate(
                        5,
                        (index) => _buildSection1Card(index),
                      ),
                    ),
                  ),
                  const SizedBox(height: 23),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "ADOPT A PET",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePageAdopt()));
                          },
                          color: const Color(0xff013958),
                          textColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("View All"),
                        ),
                      ]),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: petsList.length,
                      itemBuilder: (context, index) {
                        return _buildSection3Card(index, petsList[index]);
                      },
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "FIND A MATE",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePageMating()));
                          },
                          color: const Color(0xff013958),
                          textColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("View All"),
                        ),
                      ]),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: petsList.length,
                      itemBuilder: (context, index) {
                        return _buildSection3rdCard(index, petsList[index]);
                      },
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "NEARBY VETERINARY CLINIC",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const HomePageNearMe()));
                          },
                          color: const Color(0xff013958),
                          textColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("View All"),
                        ),
                      ]),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: clinics.length,
                      itemBuilder: (context, index) {
                        return _buildSection4Card(index, clinics[index], false);
                      },
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "NEARBY SHELTERS",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const HomePageNearMe()));
                          },
                          color: const Color(0xff013958),
                          textColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text("View All"),
                        ),
                      ]),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 350,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: shelters.length,
                      itemBuilder: (context, index) {
                        return _buildSection2Card(index, shelters[index]);
                      },
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

  Widget _buildUserAvatar(String fullname) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: Column(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 40,
            child: Icon(
              Icons.person_2_outlined,
              size: 40,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            fullname,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

///////////////////Section Header 1///////////////////
  Widget _buildSection1Card(int index) {
    // List of image paths
    List<String> imagePaths = [
      'images/dog1.jpg',
      'images/dog2.jpg',
      'images/dog3.jpg',
      'images/dog4.jpg',
      'images/dog5.jpg'
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.asset(
        imagePaths[index],
        width: 400,
        height: 250,
        fit: BoxFit.cover,
      ),
    );
  }

///////////////////Section Header 3///////////////////
  Widget _buildSection3Card(int index, Map data) {
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
                          data['name'] ?? '',
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
                          data['breed'] ?? '',
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
                    padding: const EdgeInsets.only(left: 30),
                    icon:
                        const Icon(Icons.arrow_right_alt, color: Colors.black),
                    onPressed: () {
                      // Handle search action
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

///////////////////Section Header 3rd///////////////////
  Widget _buildSection3rdCard(int index, Map data) {
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
                          data['name'] ?? '',
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
                          data['breed'] ?? '',
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
                    padding: const EdgeInsets.only(left: 30),
                    icon:
                        const Icon(Icons.arrow_right_alt, color: Colors.black),
                    onPressed: () {
                      // Handle search action
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

///////////////////Section Header 4///////////////////
  Widget _buildSection4Card(int index, Map data, bool isShelter) {
    List<String> listimages4 = [
      'images/dog4.jpg',
      'images/dog5.jpg',
      'images/dog1.jpg',
      'images/dog2.jpg',
      'images/dog3.jpg',
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Image.asset(
              'images/image 10.png',
              width: 375,
              height: 300,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      isShelter ? data['shelter'] : data['vetClinic'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      data['website'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
                  child: FivePointedStar(
                    onChange: (count) {
                      setState(() {
                        mycount = count;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///////////////////Section Header 2///////////////////
  Widget _buildSection2Card(int index, Map data) {
    List<String> listimages = [
      'images/dog1.jpg',
      'images/dog2.jpg',
      'images/dog3.jpg',
      'images/dog4.jpg',
      'images/dog5.jpg'
    ];

    return Container(
      padding: const EdgeInsets.only(top: 10, left: 10),
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              'images/image 10.png',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              data['shelter'],
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              data['website'],
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
