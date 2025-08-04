import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_husky/2car_management_system/team2/team2_adress_const.dart';
import 'package:team_husky/2car_management_system/team2/team2_electric_card.dart';

class Electric extends StatefulWidget {
  const Electric({super.key});

  @override
  State<Electric> createState() => _ElectricState();
}

class _ElectricState extends State<Electric> {
  DateTime selectedDate = DateTime.now();
  String DBAdress = elecToDate();

  void _previousDay() {
    final goToOneMonthAgo = DateTime(
      selectedDate.year,
      selectedDate.month - 1,
      selectedDate.day,
    );
    final year = goToOneMonthAgo.year.toString();
    final month = goToOneMonthAgo.month.toString().padLeft(2, '0');

    setState(() {
      selectedDate = goToOneMonthAgo;
      DBAdress = year + month;
    });
  }

  //다음날로 이동
  void _nextDay() {
    final today = DateTime.now();
    final nextMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      selectedDate.day,
    );
    final year = nextMonth.year.toString();
    final month = nextMonth.month.toString().padLeft(2, '0');

    setState(() {
      if (nextMonth.isBefore(today)) {
        setState(() {
          selectedDate = nextMonth;
          DBAdress = year + month;
        });
      }
    });
  }


  // 텍스트 만드는 함수 추가
  Future<String> createClipboardText2(String address) async {
    final query = await FirebaseFirestore.instance
        .collection(ELECTRICLIST + address)
        .orderBy('enter')
        .get();

    final count = query.docs.length;

    String year = address.substring(0, 4); // '2025'
    String month = address.substring(4, 6); // '08'

    final buffer = StringBuffer();
    buffer.writeln('$year년 $month월 전기차 충전리스트');
    buffer.writeln('-------------------총 $count대');



    for (int i = 0; i < count; i++) {


      String _getLocationText(int location) {
        switch (location) {
          case 1:
            return '차량내';
          case 2:
            return '거점내';
          case 3:
            return '기타';
          default:
            return '-';
        }
      }
      final doc = query.docs[i];
      final theDay = doc['theDay'];
      final chargeNumber = doc['chargeNumber'];
      final carModel = doc['carModel'];
      final etc = doc['etc'];
      final enter = getInTime(doc['enter']);
      final out = doc['out'] is Timestamp
          ? getOutTime((doc['out'] as Timestamp).toDate())
          : '---';
      final ex = doc['selectedLocation'];
      final selectedLocation = _getLocationText(ex);


      buffer.writeln('$theDay $chargeNumber번 $carModel $enter $out $selectedLocation');

    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '전기차 충전관리',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () async {
              final text = await createClipboardText2(DBAdress);
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('텍스트가 복사되었습니다!')),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _DateControl(
              onPressLeft: _previousDay,
              onPressRight: _nextDay,
              selectedDate: selectedDate,
            ),
            _ListState(),
            ListModel(
              adress: DBAdress,
            ),
          ],
        ),
      ),
    );
  }
}

class _DateControl extends StatelessWidget {
  final VoidCallback onPressLeft;
  final VoidCallback onPressRight;
  final DateTime selectedDate;

  const _DateControl(
      {super.key,
      required this.onPressLeft,
      required this.onPressRight,
      required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.chevron_left_outlined,
            color: Colors.white,
          ),
          onPressed: onPressLeft,
        ),
        Text(
          "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2, '0')}",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),

        SizedBox(
          width: 2,
        ),
        Text(
          '월',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        IconButton(
          icon: Icon(
            Icons.chevron_right_outlined,
            color: Colors.white,
          ),
          onPressed: onPressRight,
        ),
        SizedBox(
          width: 20,
        ),

      ],
    );
  }
}

class _ListState extends StatelessWidget {
  const _ListState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        height: 40,
        color: Colors.grey.shade800,
        child: Row(
          children: [
            _buildHeaderCell(width: 40, label: '날짜'),
            _buildHeaderCell(width: 70, label: '충전기'),
            _buildHeaderCell(width: 60, label: '차종'),
            _buildHeaderCell(width: 60, label: '충전시각'),
            _buildHeaderCell(width: 60, label: '완료시각'),
            _buildHeaderCell(width: 60, label: '체류장소'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell({required double width, required String label}) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ListModel extends StatelessWidget {
  final String adress;
  String dataId = '';
  String carModel = '';
  String enterTime = '';
  String enterName = '';
  DateTime? outTime;
  String theDay = '';
  String outLocation = '';
  String movedLocation = '';
  String wigetName = '';
  String movingTime = '';

  ListModel({super.key, required this.adress});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(ELECTRICLIST + adress)
          .orderBy('enter')
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final docs = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: () async {
                  var document = docs[index];
                  print(document.id);
                  dataId = document.id;
                  carModel = docs[index]['carModel'];
                  Timestamp sam = docs[index]['enter']; //입차시각
                  enterTime = getInTime(sam); //입차시각 변환코드
                  print(enterTime);
                  theDay = docs[index]['theDay'];
                  //
                  // outTime = docs[index]['out'] is Timestamp
                  //     ? (docs[index]['out'] as Timestamp).toDate()
                  //     : null;
                  //
                  // String outname = docs[index]['outName']; //출차한사람 이름
                  // if (outname == null) {
                  //   outName = '';
                  // } else {
                  //   outName = outname;
                  // }
                  // int location = docs[index]['outLocation']; //출차한위치 이름
                  // outLocation = checkOutLocation(location);
                  //
                  // movedLocation = docs[index]['movedLocation']; //출차한위치 이름
                  // movingTime = docs[index]['movingTime']; //출차한위치 이름
                  // wigetName = docs[index]['wigetName']; //출차한위치 이름
                  //
                  CarInfoDialog(
                    context,
                    dataId,
                    carModel,
                    adress,
                    enterTime,
                      theDay,
                  );


                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: ElectricCard(
                    theDay: docs[index]['theDay'],
                    chargeNumber: docs[index]['chargeNumber'],
                    outTime: docs[index]['out'] is Timestamp
                        ? (docs[index]['out'] as Timestamp).toDate()
                        : null,

                    inTime: docs[index]['enter'],
                    carModel: docs[index]['carModel'],
                    selectedLocation: docs[index]['selectedLocation'],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void CarInfoDialog(
      BuildContext context,
      String id,
      String carNumber,
      String adress,
      String enterTime,
      String theDay,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(maxHeight: 260),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 차량 번호 및 삭제 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$theDay',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '차종: $carModel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 첫 번째 다이얼로그 닫기

                        // 삭제 확인 다이얼로그
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title: Text("삭제 확인"),
                              content: Text("정말로 삭제하시겠습니까?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("취소"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection(ELECTRICLIST + adress)
                                          .doc(id)
                                          .delete();

                                      Navigator.of(context).pop(); // AlertDialog 닫기
                                      print('삭제 완료');
                                    } catch (e) {
                                      print('삭제 오류: $e');
                                    }
                                  },
                                  child: Text(
                                    "삭제",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        '삭제',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),


                // ✅ 충전완료 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async{
                      // 여기에 충전 완료 로직 추가 가능
                      Navigator.of(context).pop(); // 다이얼로그 닫기
                      FixTime(
                        context,
                        dataId,
                        carModel,
                        adress,
                          enterTime,

                      );



                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      '(완료시간수정)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async{
                      // 여기에 충전 완료 로직 추가 가능

                      try {
                        await FirebaseFirestore.instance
                            .collection(ELECTRICLIST + adress)
                            .doc(id)
                            .update({
                          'out': FieldValue.serverTimestamp(),
                        });
                      } catch (e) {
                        print(e);
                      }
                      Navigator.of(context).pop(); // 다이얼로그 닫기


                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      '충전완료',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void FixTime(
      BuildContext context,
      String id,
      String carNumber,
      String adress,
      String enterTime,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(maxHeight: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 차량 번호 및 삭제 버튼
                Center(
                  child: Text(
                    '차종: $carModel',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 16),


                // ✅ 충전완료 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async{
                      // 여기에 충전 완료 로직 추가 가능

                      try {
                        await FirebaseFirestore.instance
                            .collection(ELECTRICLIST + adress)
                            .doc(id)
                            .update({
                          'out':convertStringTimeToTimestamp(enterTime,addMinutes: 10),
                        });
                      } catch (e) {
                        print(e);
                      }
                      Navigator.of(context).pop(); // 다이얼로그 닫기



                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      '충전시작부터 10분뒤',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async{
                      // 여기에 충전 완료 로직 추가 가능

                      try {
                        await FirebaseFirestore.instance
                            .collection(ELECTRICLIST + adress)
                            .doc(id)
                            .update({
                          'out':convertStringTimeToTimestamp(enterTime,addMinutes:15),
                        });
                      } catch (e) {
                        print(e);
                      }
                      Navigator.of(context).pop(); // 다이얼로그 닫기


                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      '충전시작부터 15분뒤',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async{
                      // 여기에 충전 완료 로직 추가 가능

                      try {
                        await FirebaseFirestore.instance
                            .collection(ELECTRICLIST + adress)
                            .doc(id)
                            .update({
                          'out':convertStringTimeToTimestamp(enterTime,addMinutes:20),
                        });
                      } catch (e) {
                        print(e);
                      }
                      Navigator.of(context).pop(); // 다이얼로그 닫기


                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      '충전시작부터 20분뒤',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async{
                      // 여기에 충전 완료 로직 추가 가능

                      try {
                        await FirebaseFirestore.instance
                            .collection(ELECTRICLIST + adress)
                            .doc(id)
                            .update({
                          'out':convertStringTimeToTimestamp(enterTime,addMinutes:25),
                        });
                      } catch (e) {
                        print(e);
                      }
                      Navigator.of(context).pop(); // 다이얼로그 닫기


                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      '충전시작부터 25분뒤',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}