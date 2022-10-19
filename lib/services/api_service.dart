import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rt_flutter/models/api_config_model.dart';
import 'package:rt_flutter/models/attachment_model.dart';
import 'package:rt_flutter/models/paginable_model.dart';
import 'package:rt_flutter/models/queue_model.dart';
import 'package:rt_flutter/models/rt_systeminfo_model.dart';
import 'package:rt_flutter/models/ticket_model.dart';
import 'package:rt_flutter/models/transaction_model.dart';
import 'package:rt_flutter/models/user_model.dart';

class APIService {
  APIService._instantiate();
  static final APIService instance = APIService._instantiate();
  static const prefix = '/REST/2.0';

  APIConfig? config;

  bool isUsable() {
    return config != null && config!.isUsable();
  }

  Future<bool> ping() async {
    assert(config != null && config!.isConnectable());

    var response = await http
        .get(Uri.https(config!.uri!.host, '${config!.uri!.path}$prefix/rt'));
    if (response.statusCode == HttpStatus.unauthorized) {
      if (json.decode(response.body)['message'] == 'Unauthorized') {
        return true;
      }
    }

    return false;
  }

  Map<String, String> baseHeaders() {
    return {
      HttpHeaders.authorizationHeader: config!.authorizationHeader(),
      // HttpHeaders.contentTypeHeader: 'application/json',
      // HttpHeaders.acceptHeader: 'application/json',
    };
  }

  Future<Attachment> fetchAttachment(String id) async {
    assert(isUsable());

    var response = await http.get(
        Uri.https(
            config!.uri!.host, '${config!.uri!.path}$prefix/attachment/$id'),
        headers: baseHeaders());
    if (response.statusCode == HttpStatus.ok) {
      return Attachment.readJson(json.decode(response.body));
    } else {
      throw 'Unexpected status code : ${response.statusCode}';
    }
  }

  Future<Queue> fetchQueue(String id) async {
    assert(isUsable());

    print('fetchQueue:$id');
    var response = await http.get(
        Uri.https(config!.uri!.host, '${config!.uri!.path}$prefix/queue/$id'),
        headers: baseHeaders());
    if (response.statusCode == HttpStatus.ok) {
      return Queue.readJson(json.decode(response.body));
    } else {
      throw 'Unexpected status code : ${response.statusCode}';
    }
  }

  Future<Paginable<Queue>> fetchQueues() async {
    assert(isUsable());

    print('fetchQueues');
    var response = await http.get(
        Uri.https(config!.uri!.host, '${config!.uri!.path}$prefix/queues/all',
            {'fields': 'Name,Description'}),
        headers: baseHeaders());
    if (response.statusCode == HttpStatus.ok) {
      return Paginable<Queue>.readJson(
          json.decode(response.body), (item) => Queue.readJson(item));
    } else {
      throw 'Unexpected status code : ${response.statusCode}';
    }
  }

  Future<RTSystemInfo> fetchRTSystemInfo() async {
    assert(isUsable());

    print('fetchRTSystemInfo');
    var response = await http.get(
        Uri.https(config!.uri!.host, '${config!.uri!.path}$prefix/rt'),
        headers: baseHeaders());
    if (response.statusCode == HttpStatus.ok) {
      return RTSystemInfo.readJson(json.decode(response.body));
    } else {
      throw 'Unexpected status code : ${response.statusCode}';
    }
  }

  Future<Ticket> fetchTicket(String? id) async {
    assert(isUsable());

    print('fetchTicket:$id');
    var response = await http.get(
        Uri.https(config!.uri!.host, '${config!.uri!.path}$prefix/ticket/$id'),
        headers: baseHeaders());
    if (response.statusCode == HttpStatus.ok) {
      return Ticket.readJson(json.decode(response.body));
    } else {
      throw 'Unexpected status code : ${response.statusCode}';
    }
  }

  Future<Paginable<Ticket>> fetchTickets(String? queueId, {int page: 1}) async {
    assert(isUsable());

    print('fetchTickets:$queueId');
    var response = await http.get(
        Uri.https(config!.uri!.host, '${config!.uri!.path}$prefix/tickets', {
          'query': 'Queue=$queueId',
          'page': '$page',
          'fields': 'Subject,Status',
          'orderby': 'id',
          'order': 'desc'
        }),
        headers: baseHeaders());
    if (response.statusCode == HttpStatus.ok) {
      return Paginable<Ticket>.readJson(
          json.decode(response.body), (item) => Ticket.readJson(item));
    } else {
      throw 'Unexpected status code : ${response.statusCode}';
    }
  }

  Future<Transaction> fetchTransaction(String id) async {
    assert(isUsable());

    print('fetchTransaction:$id');
    var response = await http.get(
        Uri.https(
            config!.uri!.host, '${config!.uri!.path}$prefix/transaction/$id'),
        headers: baseHeaders());
    if (response.statusCode == HttpStatus.ok) {
      return Transaction.readJson(json.decode(response.body));
    } else {
      throw 'Unexpected status code : ${response.statusCode}';
    }
  }

  Future<Paginable<Transaction>> fetchTransactionsForTicket(
      String? ticketId) async {
    assert(isUsable());

    print('fetchTransactionsForTicket:$ticketId');
    var response = await http.get(
        Uri.https(
            config!.uri!.host,
            '${config!.uri!.path}$prefix/ticket/$ticketId/history',
            {'fields': 'Created,Creator,Type,Data,Field,OldValue,NewValue'}),
        headers: baseHeaders());
    if (response.statusCode == HttpStatus.ok) {
      return Paginable<Transaction>.readJson(
          json.decode(response.body), (item) => Transaction.readJson(item));
    } else {
      throw 'Unexpected status code : ${response.statusCode}';
    }
  }

  Future<Paginable<Attachment>> fetchAttachmentsForTransaction(
      String? transactionId) async {
    assert(isUsable());

    print('fetchAttachmentsForTransaction:$transactionId');
    var response = await http.get(
        Uri.https(
            config!.uri!.host,
            '${config!.uri!.path}$prefix/transaction/$transactionId/attachments',
            {'fields': 'ContentType,Content'}),
        headers: baseHeaders());
    if (response.statusCode == HttpStatus.ok) {
      return Paginable<Attachment>.readJson(
          json.decode(response.body), (item) => Attachment.readJson(item));
    } else {
      throw 'Unexpected status code : ${response.statusCode}';
    }
  }

  Future<Paginable<Attachment>> fetchAttachmentsForTicket(
      String? ticketId) async {
    assert(isUsable());

    print('fetchAttachmentsForTicket:$ticketId');
    var response = await http.get(
        Uri.https(
            config!.uri!.host,
            '${config!.uri!.path}$prefix/ticket/$ticketId/attachments',
            {'fields': 'ContentType,Content,TransactionId'}),
        headers: baseHeaders());
    if (response.statusCode == HttpStatus.ok) {
      return Paginable<Attachment>.readJson(
          json.decode(response.body), (item) => Attachment.readJson(item));
    } else {
      throw 'Unexpected status code : ${response.statusCode}';
    }
  }

  Future<User> fetchUser(String? id) async {
    assert(isUsable());

    print('fetchUser:$id');
    var response = await http.get(
        Uri.https(
            config!.uri!.host, '${config!.uri!.path}$prefix/transaction/$id'),
        headers: baseHeaders());
    if (response.statusCode == HttpStatus.ok) {
      return User.readJson(json.decode(response.body));
    } else {
      throw 'Unexpected status code : ${response.statusCode}';
    }
  }
}
