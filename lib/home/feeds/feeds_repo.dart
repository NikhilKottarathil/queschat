import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:queschat/constants/strings_and_urls.dart';
import 'package:queschat/function/api_calls.dart';
import 'package:queschat/home/feeds/quiz/leader_board/leader_board_model.dart';
import 'package:queschat/home/feeds/quiz/quiz_mcq/quiz_mcq_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedRepository {
  Future<String> postMCQWithText(
      {String question,
      List<File> questionImages,
      optionA,
      optionB,
      optionC,
      optionD,
      correctOption,
      String feedLevel}) async {
    print('correctOption $correctOption option A $optionA optionB $optionB');

    if (correctOption != null && correctOption != '') {
      try {
        Map<String, String> myBody = {
          'name': question,
          'feed_type': 'mcq',
          'option_a': optionA,
          'option_b': optionB,
          'option_c': optionC,
          'option_d': optionD,
          'option_type': 'text',
          'answer': correctOption
        };
        print(myBody);

        if (feedLevel != null) {
          myBody.addAll({'feed_level': feedLevel});
        }

        print(myBody);
        var body;

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String token = sharedPreferences.getString('token');
        Map<String, String> headers = {};
        headers['x-access-token'] = token;
        print('in pbobst inage');
        print(myBody);
        try {
          if (await checkInternetIsConnected()) {
            print('net connectuin');

            var request = http.MultipartRequest(
                'POST', Uri.parse('https://api.queschat.com/api/feed'));
            request.headers.addAll(headers);
            request.fields.addAll(myBody);

            List<http.MultipartFile> newList = [];
            for (int i = 0; i < questionImages.length; i++) {
              http.MultipartFile multipartFile = http.MultipartFile(
                  'images',
                  questionImages[i].readAsBytes().asStream(),
                  questionImages[i].lengthSync(),
                  filename: questionImages[i].path.split("/").last);
              newList.add(multipartFile);
            }
            request.files.addAll(newList);

            print('listing ok');
            try {
              http.Response response =
                  await http.Response.fromStream(await request.send());
              body = json.decode(response.body);
            } catch (e) {
              print('fgdf');
              print(e);
            }
          } else {
            body = {'message': 'noInternet'};
          }
        } catch (e) {
          print(e);
        }

        if (body['message'] != null) {
          if (body['message'] == 'Successfully Created') {
            return body['id'].toString();
          } else {
            throw Exception('Please retry');
          }
        } else {
          throw Exception('Please retry');
        }
      } catch (e) {
        print('eeeeeeeeeeeeeeeeee');
        print(e);
        throw e;
      }
    } else {
      throw Exception(['Please Select Answer']);
    }
  }

  Future<String> postMCQWithImage(
      {String question,
      List<File> questionImages,
      correctOption,
      File optionA,
      optionB,
      optionC,
      optionD,
      feedLevel}) async {
    print(correctOption);
    if (correctOption != null && correctOption != '') {
      try {
        Map<String, String> myBody = {
          'name': question,
          'feed_type': 'mcq',
          'answer': correctOption,
          'option_type': 'image',
        };
        print(myBody);
        var body;
        if (feedLevel != null) {
          myBody.addAll({'feed_level': feedLevel});
        }
        print(myBody);

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String token = sharedPreferences.getString('token');
        Map<String, String> headers = {};
        headers['x-access-token'] = token;
        print('in pbobst inage');
        print(myBody);
        try {
          if (await checkInternetIsConnected()) {
            print('net connectuin');

            var request = http.MultipartRequest(
                'POST', Uri.parse('https://api.queschat.com/api/feed'));
            request.headers.addAll(headers);
            request.fields.addAll(myBody);

            List<http.MultipartFile> newList = [];
            for (int i = 0; i < questionImages.length; i++) {
              http.MultipartFile multipartFile = http.MultipartFile(
                  'images',
                  questionImages[i].readAsBytes().asStream(),
                  questionImages[i].lengthSync(),
                  filename: questionImages[i].path.split("/").last);
              newList.add(multipartFile);
            }

            http.MultipartFile multipartFileOptionA = http.MultipartFile(
                'option_a',
                optionA.readAsBytes().asStream(),
                optionA.lengthSync(),
                filename: optionA.path.split("/").last);
            newList.add(multipartFileOptionA);

            http.MultipartFile multipartFileOptionB = http.MultipartFile(
                'option_b',
                optionB.readAsBytes().asStream(),
                optionB.lengthSync(),
                filename: optionB.path.split("/").last);
            newList.add(multipartFileOptionB);
            http.MultipartFile multipartFileOptionC = http.MultipartFile(
                'option_c',
                optionC.readAsBytes().asStream(),
                optionC.lengthSync(),
                filename: optionC.path.split("/").last);
            newList.add(multipartFileOptionC);
            http.MultipartFile multipartFileOptionD = http.MultipartFile(
                'option_d',
                optionD.readAsBytes().asStream(),
                optionD.lengthSync(),
                filename: optionD.path.split("/").last);
            newList.add(multipartFileOptionD);

            request.files.addAll(newList);

            print('listing ok');
            try {
              http.Response response =
                  await http.Response.fromStream(await request.send());
              body = json.decode(response.body);
            } catch (e) {
              print('fgdf');
              print(e);
            }
          } else {
            body = {'message': 'noInternet'};
          }
        } catch (e) {
          print(e);
        }

        if (body['message'] != null) {
          if (body['message'] == 'Successfully Created') {
            return body['id'].toString();
          } else {
            throw Exception('Please retry');
          }
        } else {
          throw Exception('Please retry');
        }
      } catch (e) {
        print('eeeeeeeeeeeeeeeeee');
        print(e);
        throw e;
      }
    } else {
      throw Exception(['Please Select Answer']);
    }
  }

  Future<String> postQuiz(
      {String heading,
      content,
      point,
      int duration,
      var media,
      List<QuizMcqState> mcqList}) async {
    try {
      List<String> mcqIDs = [];
      for (var state in mcqList) {
        if (state.isImageOptions) {
          mcqIDs.add(await postMCQWithImage(
              question: state.question,
              questionImages: state.questionImages,
              optionA: state.optionAImage,
              optionB: state.optionBImage,
              optionC: state.optionCImage,
              optionD: state.optionDImage,
              feedLevel: '2',
              correctOption: state.correctOption));
        } else {
          mcqIDs.add(await postMCQWithText(
              question: state.question,
              questionImages: state.questionImages,
              optionA: state.optionA,
              optionB: state.optionB,
              optionC: state.optionC,
              optionD: state.optionD,
              feedLevel: '2',
              correctOption: state.correctOption));
        }
      }

      String mcqIDString = '';
      mcqIDs.forEach((element) {
        if (mcqIDString != '') {
          mcqIDString = mcqIDString + ',';
        }
        mcqIDString = mcqIDString + element;
      });
      Map<String, String> myBody = {
        'name': heading,
        'quiz_time': duration.toString(),
        'quiz_point': point,
        'description': content,
        'mcq': mcqIDString,
        'feed_type': 'quiz'
      };

      var body = await postImageListDataRequest(
          myBody: myBody,
          address: 'feed',
          imageFiles: media,
          imageAddress: 'images');
      print(body);
      if (body['message'] != null) {
        if (body['message'] == 'Successfully Created') {
          return body['id'].toString();
        } else {
          throw Exception('Please retry');
        }
      } else {
        throw Exception('Please retry');
      }
    } catch (e) {
      print('eeeeeeeeeeeeeeeeee');
      print(e);
      throw e;
    }
  }

  Future<String> postBlog({String heading, content, var media}) async {
    try {
      Map<String, String> myBody = {
        'description': content,
        'feed_type': 'blog'
      };

      var body = await postImageListDataRequest(
          myBody: myBody,
          address: 'feed',
          imageFiles: media,
          imageAddress: 'images');
      print(body);
      if (body['message'] != null) {
        if (body['message'] == 'Successfully Created') {
          return body['id'].toString();
        } else {
          throw Exception('Please retry');
        }
      } else {
        throw Exception('Please retry');
      }
    } catch (e) {
      print('eeeeeeeeeeeeeeeeee');
      print(e);
      throw e;
    }
  }

  Future<void> editBlog({String heading, content, feedId}) async {
    try {
      Map<String, String> myBody = {
        'description': content,
        'feed_type': 'blog'
      };
      if (heading != null) {
        myBody.addAll({'name': heading});
      }
      var body =
          await patchDataRequest(myBody: myBody, address: 'feed/$feedId');
      print(body);
      if (body['message'] != null) {
        if (body['message'] == 'Successfully Updated') {
        } else {
          throw Exception('Please retry');
        }
      } else {
        throw Exception('Please retry');
      }
    } catch (e) {
      print('eeeeeeeeeeeeeeeeee');
      print(e);
      throw e;
    }
  }

  Future<List> getFeeds(int page, rowsPerPage, parentPage) async {
    try {
      print('page $page rowsPerPage $rowsPerPage');
      // var body = await getDataRequest( address: 'feed/list');
      var body;
      if (parentPage == 'home') {
        body = await getDataRequest(
            address:
                'feed/list?rows_per_page=$rowsPerPage&page=$page&feed_type=blog');
        if (body['Feeds'] != null) {
          return body['Feeds'];
        } else {
          throw Exception('Please retry');
        }
      } else if (parentPage == 'myFeeds') {
        body = await getDataRequest(
            address: 'feed/by_creator?rows_per_page=$rowsPerPage&page=$page');
        if (body['Feeds'] != null) {
          return body['Feeds'];
        } else {
          throw Exception('Please retry');
        }
      } else if (parentPage == 'savedFeeds') {
        body = await getDataRequest(
            address:
                'saved_feed/by_creator?rows_per_page=$rowsPerPage&page=$page');
        if (body['Saved Feeds'] != null) {
          return body['Saved Feeds'];
        } else {
          throw Exception('Please retry');
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future getSingleFeedDetails(String id) async {
    try {
      var body = await getDataRequest(address: 'feed/$id');
      if (body['Feed'] != null) {
        return body['Feed'];
      } else {
        if (body['message'] == null) {
          throw Exception('Please retry');
        } else {
          throw Exception(body['message']);
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> likeFeed({String feedId}) async {
    try {
      var myBody = {
        'associated_id': 'Feed-' + feedId,
        'connection_type': 'like',
      };

      print(myBody);
      var body = await postDataRequest(myBody: myBody, address: 'connection');
      if (body['message'] != null) {
        if (body['message'] == 'Successfully Created') {
        } else {
          throw Exception('Please retry');
        }
      } else {
        throw Exception('Please retry');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> answerMcq({String feedId, String answer}) async {
    try {
      var myBody = {
        'associated_id': 'Feed-' + feedId,
        'connection_type': 'answer',
        'name': answer
      };

      print(myBody);
      var body = await postDataRequest(myBody: myBody, address: 'connection');
      if (body['message'] != null) {
        if (body['message'] == 'Successfully Created') {
        } else {
          throw Exception('Please retry');
        }
      } else {
        throw Exception('Please retry');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> answerQuizMcq({
    String quizId,
    mcqId,
    point,
    answerStatus,
    answer,
    int completionTime,
  }) async {
    try {
      var myBody = {
        'quiz_id': quizId,
        'mcq_id': mcqId,
        'name': answer,
        'answer_status': answerStatus,
        'completion_time': completionTime.toString(),
        'point': point,
      };

      print(myBody);
      var body = await postDataRequest(myBody: myBody, address: 'leader_board');
      if (body['message'] != null) {
        if (body['message'] == 'Successfully Created') {
        } else {
          throw Exception('Please retry');
        }
      } else {
        throw Exception('Please retry');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<LeaderBoardModel>> getLeaderBoardData({String quizId}) async {
    try {
      var body = await getDataRequest(address: 'leader_board/$quizId');
      if (body['leader_board'] != null) {
        List<LeaderBoardModel> models = [];
        body['leader_board'].forEach((element) {
          models.add(LeaderBoardModel(
            userId: element['user_id'].toString(),
            profilePic:
                element['profile_pic'] != null ? Urls().serverAddress+element['profile_pic'] : null,
            userName:
                element['user_name'] != null ? element['user_name'] : null,
            completedTime: element['completion_time'] != null
                ? element['completion_time']
                : 0,
            wrongAnswers:
                element['wrong_answer'] != null ? element['wrong_answer'] : 0,
            correctAnswers: element['correct_answer'] != null
                ? element['correct_answer']
                : 0,
            score: element['score'] != null ? element['score'] : 0,
            totalAttended: element['correct_answer'] != null &&
                    element['wrong_answer'] != null
                ? element['correct_answer'] + element['wrong_answer']
                : 0,
          ));
        });
        return models;
      } else {
        if (body['message'] != null) {
          throw Exception([body['message']]);
        } else {
          throw AppExceptions().somethingWentWrong;
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> unLikeFeed({String connectionId}) async {
    try {
      var body = await deleteDataRequest(address: 'connection/$connectionId');
      if (body['message'] != null) {
        if (body['message'] == 'Successfully Deleted') {
        } else {
          throw Exception('Please retry');
        }
      } else {
        throw Exception('Please retry');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> deleteFeed({String feedId}) async {
    try {
      var body = await deleteDataRequest(address: 'feed/$feedId');
      if (body['message'] != null) {
        if (body['message'] == 'Successfully Deleted') {
        } else {
          throw Exception('Please retry');
        }
      } else {
        throw Exception('Please retry');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<String> saveFeed({String feedId}) async {
    try {
      var myBody = {'feed_id': feedId};
      var body = await postDataRequest(address: 'saved_feed', myBody: myBody);
      if (body['message'] != null) {
        if (body['message'] == 'Successfully Created') {
          return body['id'].toString();
        } else {
          throw Exception('Please retry');
        }
      } else {
        throw Exception('Please retry');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> deleteFromSaved({String savedId}) async {
    try {
      var body = await deleteDataRequest(address: 'saved_feed/$savedId');
      if (body['message'] != null) {
        if (body['message'] == 'Successfully Deleted') {
        } else {
          throw Exception('Please retry');
        }
      } else {
        throw Exception('Please retry');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
