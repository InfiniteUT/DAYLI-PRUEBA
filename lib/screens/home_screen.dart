 import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';
import 'book_screen.dart';
import 'login_screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';




typedef Books = List<Book>;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = "Usuario";
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
    Icons.auto_awesome,
    Icons.sports_esports,
    Icons.sports_soccer,  
    Icons.sports_basketball,
    Icons.sports_tennis,
    Icons.sports_volleyball,
    Icons.sports_rugby,
    Icons.sports_cricket,
    Icons.star,
    Icons.star_border,
    Icons.star_half,
    Icons.favorite,
    Icons.favorite_border,
    Icons.thumb_up,
    Icons.thumb_down,
    Icons.thumb_up_alt,
  ];

  @override
  void initState() {
    super.initState();
    _loadRating();
    _loadBooks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _loadUserName();
    _checkUserName();
  });
  }

  Future<void> _checkUserName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedName = prefs.getString('userName');
  if (savedName == null) {
    String? userName = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  LoginScreen()),
    );
    if (userName != null) {
      setState(() {
        _userName = userName;
      });
    }
  } else {
    setState(() {
      _userName = savedName;
    });
  }
}

  Future<void> _loadUserName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedName = prefs.getString('userName');
  print("Nombre cargado: $savedName");  // <---- DEBUG
  setState(() {
    _userName = savedName ?? "Usuario";
  });
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
      // ignore: deprecated_member_use
      return '${book.title}|${book.color}|${book.content}|${availableIcons.indexOf(book.icon)}';
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
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                  'Colors:',
                  style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: availableColors.map((color) {
                  return GestureDetector(
                    onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                    },
                    child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: CircleAvatar(
                      backgroundColor: color,
                      radius: 15,
                      child: selectedColor == color
                        ? const Icon(Icons.check, color: Color.fromARGB(255, 255, 255, 255))
                        : null,
                    ),
                    ),
                  );
                  }).toList(),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                  'Icons:',
                  style: TextStyle(fontSize: 16),
                  ),
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


double _rating = 3.0; // Valor inicial

Future<void> _loadRating() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    _rating = prefs.getDouble('user_rating') ?? 3.0; // Si no hay valor guardado, usa 3.0
  });
}

Future<void> _saveRating(double rating) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('user_rating', rating);
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
             Text(
              'Daily',
              style: TextStyle(
                fontFamily: 'MagicRetro',
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),            
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.black, size: 30),
          onPressed: () {
            showDialog(
              context: context,
        builder: (context) => AlertDialog(
          title: const Text("¿Cómo editar un libro?"),
          content: const Text("Para editar un libro, simplemente déjalo presionado."),
          actions: [
  IconButton(
    icon: const Icon(Icons.star, color: Colors.black, size: 30),
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Califica la app"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("¿Cuántas estrellas le das a la app?"),
              const SizedBox(height: 10),
              RatingBar.builder(
  initialRating: _rating,
  minRating: 1,
  direction: Axis.horizontal,
  allowHalfRating: true,
  itemCount: 5,
  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
  itemBuilder: (context, _) => const Icon(
    Icons.star,
    color: Colors.amber,
  ),
  onRatingUpdate: (rating) {
    setState(() {
      _rating = rating;
    });
    _saveRating(rating);  // Guarda el rating en SharedPreferences
  },
),

            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
          ],
        ),
      );
    },
  ),
],
        ),
      );
    },
  ),


),

    body: Padding(
      padding:  EdgeInsets.all(100.0),
      child: books.isEmpty
        ?  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¡Bienvenido a Daily $_userName!', 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 158, 158, 158)),
              ),
              Text(
                'Crea un nuevo diario', 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 158, 158, 158)),
              ),
            ],
          ),
        )
        : Column(
            children: [
              const SizedBox(height: 10), // Espaciado superior para centrar mejor
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
                    height: 450, // Ajuste de altura para centrar mejor
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
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentIndex == entry.key ? 12.0 : 8.0,
                    height: _currentIndex == entry.key ? 12.0 : 8.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == entry.key ? Colors.black : Colors.grey,
                      boxShadow: _currentIndex == entry.key
                          ? [BoxShadow(color: Colors.black26, blurRadius: 4)]
                          : [],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        child: const Icon(Icons.add),
      ),
    );
  }
}