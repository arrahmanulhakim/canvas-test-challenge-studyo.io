import 'package:flutter/material.dart';

import '../models/connection.dart';
import '../painters/connector_line.dart';

class MappedContainerConnection extends StatefulWidget {
  const MappedContainerConnection({Key? key}) : super(key: key);

  @override
  _MappedContainerConnectionState createState() =>
      _MappedContainerConnectionState();
}

class _MappedContainerConnectionState extends State<MappedContainerConnection>
    with TickerProviderStateMixin {
  int? selectedLeft;
  int? selectedRight;
  List<Connection> connections = [];

  Set<int> connectedLeftContainers = {};
  Set<int> connectedRightContainers = {};

  void _handleSelection() {
    if (selectedLeft != null && selectedRight != null) {
      setState(() {
        connections.add(Connection(
          left: selectedLeft!,
          right: selectedRight!,
          vsync: this,
        ));
        connectedLeftContainers.add(selectedLeft!);
        connectedRightContainers.add(selectedRight!);
        selectedLeft = null;
        selectedRight = null;
      });
    }
  }

  void _resetConnections() {
    setState(() {
      connections.clear();
      connectedLeftContainers.clear();
      connectedRightContainers.clear();
      selectedLeft = null;
      selectedRight = null;
    });
  }

  @override
  void dispose() {
    for (var connection in connections) {
      connection.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Studyo.io assignment')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double containerSize = constraints.maxWidth * 0.18;
          double spacing = containerSize * 0.5;

          return Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) => GestureDetector(
                        onTap: () {
                          if (!connectedLeftContainers.contains(index) &&
                              selectedRight == null) {
                            setState(() {
                              selectedLeft = index;
                            });
                          }
                        },
                        child: Container(
                          width: containerSize,
                          height: containerSize,
                          decoration: BoxDecoration(
                            color: selectedLeft == index
                                ? Colors.purple.withOpacity(0.3)
                                : connectedLeftContainers.contains(index)
                                    ? Colors.grey.withOpacity(0.3)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.purple, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) => GestureDetector(
                        onTap: () {
                          if (selectedLeft != null &&
                              !connectedRightContainers.contains(index)) {
                            setState(() {
                              selectedRight = index;
                              _handleSelection();
                            });
                          }
                        },
                        child: Container(
                          width: containerSize,
                          height: containerSize,
                          decoration: BoxDecoration(
                            color: selectedRight == index
                                ? Colors.blue.withOpacity(0.3)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: ConnectorLine(
                      connections: connections,
                      containerSize: containerSize,
                      spacing: spacing,
                      screenWidth: constraints.maxWidth,
                      screenHeight: constraints.maxHeight,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetConnections,
        tooltip: 'Ulangi',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
