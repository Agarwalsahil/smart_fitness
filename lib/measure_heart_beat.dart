import 'package:flutter/material.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<double> data1 = [];
  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];
  //  Widget chart = BPMChart(data);

  bool isBPMEnabled = false;
  Widget? dialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Heart BPM'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            isBPMEnabled
                ? dialog = HeartBPMDialog(
                    context: context,
                    showTextValues: true,
                    borderRadius: 10,
                    onRawData: (value) {
                      setState(() {
                        if (data.length >= 100) data.removeAt(0);
                        double tmp = value.value.toDouble();
                        if (tmp >= 90 || tmp <= 70) tmp = 70;
                        data1.add(tmp);
                        data.add(value);
                      });
                      // chart = BPMChart(data);
                    },
                    onBPM: (value) => setState(() {
                      if (bpmValues.length >= 100) bpmValues.removeAt(0);
                      double tmp = value.toDouble();
                      if (tmp >= 90 || tmp <= 70) tmp = 70;
                      bpmValues
                          .add(SensorValue(value: tmp, time: DateTime.now()));
                    }),
                    // sampleDelay: 1000 ~/ 20,
                    // child: Container(
                    //   height: 50,
                    //   width: 100,
                    //   child: BPMChart(data),
                    // ),
                  )
                : const SizedBox(),
            isBPMEnabled && data.isNotEmpty
                ? Container(
                    decoration: BoxDecoration(border: Border.all()),
                    height: 180,
                    child: BPMChart(data),
                  )
                : const SizedBox(),
            isBPMEnabled && bpmValues.isNotEmpty
                ? Container(
                    decoration: BoxDecoration(border: Border.all()),
                    constraints: const BoxConstraints.expand(height: 180),
                    child: BPMChart(bpmValues),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.favorite_rounded),
                  label:
                      Text(isBPMEnabled ? "Stop measurement" : "Measure BPM"),
                  onPressed: () => setState(() {
                    if (isBPMEnabled) {
                      isBPMEnabled = false;
                      // dialog.
                    } else {
                      isBPMEnabled = true;
                    }
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
