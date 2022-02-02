import 'package:elite_counsel/chat/type/flutter_chat_types.dart' as types;
import 'package:flutter/widgets.dart';

/// Used to make provided [types.User] class available through the whole package
class InheritedUser extends InheritedWidget {
  /// Creates [InheritedWidget] from a provided [types.User] class
  const InheritedUser({
    Key key,
    @required this.user,
    @required Widget child,
  }) : super(key: key, child: child);

  /// Represents current logged in user. Used to determine message's author.
  final types.User user;

  static InheritedUser of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedUser>();
  }

  @override
  bool updateShouldNotify(InheritedUser oldWidget) =>
      user.id != oldWidget.user.id;
}
