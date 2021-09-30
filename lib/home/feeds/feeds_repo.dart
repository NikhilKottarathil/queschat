import 'package:queschat/function/api_calls.dart';

class FeedRepository {
  Future<String> postMCQ(
      {String question,
      optionA,
      optionB,
      optionC,
      optionD,
      correctOption}) async {
    print('$question  $optionD $optionC $optionB $optionA $correctOption');
    if (correctOption != null && correctOption != '') {
      try {
        List options = [
          {'option': optionA, 'Is_answer': correctOption == 'A' ? 1 : 0},
          {'option': optionB, 'Is_answer': correctOption == 'B' ? 1 : 0},
          {'option': optionC, 'Is_answer': correctOption == 'C' ? 1 : 0},
          {'option': optionD, 'Is_answer': correctOption == 'D' ? 1 : 0},
        ];
        var myBody = {'name': question, 'options': options, 'feed_type': 'mcq'};

        print('ttttttttt');
        print(options.toString());
        print(myBody);
        var body = await postDataRequest(myBody: myBody, address: 'feed');
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

  Future<String> postBlog({String heading, content, var media}) async {
    try {
      Map<String,String> myBody = {
        'name': heading,
        'description': content,
        'feed_type': 'blog'
      };

      var body = await postImageListDataRequest(myBody: myBody, address: 'feed',imageFiles:media,imageAddress: 'images' );
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

  Future<List> getFeeds(int page, rowsPerPage) async {
    try {
      print('page $page rowsPerPage $rowsPerPage');
      // var body = await getDataRequest( address: 'feed/list');
      var body = await getDataRequest(
          address: 'feed/list?rows_per_page=$rowsPerPage&page=$page');
      if (body['Feeds'] != null) {
        return body['Feeds'];
      } else {
        throw Exception('Please retry');
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
        throw Exception('Please retry');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }



  Future<void> likeFeed({String feedId}) async {
    try {
      var myBody = {
        'associated_id': 'Feed-'+feedId,
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
  Future<void> answerMcq({String feedId,String answer}) async {
    try {
      var myBody = {
        'associated_id': 'Feed-'+feedId,
        'connection_type': 'answer',
        'name':answer
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
}
