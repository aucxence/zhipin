import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:convert';

import 'package:sticky_headers/sticky_headers.dart';

class CountryPage extends StatelessWidget {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  getCountries() async {
    print('-----------------------------');
    dynamic res = await http.get(Uri.parse(
        'https://restcountries.eu/rest/v2/all?fields=name;alpha2Code;alpha3Code;callingCodes'));
    print(res);
    if (res.statusCode == 200) {
      List<dynamic> countries = jsonDecode(res.body);
      countries = countries.map((country) {
        return {
          'name': country['name'],
          'alpha2Code': country['alpha2Code'],
          'alpha3Code': country['alpha3Code'],
          'callingCodes': '+' + country['callingCodes'][0],
          'letter': (country['name'] as String)[0]
        };
      }).toList();

      var result = {};

      countries.forEach((element) {
        if (result[element['letter']] == null) {
          result[element['letter']] = [];
        }
        result[element['letter']].add(element);
      });

      print(result);

      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          'Choisir le pays',
        ),
        backgroundColor: Colours.app_main,
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getCountries(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List letters = snapshot.data.keys.toList();
              var countries = snapshot.data.values.toList();

              return Row(
                children: <Widget>[
                  Expanded(
                      flex: 15,
                      child: ScrollablePositionedList.builder(
                        itemCount: letters.length,
                        itemBuilder: (context, index) {
                          // print(snapshot.data);
                          return StickyHeader(
                            header: Container(
                              height: 30.0,
                              color: Colors.blueGrey[700],
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                letters[index],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                            content: Column(
                              children: <Widget>[
                                ...countries[index].map((country) {
                                  return GestureDetector(
                                    onTap: () =>
                                        Navigator.pop(context, country),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(country['name'],
                                              style: TextStyle(
                                                  color: Colors.blueGrey[700])),
                                          Text(country['callingCodes'],
                                              style: TextStyle(
                                                  color: Colors.blueGrey[700]))
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.black12,
                                                  width: 1))),
                                    ),
                                  );
                                }).toList()
                              ],
                            ),
                          );
                        },
                        itemScrollController: itemScrollController,
                        itemPositionsListener: itemPositionsListener,
                      )),
                  Expanded(
                    flex: 1,
                    child: Container(
                        color: Colors.blueGrey[700],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ...letters.map<Widget>((letter) {
                              return GestureDetector(
                                  onTap: () {
                                    itemScrollController.scrollTo(
                                        index: letters.indexOf(letter),
                                        duration: Duration(seconds: 1),
                                        curve: Curves.easeInOutCubic);
                                  },
                                  child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: Text(
                                        letter,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      )));
                            })
                          ],
                        )),
                  )
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
