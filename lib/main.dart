import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _todoList = [];
  Color _backgroundColor = const Color.fromARGB(255, 7, 195, 220);
  final AudioPlayer _player = AudioPlayer();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _addToDo() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _todoList.add(_controller.text);
        _controller.clear();
      }
    });
  }

  void _playMusic(String asset) async {
    try {
      await _player.stop();
      await _player.play(AssetSource(asset));
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _changeBackgroundSwipe(DragEndDetails details) {
    setState(() {
      if (details.primaryVelocity! > 0) {
        _backgroundColor = Colors.red;
      } else if (details.primaryVelocity! < 0) {
        _backgroundColor = Colors.black;
      }
    });
  }

  Widget _buildTodoScreen() {
    return Container(
      decoration: _gradientBackground(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter task",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addToDo,
            style: _buttonStyle(),
            child: const Text("Add Task"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 6,
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(
                      _todoList[index],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundScreen() {
    return GestureDetector(
      onHorizontalDragEnd: _changeBackgroundSwipe,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_backgroundColor, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Swipe Left or Right",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMusicScreen() {
    return Container(
      decoration: _gradientBackground(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              "assets/musicc.jpg",
              width: 150,
              height: 150,
            ),
          ),
          const Text(
            "Play a Music",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _playMusic("AllorNothing.mp3"),
                style: _buttonStyle(),
                child: const Text("All or nothing"),
              ),
              ElevatedButton(
                onPressed: () => _playMusic("Lovedon'tChange.mp3"),
                style: _buttonStyle(),
                child: const Text("Love Dont Change"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _gradientBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.white, Colors.white],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      _buildTodoScreen(),
      _buildBackgroundScreen(),
      _buildMusicScreen()
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'JAAM',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipOval(
            child: Image.asset(
              "assetz/images/psu.jpg",
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipOval(
              child: Image.asset(
                "assetz/images/it.jpg",
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "To-Do List"),
          BottomNavigationBarItem(icon: Icon(Icons.color_lens), label: "Background"),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: "Music"),
        ],
      ),
    );
  }
}
