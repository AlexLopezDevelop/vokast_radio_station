import 'package:flutter/material.dart';
import 'package:vokast/models/station.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

class _StationListState extends State<StationList> with SingleTickerProviderStateMixin {
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
                          child: Stack(
                            children: List.generate(
                                4,
                                    (index) => StationItem(
                                  height: constrains.maxHeight / 2,
                                  station: stationsList[index],
                                  percent: selectedValue,
                                  depth: index,
                                )).reversed.toList(),
                          ),
                        ),
                      )),
                );
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
        const Padding(padding: EdgeInsets.all(12), child: Text('All Stations')),
        Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: stationsList.length,
                itemBuilder: (context, index) {
                  final station = stationsList[index];
                  return Padding(
                      padding: const EdgeInsets.all(10),
                      child: StationCard(station: station));
                })),
      ],
    );
  }
}

class StationCard extends StatelessWidget {
  const StationCard({super.key, required this.station});

  final Station station;

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(15);

    return PhysicalModel(
        elevation: 10,
        color: Colors.white,
        borderRadius: border,
        child: ClipRRect(
          borderRadius: border,
          child: Image.network(
            station.image,
            fit: BoxFit.cover,
          ),
        ));
  }
}

class StationItem extends StatelessWidget {
  const StationItem(
      {super.key,
      required this.height,
      required this.station,
      required this.percent,
      required this.depth});

  final Station station;
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
              print(station.name);
            },
            child: SizedBox(
              height: height,
              child: StationCard(station: station)
            ),
          )
        ));
  }
}
