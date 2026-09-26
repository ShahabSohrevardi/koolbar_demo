enum ResourceStatus { Success, Failed, Loading }

class Resource<T> {
  final ResourceStatus status;
  T? data;
  String? message;

  Resource({required this.status, this.data, this.message});

  Resource.success(T data, [String? message])
    : this(status: ResourceStatus.Success, message: message, data: data);

  Resource.failed(String message)
    : this(status: ResourceStatus.Failed, message: message);

  Resource.loading() : this(status: ResourceStatus.Loading);

  Resource<R> copyWith<R>({ResourceStatus? status, R? data, String? message}) =>
      Resource<R>(
        status: status ?? this.status,
        data: data,
        message: message ?? this.message,
      );
}
