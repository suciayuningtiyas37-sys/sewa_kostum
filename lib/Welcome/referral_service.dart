class ReferralService {
  static final Map<String, int> _codes = {
    "1234": 10,
    "9999": 20,
    "ABCD": 15,
    "KOSTUM2026": 25,
  };

  static String _normalize(String code) {
    return code.trim().toUpperCase();
  }

  // ================= VALIDASI =================
  static bool isValid(String code) {
    return _codes.containsKey(_normalize(code));
  }

  // ================= CEK EXIST =================
  static bool exists(String code) {
    return _codes.containsKey(_normalize(code));
  }

  // ================= GET BONUS =================
  static int getBonus(String code) {
    return _codes[_normalize(code)] ?? 0;
  }

  // ================= ADD CODE =================
  static void addCode(String code, {int bonus = 0}) {
    final formatted = _normalize(code);
    _codes.putIfAbsent(formatted, () => bonus);
  }

  // ================= GET ALL =================
  static List<String> getAllCodes() {
    return _codes.keys.toList();
  }

  // ================= RESET =================
  static void reset() {
    _codes
      ..clear()
      ..addAll({
        "1234": 10,
        "9999": 20,
        "ABCD": 15,
        "KOSTUM2026": 25,
      });
  }
}