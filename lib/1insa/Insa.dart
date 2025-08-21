import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_husky/1insa/Address.dart';
import 'package:team_husky/1insa/InsaCard.dart';
import 'package:team_husky/1insa/teamcard.dart';
import 'package:url_launcher/url_launcher.dart';


class Organization extends StatefulWidget {
  const Organization({super.key, required this.grade});

  final int grade;

  @override
  State<Organization> createState() => _OrganizationState();
}

class _OrganizationState extends State<Organization> {
  String teamId = ''; //팀 클릭시 그 팀 고유문서 아이디값
  String name = ''; // 팀 이름
  String mansID = ''; // 팀원문서아이디
  String formattedDate = '';
  String? picUrl = '';

  void _launchWebsite(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication); // 외부 브라우저로 열기
    } else {
      throw 'Could not launch $url';
    }
  }


  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(INSA)
            .orderBy('createdAt')
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
              itemCount: docs.length,
              itemBuilder: (context, index) {
                // 등급이 0이고, 문서 ID가 특정 ID일 경우 해당 아이템은 보여주지 않음
                if (widget.grade == 0 &&
                    docs[index].id == '3LDEwvJicNKtzDemmHY6') {
                  return SizedBox.shrink(); // 빈 공간을 반환하여 해당 아이템을 숨김
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {

                           final schedule = docs[index]['schedule'];

                            if (schedule != null && schedule.toString().trim().isNotEmpty) {
                            final siteUrl = schedule.toString();
                            _launchWebsite(siteUrl);
                            } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('사이트 주소가 없습니다')),
                            );
                            }








                            // teamId = docs[index].id;
                            // print(teamId);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => SchedulePage(
                            //       teamId: teamId,
                            //     ),
                            //   ),
                            // );
                          },
                          child: BuildingCard(
                            image: Image.asset(docs[index]['image']),
                            name: docs[index]['name'],
                            position: docs[index]['position'],
                          ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(INSA)
                              .doc(docs[index].id)
                              .collection('list')
                              .orderBy('levelNumber')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            final docs = snapshot.data!.docs.where((subDoc) {
                              // levelNumber 필드 값 확인 (필드가 없으면 기본값 0)
                              final data = subDoc.data();
                              final levelNumber = data['levelNumber'] ?? 0;
                              return levelNumber !=
                                  0; // levelNumber가 0이 아닌 문서만 포함
                            }).toList();

                            // 바뀐 부분: ListView 대신 Column을 사용하여 하위 컬렉션의 데이터를 표시
                            return Column(
                              children: docs.map((subDoc) {
                                var data =
                                    subDoc.data() ?? {}; // 데이터가 널인 경우 빈 맵 사용
                                return GestureDetector(
                                  onTap: () async {
                                    var document = subDoc;
                                    mansID = document.id;
                                    Map<String, dynamic> userData =
                                        await getData(mansID);
                                    Timestamp timestamp = userData['enterDay'];
                                    DateTime dateTime = timestamp.toDate();
                                    formattedDate =
                                        DateFormat('yy/MM/dd').format(dateTime);
                                    picUrl = userData['picUrl'];

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {

                                        return viewInsa(
                                          userData,
                                          formattedDate,
                                          picUrl!,
                                        );
                                      },
                                    );
                                  },
                                  child: OrganizationCard(
                                    image: data['image'] != null
                                        ? Image.asset(data['image'])
                                        : Icon(Icons.image_outlined),
                                    name: data['name'] ?? '',
                                    // 이름이 널인 경우 빈 문자열 사용
                                    grade: data['grade'] ?? '',
                                    // 포지션이 널인 경우 빈 문자열 사용
                                    position: data['position'] ?? '',
                                    picUrl: data['picUrl'] ?? '',
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }

  Widget viewInsa(
      Map<String, dynamic> data,
      String formattedDate,
      String picUrl,
      ) {
    return AlertDialog(
      backgroundColor: Colors.white, // 전체 배경색을 기본 흰색으로 설정
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // 모서리 둥글게
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 브라운 색 배경 영역
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.brown.shade800, // 진한 브라운
                  Colors.brown.shade200, // 연한 브라운
                ],
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Text(
                  '(주)팀허스키',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: picUrl.isNotEmpty
                      ? () {
                    _showFullImage(context, picUrl);
                  }
                      : null, // 이미지 URL이 없으면 클릭 비활성화
                  child: CircleAvatar(
                    backgroundImage: picUrl != null && picUrl.isNotEmpty
                        ? NetworkImage(picUrl)
                        : AssetImage('asset/img/husky_Logo.png') as ImageProvider,
                    radius: 50,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  data['name'] ?? '이름 없음',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  data['birthDay'] ?? '생일 정보 없음',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // 흰색 배경 영역
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _infoRow('연락처', data['phoneNumber'])),
                      IconButton(
                        icon: Icon(Icons.phone, color: Colors.green),
                        onPressed: () {
                          _makePhoneCall('01012345678');
                        },
                      ),
                    ],
                  ),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  _infoRow('등록일', formattedDate),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _infoRow('상의', data['tShirtSize'])),
                      SizedBox(width: 16),
                      Expanded(child: _infoRow('하의', data['pantsSize'])),
                    ],
                  ),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _infoRow('신발', data['footSize'])),
                      SizedBox(width: 16),
                      Expanded(child: _infoRow('키', '${data['cm']} cm')),
                    ],
                  ),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  _infoRow('몸무게', '${data['kg']} kg'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
            color: Colors.black87,
          ),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            value ?? '정보 없음',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullImageView(imageUrl: imageUrl),
      ),
    );
  }

}

//선택한 직원 신상 불러오기
Future<Map<String, dynamic>> getData(String documentId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('user')
            .doc(documentId)
            .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data()!;
      if (data != null) {
        return data;
      } else {
        print('문서 데이터가 null입니다.');
        // 데이터가 null인 경우에 대한 처리를 추가합니다.
      }
    } else {
      print('문서가 존재하지 않습니다.');
      // 문서가 존재하지 않는 경우에 대한 처리를 추가합니다.
    }
  } catch (e) {
    print('데이터를 가져오는 중에 오류가 발생했습니다: $e');
    // 오류가 발생한 경우에 대한 처리를 추가합니다.
  }

  // 모든 분기에서 return 문을 추가하여 반환 유형이 Future<Map<String, dynamic>>을 만족시킵니다.
  return {};
}


class FullImageView extends StatelessWidget {
  final String imageUrl;

  FullImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Hero(
            tag: 'fullImage',
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}