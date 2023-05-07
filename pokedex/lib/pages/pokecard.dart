import 'package:flutter/material.dart';

class PokemonGridCard extends StatefulWidget {
  final String pokemon;
  PokemonGridCard({
    super.key,
    required this.pokemon,
  });

  @override
  State<PokemonGridCard> createState() => _PokemonGridCardState();
}

class _PokemonGridCardState extends State<PokemonGridCard> {
  // @override
  // void initState() {
  //   print(getPokemonData());
  //   getPokemonData();
  //   super.initState();
  // }

  Color color = Colors.blue;

  // Future<Map<String, dynamic>> getPokemonData() async {
  //   // Load the JSON file from the assets folder
  //   String jsonString = await rootBundle.loadString('assets/data/pokemons.json');

  //   // Parse the JSON data
  //   Map<String, dynamic> jsonData = json.decode(jsonString);

  //   return jsonData;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        color: color,
      ),
      child: Center(
        child: Text(
          'Card ',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
