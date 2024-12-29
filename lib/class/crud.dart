import 'dart:convert';
import 'dart:html' as html;
import 'dart:math';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:web1/class/statusrequest.dart';

class Crud {
  checkInternet() {
    return true;
  }

  Future<Either<ResponseJson, Map>> postData(
      {required String linkurl,
      required Map data,
      required Map<String, String> headers}) async {
    Map responseBody;
    try {
      if (checkInternet()) {
        var response =
            await http.post(Uri.parse(linkurl), body: data, headers: headers);
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          responseBody = jsonDecode(response.body);
          print(responseBody);

          return Right(responseBody);
        } else {
          print('1=======$response');
          if (response.body.startsWith('{')) {
            return Left(ResponseJson(
              message: 'No Data Found',
              data: jsonDecode(response.body),
              statusRequest: StatusRequest.serverfailure,
            ));
          }
          print('2=======$response');

          return Left(ResponseJson(
            message: 'No Data Found',
            data: {},
            statusRequest: StatusRequest.serverfailure,
          ));
        }
      } else {
        return Left(ResponseJson(
          message: 'Offline',
          statusRequest: StatusRequest.offlinefailure,
        ));
      }
    } catch (e) {
      print(e);
      return Left(ResponseJson(
        message: 'No Data Found',
        data: {},
        statusRequest: StatusRequest.serverException,
      ));
    }
  }

  Future<Either<ResponseJson, Map>> patchData(
      {required String linkurl,
      required Map data,
      required Map<String, String> headers}) async {
    Map responseBody;
    try {
      if (await checkInternet()) {
        var response =
            await http.patch(Uri.parse(linkurl), body: data, headers: headers);
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          responseBody = jsonDecode(response.body);
          print(responseBody);

          return Right(responseBody);
        } else {
          if (response.body.startsWith('{')) {
            return Left(ResponseJson(
              message: 'No Data Found',
              data: jsonDecode(response.body),
              statusRequest: StatusRequest.serverfailure,
            ));
          }

          return Left(ResponseJson(
            message: 'No Data Found',
            data: {},
            statusRequest: StatusRequest.serverfailure,
          ));
        }
      } else {
        return Left(ResponseJson(
          message: 'Offline',
          statusRequest: StatusRequest.offlinefailure,
        ));
      }
    } catch (e) {
      print(e);
      return Left(ResponseJson(
        message: 'No Data Found',
        data: {},
        statusRequest: StatusRequest.serverException,
      ));
    }
  }

  Future<Either<ResponseJson, Map>> getData(
      {required String linkurl, required Map<String, String> headers}) async {
    try {
      if (checkInternet()) {
        print('=======$linkurl');
        var response = await http.get(Uri.parse(linkurl), headers: headers);
        print(response.statusCode);
        print(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          Map responsebody = jsonDecode(response.body);

          //print(responsebody);
          print('=======$response');
          return Right(responsebody);
        } else {
          print('=======$response');
          if (response.body.startsWith('{')) {
            return Left(ResponseJson(
              message: 'No Data Found',
              data: jsonDecode(response.body),
              statusRequest: StatusRequest.serverfailure,
            ));
          }

          return Left(ResponseJson(
            message: 'No Data Found',
            data: {},
            statusRequest: StatusRequest.serverfailure,
          ));
        }
      } else {
        return Left(ResponseJson(
          message: 'Offline',
          statusRequest: StatusRequest.offlinefailure,
        ));
      }
    } catch (e) {
      print(e);
      return Left(ResponseJson(
        message: 'No Data Found',
        data: {},
        statusRequest: StatusRequest.serverException,
      ));
    }
  }

  Future<Either<ResponseJson, Map>> getFiles(
      {required String linkurl, required Map<String, String> headers}) async {
    try {
      if (checkInternet()) {
        print('=======$linkurl');
        var response = await http.get(Uri.parse(linkurl), headers: headers);
        print(response.statusCode);
        print(response.body);

        if (response.statusCode == 200) {
          // Get the content type from the response headers
          final contentType = response.headers['content-type'];
          final isZip = contentType?.contains('application/zip') ?? false;

          // Determine file name based on content type
          final fileName = isZip
              ? 'files_bundle${Random().nextInt(100)}.zip'
              : 'downloaded_file';

          // Create a Blob and trigger download
          final blob = html.Blob([response.bodyBytes], contentType);
          final downloadUrl = html.Url.createObjectUrlFromBlob(blob);

          // Create an anchor element for the download
          final anchor = html.AnchorElement(href: downloadUrl)
            ..target = 'blank'
            ..download = fileName; // Use the determined file name
          anchor.click();

          // Clean up the URL
          html.Url.revokeObjectUrl(downloadUrl);

          print('File downloaded: $fileName');

          return const Right({});
        } else {
          print('=======$response');
          if (response.body.startsWith('{')) {
            return Left(ResponseJson(
              message: 'No Data Found',
              data: jsonDecode(response.body),
              statusRequest: StatusRequest.serverfailure,
            ));
          }

          return Left(ResponseJson(
            message: 'No Data Found',
            data: {},
            statusRequest: StatusRequest.serverfailure,
          ));
        }
      } else {
        return Left(ResponseJson(
          message: 'Offline',
          statusRequest: StatusRequest.offlinefailure,
        ));
      }
    } catch (e) {
      print(e);
      return Left(ResponseJson(
        message: 'No Data Found',
        data: {},
        statusRequest: StatusRequest.serverException,
      ));
    }
  }

  Future<Either<ResponseJson, Map>> deleteData(
      {required String linkurl, required Map<String, String> headers}) async {
    try {
      if (await checkInternet()) {
        var response = await http.delete(Uri.parse(linkurl), headers: headers);
        print(response.statusCode);
        print(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 204) {
          print('=======$response');
          return const Right({});
        } else {
          if (response.body.startsWith('{')) {
            return Left(ResponseJson(
              message: 'No Data Found',
              data: jsonDecode(response.body),
              statusRequest: StatusRequest.serverfailure,
            ));
          }

          return Left(ResponseJson(
            message: 'No Data Found',
            data: {},
            statusRequest: StatusRequest.serverfailure,
          ));
        }
      } else {
        return Left(ResponseJson(
          message: 'Offline',
          statusRequest: StatusRequest.offlinefailure,
        ));
      }
    } catch (e) {
      print(e);
      return Left(ResponseJson(
        message: 'No Data Found',
        data: {},
        statusRequest: StatusRequest.serverException,
      ));
    }
  }

  Future<Either<ResponseJson, Map>> postFileAndData(
      {required String linkurl,
      required Map<String, String> headers,
      required FileModel file,
      required Map data}) async {
    try {
      var request = http.MultipartRequest('Post', Uri.parse(linkurl));
      var multiFile = http.MultipartFile.fromBytes('file', file.file!,
          filename: basename(file.filePath!));
      request.files.add(multiFile);
      data.forEach((key, value) {
        request.fields[key] = value;
      });
      request.headers.addAll(headers);
      var myRequest = await request.send();
      var response = await http.Response.fromStream(myRequest);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseBody = jsonDecode(response.body);
        print(responseBody);
        return Right(responseBody);
      } else {
        print(response.statusCode);
        print(response.body);
        if (response.body.startsWith('{')) {
          return Left(ResponseJson(
            message: 'No Data Found',
            data: jsonDecode(response.body),
            statusRequest: StatusRequest.serverfailure,
          ));
        }

        return Left(ResponseJson(
          message: 'No Data Found',
          data: {},
          statusRequest: StatusRequest.serverfailure,
        ));
      }
    } catch (e) {
      print(e);
      return Left(ResponseJson(
        message: 'No Data Found',
        data: {},
        statusRequest: StatusRequest.serverException,
      ));
    }
  }
}

class ResponseJson {
  final StatusRequest statusRequest;
  final String? message;
  final Map? data;

  ResponseJson(
      {required this.statusRequest,
      this.message = 'none',
      this.data = const {}});
}

class FileModel {
  final Uint8List? file;
  final String? filePath;

  FileModel({this.file, this.filePath});
}
