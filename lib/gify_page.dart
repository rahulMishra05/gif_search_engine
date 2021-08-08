import 'dart:convert';
import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';

class GifyPage extends StatefulWidget {
  const GifyPage({Key? key}) : super(key: key);

  @override
  _GifyPageState createState() => _GifyPageState();
}

class _GifyPageState extends State<GifyPage> {
  final TextEditingController controller = new TextEditingController();
  // var url = Uri.parse("api.giphy.com/v1/gifs/search?api_key=lx150yET9h7kFsVTx9TBGO0pfRu5jj00&limit=25&offset=0&rating=G&lang=en&q=");
  final url =
      "api.giphy.com/v1/gifs/search?api_key=lx150yET9h7kFsVTx9TBGO0pfRu5jj00&limit=25&offset=0&rating=G&lang=en&q=";
  var data;
  bool showLoading = false;

  getData(String searchInput) async {
    showLoading = true;
    var res = await http.get(Uri.parse(url + searchInput));
    // print(res.body);
    data = jsonDecode(res.body)["data"];
    setState(() {
      showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.gray800,
      body: Column(
        children: <Widget>[
          "GIF Search Engine".text.white.xl4.make().objectCenter(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Search here"),
                ),
              ),
              30.widthBox,
              RaisedButton(
                onPressed: () {
                  getData(controller.text);
                },
                shape: Vx.roundedSm,
                child: Text("Go!"),
              ).h8(context),
            ],
          ).p8(),
          if(showLoading)
            CircularProgressIndicator.centered()
          else
            VxConditional(
              condition: data != null,
              builder: (context) => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedAxisCount(
                  crossAxisCount: context.isMobile ? 2 : 3,
                ),
                itemBuilder: (context, index) {
                  final url =
                      data[index]["image"]["fixed_height"]["url"].toString();
                  return Image.network(
                    url,
                    fit: BoxFit.cover,
                  ).card.roundedSM.make();
                },
                itemCount: data.length,
              ),
              fallback: (context) => "Nothing found !!".text.red600.xl3.make(),
            ).h(context.percentHeight * 70),
          ],
        ).p16(), // VelocityX syntax for adding padding
    );
  }
}
