// budget card
// it has a row of an icon, a column of text and a circular progress bar
// it receives a budget object and builds the card from it

import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Model/Budget.dart';
import 'package:maneja_tus_cuentas/Model/Category.dart';
import 'package:maneja_tus_cuentas/constants.dart';

class BudgetCard extends StatelessWidget {
  final Budget budget;

  const BudgetCard({Key? key, required this.budget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 80,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  budget.category.icon,
                  size: 40,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Text(
                      budget.name,
                      style:
                          const TextStyle(fontSize: 20, color: kPrimaryColor),
                    ),
                  ),
                  Text(budget.description),
                ],
              ),
            ),
          ),
          Text(
            budget.completed
                ? ""
                : "${budget.spent.floor()} / ${budget.amount.floor()}",
            style: const TextStyle(color: kPrimaryColor),
          ),
          // circular progress bar with the percentage in the middle
          // Aligned right
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        value: budget.spent / budget.amount,
                        strokeWidth: 5,
                      ),
                    ),
                  ),
                  // percentage text, centered inside the circle
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: Text(
                          "${((budget.spent / budget.amount) * 100).floor().toStringAsFixed(0)}%",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
