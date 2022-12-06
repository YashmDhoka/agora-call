import 'package:call/screens/call_screen.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

int? _remoteUid;
bool _isJoined = false;
bool muteEnabled = true;
bool speakerEnabled = false;
const String appId = "f8b5be34b2564abfa3c7befdab654091";
bool checkStatus = false;

status() {
  String? statusText;

  if (!_isJoined) {
    statusText = 'Connecting';
    checkStatus = false;
    // connectionState(checkStatus);
    return checkStatus;
  } else if (_remoteUid == null) {
    statusText = 'Waiting for user to join...';
    // connectionState(checkStatus);
    return checkStatus;
  } else if (_isJoined) {
    statusText = 'Connected!!';
    // connectionState(checkStatus);
    return checkStatus;
  } else {
    return Text(
      statusText.toString(),
      style: const TextStyle(color: Color(0xff9D9D9D), fontSize: 20),
    );
  }
}

Icon changeMichrophoneIcon = const Icon(
  Icons.mic_sharp,
  size: 30,
  color: Colors.black,
);

Icon speakerIcon = const Icon(
  Icons.volume_off,
  size: 30,
  color: Colors.black,
);

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
    throw Exception('Failed to load callers');
  }
}

class CallConnecting extends StatefulWidget {
  const CallConnecting({super.key});

  @override
  State<CallConnecting> createState() => _CallConnectingState();
}

class _CallConnectingState extends State<CallConnecting> {
  late Future<List<Name>> futureAvailableCallers;

  @override
  void initState() {
    super.initState();
    status();
    futureAvailableCallers = fetchAvailableCallers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (checkStatus == false) {
      return Scaffold(
        body: FutureBuilder<List<DentistName>>(
            future: futureAvailableCallers,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 1,
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          filterQuality: FilterQuality.high,
                          image: AssetImage(
                              'assets/BackgroundImage_CallScreen.png'),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 70),
                          Center(
                            child: AvatarGlow(
                              endRadius: 90,
                              glowColor: const Color(0xffA4C7FB),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white12,
                                backgroundImage: NetworkImage(
                                  snapshot.data![0].thumbnail!,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              snapshot.data![0].name!,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Center(
                            child: Text(
                              'Ringing',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
        bottomNavigationBar: BottomAppBar(
          color: const Color(0xff0A0A0A),
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 15.0, top: 15.0, bottom: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffFDEACE),
                      borderRadius: BorderRadius.circular(15)),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (speakerEnabled == true) {
                            speakerIcon = const Icon(
                              Icons.volume_off,
                              size: 30,
                              color: Colors.black,
                            );
                            // agoraEngine!.setEnableSpeakerphone(true);
                            speakerEnabled = false;
                          } else if (speakerEnabled == false) {
                            speakerIcon = const Icon(
                              Icons.volume_up,
                              size: 30,
                              color: Colors.black,
                            );
                            // agoraEngine!.setEnableSpeakerphone(false);

                            speakerEnabled = true;
                          }
                        });
                      },
                      icon: speakerIcon),
                ),
              ),
             
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 25.0, top: 15.0, bottom: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xffDECFFC),
                      borderRadius: BorderRadius.circular(15)),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (muteEnabled == true) {
                            changeMichrophoneIcon = const Icon(
                              Icons.mic_off_sharp,
                              size: 30,
                              color: Colors.black,
                            );

                            // agoraEngine!.muteLocalAudioStream(muteEnabled);
                            muteEnabled = false;
                          } else if (muteEnabled == false) {
                            changeMichrophoneIcon = const Icon(
                              Icons.mic_sharp,
                              size: 30,
                              color: Colors.black,
                            );
                            // agoraEngine!.muteLocalAudioStream(muteEnabled);

                            muteEnabled = true;
                          }
                        });
                      },
                      icon: changeMichrophoneIcon),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          backgroundColor: const Color(0xff2EC815),
          child: const Icon(
            Icons.call_end,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    } else {
      return const CallScreen();
    }
  }
}
