enum Condition {
  // Still Wrapped,Poor - Slightly Damaged,Bad - Damaged,Good,Fair,Excellent
  unknown,
  bad,
  poor,
  fair,
  good,
  excellent,
  mint,
}

final Map<Condition, String> conditionFormFieldValues = {
  Condition.unknown: "Not set",
  Condition.good: "Good",
  Condition.excellent: "Excellent",
  Condition.mint: "Mint (New or like new)",
  Condition.fair: "Fair",
  Condition.poor: "Poor (Slightly Damaged)",
  Condition.bad: "Bad (Damaged)"
};
