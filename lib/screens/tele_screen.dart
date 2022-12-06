import 'package:call/screens/call_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DentistName {
  String? name;
  String? thumbnail;

  DentistName({
    this.name,
    this.thumbnail,
  });

  factory DentistName.fromJson(Map<String, dynamic> json) {
    return DentistName(
      name: json['name'],
      thumbnail: json['thumbnail'],
    );
  }
}

Future<List<DentistName>> fetchAvailableDentist() async {
  final response = await http.post(Uri.parse('https://postman-echo.com/post'),
      body: jsonEncode([
        {"name": "dog", "thumbnail": "https://picsum.photos/id/237/200/300"},
        {
          "name": "mountain",
          "thumbnail": "https://picsum.photos/seed/picsum/200/300"
        }
      ]));

  if (response.statusCode == 200) {
    var result = jsonDecode(jsonDecode(response.body)['data'])
        .map<DentistName>((e) => DentistName.fromJson(e))
        .toList();
    return result;
  } else {
    throw Exception('Failed to load available dentists');
  }
}

class TeleScreen extends StatefulWidget {
  const TeleScreen({Key? key}) : super(key: key);

  @override
  TeleScreenState createState() => TeleScreenState();
}

class TeleScreenState extends State<TeleScreen> {
  late Future<List<DentistName>> futureAvailableDentist;

  @override
  void initState() {
    super.initState();
    futureAvailableDentist = fetchAvailableDentist();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xff002446),
        appBar: AppBar(
          backgroundColor: const Color(0xff002446),
          elevation: 0,
          leadingWidth: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: FutureBuilder<List<DentistName>>(
            future: futureAvailableDentist,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(children: [
                        Container(
                          height: 200,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                        ),
                        Align(
                          child: Container(
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Color(0xff002446),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Telephone consultation',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0.0, 1),
                          heightFactor: 1.6,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              // clipBehavior: Clip.hardEdge,
                              height: 115,
                              width: MediaQuery.of(context).size.width * 0.85,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: kElevationToShadow[4],
                                  borderRadius: BorderRadius.circular(15)),
                              child: ListTile(
                                leading: Container(
                                  height: 100,
                                  width: 60,
                                  color: Colors.transparent,
                                  child: Column(
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.center,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/gold-coin.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                                title: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Text(
                                    'This consulation will charge 200 DD coins',
                                    style: TextStyle(
                                        color: Color(0xff0A0A0A),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                subtitle: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Text(
                                    'You are short of 50 coins for consultation.',
                                    style: TextStyle(
                                        color: Color(0xff646464),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      //
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    'Dental surgeons online',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: SizedBox(
                                    height: 160,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: SizedBox(
                                                  height: 100,
                                                  width: 100,
                                                  child: Image(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                      snapshot.data![index]
                                                          .thumbnail!,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  snapshot.data![index].name!,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Row(
                                                  children: const [
                                                    Text(
                                                      'Degree',
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      size: 15,
                                                      color: Color(0xffFFA7F5),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      'Rating',
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                      itemCount: snapshot.data!.length,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Center(
                                  child: Container(
                                    height: 130,
                                    width: 300,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0xff5FDBC3),
                                            blurRadius: 1.0,
                                            spreadRadius: 1.0,
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Redeem 100 DD coins',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'For teleconsultation, redeem coins and connect instanlty',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xff646464)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color: const Color(0xff5FDBC3),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const CallScreen()),
                                                );
                                              },
                                              icon: const Icon(
                                                  Icons.phone_in_talk),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
        bottomSheet: const BottomNavigationBar(),
      ),
    );
  }
}

class BottomNavigationBar extends StatelessWidget {
  const BottomNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // color: const Color.fromARGB(255, 1, 43, 63),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.13,
        decoration: const BoxDecoration(
          color: Color(0xffCFF2E5),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        child: Center(
          child: SizedBox(
            width: 155,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: const Color.fromARGB(255, 1, 43, 63),
              ),
              onPressed: () {},
              child: const Text(
                'Make Payment',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
