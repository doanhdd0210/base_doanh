// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

export 'package:flutter/foundation.dart' show TargetPlatform;

enum MaxLengthEnforcement {
  none,
  enforced,
  truncateAfterCompositionEnds,
}
abstract class TextInputFormatter {
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  );
  static TextInputFormatter withFunction(
    TextInputFormatFunction formatFunction,
  ) {
    return _SimpleTextInputFormatter(formatFunction);
  }
}

typedef TextInputFormatFunction = TextEditingValue Function(
  TextEditingValue oldValue,
  TextEditingValue newValue,
);

class _SimpleTextInputFormatter extends TextInputFormatter {
  _SimpleTextInputFormatter(this.formatFunction);

  final TextInputFormatFunction formatFunction;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return formatFunction(oldValue, newValue);
  }
}

class _MutableTextRange {
  _MutableTextRange(this.base, this.extent);

  static _MutableTextRange? fromComposingRange(TextRange range) {
    return range.isValid && !range.isCollapsed
        ? _MutableTextRange(range.start, range.end)
        : null;
  }

  static _MutableTextRange? fromTextSelection(TextSelection selection) {
    return selection.isValid
        ? _MutableTextRange(selection.baseOffset, selection.extentOffset)
        : null;
  }

  int base;
  int extent;
}

class _TextEditingValueAccumulator {
  _TextEditingValueAccumulator(this.inputValue)
      : selection = _MutableTextRange.fromTextSelection(inputValue.selection),
        composingRegion =
            _MutableTextRange.fromComposingRange(inputValue.composing);

  final TextEditingValue inputValue;
  final StringBuffer stringBuffer = StringBuffer();
  final _MutableTextRange? selection;
  final _MutableTextRange? composingRegion;
  bool debugFinalized = false;

  TextEditingValue finalize() {
    debugFinalized = true;
    final _MutableTextRange? selection = this.selection;
    final _MutableTextRange? composingRegion = this.composingRegion;
    return TextEditingValue(
      text: stringBuffer.toString(),
      composing: composingRegion == null ||
              composingRegion.base == composingRegion.extent
          ? TextRange.empty
          : TextRange(start: composingRegion.base, end: composingRegion.extent),
      selection: selection == null
          ? const TextSelection.collapsed(offset: -1)
          : TextSelection(
              baseOffset: selection.base,
              extentOffset: selection.extent,
              affinity: inputValue.selection.affinity,
              isDirectional: inputValue.selection.isDirectional,
            ),
    );
  }
}

class FilteringTextInputFormatter extends TextInputFormatter {

  FilteringTextInputFormatter(
    this.filterPattern, {
    required this.allow,
    this.replacementString = '',
  });
  FilteringTextInputFormatter.allow(
    Pattern filterPattern, {
    String replacementString = '',
  }) : this(filterPattern, allow: true, replacementString: replacementString);
  FilteringTextInputFormatter.deny(
    Pattern filterPattern, {
    String replacementString = '',
  }) : this(filterPattern, allow: false, replacementString: replacementString);

  final Pattern filterPattern;

  final bool allow;

  final String replacementString;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    final _TextEditingValueAccumulator formatState =
        _TextEditingValueAccumulator(newValue);
    assert(!formatState.debugFinalized);

    final Iterable<Match> matches = filterPattern.allMatches(newValue.text);
    Match? previousMatch;
    for (final Match match in matches) {
      assert(match.end >= match.start);

      _processRegion(allow, previousMatch?.end ?? 0, match.start, formatState);
      assert(!formatState.debugFinalized);
      _processRegion(!allow, match.start, match.end, formatState);
      assert(!formatState.debugFinalized);

      previousMatch = match;
    }

    _processRegion(
        allow, previousMatch?.end ?? 0, newValue.text.length, formatState);
    assert(!formatState.debugFinalized);
    return formatState.finalize();
  }

  void _processRegion(bool isBannedRegion, int regionStart, int regionEnd,
      _TextEditingValueAccumulator state) {
    final String replacementString = isBannedRegion
        ? (regionStart == regionEnd ? '' : this.replacementString)
        : state.inputValue.text.substring(regionStart, regionEnd);

    state.stringBuffer.write(replacementString);

    if (replacementString.length == regionEnd - regionStart) {
      return;
    }

    int adjustIndex(int originalIndex) {
      final int replacedLength =
          originalIndex <= regionStart && originalIndex < regionEnd
              ? 0
              : replacementString.length;
      final int removedLength = originalIndex.clamp(regionStart, regionEnd) -
          regionStart; // ignore_clamp_double_lint
      return replacedLength - removedLength;
    }

    state.selection?.base += adjustIndex(state.inputValue.selection.baseOffset);
    state.selection?.extent +=
        adjustIndex(state.inputValue.selection.extentOffset);
    state.composingRegion?.base +=
        adjustIndex(state.inputValue.composing.start);
    state.composingRegion?.extent +=
        adjustIndex(state.inputValue.composing.end);
  }

  static final TextInputFormatter singleLineFormatter =
      FilteringTextInputFormatter.deny('\n');

  static final TextInputFormatter digitsOnly =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
}
class LengthLimitingTextInputFormatter extends TextInputFormatter {
  LengthLimitingTextInputFormatter(
    this.maxLength, {
    this.maxLengthEnforcement,
  }) : assert(maxLength == null || maxLength == -1 || maxLength > 0);
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  static MaxLengthEnforcement getDefaultMaxLengthEnforcement([
    TargetPlatform? platform,
  ]) {
    if (kIsWeb) {
      return MaxLengthEnforcement.truncateAfterCompositionEnds;
    } else {
      switch (platform ?? defaultTargetPlatform) {
        case TargetPlatform.android:
        case TargetPlatform.windows:
          return MaxLengthEnforcement.enforced;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
        case TargetPlatform.linux:
        case TargetPlatform.fuchsia:
          return MaxLengthEnforcement.truncateAfterCompositionEnds;
      }
    }
  }
  @visibleForTesting
  static TextEditingValue truncate(TextEditingValue value, int maxLength) {
    final CharacterRange iterator = CharacterRange(value.text);
    if (value.text.characters.length > maxLength) {
      iterator.expandNext(maxLength);
    }
    final String truncated = iterator.current;

    return TextEditingValue(
      text: truncated,
      selection: value.selection.copyWith(
        baseOffset: math.min(value.selection.start, truncated.length),
        extentOffset: math.min(value.selection.end, truncated.length),
      ),
      composing: !value.composing.isCollapsed &&
              truncated.length > value.composing.start
          ? TextRange(
              start: value.composing.start,
              end: math.min(value.composing.end, truncated.length),
            )
          : TextRange.empty,
    );
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int? maxLength = this.maxLength;

    if (maxLength == null ||
        maxLength == -1 ||
        newValue.text.characters.length <= maxLength) {
      return newValue;
    }

    assert(maxLength > 0);

    switch (maxLengthEnforcement ?? getDefaultMaxLengthEnforcement()) {
      case MaxLengthEnforcement.none:
        return newValue;
      case MaxLengthEnforcement.enforced:
        // If already at the maximum and tried to enter even more, and has no
        // selection, keep the old value.
        if (oldValue.text.characters.length == maxLength &&
            oldValue.selection.isCollapsed) {
          return oldValue;
        }

        // Enforced to return a truncated value.
        return truncate(newValue, maxLength);
      case MaxLengthEnforcement.truncateAfterCompositionEnds:
        // If already at the maximum and tried to enter even more, and the old
        // value is not composing, keep the old value.
        if (oldValue.text.characters.length == maxLength &&
            !oldValue.composing.isValid) {
          return oldValue;
        }

        // Temporarily exempt `newValue` from the maxLength limit if it has a
        // composing text going and no enforcement to the composing value, until
        // the composing is finished.
        if (newValue.composing.isValid) {
          return newValue;
        }

        return truncate(newValue, maxLength);
    }
  }
}
