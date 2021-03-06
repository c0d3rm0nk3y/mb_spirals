part of mb;

class Board {

  static const int INTERVAL = 8; // ms

  CanvasRenderingContext2D context;

  int width;
  int height;

  List<Box> boxes;
  List<Line> lines;

  Box beforeLastBoxClicked;
  Box lastBoxClicked;

  MenuBar menuBar;
  ToolBar toolBar;

  Board(CanvasElement canvas) {
    context = canvas.getContext("2d");
    width = canvas.width;
    height = canvas.height;
    border();

    boxes = new List();
    lines = new List();

    menuBar = new MenuBar(this);
    toolBar = new ToolBar(this);

    // Canvas event
    document.querySelector('#canvas').onMouseDown.listen(onMouseDown);
    // Redraw every INTERVAL ms.
    new Timer.periodic(const Duration(milliseconds: INTERVAL), (t) => redraw());
  }

  void border() {
    context.beginPath();
    context.rect(0, 0, width, height);
    context.closePath();
    context.stroke();
  }

  void clear() {
    context.clearRect(0, 0, width, height);
    border();
  }

  void redraw() {
    clear();
    for (Box box in boxes) {
      box.draw();
    }
    for (Line line in lines) {
      line.draw();
    }
  }

  void createBoxes(int n) {
    int x = 0; int y = 0;
    for (int i = 0; i < n; i++) {
      boxes.add(new Box(this, x, y, Box.DEFAULT_WIDTH, Box.DEFAULT_HEIGHT));
      x = x + Box.DEFAULT_WIDTH;
      y = y + Box.DEFAULT_HEIGHT;
    }
  }

  void deleteBoxes() {
    boxes.clear();
  }

  void deleteSelectedBoxes() {
    for (Box box in boxes.toList()) {
      if (box.isSelected()) {
        boxes.remove(box);
      }
    }
  }

  void selectBoxes() {
    for (Box box in boxes) {
      box.select();
    }
  }

  void deselectBoxes() {
    for (Box box in boxes) {
      box.deselect();
    }
  }

  void hideSelectedBoxes() {
    for (Box box in boxes) {
      if (box.isSelected()) {
        box.hide();
      }
    }
  }

  void showHiddenBoxes() {
    for (Box box in boxes) {
      if (box.isHidden()) {
        box.show();
      }
    }
  }

  int get nextBoxNo => boxes.length + 1;

  int countSelectedBoxes() {
    int count = 0;
    for (Box box in boxes) {
      if (box.isSelected()) {
        count++;
      }
    }
    return count;
  }

  int countSelectedBoxesContain(int pointX, int pointY) {
    int count = 0;
    for (Box box in boxes) {
      if (box.isSelected() && box.contains(pointX, pointY)) {
        count++;
      }
    }
    return count;
  }

  void onMouseDown(MouseEvent e) {
    bool clickedOnBox = false;
    for (Box box in boxes) {
      if (box.contains(e.offset.x, e.offset.y)) {
        clickedOnBox = true;
        break;
      }
    }

    if (!clickedOnBox) {
      if (toolBar.isSelectToolOn()) {
        deselectBoxes();
      } else if (toolBar.isBoxToolOn()) {
        Box box = new Box(this, e.offset.x, e.offset.y,
            Box.DEFAULT_WIDTH, Box.DEFAULT_HEIGHT);
        if (e.offset.x + box.width > width) {
          box.x = width - box.width - 1;
        }
        if (e.offset.y + box.height > height) {
          box.y = height - box.height - 1;
        }
        boxes.add(box);
        toolBar.selectToolOn();
      } else if (toolBar.isLineToolOn()) {
        if (beforeLastBoxClicked != null && lastBoxClicked != null) {
          Line line = new Line(this, beforeLastBoxClicked, lastBoxClicked);
          lines.add(line);
        }
        toolBar.selectToolOn();
      }
    }
  }

}
