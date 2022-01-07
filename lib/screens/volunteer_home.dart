import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demoagora/providers/call_provider.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool avaialable = false;

  @override
  // ignore: dead_code
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow[100],
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Volunteer Home",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.amber,
          elevation: 0,
          actions: [
            TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.person_rounded,
                  color: Colors.black,
                ),
                label: const Text(
                  "Log Out",
                  style: TextStyle(color: Colors.black),
                )),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  if (avaialable) {
                    context.read<CallProvider>().setTrue();
                  }
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 120),
                    primary: Colors.amberAccent),
                icon: Icon(
                  Icons.call,
                  color: Colors.black,
                ),
                label: Text(
                  "Begin Assisting",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Available",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: avaialable,
                    onChanged: (value) {
                      setState(() {
                        avaialable = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
