import 'package:flutter/material.dart';
import 'package:vokast/components/fab_icon.dart';

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
          const SizedBox(height: 25),
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
          const SizedBox(height: 25),
          Container(
            width: double.infinity,
            height: 265,
            margin: const EdgeInsets.only(left: 18),
            child: FutureBuilder(
                future: DBDownloadService.fetchLocalDB(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<RadioModel>> radios) {
                  if (radios.hasData) {
                    return Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: radios.data!.length,
                            itemBuilder: (context, index) {
                              final radio = radios.data![index];
                              return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: StationCard(radio: radio));
                            }));
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          )
        ],
      ),
    ));
  }
}
