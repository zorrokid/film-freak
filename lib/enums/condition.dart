enum Condition {
  unknown,
  bad,
  poor,
  fair,
  good,
  excellent,
  mint,
}

final conditionFormFieldValues = <Condition, String>{
  Condition.unknown: "Not set",
  Condition.good: "Good",
  Condition.excellent: "Excellent",
  Condition.mint: "Mint (New or like new)",
  Condition.fair: "Fair",
  Condition.poor: "Poor (Slightly Damaged)",
  Condition.bad: "Bad (Damaged)"
};
