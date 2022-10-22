// firestore database service

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maneja_tus_cuentas/Model/Budget.dart';
import 'package:maneja_tus_cuentas/Model/Category.dart';
import 'package:maneja_tus_cuentas/Model/UserData.dart';
import 'package:maneja_tus_cuentas/constants.dart';


class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name) async {
    return await userCollection.doc(uid).update({
      'name': name,
    });
  }

  // Update budget from budget collection inside the user document if the budget exists or create a new one
  Future updateBudget(Budget budget) async {

      return await userCollection.doc(uid).collection('budgets').doc(budget.name).set({
        'name': budget.name,
        'description': budget.description,
        'amount': budget.amount,
        'spent': budget.spent,
        'completed': budget.completed,
        'category': budget.category,
      });
  }

  // Remove budget from budget collection inside the user document
  Future removeBudget(Budget budget) async {
    return await userCollection.doc(uid).collection('budgets').doc(budget.name).delete();
  }




  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.get('name'),
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }


  // Get budgets from Collection
  List<Budget> _budgetsFromCollection(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Budget(
        name: doc.get('name') ?? '',
        description: doc.get('description') ?? '',
        amount: doc.get('amount') ?? 0.0,
        spent: doc.get('spent') ?? 0.0,
        completed: doc.get('completed') ?? false,
        category: Category(name: doc.get('category')),
      );
    }).toList();
  }

  // get budgets stream
  Stream<List<Budget>> get budgets {
    return userCollection.doc(uid).collection('budgets').snapshots().map(_budgetsFromCollection);
  }
}