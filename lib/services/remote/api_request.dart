import 'package:gastosrecorrentes/services/remote/api_request_status.dart';

class ApiRequest<T> {
  ApiRequestStatus? status;
  T? data;
  String? message;

  ApiRequest(this.status, this.data, this.message);

  ApiRequest.loading() : status = ApiRequestStatus.loading;

  ApiRequest.completed(this.data) : status = ApiRequestStatus.completed;

  ApiRequest.error(this.message) : status = ApiRequestStatus.error;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}
