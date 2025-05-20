import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_mobile_whiskerway/cons.dart';
import 'package:flutter_mobile_whiskerway/viewpets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart'; // for picking images
import 'package:flutter_mobile_whiskerway/home.dart';
import 'package:flutter_mobile_whiskerway/login.dart';
import 'package:flutter_mobile_whiskerway/profilePage.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mdb;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    determinePosition();
    getChats();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  bool hasLoaded = false;

  List chats = [];
  final box = GetStorage();
  Future<void> getChats() async {
    try {
      var db = await mdb.Db.create(MONGO_URL);
      await db.open();

      var collection = db.collection('chats');

      // Example query to find pets with a specific condition

      // Fetch documents that match the query
      var pets = await collection.find().toList();

      setState(() {
        messages = pets;
        hasLoaded = true;
      });

      // Print or process the results

      await db.close();
    } catch (e) {
      print(e);
    }
  }

  // List to store messages (both text and image)
  List<Map<String, dynamic>> messages = [];

  // Function to handle text message submission
  void _handleSendMessage(String message) async {
    var db = await mdb.Db.create(MONGO_URL);
    await db.open();

    var collection = db.collection('chats');
    await collection.insertOne({
      'email': box.read('email'),
      'data': message,
      'timestamp': DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),
      'updatedAt': DateTime.now(),
      'type': 'text',
    });
    setState(() {
      messages.add({
        'type': 'text',
        'data': message,
        'timestamp': DateFormat('yyyy-MM-dd hh:mm a')
            .format(DateTime.now()), // You can update this to get real-time
      });
      hasLoaded = false;
    });

    getChats();
  }

  void _handleSendLocation(String message) async {
    var db = await mdb.Db.create(MONGO_URL);
    await db.open();

    var collection = db.collection('chats');
    await collection.insertOne({
      'email': box.read('email'),
      'data': message,
      'timestamp': DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),
      'updatedAt': DateTime.now(),
      'type': 'location',
      'lat': message.toString().split(':')[2].split(',')[0],
      'long': message.toString().split(':')[3],
    });

    setState(() {
      messages.add({
        'lat': message.toString().split(':')[2].split(',')[0],
        'long': message.toString().split(':')[3],
        'type': 'location',
        'data': message,
        'timestamp': DateFormat('yyyy-MM-dd hh:mm a')
            .format(DateTime.now()), // You can update this to get real-time
      });
      hasLoaded = false;
    });

    getChats();
  }

  // Function to handle image submission (as bytes)
  void _handleSendImage(Uint8List imageBytes) async {
    // var db = await mdb.Db.create(MONGO_URL);
    // await db.open();

    // var collection = db.collection('chats');
    // await collection.insertOne({
    //   'email': box.read('email'),
    //   'data': '',
    //   'timestamp': DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),
    //   'updatedAt': DateTime.now(),
    //   'type': 'image',
    // });
    setState(() {
      messages.add({
        'type': 'image',
        'data': imageBytes.toString(),
        'timestamp': DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),
      });
      hasLoaded = false;
    });

    getChats();
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
                    "Community Forum",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
      // Pass messages to ChatMessages widget
      body: hasLoaded
          ? ChatMessages(messages: messages)
          : const Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: ChatInputBar(
        onSendLocation: _handleSendLocation,
        onSendMessage: _handleSendMessage,
        onSendImage: _handleSendImage,
      ), // Pass callbacks for sending text and images
    );
  }
}

// Widget for input bar
class ChatInputBar extends StatefulWidget {
  final Function(String) onSendMessage;
  final Function(Uint8List) onSendImage; // Callback for sending images
  final Function(String) onSendLocation; // Callback for sending images

  const ChatInputBar(
      {super.key,
      required this.onSendMessage,
      required this.onSendImage,
      required this.onSendLocation});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Function to pick image and send
  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        // If on Flutter Web, convert to bytes and use Image.memory
        final bytes = await pickedFile.readAsBytes();
        widget.onSendImage(bytes); // Send image bytes
      } else {
        // On mobile, read as bytes for consistency
        final bytes = await pickedFile.readAsBytes();
        widget.onSendImage(bytes);
      }
    }
  }

  // Function to send text message
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      widget.onSendMessage(_controller.text);
      _controller.clear();
    }
  }

  void _sendLocation() async {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Position position =
        await Geolocator.getCurrentPosition(locationSettings: locationSettings);

    widget.onSendLocation(
        'Shared Location: Lat: ${position.latitude}, Long: ${position.longitude}');
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.location_on_rounded),
            onPressed: _sendLocation, // Trigger image picker
          ),
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: _pickImage, // Trigger image picker
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage, // Send message
          ),
        ],
      ),
    );
  }
}

// Widget to display chat messages
class ChatMessages extends StatelessWidget {
  final List<Map<String, dynamic>> messages;

  const ChatMessages({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        if (message['type'] == 'text') {
          // If the message is text
          return ChatBubble(
            text: message['data'],
            timestamp: message['timestamp'],
          );
        } else if (message['type'] == 'image') {
          // If the message is an image
          return ChatImageBubble(
            imageBytes: message['data'], // image data as bytes
            timestamp: message['timestamp'],
          );
        } else if (message['type'] == 'location') {
          // If the message is an image
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                              double.parse(message['data']
                                  .toString()
                                  .split(':')[2]
                                  .split(',')[0]),
                              double.parse(
                                  message['data'].toString().split(':')[3])),
                          initialZoom: 18,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                          CircleLayer(circles: [
                            CircleMarker(
                                point: LatLng(
                                    double.parse(message['data']
                                        .toString()
                                        .split(':')[2]
                                        .split(',')[0]),
                                    double.parse(message['data']
                                        .toString()
                                        .split(':')[3])),
                                radius: 5,
                                color: Colors.red),
                          ]),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: ChatBubble(
              text: message['data'],
              timestamp: message['timestamp'],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// Widget for displaying text messages
class ChatBubble extends StatelessWidget {
  final String text;
  final String timestamp;

  const ChatBubble({
    super.key,
    required this.text,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // Align text boxes to the left
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // Added margin to the container for the text bubble
            margin: const EdgeInsets.only(left: 10, top: 5),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Text(
              text,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 4.0), // Space between message and timestamp
          // Moved the timestamp outside and below the text bubble
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: Text(
                  timestamp,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget for displaying image messages
class ChatImageBubble extends StatelessWidget {
  final Uint8List imageBytes; // Image data in bytes
  final String timestamp;

  const ChatImageBubble({
    super.key,
    required this.imageBytes,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // Added margin to the container for the image bubble
            margin: const EdgeInsets.only(left: 10, top: 5),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Image.memory(
              imageBytes,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4.0), // Space between image and timestamp
          // Moved the timestamp outside and below the image bubble
          Container(
            margin: const EdgeInsets.only(left: 15),
            child: Text(
              timestamp,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
