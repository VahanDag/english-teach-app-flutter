import 'package:flutter/material.dart';
import 'package:teach_app/core/extensions.dart';
import 'package:teach_app/core/paddings_borders.dart';

class GameCard extends StatefulWidget {
  const GameCard({super.key});

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  int _selectedCard = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: context.deviceWidth * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Crocodile"),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 30),
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCard = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: _selectedCard == index ? Colors.green : Colors.transparent,
                            borderRadius: BorderRadiusConstant.borderRadiusMedium,
                            border: Border.all()),
                        child: const Text("data"),
                      ),
                    );
                  },
                ),
              ),
              Container(
                  margin: PaddingConstant.paddingOnlyBottomHigh,
                  width: context.deviceWidth * 0.5,
                  child: ElevatedButton(onPressed: () {}, child: const Text("Confirm")))
            ],
          ),
        ),
      ),
    );
  }
}
