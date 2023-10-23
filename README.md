# Flexible Dropdown Package

Support multi platform

## Features

* Customize dropdown

* Auto scroll to selected item position

* Support `BarrierShape.headerTrans` to highlight the content above the flexible dropdown button

* Allows the dropdown to be dismissed by tapping | panning the scrim or by pressing the escape key on the keyboard.

## Installation

First, add `flexible_dropdown` as a [dependency in your pubspec.yaml file](https://flutter.dev/using-packages/).

```yaml
dependencies
  flexible_dropdown: ^1.1.2
```

## Usage

```dart
FlexibleDropdown(
  overlayChild: Container(
    height: 160,
    width: double.infinity,
    color: Colors.deepPurple,
  ),
  barrierColor: Colors.black38.withOpacity(.2),
  barrierShape: BarrierShape.headerTrans,
  textDirection: TextDirection.ltr,
  offset: Offset.zero,
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      color: Colors.blueAccent.withOpacity(.2),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
  ),
)
```

<video src="assets/example1.mp4" controls title="Title"></video>
