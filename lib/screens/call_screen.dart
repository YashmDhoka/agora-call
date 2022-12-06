import 'package:call/screens/call_connecting_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

int? _remoteUid;
bool _isJoined = false;
bool muteEnabled = true;
bool speakerEnabled = false;
const String appId = "f8b5be34b2564abfa3c7befdab654091";
bool muteStatus = true;

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

class DentistName {
  String? name;
  String? thumbnail;
  String? callLength;

  DentistName({
    this.name,
    this.thumbnail,
    this.callLength,
  });

  factory DentistName.fromJson(Map<String, dynamic> json) {
    return DentistName(
        name: json['name'],
        thumbnail: json['thumbnail'],
        callLength: json['callLenth']);
  }
}

Future<List<DentistName>> fetchAvailableDentist() async {
  final response = await http.post(Uri.parse('https://postman-echo.com/post'),
      body: jsonEncode([
        {
          "name": "dog",
          "thumbnail": "https://picsum.photos/id/237/200/300",
          "callLength": "",
        },
        {
          "name": "mountain",
          "thumbnail": "https://picsum.photos/seed/picsum/200/300",
          "callLength": "",
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

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  String channelName = "trial";
  String token =
      "007eJxTYMjasMf91+VTr+MfqGRdn1s1sb509+ltjLvnbplu9jnDRElfgSHNIsk0KdXYJMnI1MwkMSkt0TjZPCk1LSUxyczUxMDSMDi7JbkhkJGBh6eMhZEBAkF8VoaSoszEHAYGAEd7IZA=";
  int uid = 0;

  RtcEngine? agoraEngine;

  late Future<List<DentistName>> futureAvailableDentist;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Future<void> setupVoiceSDKEngine() async {
    await Permission.microphone.request();

    agoraEngine = await RtcEngine.create(
      appId,
    );

    await agoraEngine!.enableAudio();
    agoraEngine!.disableVideo();

    agoraEngine!.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, int elapsed) {
        showMessage("Local user uid: $uid joined the channel");
        setState(() {
          _isJoined = true;
        });
      },
      userJoined: (uid, int elapsed) {
        showMessage("Remote user uid:$uid joined the channel");
        setState(() {
          _remoteUid = uid;
        });
      },
      userOffline: (int remoteUid, reason) {
        showMessage("Remote user uid:$remoteUid left the channel");
        setState(() {
          _remoteUid = null;
        });
      },
    ));

    await agoraEngine!.joinChannel(token, channelName, null, 0,
        ChannelMediaOptions(publishLocalVideo: false));
  }

  @override
  void initState() {
    super.initState();
    setupVoiceSDKEngine();
    futureAvailableDentist = fetchAvailableDentist();
  }

  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine!.leaveChannel();
  }

  @override
  void dispose() {
    agoraEngine!.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_remoteUid != null) {
      if (muteStatus == false) {
        return muteBody(context);
      } else {
        return unMuteBody(context);
      }
    } else {
      return const CallConnecting();
    }
  }

  Scaffold muteBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffC9E5FF),
      ),
      body: FutureBuilder<List<DentistName>>(
          future: futureAvailableDentist,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: Container(
                            height: 300,
                            decoration: const BoxDecoration(
                              color: Color(0xffC9E5FF),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.18,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          snapshot.data![0].thumbnail!,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    snapshot.data![0].name!,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xff0A0A0A)
                                            .withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child:
                                          Text(snapshot.data![0].callLength!),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Text('Muted'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.36,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              image: AssetImage(
                                  'assets/BackgroundImage_CallScreen.png'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
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
                            Icons.volume_up,
                            size: 30,
                            color: Colors.black,
                          );
                          agoraEngine!.setEnableSpeakerphone(true);
                          speakerEnabled = false;
                        } else if (speakerEnabled == false) {
                          speakerIcon = const Icon(
                            Icons.volume_off,
                            size: 30,
                            color: Colors.black,
                          );
                          agoraEngine!.setEnableSpeakerphone(false);
                          speakerEnabled = true;
                        }
                      });
                    },
                    icon: speakerIcon),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 23.0),
              child: Text(
                'DentalDost',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

                          agoraEngine!.muteLocalAudioStream(muteEnabled);
                          muteStatus = false;
                          muteEnabled = false;
                        } else if (muteEnabled == false) {
                          changeMichrophoneIcon = const Icon(
                            Icons.mic_sharp,
                            size: 30,
                            color: Colors.black,
                          );
                          agoraEngine!.muteLocalAudioStream(muteEnabled);
                          muteStatus = true;
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
          leave();
          Navigator.pop(context);
        },
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.call_end,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Scaffold unMuteBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffC9E5FF),
      ),
      body: FutureBuilder<List<DentistName>>(
          future: futureAvailableDentist,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: Container(
                            height: 300,
                            decoration: const BoxDecoration(
                              color: Color(0xffC9E5FF),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.18,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          snapshot.data![0].thumbnail!,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(snapshot.data![0].name!),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: const Color(0xff0A0A0A)
                                            .withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text('Call length'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.36,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              image: AssetImage(
                                  'assets/BackgroundImage_CallScreen.png'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
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
                            Icons.volume_up,
                            size: 30,
                            color: Colors.black,
                          );
                          agoraEngine!.setEnableSpeakerphone(true);
                          speakerEnabled = false;
                        } else if (speakerEnabled == false) {
                          speakerIcon = const Icon(
                            Icons.volume_off,
                            size: 30,
                            color: Colors.black,
                          );
                          agoraEngine!.setEnableSpeakerphone(false);
                          speakerEnabled = true;
                        }
                      });
                    },
                    icon: speakerIcon),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 23.0),
              child: Text(
                'DentalDost',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                          agoraEngine!.muteLocalAudioStream(muteEnabled);
                          muteStatus = false;
                          muteEnabled = false;
                        } else if (muteEnabled == false) {
                          changeMichrophoneIcon = const Icon(
                            Icons.mic_sharp,
                            size: 30,
                            color: Colors.black,
                          );
                          agoraEngine!.muteLocalAudioStream(muteEnabled);
                          muteStatus = true;
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
          leave();
          Navigator.pop(context);
        },
        backgroundColor: Colors.red,
        child: const Icon(
          Icons.call_end,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Widget _status() {
  String statusText;

  if (!_isJoined) {
    statusText = 'Connecting to DentalDost';
  } else if (_remoteUid == null) {
    statusText = 'Waiting for a dentist to join...';
  } else {
    statusText = 'Connected!!';
  }

  return Text(
    statusText,
  );
}
