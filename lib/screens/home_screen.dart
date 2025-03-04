import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import 'book_screen.dart';

typedef Books = List<Book>;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> books = [];
  int _currentIndex = 0;

  final List<Color> availableColors = [
    Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple,
    Colors.yellow, Colors.pink, Colors.teal, Colors.cyan, Colors.indigo,
    Colors.brown, Colors.grey, Colors.deepOrange, Colors.lightGreen, Colors.lime,
    Colors.amber, Colors.deepPurple, Colors.blueGrey, Colors.black, Colors.white
  ];

  final List<IconData> availableIcons = [
    Icons.book,
    Icons.chrome_reader_mode,
    Icons.note,
    Icons.history_edu,
    Icons.school,
    Icons.fact_check,
    Icons.description,
    Icons.article,
    Icons.music_note,
    Icons.headset,
    Icons.movie,
    Icons.videogame_asset,
    Icons.mic,
    Icons.favorite,
    Icons.handshake,
    Icons.emoji_emotions,
    Icons.sentiment_satisfied_alt,
    Icons.sentiment_very_dissatisfied,
    Icons.flight,
    Icons.explore,
    Icons.map,
    Icons.public,
    Icons.directions_walk,
    Icons.fastfood,
    Icons.local_pizza,
    Icons.local_cafe,
    Icons.icecream,
    Icons.ramen_dining,
    Icons.science,
    Icons.computer,
    Icons.memory,
    Icons.smartphone,
  ];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? storedBooks = prefs.getStringList('books');
    if (storedBooks != null) {
      setState(() {
        books = storedBooks.map((book) {
          final data = book.split('|');
          return Book(
            title: data[0],
            color: Color(int.parse(data[1])),
            content: data.length > 2 ? data[2] : "",
            icon: availableIcons[int.parse(data[3]) % availableIcons.length],
          );
        }).toList();
      });
    }
  }

  Future<void> _saveBooks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> bookData = books.map((book) {
      return '${book.title}|${book.color.value}|${book.content}|${availableIcons.indexOf(book.icon)}';
    }).toList();
    await prefs.setStringList('books', bookData);
  }

  void _addBook() {
    setState(() {
      books.add(Book(
        title: 'Nuevo Cuaderno',
        color: Colors.blue,
        icon: Icons.book,
      ));
      _saveBooks();
    });
  }

  void _editBook(int index) {
    TextEditingController titleController = TextEditingController(text: books[index].title);
    Color selectedColor = books[index].color;
    IconData selectedIcon = books[index].icon;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título del libro',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: availableColors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: color,
                        radius: 15,
                        child: selectedColor == color
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: availableIcons.map((icon) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIcon = icon;
                        });
                      },
                      child: Icon(
                        icon,
                        size: 30,
                        color: selectedIcon == icon ? Colors.black : Colors.grey,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      books[index].title = titleController.text;
                      books[index].color = selectedColor;
                      books[index].icon = selectedIcon;
                      _saveBooks();
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Guardar"),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Eliminar Cuaderno"),
                        content: const Text("¿Estás seguro de que quieres eliminar este cuaderno?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              _deleteBook(index);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text("Sí", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteBook(int index) {
    setState(() {
      books.removeAt(index);
      _saveBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Cuadernos'),
        centerTitle: true,
      ),
      body: books.isEmpty
    ? const Center(
        child: Text(
          'Crea un Diario',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      )
    : Column(
        children: [
          const SizedBox(height: 50), // Espaciado superior para centrar mejor
          Expanded(
            child: CarouselSlider.builder(
              itemCount: books.length,
              itemBuilder: (context, index, realIndex) {
                return BookCard(
                  book: books[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookScreen(book: books[index], onSave: _saveBooks),
                      ),
                    );
                  },
                  onLongPress: () => _editBook(index),
                );
              },
              options: CarouselOptions(
                height: 300, // Ajuste de altura para centrar mejor
                enlargeCenterPage: true,
                autoPlay: books.length > 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: books.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key ? Colors.blueAccent : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        child: const Icon(Icons.add),
      ),
    );
  }
}