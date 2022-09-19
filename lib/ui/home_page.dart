import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:gifs_bill/ui/gif_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   String? _search;
   int _offset = 0;

  Future<Map> _getGifs() async{
    http.Response response;

    var urlTrend = "https://api.giphy.com/v1/gifs/trending?api_key=CaIDLIMCYMOQcSmwYV8rbIwgJfBlkncu&limit=20&rating=g";
    var urlSearch = "https://api.giphy.com/v1/gifs/search?api_key=CaIDLIMCYMOQcSmwYV8rbIwgJfBlkncu&q=$_search&limit=19&offset=$_offset&rating=g&lang=en";

    if(_search == null) 
      response = await http.get(Uri.parse(urlTrend));
    else
      response = await http.get(Uri.parse(urlSearch));

    return json.decode(response.body);
  }


  @override
  void initState() {
    super.initState();

    _getGifs().then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children:  [
           Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
              decoration: InputDecoration(
                labelText: "Pesquise aqui",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder()
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              child: FutureBuilder(
                  future: _getGifs(),
                  builder: (context,snapshot) {
                    switch(snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          width: 200.0,
                          height: 200.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5.0,
                          ),
                        );
                      default:
                        if(snapshot.hasError) return Container();
                        else return _createGifTable(context, snapshot);
                    }

                  }
              ),
          ),
        ],
      ),
    );
  }

  int _gifCount(List data) {
    if(_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0
        ),
      itemCount: _gifCount(snapshot.data["data"]),
      itemBuilder: (context,index) {
          if(_search == null || index < snapshot.data["data"].length)
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                height: 300.0,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(context, 
                MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index]))
                );
              },
              onLongPress: () {
                FlutterShare.share(title:snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
            );
          else
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 70.0,),
                    Text("Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 22.0),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            );
      },
    );
  }
}
