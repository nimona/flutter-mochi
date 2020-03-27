import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menu/menu.dart';
import 'package:mochi/data/repository.dart';
import 'package:mochi/view/dialog_create_contact.dart';

class ParticipantName extends StatelessWidget {
  const ParticipantName({
    Key key,
    @required this.context,
    @required this.profileKey,
    @required this.nameFirst,
    @required this.nameLast,
    @required this.alias,
    @required this.textTheme,
  }) : super(key: key);

  final BuildContext context;
  final String profileKey;
  final String nameFirst;
  final String nameLast;
  final String alias;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    var displayName = "";
    var children = <TextSpan>[];

    if (nameFirst != "") {
      displayName = nameFirst;
    }

    if (nameLast != "") {
      if (displayName != "") {
        displayName = displayName + " ";
      }
      displayName = displayName + nameLast;
    }

    var updateContactAlias = "";
    var updateContact = false;

    if (alias != "") {
      updateContact = true;
      updateContactAlias = alias;
      children.add(
        new TextSpan(
          text: alias + " ",
          style: TextStyle(
            color: Colors.blueAccent,
          ),
        ),
      );
    }

    if (displayName != "") {
      children.add(
        new TextSpan(
          text: displayName + " ",
          style: textTheme.caption,
        ),
      );
    }

    void _showCreateContactDialog(String key, alias) {
      final aliasController = TextEditingController(
        text: alias,
      );
      final publicKeyController = TextEditingController(
        text: key,
      );
      showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return CreateContactDialog(
            aliasController: aliasController,
            publicKeyController: publicKeyController,
            updateContact: updateContact,
          );
        },
      ).then<void>(
        (bool userClickedSave) {
          if (userClickedSave == true && aliasController.text.isNotEmpty) {
            if (updateContact) {
              Repository.get().updateContact(
                publicKeyController.text,
                aliasController.text,
              );
            } else {
              Repository.get().createContact(
                publicKeyController.text,
                aliasController.text,
              );
            }
          }
        },
      );
    }

    Widget m = new Menu(
      clickType: ClickType.click,
      items: [
        MenuItem(
          () {
            if (updateContact) {
              return "update contact for " + updateContactAlias;
            }
            return "add " + updateContactAlias + "as contact";
          }(),
          () {
            _showCreateContactDialog(
              profileKey,
              updateContactAlias,
            );
          },
        ),
        MenuItem("copy key", () {
          Clipboard.setData(
            ClipboardData(
              text: profileKey,
            ),
          );
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Public key copied'),
              duration: Duration(seconds: 1),
              action: SnackBarAction(
                label: 'Ok',
                onPressed: () {},
              ),
            ),
          );
        })
      ],
      decoration: MenuDecoration(
        color: Colors.blueAccent,
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(),
      ),
      child: new RichText(
        text: new TextSpan(
          children: children,
        ),
      ),
    );

    return m;
  }
}
