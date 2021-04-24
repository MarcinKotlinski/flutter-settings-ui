import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/src/cupertino_settings_item.dart';

import 'defines.dart';

enum _SettingsTileType { simple, switchTile }

class SettingsTile extends StatelessWidget {
  final String title;
  final String semanticsLabel;
  final String semanticsHint;
  final String semanticsValue;
  final int titleMaxLines;
  final String subtitle;
  final int subtitleMaxLines;
  final Widget leading;
  final Widget trailing;
  final Icon iosChevron;
  final EdgeInsetsGeometry iosChevronPadding;
  final VoidCallback onTap;
  final Function(BuildContext context) onPressed;
  final Function(bool value) onToggle;
  final bool switchValue;
  final bool enabled;
  final TextStyle titleTextStyle;
  final TextStyle subtitleTextStyle;
  final Color switchActiveColor;
  final _SettingsTileType _tileType;

  const SettingsTile({
    Key key,
    @required this.title,
    this.semanticsLabel,
    this.semanticsHint,
    this.semanticsValue,
    this.titleMaxLines,
    this.subtitle,
    this.subtitleMaxLines,
    this.leading,
    this.trailing,
    this.iosChevron = defaultCupertinoForwardIcon,
    this.iosChevronPadding = defaultCupertinoForwardPadding,
    @Deprecated('Use onPressed instead') this.onTap,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.enabled = true,
    this.onPressed,
    this.switchActiveColor,
  })  : _tileType = _SettingsTileType.simple,
        onToggle = null,
        switchValue = null,
        assert(titleMaxLines == null || titleMaxLines > 0),
        assert(subtitleMaxLines == null || subtitleMaxLines > 0),
        super(key: key);

  const SettingsTile.switchTile({
    Key key,
    @required this.title,
    this.semanticsLabel,
    this.semanticsHint,
    this.semanticsValue,
    this.titleMaxLines,
    this.subtitle,
    this.subtitleMaxLines,
    this.leading,
    this.enabled = true,
    this.trailing,
    @required this.onToggle,
    @required this.switchValue,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.switchActiveColor,
  })  : _tileType = _SettingsTileType.switchTile,
        onTap = null,
        onPressed = null,
        iosChevron = null,
        iosChevronPadding = null,
        assert(titleMaxLines == null || titleMaxLines > 0),
        assert(subtitleMaxLines == null || subtitleMaxLines > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return iosTile(context);
    } else {
      return androidTile(context);
    }
  }

  Widget iosTile(BuildContext context) {
    if (_tileType == _SettingsTileType.switchTile) {
      return Semantics(
        label: semanticsLabel,
        hint: semanticsHint,
        value: semanticsValue,
        child: CupertinoSettingsItem(
          enabled: enabled,
          type: SettingsItemType.toggle,
          label: title,
          labelMaxLines: titleMaxLines,
          leading: leading,
          subtitle: subtitle,
          subtitleMaxLines: subtitleMaxLines,
          switchValue: switchValue,
          onToggle: onToggle,
          labelTextStyle: titleTextStyle,
          switchActiveColor: switchActiveColor,
          subtitleTextStyle: subtitleTextStyle,
          valueTextStyle: subtitleTextStyle,
          trailing: trailing,
        ),
      );
    } else {
      return Semantics(
        label: semanticsLabel,
        hint: semanticsHint,
        value: semanticsValue,
        child: ExcludeSemantics(
          child: CupertinoSettingsItem(
            enabled: enabled,
            type: SettingsItemType.modal,
            label: title,
            labelMaxLines: titleMaxLines,
            value: subtitle,
            trailing: trailing,
            iosChevron: iosChevron,
            iosChevronPadding: iosChevronPadding,
            hasDetails: false,
            leading: leading,
            onPress: onTapFunction(context),
            labelTextStyle: titleTextStyle,
            subtitleTextStyle: subtitleTextStyle,
            valueTextStyle: subtitleTextStyle,
          ),
        ),
      );
    }
  }

  Widget androidTile(BuildContext context) {
    if (_tileType == _SettingsTileType.switchTile) {
      return Semantics(
        label: semanticsLabel,
        hint: semanticsHint,
        value: semanticsValue,
        child: SwitchListTile(
          secondary: leading,
          value: switchValue,
          activeColor: switchActiveColor,
          onChanged: enabled ? onToggle : null,
          title: Text(
            title,
            style: titleTextStyle,
            maxLines: titleMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: subtitleTextStyle,
                  maxLines: subtitleMaxLines,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
        ),
      );
    } else {
      return Semantics(
        label: semanticsLabel,
        hint: semanticsHint,
        value: semanticsValue,
        child: ExcludeSemantics(
          child: ListTile(
            title: Text(title, style: titleTextStyle),
            subtitle: subtitle != null
                ? Text(
                    subtitle,
                    style: subtitleTextStyle,
                    maxLines: subtitleMaxLines,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            leading: leading,
            enabled: enabled,
            trailing: trailing,
            onTap: onTapFunction(context),
          ),
        ),
      );
    }
  }

  Function onTapFunction(BuildContext context) =>
      onTap != null || onPressed != null
          ? () {
              if (onPressed != null) {
                onPressed.call(context);
              } else {
                onTap.call();
              }
            }
          : null;
}
