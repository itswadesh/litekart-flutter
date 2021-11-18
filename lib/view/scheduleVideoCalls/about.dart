import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AboutPageState();
  }
}

class _AboutPageState extends State<AboutPage> {
  PackageInfo _packageInfo = PackageInfo(
    version: 'Unknown',
    buildNumber: 'Unknown', packageName: '', appName: '',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        titleSpacing: 0,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Version Name'),
              subtitle: Text(_packageInfo.version),
            ),
            Divider(
                height: 1, color: Colors.grey, indent: 15.0, endIndent: 15.0),
            ListTile(
              title: const Text('Build Number'),
              subtitle: Text(_packageInfo.buildNumber),
            )
          ],
        ),
      ),
    );
  }
}