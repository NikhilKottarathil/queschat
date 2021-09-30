import 'package:queschat/function/api_calls.dart';

class ConnectionRepository {
  Future<String> AddNewComment(
      {String comment,
        feedID,}) async {
    try {

      var myBody = {'name': comment, 'associated_id': 'Feed-'+feedID,'connection_type':'comment'};
      print(myBody);
      var body = await postDataRequest(myBody: myBody, address: 'connection');
      if (body['message'] != null) {
        if (body['message'] == 'Successfully Created') {
          return body['id'].toString();
        } else {
          throw Exception('Please retry');
        }
      } else {
        throw Exception('Please retry');
      }
    }catch(e){

    }
  }

  Future<String> AddNewReplay(
      {String replay,
        feedID,commentId}) async {
    try {

      var myBody = {'name': replay, 'associated_id': 'Feed-'+feedID,'connection_type':'comment','parent_id':commentId,'connection_level':2};
      print(myBody);
      var body = await postDataRequest(myBody: myBody, address: 'connection');
      if (body['message'] != null) {
        if (body['message'] == 'Successfully Created') {
          return body['id'].toString();
        } else {
          throw Exception('Please retry');
        }
      } else {
        throw Exception('Please retry');
      }
    }catch(e){

    }
  }


  Future<List> getComments(int page, rowsPerPage,feedID) async {
    try {
      print('page $page rowsPerPage $rowsPerPage');
      // var body = await getDataRequest( address: 'feed/list');
      var body = await getDataRequest(
          address: 'connection/list/Feed-$feedID/comment');
          // address: 'connection/list/Feed-$feedID/comment?rows_per_page=$rowsPerPage&page=$page');
      if (body['Connections'] != null) {
        return body['Connections'];
      } else {
        throw Exception('Please retry');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future getSingleCommentDetails(String commentID) async {
    try {
      var body = await getDataRequest(address: 'connection/$commentID');
      if (body['Connection'] != null) {
        return body['Connection'];
      } else {
        throw Exception('Please retry');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }




  Future<void> likeComment({String commentID}) async {
    try {
      var myBody = {
        'associated_id': 'Connection-'+commentID,
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
  Future<void> unLikeComment({String commentId}) async {
    try {
      var body = await deleteDataRequest(address: 'connection/$commentId');
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

  deleteCommentAndReplay(String commentId) async {
    try {
      var body = await deleteDataRequest(address: 'connection/$commentId');
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
