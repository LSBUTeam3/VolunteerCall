import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:demoagora/providers/call_provider.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

const app_id = "";
const token = "";
const channelName = "";

RtcEngineContext context = RtcEngineContext(app_id);
var engine;

class VideoCall extends StatefulWidget {
  const VideoCall({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<VideoCall> {
  bool _joined = false;
  int _remoteUid = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await [Permission.camera, Permission.microphone].request();

    // Create RTC client instance
    RtcEngineContext context = RtcEngineContext(app_id);

    engine = await RtcEngine.createWithContext(context);
    // Define event handling logic
    engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
      print('joinChannelSuccess $channel ${uid}');
      setState(() {
        _joined = true;
      });
    }, userJoined: (int uid, int elapsed) {
      print('userJoined ${uid}');
      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      print('userOffline ${uid}');
      setState(() {
        _remoteUid = 0;
      });
    }));

    await engine.enableVideo();
    await engine.enableAudio();
    await engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await engine.setClientRole(ClientRole.Broadcaster);
    await engine.joinChannel(token, channelName, null, 0);
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.yellowAccent[100],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            leaveChannel(engine);
            context.read<CallProvider>().setFalse();
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.call_end),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Volunteer Video Call",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.amberAccent,
        ),
        body: Stack(
          children: [
            Center(
              child: _renderRemoteVideo(),
            ),
          ],
        ),
      ),
    );
  }

  // Remote preview
  Widget _renderRemoteVideo() {
    if (_remoteUid != 0) {
      return rtc_remote_view.SurfaceView(
        uid: _remoteUid,
        channelId: "testing",
      );
    } else {
      return const Text(
        "Please wait for remote user to join",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        textAlign: TextAlign.center,
      );
    }
  }

  void leaveChannel(RtcEngine engine) {
    engine.leaveChannel();
  }
}
