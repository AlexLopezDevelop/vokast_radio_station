import 'package:flutter/material.dart';
import 'package:vokast/models/radio.dart';
import 'package:vokast/pages/player.dart';
import 'package:vokast/services/db_download_service.dart';

class HomePageOLD extends StatelessWidget {
  const HomePageOLD({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('Vokast', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: const [
            Expanded(flex: 3, child: StationList()),
            Expanded(flex: 2, child: HorizontalList()),
          ],
        ));
  }
}

class StationList extends StatefulWidget {
  const StationList({super.key});

  @override
  _StationListState createState() => _StationListState();
}

class _StationListState extends State<StationList>
    with SingleTickerProviderStateMixin {
  bool selectedMode = false;
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      lowerBound: 0.15,
      upperBound: 0.5,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return AnimatedBuilder(
            animation: animationController,
              builder: (context, child) {
              final selectedValue = animationController.value;
                return GestureDetector(
                  onTap: () {
                    if (!selectedMode) {
                      animationController.forward();
                      setState(() {
                        selectedMode = true;
                      });
                    } else {
                      animationController.reverse();
                      setState(() {
                        selectedMode = false;
                      });
                    }
                  },
                  child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(selectedValue),
                      child: AbsorbPointer(
                        absorbing: !selectedMode,
                        child: Container(
                          height: constrains.maxHeight,
                          width: constrains.maxWidth * 0.45,
                          color: Colors.white,
                          child: FutureBuilder(
                              future: DBDownloadService.fetchTopRadios(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<RadioModel>> radios) {
                                print(radios.data);
                                if (radios.hasData) {
                                  return Stack(
                                    children: List.generate(
                                        radios.data!.length,
                                            (index) => StationItem(
                                          height: constrains.maxHeight / 2,
                                          radio: radios.data![index],
                                          percent: selectedValue,
                                          depth: index,
                                        )).reversed.toList(),
                                  );
                                }
                                return const Center(child: CircularProgressIndicator());
                              }),
                  )),
            ));
          });
    });
  }
}

class HorizontalList extends StatelessWidget {
  const HorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.all(12), child: Text('All Stations')), FutureBuilder(
              future: DBDownloadService.fetchRadios(),
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
      ],
    );
  }
}

class StationCard extends StatelessWidget {
  const StationCard({super.key, required this.radio});

  final RadioModel radio;

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(15);
    return InkWell(onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Player(radioModel: radio,)));
    },
    child: PhysicalModel(
        elevation: 10,
        color: Colors.white,
        borderRadius: border,
        child: ClipRRect(
          borderRadius: border,
          child: Image.network(
            radio.image,
            fit: BoxFit.cover,
          ),
        )));
  }
}

class StationItem extends StatelessWidget {
  const StationItem(
      {super.key,
      required this.height,
      required this.radio,
      required this.percent,
      required this.depth});

  final RadioModel radio;
  final double height;
  final double percent;
  final int depth;

  @override
  Widget build(BuildContext context) {
    const depthFactor = 50.0;

    return Positioned(
        top: height + -depth * height / 2.0 * percent - (height / 4.0),
        left: 0,
        right: 0,
        child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..translate(0.0, 0.0, depth * depthFactor),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Player(radioModel: radio)));
              },
              child: SizedBox(height: height, child: StationCard(radio: radio)),
            )));
  }
}
