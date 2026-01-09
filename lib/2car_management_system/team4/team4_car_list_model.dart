import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:team_husky/2car_management_system/team4/team4_adress.dart';
import 'package:team_husky/2car_management_system/team4/team4_carlist_card.dart';

class Team4CarListModel extends StatefulWidget {
  final String adress;

  const Team4CarListModel({super.key, required this.adress});

  @override
  State<Team4CarListModel> createState() => _Team4CarListModelState();
}

class _Team4CarListModelState extends State<Team4CarListModel> {
  String dataId = '';
  String carNumber = '';
  String enterTime = '';
  String enterName = '';
  String selfParking = '';
  String etc = '';
  DateTime? outTime;
  String outName = '';
  String outLocation = '';
  String movedLocation = '';
  String movingTime = '';
  late TextEditingController etcController;

  /////////////////특이사항수정 //////////////
  @override
  void initState() {
    super.initState();
    etcController = TextEditingController(text: etc ?? '');
  }

  @override
  void dispose() {
    etcController.dispose(); // ⭐ 필수
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(TEAM4CARLIST + widget.adress)
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
                  carNumber = docs[index]['carNumber'];
                  Timestamp sam = docs[index]['enter']; //입차시각
                  enterTime = Team4getInTime(sam); //입차시각 변환코드
                  enterName = docs[index]['wigetName']; //입차한사람 이름
                  selfParking = docs[index]
                      ['enterName']; // 자가주차하면 enterName으로 들어간데이터가 여기에 저장됨
                  etc = docs[index]['etc']; //특이사항

                  outTime = docs[index]['out'] is Timestamp
                      ? (docs[index]['out'] as Timestamp).toDate()
                      : null;

                  String outname = docs[index]['outName']; //출차한사람 이름
                  if (outname == null) {
                    outName = '';
                  } else {
                    outName = outname;
                  }
                  int location = docs[index]['outLocation']; //출차한위치 이름
                  outLocation = checkOutLocation(location);

                  movedLocation = docs[index]['movedLocation']; //출차한위치 이름
                  movingTime =
                      docs[index]['movingTime']; //변수는 시각으로 되어있는데 자가주차가들어감

                  showCarInfoBottomSheet(
                    context,
                    dataId,
                    carNumber,
                    enterTime,
                    enterName,
                    etc,
                    outName,
                    outTime,
                    outLocation,
                    movedLocation,
                    movingTime,
                    widget.adress,
                    selfParking,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Team4CarListCard(
                    index: index + 1,
                    carNum: docs[index]['carNumber'],
                    inTime: docs[index]['enter'],
                    outTime: docs[index]['out'] is Timestamp
                        ? (docs[index]['out'] as Timestamp).toDate()
                        : null,
                    carBrand: docs[index]['carBrand'],
                    carModel: docs[index]['carModel'],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showCarInfoBottomSheet(
    context,
    id,
    carNumber,
    enterTime,
    enterName,
    etc,
    outName,
    outTime,
    outLocation,
    movedLocation,
    movingTime,
    adress,
    selfParking,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '차번호:$carNumber',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // 다이얼로그 닫기

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("삭제 확인"),
                                content: Text("정말로 삭제하시겠습니까?"),
                                actions: [
                                  TextButton(
                                    child: Text("취소"),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // 다이얼로그 닫기
                                    },
                                  ),
                                  TextButton(
                                    child: Text("삭제"),
                                    onPressed: () async {
                                      try {
                                        // 삭제할 문서의 참조를 가져와
                                        await FirebaseFirestore.instance
                                            .collection(TEAM4CARLIST +
                                                adress) // 예: 'users'
                                            .doc(id) // 예: 'abc123'
                                            .delete();

                                        Navigator.of(context).pop(); // 다이얼로그 닫기
                                        print('삭제 확인됨');
                                        // 여기에 삭제 완료 후 처리 추가 (예: 스낵바 등)
                                      } catch (e) {
                                        print('삭제 중 오류 발생: $e');
                                        // 오류 처리 로직 추가 가능
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: TextButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          backgroundColor: Colors.red.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          '삭제',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.red, // 삭제는 빨간색이 직관적
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    // 여기에 다이얼로그의 내용을 추가할 수 있습니다.
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '입차',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            Text('시각 : $enterTime분'),
                            SizedBox(
                              width: 10,
                            ),
                            Text('이름 : $enterName'),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '출차',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                                '시각 : ${outTime != null ? Team4getOutTime(outTime!) : ''}'),
                            SizedBox(
                              width: 10,
                            ),

                            Text('위치 : ${outLocation ?? ''}'),

                            const Spacer(), // 🔥 이게 핵심

                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 다이얼로그 닫기

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      title: const Text(
                                        '출차 시간 수정',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: const Text(
                                        '출차시간 수정방식 선택하세요',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      actionsPadding: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 16),
                                      actions: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                label: const Text('현재시각'),
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      Colors.blue.shade50,
                                                  foregroundColor:
                                                      Colors.blue.shade800,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 14),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  Navigator.pop(context);

                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(TEAM4CARLIST +
                                                          widget.adress)
                                                      .doc(id)
                                                      .update({
                                                    'out': Timestamp.fromDate(
                                                        DateTime.now()),
                                                  });
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                label: const Text('설정하기'),
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      Colors.green.shade50,
                                                  foregroundColor:
                                                      Colors.green.shade800,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 14),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  Navigator.pop(context);

                                                  TimeOfDay? selectedTime =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                  );

                                                  if (selectedTime != null) {
                                                    int year = int.parse(widget
                                                        .adress
                                                        .substring(0, 4));
                                                    int month = int.parse(widget
                                                        .adress
                                                        .substring(4, 6));
                                                    int day = int.parse(widget
                                                        .adress
                                                        .substring(6, 8));

                                                    DateTime newOutTime =
                                                        DateTime(
                                                      year,
                                                      month,
                                                      day,
                                                      selectedTime.hour,
                                                      selectedTime.minute,
                                                    );

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            TEAM4CARLIST +
                                                                widget.adress)
                                                        .doc(id)
                                                        .update({
                                                      'out': Timestamp.fromDate(
                                                          newOutTime),
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                label: const Text('취소'),
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      Colors.red.shade50,
                                                  foregroundColor:
                                                      Colors.red.shade800,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 14),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                backgroundColor: Colors.blue.withAlpha(26),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                '출차시각수정',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black, // 삭제는 빨간색이 직관적
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              '특이사항',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              selfParking,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.blue),
                            ),

                            const Spacer(), // 🔥 이게 핵심

                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);

                                // 기존 특이사항을 컨트롤러에 세팅
                                etcController.text = etc;

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('특이사항 수정'),
                                      content: Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width
                                            .clamp(0, 300),
                                        height: 150,
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: etcController,
                                              maxLength: 20,
                                              decoration: const InputDecoration(
                                                hintText: '특이사항 20자까지 가능',
                                              ),
                                              onChanged: (value) {
                                                etc = value;
                                              },
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);

                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              TEAM4CARLIST +
                                                                  widget.adress)
                                                          .doc(id)
                                                          .update({
                                                        'etc': etc,
                                                      });
                                                    },
                                                    child: const Text('수정'),
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('취소'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                backgroundColor: Colors.blue.withAlpha(26),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                '특이사항수정',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(etc),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
