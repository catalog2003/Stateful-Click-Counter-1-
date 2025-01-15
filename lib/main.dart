import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(WordCounterApp());
}

class WordCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WordCounterScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.edit_note,
                size: 120,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                'Word Counter',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WordCounterScreen extends StatefulWidget {
  @override
  _WordCounterScreenState createState() => _WordCounterScreenState();
}

class _WordCounterScreenState extends State<WordCounterScreen> {
  TextEditingController _textController = TextEditingController();

  int _getWordCount(String text) {
    return text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length;
  }

  int _getCharacterCount(String text, {bool includeSpaces = true}) {
    return includeSpaces ? text.length : text.replaceAll(' ', '').length;
  }

  int _getSentenceCount(String text) {
    return text
        .split(RegExp(r'[.!?]'))
        .where((s) => s.trim().isNotEmpty)
        .length;
  }

  int _getParagraphCount(String text) {
    return text.split('\n').where((p) => p.trim().isNotEmpty).length;
  }

  @override
  Widget build(BuildContext context) {
    final text = _textController.text;

    return Scaffold(
      appBar: AppBar(
        title: Text('Word Counter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your text below:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _textController,
              maxLines: 8,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Type something...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.clear),
                    label: Text('Clear'),
                    onPressed: () {
                      _textController.clear();
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.copy),
                    label: Text('Copy'),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Text copied to clipboard!')),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildStatCard(
                    'Words',
                    _getWordCount(text).toString(),
                    Icons.text_fields,
                    Colors.blueAccent,
                  ),
                  _buildStatCard(
                    'Characters (with spaces)',
                    _getCharacterCount(text, includeSpaces: true).toString(),
                    Icons.space_bar,
                    Colors.greenAccent,
                  ),
                  _buildStatCard(
                    'Characters (without spaces)',
                    _getCharacterCount(text, includeSpaces: false).toString(),
                    Icons.format_color_text,
                    Colors.orangeAccent,
                  ),
                  _buildStatCard(
                    'Sentences',
                    _getSentenceCount(text).toString(),
                    Icons.article,
                    Colors.pinkAccent,
                  ),
                  _buildStatCard(
                    'Paragraphs',
                    _getParagraphCount(text).toString(),
                    Icons.view_headline,
                    Colors.purpleAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
