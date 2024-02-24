import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rss_dart/dart_rss.dart';
import 'package:rss_dart/domain/rss1_feed.dart';

void main() async {
  final configurations = Configurations();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: configurations.apiKey,
          appId: configurations.appId,
          messagingSenderId: configurations.messagingSenderId,
          projectId: configurations.projectId));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Rss Reader',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _pageIndex = 0;
  PageController _pageController = PageController();

  static final List<Widget> _pages = <Widget>[
    const Feed(),
    const Settings(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rss Reader'),
      ),
      body: PageView(
        onPageChanged: _onPageChanged,
        controller: _pageController,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _pageIndex,
        onTap: (int index) {
          _pageIndex = index;
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        },
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.rss_feed),
          label: 'Feed',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      onTap: (int index) {},
    );
  }
}

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Feed'),
      ),
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Add Feed'),
          onPressed: () {
            _showDialog(context);
          },
        ),
      ),
    );
  }
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog();
    },
  );
}

class Dialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Dialog();
  }
}

class _Dialog extends State<Dialog> {
  String name = "";
  String url = "";
  String infoText = "";
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Add Feed'),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: const InputDecoration(labelText: "name"),
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: const InputDecoration(labelText: "feed url"),
            onChanged: (value) {
              setState(() {
                url = value;
              });
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Text(infoText),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                infoText = "";
              });
              try {
                await parseRss(url);
              } catch (e) {
                setState(() {
                  infoText = "このURLは登録できません。\n${e.toString()}";
                });
              }
            },
            child: const Text('Add'),
          ),
        )
      ],
    );
  }
}

Future<http.Response?> parseRss(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch atom.xml");
    }

    final body = response.body;

    if (!isAtom(body) && !isRss1(body) && !isRss2(body)) {
      throw Exception("This is not a valid rss feed");
    }
    return response;
  } catch (e) {
    throw Exception(e);
  }
}

bool isRss2(String body) {
  try {
    RssFeed.parse(body);
    return true;
  } catch (e) {
    return false;
  }
}

bool isAtom(String body) {
  try {
    AtomFeed.parse(body);
    return true;
  } catch (e) {
    return false;
  }
}

bool isRss1(String body) {
  try {
    Rss1Feed.parse(body);
    return true;
  } catch (e) {
    return false;
  }
}
