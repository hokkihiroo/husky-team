import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer'as dev;

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _addressController = TextEditingController();

  List<dynamic> addressList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('주소검색')),
      body: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0), // 좌우 여백 12
                  child: TextField(
                    controller: _addressController,
                  ),
                ),
              ),

              ElevatedButton(
                  onPressed: () {
                    //   도로망 주소요청 키
                    //   U01TX0FVVEgyMDI1MDcwNzEzMzcxMTExNTkxODQ=
                    //

                    Map<String, String> paranms = {
                      'confmKey':'U01TX0FVVEgyMDI1MDcwNzEzMzcxMTExNTkxODQ=',
                      'currentPage': '1',
                      'countPerPage': '10',
                      'keyword': _addressController.text,
                      'resultType': 'json',
                    };

                    http
                        .post(
                      Uri.parse(
                          'https://business.juso.go.kr/addrlink/addrLinkApi.do'),
                      body: paranms,
                      headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                      }
                    )
                        .then((response) {
                      print(response.body);
                      try {
                        final data = jsonDecode(response.body);

                        if (data['results']?['juso'] != null) {
                          setState(() {
                            addressList = data['results']['juso'];
                          });
                        } else {
                          dev.log("검색 결과 없음 또는 잘못된 응답");
                          setState(() {
                            addressList = [];
                          });
                        }
                      } catch (e) {
                        dev.log("JSON 파싱 에러: $e");
                        dev.log(response.body);  // 실제 응답 확인
                      }
                    });
                  },
                  child: Text('주소검색')),
            ],
          ),
          Expanded(
            child: ListView.separated(
              itemCount: addressList.length,
              itemBuilder: (context, index) {
                final address = addressList[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      address['roadAddr'] ?? '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (address['jibunAddr'] != null)
                          Text('지번: ${address['jibunAddr']}'),
                        if (address['zipNo'] != null)
                          Text('우편번호: ${address['zipNo']}'),
                      ],
                    ),
                      onTap: () {
                        Navigator.pop(context, address['roadAddr']); // 이 값이 result로 전달됨
                      }
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 4),
            ),
          ),

        ],
      ),
    );
  }
}
