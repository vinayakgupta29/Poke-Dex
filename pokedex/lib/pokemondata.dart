// To parse this JSON data, do
//
//     final pokemonSummary = pokemonSummaryFromJson(jsonString);

import 'dart:convert';

List<PokemonSummary> pokemonSummaryFromJson(String str) => List<PokemonSummary>.from(json.decode(str).map((x) => PokemonSummary.fromJson(x)));

String pokemonSummaryToJson(List<PokemonSummary> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PokemonSummary {
    String number;
    String name;
    String imageUrl;
    String thumbnailUrl;
    Sprites sprites;
    List<Type> types;
    String specie;
    Generation generation;

    PokemonSummary({
        required this.number,
        required this.name,
        required this.imageUrl,
        required this.thumbnailUrl,
        required this.sprites,
        required this.types,
        required this.specie,
        required this.generation,
    });

    factory PokemonSummary.fromJson(Map<String, dynamic> json) => PokemonSummary(
        number: json["number"],
        name: json["name"],
        imageUrl: json["imageUrl"],
        thumbnailUrl: json["thumbnailUrl"],
        sprites: Sprites.fromJson(json["sprites"]),
        types: List<Type>.from(json["types"].map((x) => typeValues.map[x]!)),
        specie: json["specie"],
        generation: generationValues.map[json["generation"]]!,
    );

    Map<String, dynamic> toJson() => {
        "number": number,
        "name": name,
        "imageUrl": imageUrl,
        "thumbnailUrl": thumbnailUrl,
        "sprites": sprites.toJson(),
        "types": List<dynamic>.from(types.map((x) => typeValues.reverse[x])),
        "specie": specie,
        "generation": generationValues.reverse[generation],
    };
}

enum Generation { GENERATION_I, GENERATION_II, GENERATION_III, GENERATION_IV, GENERATION_V, GENERATION_VI, GENERATION_VII, GENERATION_VIII }

final generationValues = EnumValues({
    "GENERATION_I": Generation.GENERATION_I,
    "GENERATION_II": Generation.GENERATION_II,
    "GENERATION_III": Generation.GENERATION_III,
    "GENERATION_IV": Generation.GENERATION_IV,
    "GENERATION_V": Generation.GENERATION_V,
    "GENERATION_VI": Generation.GENERATION_VI,
    "GENERATION_VII": Generation.GENERATION_VII,
    "GENERATION_VIII": Generation.GENERATION_VIII
});

class Sprites {
    String mainSpriteUrl;
    String? frontAnimatedSpriteUrl;
    String? backAnimatedSpriteUrl;
    String? frontShinyAnimatedSpriteUrl;
    String? backShinyAnimatedSpriteUrl;

    Sprites({
        required this.mainSpriteUrl,
        this.frontAnimatedSpriteUrl,
        this.backAnimatedSpriteUrl,
        this.frontShinyAnimatedSpriteUrl,
        this.backShinyAnimatedSpriteUrl,
    });

    factory Sprites.fromJson(Map<String, dynamic> json) => Sprites(
        mainSpriteUrl: json["mainSpriteUrl"],
        frontAnimatedSpriteUrl: json["frontAnimatedSpriteUrl"],
        backAnimatedSpriteUrl: json["backAnimatedSpriteUrl"],
        frontShinyAnimatedSpriteUrl: json["frontShinyAnimatedSpriteUrl"],
        backShinyAnimatedSpriteUrl: json["backShinyAnimatedSpriteUrl"],
    );

    Map<String, dynamic> toJson() => {
        "mainSpriteUrl": mainSpriteUrl,
        "frontAnimatedSpriteUrl": frontAnimatedSpriteUrl,
        "backAnimatedSpriteUrl": backAnimatedSpriteUrl,
        "frontShinyAnimatedSpriteUrl": frontShinyAnimatedSpriteUrl,
        "backShinyAnimatedSpriteUrl": backShinyAnimatedSpriteUrl,
    };
}

enum Type { GRASS, POISON, FIRE, FLYING, WATER, BUG, NORMAL, ELECTRIC, GROUND, FAIRY, FIGHTING, PSYCHIC, ROCK, STEEL, ICE, GHOST, DRAGON, DARK }

final typeValues = EnumValues({
    "Bug": Type.BUG,
    "Dark": Type.DARK,
    "Dragon": Type.DRAGON,
    "Electric": Type.ELECTRIC,
    "Fairy": Type.FAIRY,
    "Fighting": Type.FIGHTING,
    "Fire": Type.FIRE,
    "Flying": Type.FLYING,
    "Ghost": Type.GHOST,
    "Grass": Type.GRASS,
    "Ground": Type.GROUND,
    "Ice": Type.ICE,
    "Normal": Type.NORMAL,
    "Poison": Type.POISON,
    "Psychic": Type.PSYCHIC,
    "Rock": Type.ROCK,
    "Steel": Type.STEEL,
    "Water": Type.WATER
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
