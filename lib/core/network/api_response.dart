class ApiResponse<T> {
  final String? successMessage;
  final String? errorMessage;
  final int statusCode;
  final dynamic rawData;
  final T? data;

  ApiResponse({
    this.successMessage,
    this.errorMessage,
    required this.statusCode,
    this.rawData,
    this.data,
  });

  ApiResponse<H> copyWithData<H>(H data) => ApiResponse<H>(
    statusCode: statusCode,
    data: data,
    successMessage: successMessage,
    errorMessage: errorMessage,
    rawData: rawData,
  );

  ApiResponse.success(String message, int statusCode, dynamic data)
    : this(successMessage: message, statusCode: statusCode, data: data);

  ApiResponse.failed(String message, int statusCode)
    : this(errorMessage: message, statusCode: statusCode);
}
