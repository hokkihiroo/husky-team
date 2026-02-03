import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team2/team2-2/team2_4_2_stateList_card.dart';
import 'package:team_husky/2car_management_system/team2/team2_adress_const.dart';

class StateList extends StatefulWidget {
  final String dataId;

  const StateList({super.key, required this.dataId});

  @override
  State<StateList> createState() => _StateListState();
}

class _StateListState extends State<StateList> {
  DateTime selectedDate = DateTime.now();
  String DBAdress = carStateAddress();


  void _previousDay() {
    print(DBAdress);
    print(widget.dataId);
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

  //다음달로 이동
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '시승차 상태 관리',
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
              // final text = await createClipboardText2(DBAdress);
              // Clipboard.setData(ClipboardData(text: text));
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text('텍스트가 복사되었습니다!')),
              // );
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
              mainDataId: widget.dataId,
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
            SizedBox(
              width: 20,
            ),
            _buildHeaderCell(width: 40, label: '날짜'),
            SizedBox(width: 20,),
            _buildHeaderCell(width: 40, label: '시각'),
            SizedBox(width: 40,),
            _buildHeaderCell(width: 50, label: '상태일지'),
            SizedBox(width: 50,),
            _buildHeaderCell(width: 50, label: '시승방법'),
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
  final String mainDataId;

  String smallDataId = '';
  String prepareName = '';
  String finishdName = '';
  String wayToDrive2 = '';
  String carModel = '';
  String enterTime = '';
  String enterName = '';
  DateTime? outTime;
  String theDay = '';
  String wigetName = '';
  int? hiPassBefore =0;
  int? leftGasBefore =0;
  int? totalKmBefore =0;
  int? hiPassAfter =0;
  int? leftGasAfter =0;
  int? totalKmAfter =0;
  int? oilPriceValue =0;

  ListModel({super.key, required this.adress, required this.mainDataId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(STATELIST)
          .doc(mainDataId)           // 123
          .collection(adress)
          .orderBy('createdAt', descending: true)
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
            // ✅ 여기다 넣어
            final Timestamp ts = docs[index]['createdAt'];
            final DateTime dateTime = ts.toDate();

            final String theDay =
                '${dateTime.month}월${dateTime.day}일';

            final String theTime =
                '${dateTime.hour.toString().padLeft(2, '0')}시'
                '${dateTime.minute.toString().padLeft(2, '0')}분';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: () async {

                  var document = docs[index];
                  smallDataId=document.id;
                  hiPassBefore = int.tryParse(docs[index]['hiPassBefore'].toString()) ??
                      0; //하이패스 잔액
                  leftGasBefore = int.tryParse(docs[index]['leftGasBefore'].toString()) ??
                      0; //주유잔량
                  totalKmBefore = int.tryParse(docs[index]['totalKmBefore'].toString()) ??
                      0; //총킬로수
                  hiPassAfter =
                      int.tryParse(docs[index]['hiPassAfter'].toString()) ??
                          0; //하이패스 잔액
                  leftGasAfter =
                      int.tryParse(docs[index]['leftGasAfter'].toString()) ??
                          0; //주유잔량
                  totalKmAfter =
                      int.tryParse(docs[index]['totalKmAfter'].toString()) ??
                          0; //총킬로수

                  oilPriceValue =
                      int.tryParse(docs[index]['oilPriceValue'].toString()) ??
                          0; //총킬로수

                  prepareName = document['prepareName']?.toString() ?? '';
                  finishdName = document['finishdName']?.toString() ?? '';
                  wayToDrive2 = document['wayToDrive2']?.toString() ?? '';

                  showCarInfoBottomSheet2(
                    context,
                    smallDataId,
                    leftGasBefore,
                    hiPassBefore,
                    totalKmBefore,
                    leftGasAfter,
                    hiPassAfter,
                    totalKmAfter,
                      prepareName,
                      finishdName,
                      oilPriceValue,
                      wayToDrive2,

                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: StateListCard(
                    theDay: theDay,
                    theTime: theTime,
                    state: docs[index]['state'],
                    wayToDrive: docs[index]['wayToDrive'],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

void showCarInfoBottomSheet2(
    context,
    id,
    leftGasBefore,
    hiPassBefore,
    totalKmBefore,
    leftGasAfter,
    hiPassAfter,
    totalKmAfter,
    prepareName,
    finishdName,
    oilPriceValue,
    wayToDrive2,
    ) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [

                const SizedBox(height: 5),

                /// =====================
                /// ⛽ 주유 / 거리 카드
                /// =====================
                _card(
                  child: Column(
                    children: [
                      _rowHeader(['상태', '주유잔량', '하이패스', '총거리']),
                      const SizedBox(height: 5),
                      _rowValue([
                        '시승전',
                        formatKm(leftGasBefore),
                        formatWon(hiPassBefore),
                        formatKm(totalKmBefore),
                      ]),
                      const SizedBox(height: 5),
                      _rowValue([
                        '시승후',
                        formatKm(leftGasAfter),
                        formatWon(hiPassAfter),
                        formatKm(totalKmAfter),
                      ]),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                /// =====================
                /// 👤 시승상태 카드 (변경됨)
                /// =====================
                _card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12), // ⭐ 핵심
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _cell('시승준비 :', align: TextAlign.right),
                        ),
                        Expanded(
                          flex: 4,
                          child: _cell(prepareName),
                        ),
                        Expanded(
                          flex: 3,
                          child: _cell('시승복귀 :', align: TextAlign.right),
                        ),
                        Expanded(
                          flex: 4,
                          child: _cell(finishdName),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 5),
                _card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12), // ⭐ 핵심
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _cell('주유금액 :', align: TextAlign.right),
                        ),
                        Expanded(
                          flex: 4,
                          child: _cell(formatWon(oilPriceValue)),
                        ),
                        Expanded(
                          flex: 3,
                          child: _cell('시승상태 :', align: TextAlign.right),
                        ),
                        Expanded(
                          flex: 4,
                          child: _cell(wayToDrive2),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _cell(String text, {TextAlign align = TextAlign.center}) {
  return Text(
    text,
    textAlign: align,
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget _rowHeader(List<String> texts) {
  return Row(
    children: texts
        .map(
          (t) => Expanded(
        child: _cell(
          t,
          align: TextAlign.center,
        ),
      ),
    )
        .toList(),
  );
}

Widget _rowValue(List<String> texts) {
  return Row(
    children: texts
        .map(
          (t) => Expanded(
        child: _cell(t),
      ),
    )
        .toList(),
  );
}

Widget _card({required Widget child}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 12,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}