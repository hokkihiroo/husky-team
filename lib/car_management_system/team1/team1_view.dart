import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Team1View extends StatefulWidget {
  const Team1View({super.key});

  @override
  State<Team1View> createState() => _Team1ViewState();
}

class _Team1ViewState extends State<Team1View> {
  String carNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('차량관리 시스템',
          style: TextStyle(
            color: Colors.white,
          ),),

          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _LocationName(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomOne());
  }

  Widget bottomOne() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        '입차번호',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      actions: [
                        TextField(
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          maxLength: 4,
                          decoration: InputDecoration(
                            hintText: '입차번호를 입력해주세요',
                          ),
                          onChanged: (value) {
                            carNumber = value;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text('입력'),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('취소')),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('입차'),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              onPressed: () {},
              child: Text('입차리스트'),
            ),
          )
        ],
      ),
      color: Colors.black,
    );
  }
}

class _LocationName extends StatelessWidget {
  const _LocationName({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(
              '로터리',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              '외벽',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '광장',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              '문앞',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              '신사',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
