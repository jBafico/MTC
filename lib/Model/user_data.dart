class UserData {

  final String name;

  final String uid;

  final List<Budget> budgets;

  UserData({ required this.uid, required this.name, required this.budgets });

}



class Budget {
  final String name;
  final int amount;
  int collected = 0;

  Budget({ required this.name, required this.amount});
}
