import 'package:call/screens/call_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Name {
  String? name;
  String? thumbnail;

 Name({
    this.name,
    this.thumbnail,
  });

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      name: json['name'],
      thumbnail: json['thumbnail'],
    );
  }
}

Future<List<Name>> fetchAvailableCallers() async {
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
        .map<Name>((e) => Name.fromJson(e))
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
  late Future<List<Name>> futureAvailableCallers;

  @override
  void initState() {
    super.initState();
    futureAvailableCallers = fetchAvailableCallers();
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
        body: FutureBuilder<List<Name>>(
            future: futureAvailableCallers,
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
                                    'Users online',
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
                                                height: 15,
                                              ),
                                              
                                              
                                             
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
                'Make Call',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
