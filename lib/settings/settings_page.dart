import 'package:flutter/material.dart';
import 'package:to_do_flutter_03/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _isDarkTheme = preferences.isDarkTheme;
  }

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkTheme = value;
      preferences.setDarkTheme(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Настройки'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Text('Темная тема'),
              Switch(
                value:false,
                onChanged: (value) {
                  setState(() {
                    
                  });
                }
              ),
            ],
          )
        ],
      ),
    );
  }
}