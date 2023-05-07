import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/pages/resultpage.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    super.key,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<PokemonSummary>? _Pokelist;
  List<String>? pokeName;
  List<int>? pokeId;
  TextEditingController _textEditingController = TextEditingController();

  var _pokeChoose;

  final _formkey = GlobalKey<FormState>();

  List<String>? _similarpokelist;

  @override
  void initState() {
    getList();
    super.initState();
  }

  void getList() {
    pokeId = _Pokelist?.map((e) => e.id).cast<int>().toList();
    pokeName = _Pokelist?.map((e) => e.name).toList();
  }

  Future<List<dynamic>> fetchJsonData() async {
    final response = await http
        .get(Uri.parse('https://pokedex.alansantos.dev/api/pokemons.json'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  final String apiUrl = 'http://10.0.2.2:5000/api';

  Future<List<String>?> findSimilarPokemon(String? name) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name}),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> _similarpokelist = json.decode(response.body);
        return List<String>.from(_similarpokelist['pokelist'].map((x) => x));
      } else {
        throw Exception(
            'Failed to load similar Pokemon. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching similar Pokemon: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchJsonData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // extract the names using map()
          List<dynamic>? names =
              snapshot.data?.map((item) => item['name']).toList();
          List<dynamic>? images =
              snapshot.data?.map((e) => e['thumbnailUrl']).toList();
          List<PokemonSummary> pokemonDetails = [];
          for (int i = 0; i < names!.length; i++) {
            pokemonDetails.add(PokemonSummary(
                id: i + 1, name: names[i], imageUrl: images![i]));
          }
          // use the names list in your UI
          return GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Scaffold(
              body: Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Pokemon name';
                          }
                          return null;
                        },
                        controller: _textEditingController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Search for a Pokemon',
                            floatingLabelBehavior: FloatingLabelBehavior.auto),
                        onChanged: (value) {
                          setState(() {
                            _pokeChoose = null;
                          });
                        },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            findSimilarPokemon(_textEditingController.text);
                            _similarpokelist = await findSimilarPokemon(
                                _textEditingController.text);
                            print(_similarpokelist);
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => ResultPage(
                                        pokelist: _similarpokelist,
                                        images: images,
                                        names: names,
                                      )));
                        },
                        style: ButtonStyle(
                            elevation: MaterialStatePropertyAll(4.0),
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xffc45c4b))),
                        child: Text(
                          "Send",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )),
                    Expanded(
                      child: ListView.builder(
                        itemCount: pokemonDetails.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (_textEditingController.text.isEmpty ||
                              pokemonDetails[index].name.toLowerCase().contains(
                                  _textEditingController.text.toLowerCase())) {
                            return Card(
                              color: Colors.grey[50],
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: CachedNetworkImage(
                                    imageUrl: pokemonDetails[index].imageUrl,
                                    height: 50,
                                    width: 50,
                                  ),
                                  title: Text(pokemonDetails[index].name),
                                  onTap: () {
                                    setState(() {
                                      _pokeChoose = pokemonDetails[index].id;
                                      _textEditingController.text =
                                          pokemonDetails[index].name;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class PokemonSummary {
  final int id;
  final String name;
  final String imageUrl;

  PokemonSummary({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}
