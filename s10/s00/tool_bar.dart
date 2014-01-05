part of mb;

class ToolBar {

  static const int SELECT = 1;
  static const int BOX = 2;
  static const int LINE = 3;

  final Board board;

  int _onTool;
  int _fixedTool;

  ButtonElement selectButton;
  ButtonElement boxButton;
  ButtonElement lineButton;

  InputElement boxNameInput;
  InputElement itemNameInput;
  SelectElement itemOption;
  ButtonElement addItemButton;
  ButtonElement getItemButton;
  ButtonElement setItemButton;
  ButtonElement removeItemButton;

  Item currentItem;

  LabelElement line12Box1Label;
  LabelElement line12Box2Label;
  InputElement line12MinInput;
  InputElement line12MaxInput;
  InputElement line12IdCheckbox;
  InputElement line12NameInput;

  LabelElement line21Box2Label;
  LabelElement line21Box1Label;
  InputElement line21MinInput;
  InputElement line21MaxInput;
  InputElement line21IdCheckbox;
  InputElement line21NameInput;

  ButtonElement getLineButton;
  ButtonElement setLineButton;

  ToolBar(this.board) {
    selectButton = document.querySelector('#select');
    boxButton = document.querySelector('#box');
    lineButton = document.querySelector('#line');

    // Tool bar events.
    selectButton.onClick.listen((MouseEvent e) {
      onTool(SELECT);
    });
    selectButton.onDoubleClick.listen((MouseEvent e) {
      onTool(SELECT);
      _fixedTool = SELECT;
    });

    boxButton.onClick.listen((MouseEvent e) {
      onTool(BOX);
    });
    boxButton.onDoubleClick.listen((MouseEvent e) {
      onTool(BOX);
      _fixedTool = BOX;
    });

    lineButton.onClick.listen((MouseEvent e) {
      onTool(LINE);
    });
    lineButton.onDoubleClick.listen((MouseEvent e) {
      onTool(LINE);
      _fixedTool = LINE;
    });

    onTool(SELECT);
    _fixedTool = SELECT;

    boxNameInput = document.querySelector('#boxName');
    boxNameInput.onFocus.listen((Event e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        boxNameInput.value = box.title;
      }
    });
    boxNameInput.onInput.listen((Event e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        box.title = boxNameInput.value;
      }
    });

    itemNameInput = document.querySelector('#itemName');

    itemOption = document.querySelector('#itemCategory');

    addItemButton = document.querySelector('#addItem');
    addItemButton.onClick.listen((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        currentItem = new Item(box, itemNameInput.value, itemOption.value);
        itemNameInput.select();
      }
    });

    getItemButton = document.querySelector('#getItem');
    getItemButton.onClick.listen((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        Item item = box.findItem(itemNameInput.value);
        if (item != null) {
          currentItem = item;
          itemNameInput.value = item.name;
          itemOption.value = item.category;
          itemNameInput.select();
        } else {
          currentItem = null;
        }
      }
    });

    setItemButton = document.querySelector('#setItem');
    setItemButton.onClick.listen((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          currentItem.name = itemNameInput.value;
          currentItem.category = itemOption.value;
          itemNameInput.select();
        }
      }
    });

    removeItemButton = document.querySelector('#removeItem');
    removeItemButton.onClick.listen((MouseEvent e) {
      Box box = board.lastBoxSelected;
      if (box != null) {
        if (currentItem != null) {
          if (box.removeItem(currentItem)) {
            currentItem = null;
            itemNameInput.value = '';
            itemOption.value = 'attribute';
          }
        }
      }
    });

    line12Box1Label = document.querySelector('#line12Box1');
    line12Box2Label = document.querySelector('#line12Box2');
    line12MinInput = document.querySelector('#line12Min');
    line12MaxInput = document.querySelector('#line12Max');
    line12IdCheckbox = document.querySelector('#line12Id');
    line12NameInput = document.querySelector('#line12Name');

    line21Box2Label = document.querySelector('#line21Box2');
    line21Box1Label = document.querySelector('#line21Box1');
    line21MinInput = document.querySelector('#line21Min');
    line21MaxInput = document.querySelector('#line21Max');
    line21IdCheckbox = document.querySelector('#line21Id');
    line21NameInput = document.querySelector('#line21Name');

    getLineButton = document.querySelector('#getLine');
    getLineButton.onClick.listen((MouseEvent e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line12Box1Label.text = line.box1.title;
        line12Box2Label.text = line.box2.title;
        line12MinInput.value = line.box1box2Min;
        line12MaxInput.value = line.box1box2Max;
        line12IdCheckbox.checked = line.box1box2Id;
        line12NameInput.value = line.box1box2Name;

        line21Box2Label.text = line.box2.title;
        line21Box1Label.text = line.box1.title;
        line21MinInput.value = line.box2box1Min;
        line21MaxInput.value = line.box2box1Max;
        line21IdCheckbox.checked = line.box2box1Id;
        line21NameInput.value = line.box2box1Name;
      }
    });

    setLineButton = document.querySelector('#setLine');
    setLineButton.onClick.listen((MouseEvent e) {
      Line line = board.lastLineSelected;
      if (line != null) {
        line.box1box2Min = line12MinInput.value.trim();
        line.box1box2Max = line12MaxInput.value.trim();
        if (line.box1box2Min == '1' && line.box1box2Max == '1') {
          line.box1box2Id = line12IdCheckbox.checked;
        } else {
          line12IdCheckbox.checked = false;
          line.box1box2Id = false;
        }
        line.box1box2Name = line12NameInput.value.trim();

        line.box2box1Min = line21MinInput.value.trim();
        line.box2box1Max = line21MaxInput.value.trim();
        if (line.box2box1Min == '1' && line.box2box1Max == '1') {
          line.box2box1Id = line21IdCheckbox.checked;
        } else {
          line21IdCheckbox.checked = false;
          line.box2box1Id = false;
        }
        line.box2box1Name = line21NameInput.value.trim();
      }
    });
  }

  onTool(int tool) {
    _onTool = tool;
    if (_onTool == SELECT) {
      selectButton.style.borderColor = "#000000"; // black
      boxButton.style.borderColor = "#808080"; // grey
      lineButton.style.borderColor = "#808080"; // grey
    } else if (_onTool == BOX) {
      selectButton.style.borderColor = "#808080"; // grey
      boxButton.style.borderColor = "#000000"; // black
      lineButton.style.borderColor = "#808080"; // grey
    } else if (_onTool == LINE) {
      selectButton.style.borderColor = "#808080"; // grey
      boxButton.style.borderColor = "#808080"; // grey
      lineButton.style.borderColor = "#000000"; // black
    }
  }

  bool isSelectToolOn() {
    if (_onTool == SELECT) {
      return true;
    }
    return false;
  }

  bool isBoxToolOn() {
    if (_onTool == BOX) {
      return true;
    }
    return false;
  }

  bool isLineToolOn() {
    if (_onTool == LINE) {
      return true;
    }
    return false;
  }

  void backToFixedTool()  {
      onTool(_fixedTool);
  }

  void backToSelectAsFixedTool()  {
    onTool(SELECT);
    _fixedTool = SELECT;
  }

}
