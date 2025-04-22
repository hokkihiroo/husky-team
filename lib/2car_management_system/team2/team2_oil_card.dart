import 'package:flutter/material.dart';

class OilCard extends StatelessWidget {
  final String oilCount;
  final String name;
  final String carNumber;

  const OilCard({
    super.key,
    required this.oilCount,
    required this.name, required this.carNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: Colors.black,
      child: Row(
        children: [

          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    carNumber,
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$oilCount km',
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
