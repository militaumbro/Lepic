double getPpm(int wordCount, int duration) {
  if (wordCount != null && duration != null) {
    double durationInMinutes = duration / 60;
    return wordCount / (durationInMinutes);
  }
}

double getPercentage(int wordCount, int errorCount) {
  if (wordCount != null && errorCount != null)
    return (wordCount - errorCount) / wordCount;
}

double getPcpm(int wordCount, int duration, int errorCount) {
  if (wordCount != null && duration != null && errorCount != null) {
    var correct = wordCount - errorCount;
    return getPpm(correct, duration);
  }
}
