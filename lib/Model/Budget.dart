// Budget object
import 'package:maneja_tus_cuentas/Model/Category.dart';

class Budget {
  String name;
  String description;
  double amount;
  double spent;
  bool completed;
  Category category;

  Budget({required this.name, required this.description, required this.amount,required this.spent, required this.completed, required this.category});

  updateSpent(double newAmount){
    spent = (spent + newAmount > amount) ? amount : spent + newAmount;

    if(spent >= amount){
      completed = true;
    }
  }
}