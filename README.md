# Spend It

A new Flutter application to track monthly expenses.

## Description

This mobile app is built in Flutter using the Dart language, so it is compatible with both Andriod and iOS devices.
I used SQLite to store my "payment" data in this app.

## Images

![Home page1](https://drive.google.com/file/d/1TfH9Ucab5kTDmO4PvooffoBVgnw3ePsZ/view?usp=sharing)

![Home page2](https://drive.google.com/file/d/1DiK8-hTDQorsbNgSUxK-M-9DsWpYqwTT/view?usp=sharing)

![Home page3](https://drive.google.com/file/d/1UnzXPJi9b_l5gzYaquycbtgfIjCimYaK/view?usp=sharing)

![List view1](https://drive.google.com/file/d/1Z3f2wVTAbwLx_-p3Gv7uz_UCiv6JLo3M/view?usp=sharing)

![List view2](https://drive.google.com/file/d/13v3Y7taY05jG-OWLn-6gWBjCTYtkg95N/view?usp=sharing)

![Edit payment](https://drive.google.com/file/d/1UKs896JtsSdPSwTnW-YiabbUV3sawd4A/view?usp=sharing)

![Add payment1](https://drive.google.com/file/d/1qK3H4tVvH5WQQ6ScS0pPf3TkMlDtnkTv/view?usp=sharing)

![Add payment2](https://drive.google.com/file/d/1uWF14jZGlsyyL0BbUyh9MqyJCEThevTu/view?usp=sharing)

![Drawer](https://drive.google.com/file/d/1VBHzOjhFw3Nlh8laT-3-2-qyIfAPxLJD/view?usp=sharing)

![History](https://drive.google.com/file/d/1VBb-li9lzQ2DAQ9-xd1LaVNF9sehNiUX/view?usp=sharing)

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


