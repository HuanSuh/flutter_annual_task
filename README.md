# flutter_annual_task

## flutter_annual_task
Flutter package for displaying grid view of daily task like **Github Distribution**.

**Example**
![example](./example/assets/example.png)

##Usage
Make sure to check out [example project](https://github.com/HuanSuh/flutter_annual_task/tree/master/example).

```dart
AnnualTaskView(
	taskItem	// List<AnnualTaskItem>
),
```

- - -
### Installation
Add to pubspec.yaml:
```xml
dependencies:
	flutter_annual_task: <version>
```
Then import it to your project:
```dart
import 'package:flutter_annual_task/flutter_annual_task.dart';
```
And finally add `AnnualTaskView` widget in your project.
```dart
AnnualTaskView(
	taskItem	// List<AnnualTaskItem>
),
```
- - -
###AnnualTaskItem
**AnnualTaskItem**
```dart
class AnnualTaskItem {
  final DateTime date;
  final double proceeding;	// 0.0 ~ 1.0

  AnnualTaskItem(this.date, [this.proceeding = 1.0]);
  ...
}
```
The value of `proceeding` affects the opacity on the each cell of daily task.<br/>- For showing the color in visual, the minimum value of displaying is 80(max: 255).
</br>

**AnnualTaskColorItem**
If you want to specify color for each daily task, you can use `AnnualTaskColorItem`.
```dart
class AnnualTaskColorItem extends AnnualTaskItem {
  final Color color;

  AnnualTaskColorItem(
    DateTime date, {
    double proceeding = 1.0,
    this.color,
  }) : super(date, proceeding);
  ...
}
```

You should generate **list of AnnualTaskItem**(`List<AnnualTaskItem>`) to use this package.</br>Below is an example for building  **list of AnnualTaskItem**.
```dart
//AnnualTaskItem
<user_item_list>.map(
          (item) => AnnualTaskItem(
            DateTime.now(),
            0.5,
          ),
        )
        .toList();
        
//AnnualTaskColorItem
<user_item_list>.map(
          (item) => AnnualTaskColorItem(
            DateTime.now(),
            color: <color_for_each_item>
          ),
        )
        .toList();
```
##Examples
###Cell Shape
Specify cellShape with `AnnualTaskCellShape` with `AnnualTaskCellShape.ROUNDED_CIRCLE`(default), `AnnualTaskCellShape.SQUARE` or `AnnualTaskCellShape.CIRCLE`.

**Square**

| ![Image](./example/assets/example_cellshape_square.png) |
| :---: |
| square |
```dart
AnnualTaskView(
    taskItem, // List<AnnualTaskItem>
	cellShape: AnnualTaskCellShape.SQUARE,
)
```
**Circle**

| ![Image](./example/assets/example_cellshape_circle.png) |
| :---: |
| circle |

```dart
AnnualTaskView(
    taskItem, // List<AnnualTaskItem>
	cellShape: AnnualTaskCellShape.CIRCLE,
)
```

**AnnualTaskColorItem**

| ![Image](./example/assets/example_cellshape_coloritem.png) |
| :---: |
| circle |

```dart
AnnualTaskView(
    taskItem, // List<AnnualTaskColorItem>
)
```

### Labels
You can edit the **labels of week** or the **labels of month**.
```dart
AnnualTaskView(
  taskItem, // List<AnnualTaskItem>
  showMonthLabel: false, //default : true
  showWeekDayLabel: false, //default : true
)
```

| ![Image](./example/assets/example_label_without.png) |
| :---: |
| without labels |

**Custom label**
```dart
AnnualTaskView(
  taskItem, // List<AnnualTaskItem>
  weekDayLabels: ['', 'Mon', '', 'Wed', '', 'Fri', ''],
  monthLabels: ['1','2','3','4','5','6','7','8','9','10','11','12'],
)
```
The type of `weekDayLabels` and `monthLabels` is `List<String>`.

You can also hide the lable of each items with empty String(`''`). However, `weekDayLabels` should be **length of 7** and, `monthLabels` should be **length of 12**.  <br/>- `weekDayLables` starts from Sunday.<br/>- default value of `weekDayLables' is ['S', 'M', 'T', 'W', 'T', 'F', 'S'].
<br/>- default value of `monthLabels' is `['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']`.

