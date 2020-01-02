// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:source_span/source_span.dart';
import 'parser.dart';

part 'src/css_printer.dart';
part 'src/tree.dart';
part 'src/tree_base.dart';
part 'src/tree_printer.dart';

abstract class VisitorBase<T> {
  T visitCalcTerm(CalcTerm node);
  T visitCssComment(CssComment node);
  T visitCommentDefinition(CommentDefinition node);
  T visitStyleSheet(StyleSheet node);
  T visitNoOp(NoOp node);
  T visitTopLevelProduction(TopLevelProduction node);
  T visitDirective(Directive node);
  T visitDocumentDirective(DocumentDirective node);
  T visitSupportsDirective(SupportsDirective node);
  T visitSupportsConditionInParens(SupportsConditionInParens node);
  T visitSupportsNegation(SupportsNegation node);
  T visitSupportsConjunction(SupportsConjunction node);
  T visitSupportsDisjunction(SupportsDisjunction node);
  T visitViewportDirective(ViewportDirective node);
  T visitMediaExpression(MediaExpression node);
  T visitMediaQuery(MediaQuery node);
  T visitMediaDirective(MediaDirective node);
  T visitHostDirective(HostDirective node);
  T visitPageDirective(PageDirective node);
  T visitCharsetDirective(CharsetDirective node);
  T visitImportDirective(ImportDirective node);
  T visitKeyFrameDirective(KeyFrameDirective node);
  T visitKeyFrameBlock(KeyFrameBlock node);
  T visitFontFaceDirective(FontFaceDirective node);
  T visitStyletDirective(StyletDirective node);
  T visitNamespaceDirective(NamespaceDirective node);
  T visitVarDefinitionDirective(VarDefinitionDirective node);
  T visitMixinDefinition(MixinDefinition node);
  T visitMixinRulesetDirective(MixinRulesetDirective node);
  T visitMixinDeclarationDirective(MixinDeclarationDirective node);
  T visitIncludeDirective(IncludeDirective node);
  T visitContentDirective(ContentDirective node);

  T visitRuleSet(RuleSet node);
  T visitDeclarationGroup(DeclarationGroup node);
  T visitMarginGroup(MarginGroup node);
  T visitDeclaration(Declaration node);
  T visitVarDefinition(VarDefinition node);
  T visitIncludeMixinAtDeclaration(IncludeMixinAtDeclaration node);
  T visitExtendDeclaration(ExtendDeclaration node);
  T visitSelectorGroup(SelectorGroup node);
  T visitSelector(Selector node);
  T visitSimpleSelectorSequence(SimpleSelectorSequence node);
  T visitSimpleSelector(SimpleSelector node);
  T visitElementSelector(ElementSelector node);
  T visitNamespaceSelector(NamespaceSelector node);
  T visitAttributeSelector(AttributeSelector node);
  T visitIdSelector(IdSelector node);
  T visitClassSelector(ClassSelector node);
  T visitPseudoClassSelector(PseudoClassSelector node);
  T visitPseudoElementSelector(PseudoElementSelector node);
  T visitPseudoClassFunctionSelector(PseudoClassFunctionSelector node);
  T visitPseudoElementFunctionSelector(PseudoElementFunctionSelector node);
  T visitNegationSelector(NegationSelector node);
  T visitSelectorExpression(SelectorExpression node);

  T visitUnicodeRangeTerm(UnicodeRangeTerm node);
  T visitLiteralTerm(LiteralTerm node);
  T visitHexColorTerm(HexColorTerm node);
  T visitNumberTerm(NumberTerm node);
  T visitUnitTerm(UnitTerm node);
  T visitLengthTerm(LengthTerm node);
  T visitPercentageTerm(PercentageTerm node);
  T visitEmTerm(EmTerm node);
  T visitExTerm(ExTerm node);
  T visitAngleTerm(AngleTerm node);
  T visitTimeTerm(TimeTerm node);
  T visitFreqTerm(FreqTerm node);
  T visitFractionTerm(FractionTerm node);
  T visitUriTerm(UriTerm node);
  T visitResolutionTerm(ResolutionTerm node);
  T visitChTerm(ChTerm node);
  T visitRemTerm(RemTerm node);
  T visitViewportTerm(ViewportTerm node);
  T visitFunctionTerm(FunctionTerm node);
  T visitGroupTerm(GroupTerm node);
  T visitItemTerm(ItemTerm node);
  T visitIE8Term(IE8Term node);
  T visitOperatorSlash(OperatorSlash node);
  T visitOperatorComma(OperatorComma node);
  T visitOperatorPlus(OperatorPlus node);
  T visitOperatorMinus(OperatorMinus node);
  T visitVarUsage(VarUsage node);

  T visitExpressions(Expressions node);
  T visitBinaryExpression(BinaryExpression node);
  T visitUnaryExpression(UnaryExpression node);

  T visitIdentifier(Identifier node);
  T visitWildcard(Wildcard node);
  T visitThisOperator(ThisOperator node);
  T visitNegation(Negation node);

  T visitDartStyleExpression(DartStyleExpression node);
  T visitFontExpression(FontExpression node);
  T visitBoxExpression(BoxExpression node);
  T visitMarginExpression(MarginExpression node);
  T visitBorderExpression(BorderExpression node);
  T visitHeightExpression(HeightExpression node);
  T visitPaddingExpression(PaddingExpression node);
  T visitWidthExpression(WidthExpression node);
}

/// Base vistor class for the style sheet AST.
class Visitor implements VisitorBase<void> {
  /// Helper function to walk a list of nodes.
  void _visitNodeList(List<TreeNode> list) {
    // Don't use iterable otherwise the list can't grow while using Visitor.
    // It certainly can't have items deleted before the index being iterated
    // but items could be added after the index.
    for (var index = 0; index < list.length; index++) {
      list[index].visit(this);
    }
  }

  void visitTree(StyleSheet tree) => visitStyleSheet(tree);

  @override
  void visitStyleSheet(StyleSheet ss) {
    _visitNodeList(ss.topLevels);
  }

  @override
  void visitNoOp(NoOp node) {}

  @override
  void visitTopLevelProduction(TopLevelProduction node) {}

  @override
  void visitDirective(Directive node) {}

  @override
  void visitCalcTerm(CalcTerm node) {
    visitLiteralTerm(node);
    visitLiteralTerm(node.expr);
  }

  @override
  void visitCssComment(CssComment node) {}

  @override
  void visitCommentDefinition(CommentDefinition node) {}

  @override
  void visitMediaExpression(MediaExpression node) {
    visitExpressions(node.exprs);
  }

  @override
  void visitMediaQuery(MediaQuery node) {
    for (var mediaExpr in node.expressions) {
      visitMediaExpression(mediaExpr);
    }
  }

  @override
  void visitDocumentDirective(DocumentDirective node) {
    _visitNodeList(node.functions);
    _visitNodeList(node.groupRuleBody);
  }

  @override
  void visitSupportsDirective(SupportsDirective node) {
    node.condition.visit(this);
    _visitNodeList(node.groupRuleBody);
  }

  @override
  void visitSupportsConditionInParens(SupportsConditionInParens node) {
    node.condition.visit(this);
  }

  @override
  void visitSupportsNegation(SupportsNegation node) {
    node.condition.visit(this);
  }

  @override
  void visitSupportsConjunction(SupportsConjunction node) {
    _visitNodeList(node.conditions);
  }

  @override
  void visitSupportsDisjunction(SupportsDisjunction node) {
    _visitNodeList(node.conditions);
  }

  @override
  void visitViewportDirective(ViewportDirective node) {
    node.declarations.visit(this);
  }

  @override
  void visitMediaDirective(MediaDirective node) {
    _visitNodeList(node.mediaQueries);
    _visitNodeList(node.rules);
  }

  @override
  void visitHostDirective(HostDirective node) {
    _visitNodeList(node.rules);
  }

  @override
  void visitPageDirective(PageDirective node) {
    for (var declGroup in node._declsMargin) {
      if (declGroup is MarginGroup) {
        visitMarginGroup(declGroup);
      } else {
        visitDeclarationGroup(declGroup);
      }
    }
  }

  @override
  void visitCharsetDirective(CharsetDirective node) {}

  @override
  void visitImportDirective(ImportDirective node) {
    for (var mediaQuery in node.mediaQueries) {
      visitMediaQuery(mediaQuery);
    }
  }

  @override
  void visitKeyFrameDirective(KeyFrameDirective node) {
    visitIdentifier(node.name);
    _visitNodeList(node._blocks);
  }

  @override
  void visitKeyFrameBlock(KeyFrameBlock node) {
    visitExpressions(node._blockSelectors);
    visitDeclarationGroup(node._declarations);
  }

  @override
  void visitFontFaceDirective(FontFaceDirective node) {
    visitDeclarationGroup(node._declarations);
  }

  @override
  void visitStyletDirective(StyletDirective node) {
    _visitNodeList(node.rules);
  }

  @override
  void visitNamespaceDirective(NamespaceDirective node) {}

  @override
  void visitVarDefinitionDirective(VarDefinitionDirective node) {
    visitVarDefinition(node.def);
  }

  @override
  void visitMixinRulesetDirective(MixinRulesetDirective node) {
    _visitNodeList(node.rulesets);
  }

  @override
  void visitMixinDefinition(MixinDefinition node) {}

  @override
  void visitMixinDeclarationDirective(MixinDeclarationDirective node) {
    visitDeclarationGroup(node.declarations);
  }

  @override
  void visitIncludeDirective(IncludeDirective node) {
    for (var index = 0; index < node.args.length; index++) {
      var param = node.args[index];
      _visitNodeList(param);
    }
  }

  @override
  void visitContentDirective(ContentDirective node) {
    // TODO(terry): TBD
  }

  @override
  void visitRuleSet(RuleSet node) {
    visitSelectorGroup(node._selectorGroup);
    visitDeclarationGroup(node._declarationGroup);
  }

  @override
  void visitDeclarationGroup(DeclarationGroup node) {
    _visitNodeList(node.declarations);
  }

  @override
  void visitMarginGroup(MarginGroup node) => visitDeclarationGroup(node);

  @override
  void visitDeclaration(Declaration node) {
    visitIdentifier(node._property);
    if (node._expression != null) node._expression.visit(this);
  }

  @override
  void visitVarDefinition(VarDefinition node) {
    visitIdentifier(node._property);
    if (node._expression != null) node._expression.visit(this);
  }

  @override
  void visitIncludeMixinAtDeclaration(IncludeMixinAtDeclaration node) {
    visitIncludeDirective(node.include);
  }

  @override
  void visitExtendDeclaration(ExtendDeclaration node) {
    _visitNodeList(node.selectors);
  }

  @override
  void visitSelectorGroup(SelectorGroup node) {
    _visitNodeList(node.selectors);
  }

  @override
  void visitSelector(Selector node) {
    _visitNodeList(node.simpleSelectorSequences);
  }

  @override
  void visitSimpleSelectorSequence(SimpleSelectorSequence node) {
    node.simpleSelector.visit(this);
  }

  @override
  void visitSimpleSelector(SimpleSelector node) => node._name.visit(this);

  @override
  void visitNamespaceSelector(NamespaceSelector node) {
    if (node._namespace != null) node._namespace.visit(this);
    if (node.nameAsSimpleSelector != null) {
      node.nameAsSimpleSelector.visit(this);
    }
  }

  @override
  void visitElementSelector(ElementSelector node) => visitSimpleSelector(node);

  @override
  void visitAttributeSelector(AttributeSelector node) {
    visitSimpleSelector(node);
  }

  @override
  void visitIdSelector(IdSelector node) => visitSimpleSelector(node);

  @override
  void visitClassSelector(ClassSelector node) => visitSimpleSelector(node);

  @override
  void visitPseudoClassSelector(PseudoClassSelector node) =>
      visitSimpleSelector(node);

  @override
  void visitPseudoElementSelector(PseudoElementSelector node) =>
      visitSimpleSelector(node);

  @override
  void visitPseudoClassFunctionSelector(PseudoClassFunctionSelector node) =>
      visitSimpleSelector(node);

  @override
  void visitPseudoElementFunctionSelector(PseudoElementFunctionSelector node) =>
      visitSimpleSelector(node);

  @override
  void visitNegationSelector(NegationSelector node) =>
      visitSimpleSelector(node);

  @override
  void visitSelectorExpression(SelectorExpression node) {
    _visitNodeList(node.expressions);
  }

  @override
  void visitUnicodeRangeTerm(UnicodeRangeTerm node) {}

  @override
  void visitLiteralTerm(LiteralTerm node) {}

  @override
  void visitHexColorTerm(HexColorTerm node) {}

  @override
  void visitNumberTerm(NumberTerm node) {}

  @override
  void visitUnitTerm(UnitTerm node) {}

  @override
  void visitLengthTerm(LengthTerm node) {
    visitUnitTerm(node);
  }

  @override
  void visitPercentageTerm(PercentageTerm node) {
    visitLiteralTerm(node);
  }

  @override
  void visitEmTerm(EmTerm node) {
    visitLiteralTerm(node);
  }

  @override
  void visitExTerm(ExTerm node) {
    visitLiteralTerm(node);
  }

  @override
  void visitAngleTerm(AngleTerm node) {
    visitUnitTerm(node);
  }

  @override
  void visitTimeTerm(TimeTerm node) {
    visitUnitTerm(node);
  }

  @override
  void visitFreqTerm(FreqTerm node) {
    visitUnitTerm(node);
  }

  @override
  void visitFractionTerm(FractionTerm node) {
    visitLiteralTerm(node);
  }

  @override
  void visitUriTerm(UriTerm node) {
    visitLiteralTerm(node);
  }

  @override
  void visitResolutionTerm(ResolutionTerm node) {
    visitUnitTerm(node);
  }

  @override
  void visitChTerm(ChTerm node) {
    visitUnitTerm(node);
  }

  @override
  void visitRemTerm(RemTerm node) {
    visitUnitTerm(node);
  }

  @override
  void visitViewportTerm(ViewportTerm node) {
    visitUnitTerm(node);
  }

  @override
  void visitFunctionTerm(FunctionTerm node) {
    visitLiteralTerm(node);
    visitExpressions(node._params);
  }

  @override
  void visitGroupTerm(GroupTerm node) {
    for (var term in node._terms) {
      term.visit(this);
    }
  }

  @override
  void visitItemTerm(ItemTerm node) {
    visitNumberTerm(node);
  }

  @override
  void visitIE8Term(IE8Term node) {}

  @override
  void visitOperatorSlash(OperatorSlash node) {}

  @override
  void visitOperatorComma(OperatorComma node) {}

  @override
  void visitOperatorPlus(OperatorPlus node) {}

  @override
  void visitOperatorMinus(OperatorMinus node) {}

  @override
  void visitVarUsage(VarUsage node) {
    _visitNodeList(node.defaultValues);
  }

  @override
  void visitExpressions(Expressions node) {
    _visitNodeList(node.expressions);
  }

  @override
  void visitBinaryExpression(BinaryExpression node) {
    // TODO(terry): TBD
    throw UnimplementedError();
  }

  @override
  void visitUnaryExpression(UnaryExpression node) {
    // TODO(terry): TBD
    throw UnimplementedError();
  }

  @override
  void visitIdentifier(Identifier node) {}

  @override
  void visitWildcard(Wildcard node) {}

  @override
  void visitThisOperator(ThisOperator node) {}

  @override
  void visitNegation(Negation node) {}

  @override
  void visitDartStyleExpression(DartStyleExpression node) {}

  @override
  void visitFontExpression(FontExpression node) {
    // TODO(terry): TBD
    throw UnimplementedError();
  }

  @override
  void visitBoxExpression(BoxExpression node) {
    // TODO(terry): TBD
    throw UnimplementedError();
  }

  @override
  void visitMarginExpression(MarginExpression node) {
    // TODO(terry): TBD
    throw UnimplementedError();
  }

  @override
  void visitBorderExpression(BorderExpression node) {
    // TODO(terry): TBD
    throw UnimplementedError();
  }

  @override
  void visitHeightExpression(HeightExpression node) {
    // TODO(terry): TB
    throw UnimplementedError();
  }

  @override
  void visitPaddingExpression(PaddingExpression node) {
    // TODO(terry): TBD
    throw UnimplementedError();
  }

  @override
  void visitWidthExpression(WidthExpression node) {
    // TODO(terry): TBD
    throw UnimplementedError();
  }
}
