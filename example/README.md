# BS Popover Menu

A lightweight Flutter popover menu that appears on button click, automatically positioning itself above or below the button.

## Example

```dart
PopoverMenu.show(
  context: context,
  items: [
    MenuItemModel(icon: Icon(Icons.insert_drive_file), title: "Document", onTap: () {}),
    MenuItemModel(icon: Icon(Icons.photo), title: "Photos & Videos", onTap: () {}),
  ],
);
