double getPpm(int wordCount, int duration) {
  if (wordCount != null && duration != null) {
    double durationInMinutes = duration / 60;
    return wordCount / (durationInMinutes);
  }
}

double getAccuracy(double ppm, int errorCount) {
  if (ppm != null && errorCount != null) return (ppm - errorCount) / ppm;
}

double getPcpm(int wordCount, int duration, int errorCount) {
  if (wordCount != null && duration != null && errorCount != null) {
    var correct = wordCount - errorCount;
    return getPpm(correct, duration);
  }
}
