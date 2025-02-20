import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {

  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _results = [];

  Future<List<Map<String, dynamic>>> fetchWords(String query) async {
    final response = await Supabase.instance.client
        .from('words')
        .select()
        .ilike('word', '%$query%');

    print(response);
    return response;
  }

  void _searchWord() async {
    final words = await fetchWords(_controller.text);
    setState(() => _results = words);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search Word',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchWord,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final word = _results[index];
                  return ListTile(
                    title: Text(word['word']),
                    subtitle: Text(word['definition']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}