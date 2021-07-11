double getPpm(int wordCount, int duration) {
  if (wordCount != null && duration != null) {
    double durationInMinutes = duration / 60;
    return wordCount / (durationInMinutes);
  }
  return -1;
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
