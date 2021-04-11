class ErrorController {
  int errorCount;
  List<String> errorList = [];
  ErrorController({this.errorCount = 0});

  void updateErrorCount(int number, String errorType) {
    this.errorCount += number;
    if (errorType == "") errorType = "Não Especificado";
    errorList.add(errorType ?? "Não Especificado");
  }
}
