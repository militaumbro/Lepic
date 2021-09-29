import 'dart:math';

double getPpm(int wordCount, int duration) {
  if (wordCount != null && duration != null) {
    double durationInMinutes = duration / 60;
    return wordCount / (durationInMinutes);
  }
  return -1;
}

int randomId() {
  var random = Random();
  var id = random.nextInt(1000000000);
  return id;
}

double getPercentage(int wordCount, int errorCount) {
  if (wordCount != null && errorCount != null)
    return (wordCount - errorCount) / wordCount;
  return 100;
}

double getPcpm(int wordCount, int duration, int errorCount) {
  if (wordCount != null && duration != null && errorCount != null) {
    var correct = wordCount - errorCount;
    return getPpm(correct, duration);
  }
  return -1;
}

int calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  print("idade:$age");
  return age;
}

String getWeekDay(int weekDay) {
    switch (weekDay) {
      case 1:
        return "Segunda-feira";

      case 2:
        return "Terça-feira";

      case 3:
        return "Quarta-feira";

      case 4:
        return "Quinta-feira";

      case 5:
        return "Sexta-feira";

      case 6:
        return "Sábado";

      case 7:
        return "Domingo";

      default:
        return "";
    }
  }