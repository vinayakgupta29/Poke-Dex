import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/pokemondata.dart';
import 'package:http/http.dart' as http;
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

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

  GlobalKey<AutoCompleteTextFieldState<String>> _key = GlobalKey();

  var _pokeChoose;

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
              body: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(
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
                  ElevatedButton(onPressed: () {}, child: Text("Send")),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pokemonDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (_textEditingController.text.isEmpty ||
                            pokemonDetails[index].name.toLowerCase().contains(
                                _textEditingController.text.toLowerCase())) {
                          return ListTile(
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
