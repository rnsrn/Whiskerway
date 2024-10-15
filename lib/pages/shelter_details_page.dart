import 'package:flutter/material.dart';
import 'package:flutter_mobile_whiskerway/map_screen.dart';
import 'package:flutter_mobile_whiskerway/widgets/button_widget.dart';
import 'package:flutter_mobile_whiskerway/widgets/text_widget.dart';

class ShelterDetailsPage extends StatefulWidget {
  Map data;

  ShelterDetailsPage({super.key, required this.data});

  @override
  State<ShelterDetailsPage> createState() => _ShelterDetailsPageState();
}

class _ShelterDetailsPageState extends State<ShelterDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd9f1fd),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      TextWidget(
                        text: 'Shelter Details',
                        fontSize: 24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Image.asset(
                  'images/image 10.png',
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                TextWidget(
                  text: widget.data['shelter'],
                  fontSize: 18,
                  color: Colors.black,
                ),
                TextWidget(
                  text: widget.data['location'],
                  fontSize: 14,
                  color: Colors.grey,
                ),
                TextWidget(
                  text: widget.data['phone'],
                  fontSize: 12,
                  color: Colors.grey,
                ),
                TextWidget(
                  text: widget.data['email'],
                  fontSize: 12,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextWidget(
                  text: 'Open for Donations',
                  fontSize: 18,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: 0,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        child: SizedBox(
                          height: 90,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: 'BPI Savings Account',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                TextWidget(
                                  text: 'Bank account number',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                TextWidget(
                                  text: 'Bank account holder',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextWidget(
                  text: 'Follow us on:',
                  fontSize: 18,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < 4; i++)
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Image.asset(
                          'images/Vector (${i + 2}).png',
                          width: 20,
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ButtonWidget(
                    label: 'Locate',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapScreen(
                                    data: widget.data,
                                  )));
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
