import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Team Matchup',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const MatchupScreen(),
          );
        });
  }
}

class MatchupScreen extends StatefulWidget {
  const MatchupScreen({super.key});

  @override
  _MatchupScreenState createState() => _MatchupScreenState();
}

class _MatchupScreenState extends State<MatchupScreen> {
  final _group1CountController = TextEditingController();
  final _group2CountController = TextEditingController();
  List<Widget> _group1TextFields = [];
  List<Widget> _group2TextFields = [];
  final List<String> _group1Teams = [];
  final List<String> _group2Teams = [];
  List<String> _matches = [];

  void _generateTextFields() {
    final group1Count = int.tryParse(_group1CountController.text) ?? 0;
    final group2Count = int.tryParse(_group2CountController.text) ?? 0;

    setState(() {
      _group1TextFields = List.generate(group1Count, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Group 1 Team ${index + 1}',
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (_group1Teams.length > index) {
                _group1Teams[index] = value;
              } else {
                _group1Teams.add(value);
              }
            },
          ),
        );
      });

      _group2TextFields = List.generate(group2Count, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.w),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Group 2 Team ${index + 1}',
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (_group2Teams.length > index) {
                _group2Teams[index] = value;
              } else {
                _group2Teams.add(value);
              }
            },
          ),
        );
      });

      _group1Teams.clear();
      _group2Teams.clear();
      _matches.clear();
    });
  }

  void _generateMatches() {
    if (_group1Teams.length != _group2Teams.length) {
      setState(() {
        _matches = ['Groups must have the same number of teams.'];
      });
      return;
    }

    final matches = <String>[];
    final group2Teams = List.of(_group2Teams);
    // Shuffle Group 2 teams to ensure randomness
    group2Teams.shuffle();
    group2Teams.shuffle();
    // Pair teams from Group 1 with shuffled Group 2 teams
    for (int i = 0; i < _group1Teams.length; i++) {
      final team1 = _group1Teams[i];
      final team2 = group2Teams[i];
      matches.add('$team1 vs $team2');
    }

    setState(() {
      _matches = matches;
    });
  }

  void _resetScreen() {
    setState(() {
      _group1CountController.clear();
      _group2CountController.clear();
      _group1TextFields.clear();
      _group2TextFields.clear();
      _group1Teams.clear();
      _group2Teams.clear();
      _matches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        actions: [
          Icon(Icons.sports_tennis, color: Colors.blue, size: 35.sp),
        ],
        leading: Icon(Icons.sports_tennis, color: Colors.blue, size: 35.sp),
        centerTitle: true,
        title: Text('Ping Pong Matchup',
            style: TextStyle(fontSize: 30.sp, color: Colors.blue)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w,bottom: 16.h,top: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text('Enter the number of teams in each group',
                    style: TextStyle(color: Colors.blue, fontSize: 18.sp)),
              ),
               SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _group1CountController,
                      decoration: InputDecoration(
                        labelText: 'Number of Group 1',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: const BorderSide(
                            color: Colors.green,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: const BorderSide(
                            color: Colors.green,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                   SizedBox(width: 16.w),
                  Expanded(
                    child: TextField(
                      controller: _group2CountController,
                      decoration: InputDecoration(
                        labelText: 'Number of Group 2',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.green,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: const BorderSide(
                            color: Colors.green,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
               SizedBox(height: 16.h),
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(Colors.green.shade100),
                ),
                onPressed: _generateTextFields,
                label:  Text("GO",
                    style: TextStyle(color: Colors.green, fontSize: 26.sp)),
                icon:  Icon(Icons.generating_tokens,
                    color: Colors.green, size: 35.sp),
              ),
               SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                         Text("Group 1",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                                color: Colors.red)),
                        ..._group1TextFields,
                      ],
                    ),
                  ),
                   SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      children: [
                         Text("Group 2",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                                color: Colors.green)),
                        ..._group2TextFields,
                      ],
                    ),
                  ),
                ],
              ),
               SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.red.shade100),
                      ),
                      onPressed: _generateMatches,
                      label:  Text("Start",
                          style: TextStyle(color: Colors.red, fontSize: 26.sp)),
                      icon:
                           Icon(Icons.sports, color: Colors.red, size: 35.sp),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: CircleAvatar(
                        radius: 22.r,
                        backgroundColor: Colors.red.shade100,
                        child: IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.red),
                          onPressed: () {
                            _resetScreen();
                          },
                        ),
                      )),
                ],
              ),
               SizedBox(height: 16.h),
              _matches.isEmpty
                  ? Center(
                      child: Column(
                      children: [
                        Image.asset('assets/image/table.gif'),
                         SizedBox(height: 20.h),
                         Text(
                            "No matches found... Lets play some Ping Pong!",
                            style: TextStyle(color: Colors.red, fontSize: 18.sp)),
                      ],
                    ))
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: ListView.separated(
                        itemCount: _matches.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.red.shade100,
                              child: Text(" ${index + 1}",
                                  style: const TextStyle(color: Colors.red)),
                            ),
                            trailing:  Icon(Icons.sports_tennis,
                                color: Colors.green, size: 35.sp),
                            title: Text(_matches[index].toUpperCase(),
                                style:  TextStyle(
                                    color: Colors.black, fontSize: 20.sp)),
                            subtitle: Text("Match: ${index + 1}",
                                style:  TextStyle(fontSize: 16.sp)),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return  Divider(height: 1.h, color: Colors.red);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
