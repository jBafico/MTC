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

  Future createUser(String name) async {
    return await userCollection.doc(uid).set({'name': name, 'balance': 0.0});
  }

  // ---------- CATEGORY ---------- //
  // Update category from category collection inside the user document if the category exists or create a new one
  Future updateCategory(Category category) async {
    return await userCollection
        .doc(uid)
        .collection('categories')
        .doc(category.name)
        .set({
      'name': category.name,
      'icon': category.icon.codePoint,
      'color': category.color.value,
    });
  }

  // Remove category from category collection inside the user document
  Future removeCategory(String name) async {
    return await userCollection
        .doc(uid)
        .collection('categories')
        .doc(name)
        .delete();
  }

  // ---------- BUDGETS ---------- //
  // Update budget from budget collection inside the user document if the budget exists or create a new one
  Future updateBudget(Budget budget) async {
    // Get category document reference from category collection inside the user document
    DocumentReference categoryRef = userCollection
        .doc(uid)
        .collection('categories')
        .doc(budget.category.name);

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
      'category': categoryRef,
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
    // Get category document reference from category collection inside the user document
    DocumentReference categoryRef = userCollection
        .doc(uid)
        .collection('categories')
        .doc(movement.category.name);

    DocumentReference budgetRef = userCollection
        .doc(uid)
        .collection('budgets')
        .doc(movement.budget?.name);

    return await userCollection
        .doc(uid)
        .collection('movements')
        .doc(movement.description)
        .set({
      'description': movement.description,
      'amount': movement.amount,
      'date': movement.date,
      'category': categoryRef,
      'type': movement.type,
      'budget': budgetRef
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

    String name = '';
    double balance = 0;

    try {
      name = snapshot.get('name');
      balance = snapshot.get('balance').toDouble();
    } catch (e) {
      print(e.toString());
    }

    return UserData(uid: uid, name: name, balance: balance);
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

  // ---------- CATEGORY ---------- //
  // Get categories from Collection
  List<Category> _categoriesFromCollection(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Category(
        name: doc.get('name'),
        iconCode: doc.get('icon'),
        colorValue: doc.get('color'),
      );
    }).toList();
  }

  // Get categories stream
  Stream<List<Category>> get categories {
    return userCollection
        .doc(uid)
        .collection('categories')
        .snapshots()
        .map(_categoriesFromCollection);
  }

  // ---------- BUDGETS ---------- //
  // Get budget from Document
  Future<Budget> _budgetFromDoc(QueryDocumentSnapshot doc) async {
    String name = '';
    String description = '';
    double amount = 0;
    double spent = 0;
    bool completed = false;
    DocumentReference? categoryRef;
    Category category = Category.defaultCategory;

    try {
      name = doc.get('name');
      description = doc.get('description');
      amount = doc.get('amount');
      spent = doc.get('spent');
      completed = doc.get('completed');
      categoryRef = doc.get('category');
    } catch (e) {
      print(e.toString());
    }

    // Get category from categoryRef
    var categoryDoc = await categoryRef!.get();

    category = Category(
      name: categoryDoc.get('name'),
      iconCode: categoryDoc.get('icon'),
      colorValue: categoryDoc.get('color'),
    );

    return Budget(
      name: name,
      description: description,
      amount: amount,
      spent: spent,
      completed: completed,
      category: category,
    );
  }

  // Get budgets from Collection
  Future<List<Budget>> _budgetsFromCollection(QuerySnapshot snapshot) async {
    var resp = await Future.wait(
        snapshot.docs.map((doc) async => await _budgetFromDoc(doc)).toList());

    return resp;
  }

  // get budgets stream
  Stream<List<Budget>> get budgets {
    return userCollection
        .doc(uid)
        .collection('budgets')
        .snapshots()
        .asyncMap((snapshot) async => await _budgetsFromCollection(snapshot));
  }

  // ---------- MOVEMENTS ---------- //
  // Get Movement from document
  Future<Movement> _movementFromDoc(QueryDocumentSnapshot doc) async {
    String description = '';
    double amount = 0;
    Timestamp date = Timestamp.now();
    DocumentReference? categoryRef;
    Category category = Category.defaultCategory;
    String type = '';

    try {
      description = doc.get('description');
      amount = doc.get('amount');
      date = doc.get('date');
      categoryRef = doc.get('category');
      type = doc.get('type');
    } catch (e) {
      print(e.toString());
    }

    // Get category from categoryRef
    var categoryDoc = await categoryRef!.get();

    category = Category(
      name: categoryDoc.get('name'),
      iconCode: categoryDoc.get('icon'),
      colorValue: categoryDoc.get('color'),
    );

    return Movement(
      description: description,
      amount: amount.toDouble(),
      date: date.toDate(),
      category: category,
      type: type,
    );
  }

  // Get movements from Collection
  Future<List<Movement>> _movementsFromCollection(
      QuerySnapshot snapshot) async {
    var resp = await Future.wait(
        snapshot.docs.map((doc) async => await _movementFromDoc(doc)).toList());

    resp.sort((a, b) => b.date.compareTo(a.date));
    return resp;
  }

  // get movements stream
  Stream<List<Movement>> get movements {
    return userCollection
        .doc(uid)
        .collection('movements')
        .snapshots()
        .asyncMap((snapshot) async => await _movementsFromCollection(snapshot));
  }
}
