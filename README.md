# Spend It

A new Flutter mobile application to track monthly your expenses.

## Description

This mobile app is built in Flutter using the Dart language, so it is compatible with both Andriod and iOS devices.
The user has the ability to view their monthly payments in a graph form or a list view. They have the ability to edit or delete previous payments and add new ones as well. They can view their payment history for previous months. I used SQLite to store my "payment" data in this app. To prevent SQL injections I have restricted the keyboards and types of characters the user can use.

## Images

![Home page1](https://drive.google.com/uc?export=view&id=1TfH9Ucab5kTDmO4PvooffoBVgnw3ePsZ)

![Home page2](https://drive.google.com/uc?export=view&id=1DiK8-hTDQorsbNgSUxK-M-9DsWpYqwTT)

![Home page3](https://drive.google.com/uc?export=view&id=1UnzXPJi9b_l5gzYaquycbtgfIjCimYaK)

![List view1](https://drive.google.com/uc?export=view&id=1Z3f2wVTAbwLx_-p3Gv7uz_UCiv6JLo3M)

![List view2](https://drive.google.com/uc?export=view&id=13v3Y7taY05jG-OWLn-6gWBjCTYtkg95N)

![Edit payment](https://drive.google.com/uc?export=view&id=1UKs896JtsSdPSwTnW-YiabbUV3sawd4A)

![Add payment1](https://drive.google.com/uc?export=view&id=1qK3H4tVvH5WQQ6ScS0pPf3TkMlDtnkTv)

![Add payment2](https://drive.google.com/uc?export=view&id=1uWF14jZGlsyyL0BbUyh9MqyJCEThevTu)

![Drawer](https://drive.google.com/uc?export=view&id=1VBHzOjhFw3Nlh8laT-3-2-qyIfAPxLJD)

![History](https://drive.google.com/uc?export=view&id=1VBb-li9lzQ2DAQ9-xd1LaVNF9sehNiUX)

## Data Model for Payment

```dart
  class Payment {
    int id;
    String name;
    String category;
    int year;
    int month;
    int day;
    double price;
  }
```


