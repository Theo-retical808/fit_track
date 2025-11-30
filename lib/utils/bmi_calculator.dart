class BMICalculator {
  static double calculateBMI(double weight, double height) {
    // weight in kg, height in cm
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  static String getHealthStatus(double bmi) {
    if (bmi < 18.5) return 'Kalansay';
    if (bmi < 25) return 'Mid';
    if (bmi < 30) return 'Caseoh';
    return 'NikocadoAvocado';
  }

  static String getHealthAdvice(double bmi) {
    if (bmi < 18.5) return 'Consider increasing calorie intake and strength training.';
    if (bmi < 25) return 'Great! Maintain your current lifestyle.';
    if (bmi < 30) return 'Consider regular exercise and balanced diet.';
    return 'Consult a healthcare professional for personalized advice.';
  }
}
