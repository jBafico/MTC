// User data

class UserData {
  final String uid;
  final String name;
  double balance;

  UserData({required this.uid, required this.name, required this.balance});

  void updateBalance(double amount) {
    // TODO: logica mas compleja? tipo no permitir que quede en negativo etc.
    balance += amount;
  }
}