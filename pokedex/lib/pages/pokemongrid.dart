import 'package:flutter/material.dart';
import 'package:pokedex/pages/pokecard.dart';
import 'package:pokedex/pokemondata.dart';

class PokemonGrid extends StatefulWidget {
  final List<PokemonSummary> repo;
  const PokemonGrid({super.key, required this.repo});

  @override
  State<PokemonGrid> createState() => _PokemonGridState();
}

class _PokemonGridState extends State<PokemonGrid> {
  @override
  Widget build(BuildContext context) {
      var pokemonlist=widget.repo;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        crossAxisCount: 2, // Number of cards per row
        childAspectRatio: 1.5, // Width to height ratio of each card
      ),
      itemCount: pokemonlist.length, // Total number of cards
      itemBuilder: (context, index) {
        var pokelist=pokemonlist[index];
        var name=pokelist.name;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: PokemonGridCard(pokemon:name),
        );
      },
    );
  }
}
