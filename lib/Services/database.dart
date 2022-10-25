// firestore database service

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maneja_tus_cuentas/Model/Budget.dart';
import 'package:maneja_tus_cuentas/Model/Category.dart';
import 'package:maneja_tus_cuentas/Model/Movement.dart';
import 'package:maneja_tus_cuentas/Model/UserData.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // ----------------- UPDATE OR SET DATA ----------------- //

  // ---------- USER DATA ---------- //
  Future updateUserName(String name) async {
    return await userCollection.doc(uid).update({
      'name': name,
    });
  }

  Future updateUserBalance(double balance) async {
    return await userCollection.doc(uid).update({
      'balance': balance,
    });
  }

  // ---------- BUDGETS ---------- //
  // Update budget from budget collection inside the user document if the budget exists or create a new one
  Future updateBudget(Budget budget) async {
    return await userCollection
        .doc(uid)
        .collection('budgets')
        .doc(budget.name)
        .set({
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
    return await userCollection
        .doc(uid)
        .collection('budgets')
        .doc(budget.name)
        .delete();
  }

  // ---------- MOVEMENTS ---------- //
  // Update movement from movement collection inside the user document if the movement exists or create a new one
  Future updateMovement(Movement movement) async {
    return await userCollection
        .doc(uid)
        .collection('movements')
        .doc(movement.description)
        .set({
      'description': movement.description,
      'amount': movement.amount,
      'date': movement.date,
      'category': movement.category.name,
      'type': movement.type,
    });
  }

  // Remove movement from movement collection inside the user document
  Future removeMovement(Movement movement) async {
    return await userCollection
        .doc(uid)
        .collection('movements')
        .doc(movement.description)
        .delete();
  }

  // ----------------- GET DATA ----------------- //
  // ---------- USER DATA ---------- //
  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    //TODO: mejorar esto
    try {
      return UserData(
        uid: uid,
        name: snapshot.get('name'),
        balance: (snapshot.get('balance') ?? 0) +
                0.0 /* casteo falopa porque devuelve int y no me deja castear directamente */ ??
            0.0,
      );
    } catch (e) {
      print(e.toString());
      return UserData(uid: uid, name: snapshot.get('name'), balance: 0.0);
    }
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  // Get single user data
  Future<UserData> getUserData() async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    return _userDataFromSnapshot(snapshot);
  }

  // ---------- BUDGETS ---------- //
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
    return userCollection
        .doc(uid)
        .collection('budgets')
        .snapshots()
        .map(_budgetsFromCollection);
  }

  // ---------- MOVEMENTS ---------- //
  // Get movements from Collection
  List<Movement> _movementsFromCollection(QuerySnapshot snapshot) {
    var resp = snapshot.docs.map((doc) {
      return Movement(
        description: doc.get('description') ?? '',
        amount: doc.get('amount') ?? 0.0,
        date: doc.get('date').toDate() ?? DateTime.now(),
        category: Category(name: doc.get('category')),
        type: doc.get('type') ?? '',
      );
    }).toList();

    resp.sort((a, b) => b.date.compareTo(a.date));
    return resp;
  }

  // get movements stream
  Stream<List<Movement>> get movements {
    return userCollection
        .doc(uid)
        .collection('movements')
        .snapshots()
        .map(_movementsFromCollection);
  }
}
