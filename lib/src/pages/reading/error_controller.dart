class ErrorController {
  int errorCount;
  List<String> errorList = [];
  ErrorController({this.errorCount = 0});

  void removeError(String errorType) {
    errorCount = errorCount - 1;
    if (errorType.contains("Não Especificado")) {
    } else
      errorList.remove(errorType);
  }

  void updateErrorCount(int number, String errorType) {
    this.errorCount += number;
    if (errorType == "") errorType = "Não Especificado";
    errorList.add(errorType ?? "Não Especificado");
  }
}
