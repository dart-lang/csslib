// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// Generated by scripts/tokenizer_gen.py.

part of csslib.parser;

/** Tokenizer state to support look ahead for Less' nested selectors. */
class TokenizerState {
  final int index;
  final int startIndex;
  final bool inSelectorExpression;
  final bool inSelector;

  TokenizerState(TokenizerBase base)
      : index = base._index,
        startIndex = base._startIndex,
        inSelectorExpression = base.inSelectorExpression,
        inSelector = base.inSelector;
}

/**
 * The base class for our tokenizer. The hand coded parts are in this file, with
 * the generated parts in the subclass Tokenizer.
 */
abstract class TokenizerBase {
  final SourceFile _file;
  final String _text;

  bool _inString;

  /**
   * Changes tokenization when in a pseudo function expression.  If true then
   * minus signs are handled as operators instead of identifiers.
   */
  bool inSelectorExpression = false;

  /**
   * Changes tokenization when in selectors. If true, it prevents identifiers
   * from being treated as units. This would break things like ":lang(fr)" or
   * the HTML (unknown) tag name "px", which is legal to use in a selector.
   */
  // TODO(jmesserly): is this a problem elsewhere? "fr" for example will be
  // processed as a "fraction" unit token, preventing it from working in
  // places where an identifier is expected. This was breaking selectors like:
  //     :lang(fr)
  // The assumption that "fr" always means fraction (and similar issue with
  // other units) doesn't seem valid. We probably should defer this
  // analysis until we reach places in the parser where units are expected.
  // I'm not sure this is tokenizing as described in the specs:
  //     http://dev.w3.org/csswg/css-syntax/
  //     http://dev.w3.org/csswg/selectors4/
  bool inSelector = false;

  int _index = 0;
  int _startIndex = 0;

  TokenizerBase(this._file, this._text, this._inString, [this._index = 0]);

  Token next();
  int getIdentifierKind();

  /** Snapshot of Tokenizer scanning state. */
  TokenizerState get mark => new TokenizerState(this);

  /** Restore Tokenizer scanning state. */
  void restore(TokenizerState markedData) {
    _index = markedData.index;
    _startIndex = markedData.startIndex;
    inSelectorExpression = markedData.inSelectorExpression;
    inSelector = markedData.inSelector;
  }

  int _nextChar() {
    if (_index < _text.length) {
      return _text.codeUnitAt(_index++);
    } else {
      return 0;
    }
  }

  int _peekChar() {
    if (_index < _text.length) {
      return _text.codeUnitAt(_index);
    } else {
      return 0;
    }
  }

  bool _maybeEatChar(int ch) {
    if (_index < _text.length) {
      if (_text.codeUnitAt(_index) == ch) {
        _index++;
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Token _finishToken(int kind) {
    return new Token(kind, _file.span(_startIndex, _index));
  }

  Token _errorToken([String message = null]) {
    return new ErrorToken(
        TokenKind.ERROR, _file.span(_startIndex, _index), message);
  }

  Token finishWhitespace() {
    _index--;
    while (_index < _text.length) {
      final ch = _text.codeUnitAt(_index++);
      if (ch == TokenChar.SPACE ||
          ch == TokenChar.TAB ||
          ch == TokenChar.RETURN) {
        // do nothing
      } else if (ch == TokenChar.NEWLINE) {
        if (!_inString) {
          return _finishToken(TokenKind.WHITESPACE); // note the newline?
        }
      } else {
        _index--;
        if (_inString) {
          return next();
        } else {
          return _finishToken(TokenKind.WHITESPACE);
        }
      }
    }
    return _finishToken(TokenKind.END_OF_FILE);
  }

  Token finishMultiLineComment() {
    int nesting = 1;
    do {
      int ch = _nextChar();
      if (ch == 0) {
        return _errorToken();
      } else if (ch == TokenChar.ASTERISK) {
        if (_maybeEatChar(TokenChar.SLASH)) {
          nesting--;
        }
      } else if (ch == TokenChar.SLASH) {
        if (_maybeEatChar(TokenChar.ASTERISK)) {
          nesting++;
        }
      }
    } while (nesting > 0);

    if (_inString) {
      return next();
    } else {
      return _finishToken(TokenKind.COMMENT);
    }
  }

  void eatDigits() {
    while (_index < _text.length) {
      if (TokenizerHelpers.isDigit(_text.codeUnitAt(_index))) {
        _index++;
      } else {
        return;
      }
    }
  }

  static int _hexDigit(int c) {
    if (c >= 48 /*0*/ && c <= 57 /*9*/) {
      return c - 48;
    } else if (c >= 97 /*a*/ && c <= 102 /*f*/) {
      return c - 87;
    } else if (c >= 65 /*A*/ && c <= 70 /*F*/) {
      return c - 55;
    } else {
      return -1;
    }
  }

  int readHex([int hexLength]) {
    int maxIndex;
    if (hexLength == null) {
      maxIndex = _text.length - 1;
    } else {
      // TODO(jimhug): What if this is too long?
      maxIndex = _index + hexLength;
      if (maxIndex >= _text.length) return -1;
    }
    var result = 0;
    while (_index < maxIndex) {
      final digit = _hexDigit(_text.codeUnitAt(_index));
      if (digit == -1) {
        if (hexLength == null) {
          return result;
        } else {
          return -1;
        }
      }
      _hexDigit(_text.codeUnitAt(_index));
      // Multiply by 16 rather than shift by 4 since that will result in a
      // correct value for numbers that exceed the 32 bit precision of JS
      // 'integers'.
      // TODO: Figure out a better solution to integer truncation. Issue 638.
      result = (result * 16) + digit;
      _index++;
    }

    return result;
  }

  Token finishNumber() {
    eatDigits();

    if (_peekChar() == TokenChar.DOT) {
      // Handle the case of 1.toString().
      _nextChar();
      if (TokenizerHelpers.isDigit(_peekChar())) {
        eatDigits();
        return finishNumberExtra(TokenKind.DOUBLE);
      } else {
        _index--;
      }
    }

    return finishNumberExtra(TokenKind.INTEGER);
  }

  Token finishNumberExtra(int kind) {
    if (_maybeEatChar(101 /*e*/) || _maybeEatChar(69 /*E*/)) {
      kind = TokenKind.DOUBLE;
      _maybeEatChar(TokenKind.MINUS);
      _maybeEatChar(TokenKind.PLUS);
      eatDigits();
    }
    if (_peekChar() != 0 && TokenizerHelpers.isIdentifierStart(_peekChar())) {
      _nextChar();
      return _errorToken("illegal character in number");
    }

    return _finishToken(kind);
  }

  Token _makeStringToken(List<int> buf, bool isPart) {
    final s = new String.fromCharCodes(buf);
    final kind = isPart ? TokenKind.STRING_PART : TokenKind.STRING;
    return new LiteralToken(kind, _file.span(_startIndex, _index), s);
  }

  Token makeIEFilter(int start, int end) {
    var filter = _text.substring(start, end);
    return new LiteralToken(TokenKind.STRING, _file.span(start, end), filter);
  }

  Token _makeRawStringToken(bool isMultiline) {
    var s;
    if (isMultiline) {
      // Skip initial newline in multiline strings
      int start = _startIndex + 4;
      if (_text[start] == '\n') start++;
      s = _text.substring(start, _index - 3);
    } else {
      s = _text.substring(_startIndex + 2, _index - 1);
    }
    return new LiteralToken(
        TokenKind.STRING, _file.span(_startIndex, _index), s);
  }

  Token finishMultilineString(int quote) {
    var buf = <int>[];
    while (true) {
      int ch = _nextChar();
      if (ch == 0) {
        return _errorToken();
      } else if (ch == quote) {
        if (_maybeEatChar(quote)) {
          if (_maybeEatChar(quote)) {
            return _makeStringToken(buf, false);
          }
          buf.add(quote);
        }
        buf.add(quote);
      } else if (ch == TokenChar.BACKSLASH) {
        var escapeVal = readEscapeSequence();
        if (escapeVal == -1) {
          return _errorToken("invalid hex escape sequence");
        } else {
          buf.add(escapeVal);
        }
      } else {
        buf.add(ch);
      }
    }
  }

  Token finishString(int quote) {
    if (_maybeEatChar(quote)) {
      if (_maybeEatChar(quote)) {
        // skip an initial newline
        _maybeEatChar(TokenChar.NEWLINE);
        return finishMultilineString(quote);
      } else {
        return _makeStringToken(new List<int>(), false);
      }
    }
    return finishStringBody(quote);
  }

  Token finishRawString(int quote) {
    if (_maybeEatChar(quote)) {
      if (_maybeEatChar(quote)) {
        return finishMultilineRawString(quote);
      } else {
        return _makeStringToken(<int>[], false);
      }
    }
    while (true) {
      int ch = _nextChar();
      if (ch == quote) {
        return _makeRawStringToken(false);
      } else if (ch == 0) {
        return _errorToken();
      }
    }
  }

  Token finishMultilineRawString(int quote) {
    while (true) {
      int ch = _nextChar();
      if (ch == 0) {
        return _errorToken();
      } else if (ch == quote && _maybeEatChar(quote) && _maybeEatChar(quote)) {
        return _makeRawStringToken(true);
      }
    }
  }

  Token finishStringBody(int quote) {
    var buf = new List<int>();
    while (true) {
      int ch = _nextChar();
      if (ch == quote) {
        return _makeStringToken(buf, false);
      } else if (ch == 0) {
        return _errorToken();
      } else if (ch == TokenChar.BACKSLASH) {
        var escapeVal = readEscapeSequence();
        if (escapeVal == -1) {
          return _errorToken("invalid hex escape sequence");
        } else {
          buf.add(escapeVal);
        }
      } else {
        buf.add(ch);
      }
    }
  }

  int readEscapeSequence() {
    final ch = _nextChar();
    int hexValue;
    switch (ch) {
      case 110 /*n*/ :
        return TokenChar.NEWLINE;
      case 114 /*r*/ :
        return TokenChar.RETURN;
      case 102 /*f*/ :
        return TokenChar.FF;
      case 98 /*b*/ :
        return TokenChar.BACKSPACE;
      case 116 /*t*/ :
        return TokenChar.TAB;
      case 118 /*v*/ :
        return TokenChar.FF;
      case 120 /*x*/ :
        hexValue = readHex(2);
        break;
      case 117 /*u*/ :
        if (_maybeEatChar(TokenChar.LBRACE)) {
          hexValue = readHex();
          if (!_maybeEatChar(TokenChar.RBRACE)) {
            return -1;
          }
        } else {
          hexValue = readHex(4);
        }
        break;
      default:
        return ch;
    }

    if (hexValue == -1) return -1;

    // According to the Unicode standard the high and low surrogate halves
    // used by UTF-16 (U+D800 through U+DFFF) and values above U+10FFFF
    // are not legal Unicode values.
    if (hexValue < 0xD800 || hexValue > 0xDFFF && hexValue <= 0xFFFF) {
      return hexValue;
    } else if (hexValue <= 0x10FFFF) {
      messages.error('unicode values greater than 2 bytes not implemented yet',
          _file.span(_startIndex, _startIndex + 1));
      return -1;
    } else {
      return -1;
    }
  }

  Token finishDot() {
    if (TokenizerHelpers.isDigit(_peekChar())) {
      eatDigits();
      return finishNumberExtra(TokenKind.DOUBLE);
    } else {
      return _finishToken(TokenKind.DOT);
    }
  }
}
