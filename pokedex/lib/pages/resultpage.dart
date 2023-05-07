import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final List<String>? pokelist;
  final List<dynamic>? names;
  final List<dynamic>? images;

  const ResultPage(
      {super.key,
      required this.pokelist,
      required this.names,
      required this.images});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<int> matchingIndexes = [];
  List<String> _imageurls = [];

  var selectedIndexes;
  @override
  void initState() {
    if (widget.pokelist != null &&
        widget.names != null &&
        widget.images != null) {
      for (String element in widget.pokelist!) {
        int index = widget.names!.indexWhere((e) => e == element);
        if (index != -1) {
          matchingIndexes.add(index);
        }
      }
      if (matchingIndexes != null && widget.images != null) {
        List<int> selectedIndexes = matchingIndexes
            .where((ele) => ele < widget.images!.length)
            .toList();

        for (int i in selectedIndexes) {
          if (i >= 0 && i < widget.images!.length) {
            String? _url = widget.images?[i];
            // Check if index is within range
            if (_url != null) {
              _imageurls.add(widget.images![i]);
            } // Add URL to the selectedUrls list
          }
        }
      }
    }
    print("images: ${_imageurls}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Result",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey[100],
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: this.widget.images == null &&
              this.widget.names == null &&
              this.widget.pokelist == null
          ? CircularProgressIndicator()
          : Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.pokelist?.length ?? 1,
                      itemBuilder: (context, int) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Card(
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: ListTile(
                                tileColor: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                visualDensity: VisualDensity(vertical: 3),
                                leading: Image.network(
                                  _imageurls.isEmpty
                                      ? "https://e7.pngegg.com/pngimages/706/299/png-clipart-pokemon-pokeball-illustration-pikachu-ash-ketchum-pokemon-coloring-book-pokeball-rim-pokemon-thumbnail.png"
                                      : _imageurls[int],
                                  errorBuilder: (context, url, error) =>
                                      new Icon(Icons.error),
                                ),
                                title: Text(
                                  widget.pokelist?[int] ?? "Data",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 25),
                                ),
                              ),
                            ),
                          )),
                ),
              ],
            ),
    );
  }
}
