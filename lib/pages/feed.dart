import 'package:flutter/material.dart';
import 'package:vokast/components/fab_icon.dart';
import 'package:vokast/pages/player.dart';

import '../config.dart';
import '../models/radio.dart';
import '../services/db_download_service.dart';
import 'homeOLD.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 25),
          SafeArea(
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                            text: "Feel the music \n",
                            style: TextStyle(fontSize: 17, color: Colors.grey)),
                        TextSpan(
                            text: "By Vokast",
                            style: TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                height: 1.5))
                      ])),
                    ],
                  ))),
          const SizedBox(height: 25),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: const [
                FabIcon(icon: "🇺🇸", title: "USA"),
                FabIcon(icon: "🇬🇧", title: "UK"),
                FabIcon(icon: "🇪🇸", title: "Spain"),
                FabIcon(icon: "🇩🇪", title: "Germany"),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(children: const [
              Text("Recomended",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ]),
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            height: 200,
            margin: const EdgeInsets.only(left: 18),
            child: FutureBuilder(
                future: DBDownloadService.fetchLocalDB(Config.apiUrl),
                builder: (BuildContext context,
                    AsyncSnapshot<List<RadioModel>> radios) {
                  if (radios.hasData) {
                    return Row(children: [
                      Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: radios.data!.length,
                              itemBuilder: (context, index) {
                                final radio = radios.data![index];
                                return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 120,
                                          width: 120,
                                          child: StationCard(radio: radio),
                                        ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          width: 100,
                                          child: Center(
                                              child: Text(radio.name,
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 1,
                                                  softWrap: false,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        ),
                                        const SizedBox(height: 3),
                                        SizedBox(
                                          width: 100,
                                          child: Center(
                                              child: Text(radio.genre,
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 1,
                                                  softWrap: false,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ))),
                                        ),
                                      ],
                                    ));
                              }))
                    ]);
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(children: const [
              Text("All Stations",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ]),
          ),
          FutureBuilder(
              future: DBDownloadService.fetchLocalDB(Config.topRadioUrl),
              builder: (BuildContext context,
                  AsyncSnapshot<List<RadioModel>> radios) {
                if (radios.hasData) {
                  return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      scrollDirection: Axis.vertical,
                            itemCount: radios.data!.length,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              final radio = radios.data![index];
                              return Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Player(radioModel: radio,)));
                                    },
                                    child: Card(
                                elevation: 6,
                                shadowColor: const Color.fromRGBO(255, 255, 255, 0.3),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Container(
                                  width: double.infinity,
                                  height: 120,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            radio.image,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(radio.name,
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                                softWrap: false,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(height: 5),
                                            Text(radio.genre,
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                                softWrap: false,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),)
                              );
                            });
                }
                return const Center(child: CircularProgressIndicator());
              }),
        ],
      ),
    ));
  }
}
