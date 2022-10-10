// Budget object
class Budget {
  String name;
  String description;
  double amount;
  double spent;
  bool completed;

  Budget({required this.name, required this.description, required this.amount,required this.spent, required this.completed});

  updateSpent(double newAmount){
    spent = (spent + newAmount > amount) ? amount : spent + newAmount;

    if(spent >= amount){
      completed = true;
    }
  }
}