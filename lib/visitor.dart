// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:source_span/source_span.dart';
import 'parser.dart';

part 'src/css_printer.dart';
part 'src/tree.dart';
part 'src/tree_base.dart';
part 'src/tree_printer.dart';

abstract class VisitorBase {
  void visitCalcTerm(CalcTerm node);
  void visitCssComment(CssComment node);
  void visitCommentDefinition(CommentDefinition node);
  void visitStyleSheet(StyleSheet node);
  void visitNoOp(NoOp node);
  void visitTopLevelProduction(TopLevelProduction node);
  void visitDirective(Directive node);
  void visitDocumentDirective(DocumentDirective node);
  void visitSupportsDirective(SupportsDirective node);
  void visitSupportsConditionInParens(SupportsConditionInParens node);
  void visitSupportsNegation(SupportsNegation node);
  void visitSupportsConjunction(SupportsConjunction node);
  void visitSupportsDisjunction(SupportsDisjunction node);
  void visitViewportDirective(ViewportDirective node);
  void visitMediaExpression(MediaExpression node);
  void visitMediaQuery(MediaQuery node);
  void visitMediaDirective(MediaDirective node);
  void visitHostDirective(HostDirective node);
  void visitPageDirective(PageDirective node);
  void visitCharsetDirective(CharsetDirective node);
  void visitImportDirective(ImportDirective node);
  void visitKeyFrameDirective(KeyFrameDirective node);
  void visitKeyFrameBlock(KeyFrameBlock node);
  void visitFontFaceDirective(FontFaceDirective node);
  void visitStyletDirective(StyletDirective node);
  void visitNamespaceDirective(NamespaceDirective node);
  void visitVarDefinitionDirective(VarDefinitionDirective node);
  void visitMixinDefinition(MixinDefinition node);
  void visitMixinRulesetDirective(MixinRulesetDirective node);
  void visitMixinDeclarationDirective(MixinDeclarationDirective node);
  void visitIncludeDirective(IncludeDirective node);
  void visitContentDirective(ContentDirective node);

  void visitRuleSet(RuleSet node);
  void visitDeclarationGroup(DeclarationGroup node);
  void visitMarginGroup(MarginGroup node);
  void visitDeclaration(Declaration node);
  void visitVarDefinition(VarDefinition node);
  void visitIncludeMixinAtDeclaration(IncludeMixinAtDeclaration node);
  void visitExtendDeclaration(ExtendDeclaration node);
  void visitSelectorGroup(SelectorGroup node);
  void visitSelector(Selector node);
  void visitSimpleSelectorSequence(SimpleSelectorSequence node);
  void visitSimpleSelector(SimpleSelector node);
  void visitElementSelector(ElementSelector node);
  void visitNamespaceSelector(NamespaceSelector node);
  void visitAttributeSelector(AttributeSelector node);
  void visitIdSelector(IdSelector node);
  void visitClassSelector(ClassSelector node);
  void visitPseudoClassSelector(PseudoClassSelector node);
  void visitPseudoElementSelector(PseudoElementSelector node);
  void visitPseudoClassFunctionSelector(PseudoClassFunctionSelector node);
  void visitPseudoElementFunctionSelector(PseudoElementFunctionSelector node);
  void visitNegationSelector(NegationSelector node);
  void visitSelectorExpression(SelectorExpression node);

  void visitUnicodeRangeTerm(UnicodeRangeTerm node);
  void visitLiteralTerm(LiteralTerm node);
  void visitHexColorTerm(HexColorTerm node);
  void visitNumberTerm(NumberTerm node);
  void visitUnitTerm(UnitTerm node);
  void visitLengthTerm(LengthTerm node);
  void visitPercentageTerm(PercentageTerm node);
  void visitEmTerm(EmTerm node);
  void visitExTerm(ExTerm node);
  void visitAngleTerm(AngleTerm node);
  void visitTimeTerm(TimeTerm node);
  void visitFreqTerm(FreqTerm node);
  void visitFractionTerm(FractionTerm node);
  void visitUriTerm(UriTerm node);
  void visitResolutionTerm(ResolutionTerm node);
  void visitChTerm(ChTerm node);
  void visitRemTerm(RemTerm node);
  void visitViewportTerm(ViewportTerm node);
  void visitFunctionTerm(FunctionTerm node);
  void visitGroupTerm(GroupTerm node);
  void visitItemTerm(ItemTerm node);
  void visitIE8Term(IE8Term node);
  void visitOperatorSlash(OperatorSlash node);
  void visitOperatorComma(OperatorComma node);
  void visitOperatorPlus(OperatorPlus node);
  void visitOperatorMinus(OperatorMinus node);
  void visitVarUsage(VarUsage node);

  void visitExpressions(Expressions node);
  void visitBinaryExpression(BinaryExpression node);
  void visitUnaryExpression(UnaryExpression node);

  void visitIdentifier(Identifier node);
  void visitWildcard(Wildcard node);
  void visitThisOperator(ThisOperator node);
  void visitNegation(Negation node);

  void visitDartStyleExpression(DartStyleExpression node);
  void visitFontExpression(FontExpression node);
  void visitBoxExpression(BoxExpression node);
  void visitMarginExpression(MarginExpression node);
  void visitBorderExpression(BorderExpression node);
  void visitHeightExpression(HeightExpression node);
  void visitPaddingExpression(PaddingExpression node);
  void visitWidthExpression(WidthExpression node);
}

/// Base vistor class for the style sheet AST.
class Visitor implements VisitorBase {
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
  visitNoOp(NoOp node) {}

  @override
  visitTopLevelProduction(TopLevelProduction node) {}

  @override
  visitDirective(Directive node) {}

  @override
  visitCalcTerm(CalcTerm node) {
    visitLiteralTerm(node);
    visitLiteralTerm(node.expr);
  }

  @override
  visitCssComment(CssComment node) {}

  @override
  visitCommentDefinition(CommentDefinition node) {}

  @override
  visitMediaExpression(MediaExpression node) {
    visitExpressions(node.exprs);
  }

  @override
  visitMediaQuery(MediaQuery node) {
    for (var mediaExpr in node.expressions) {
      visitMediaExpression(mediaExpr);
    }
  }

  @override
  visitDocumentDirective(DocumentDirective node) {
    _visitNodeList(node.functions);
    _visitNodeList(node.groupRuleBody);
  }

  @override
  visitSupportsDirective(SupportsDirective node) {
    node.condition.visit(this);
    _visitNodeList(node.groupRuleBody);
  }

  @override
  visitSupportsConditionInParens(SupportsConditionInParens node) {
    node.condition.visit(this);
  }

  @override
  visitSupportsNegation(SupportsNegation node) {
    node.condition.visit(this);
  }

  @override
  visitSupportsConjunction(SupportsConjunction node) {
    _visitNodeList(node.conditions);
  }

  @override
  visitSupportsDisjunction(SupportsDisjunction node) {
    _visitNodeList(node.conditions);
  }

  @override
  visitViewportDirective(ViewportDirective node) {
    node.declarations.visit(this);
  }

  @override
  visitMediaDirective(MediaDirective node) {
    _visitNodeList(node.mediaQueries);
    _visitNodeList(node.rules);
  }

  @override
  visitHostDirective(HostDirective node) {
    _visitNodeList(node.rules);
  }

  @override
  visitPageDirective(PageDirective node) {
    for (var declGroup in node._declsMargin) {
      if (declGroup is MarginGroup) {
        visitMarginGroup(declGroup);
      } else {
        visitDeclarationGroup(declGroup);
      }
    }
  }

  @override
  visitCharsetDirective(CharsetDirective node) {}

  @override
  visitImportDirective(ImportDirective node) {
    for (var mediaQuery in node.mediaQueries) {
      visitMediaQuery(mediaQuery);
    }
  }

  @override
  visitKeyFrameDirective(KeyFrameDirective node) {
    visitIdentifier(node.name);
    _visitNodeList(node._blocks);
  }

  @override
  visitKeyFrameBlock(KeyFrameBlock node) {
    visitExpressions(node._blockSelectors);
    visitDeclarationGroup(node._declarations);
  }

  @override
  visitFontFaceDirective(FontFaceDirective node) {
    visitDeclarationGroup(node._declarations);
  }

  @override
  visitStyletDirective(StyletDirective node) {
    _visitNodeList(node.rules);
  }

  @override
  visitNamespaceDirective(NamespaceDirective node) {}

  @override
  visitVarDefinitionDirective(VarDefinitionDirective node) {
    visitVarDefinition(node.def);
  }

  @override
  visitMixinRulesetDirective(MixinRulesetDirective node) {
    _visitNodeList(node.rulesets);
  }

  @override
  visitMixinDefinition(MixinDefinition node) {}

  @override
  visitMixinDeclarationDirective(MixinDeclarationDirective node) {
    visitDeclarationGroup(node.declarations);
  }

  @override
  visitIncludeDirective(IncludeDirective node) {
    for (var index = 0; index < node.args.length; index++) {
      var param = node.args[index];
      _visitNodeList(param);
    }
  }

  @override
  visitContentDirective(ContentDirective node) {
    // TODO(terry): TBD
  }

  @override
  visitRuleSet(RuleSet node) {
    visitSelectorGroup(node._selectorGroup);
    visitDeclarationGroup(node._declarationGroup);
  }

  @override
  visitDeclarationGroup(DeclarationGroup node) {
    _visitNodeList(node.declarations);
  }

  @override
  visitMarginGroup(MarginGroup node) => visitDeclarationGroup(node);

  @override
  visitDeclaration(Declaration node) {
    visitIdentifier(node._property);
    if (node._expression != null) node._expression.visit(this);
  }

  @override
  visitVarDefinition(VarDefinition node) {
    visitIdentifier(node._property);
    if (node._expression != null) node._expression.visit(this);
  }

  @override
  visitIncludeMixinAtDeclaration(IncludeMixinAtDeclaration node) {
    visitIncludeDirective(node.include);
  }

  @override
  visitExtendDeclaration(ExtendDeclaration node) {
    _visitNodeList(node.selectors);
  }

  @override
  visitSelectorGroup(SelectorGroup node) {
    _visitNodeList(node.selectors);
  }

  @override
  visitSelector(Selector node) {
    _visitNodeList(node.simpleSelectorSequences);
  }

  @override
  visitSimpleSelectorSequence(SimpleSelectorSequence node) {
    node.simpleSelector.visit(this);
  }

  @override
  visitSimpleSelector(SimpleSelector node) => node._name.visit(this);

  @override
  visitNamespaceSelector(NamespaceSelector node) {
    if (node._namespace != null) node._namespace.visit(this);
    if (node.nameAsSimpleSelector != null) {
      node.nameAsSimpleSelector.visit(this);
    }
  }

  @override
  visitElementSelector(ElementSelector node) => visitSimpleSelector(node);

  @override
  visitAttributeSelector(AttributeSelector node) {
    visitSimpleSelector(node);
  }

  @override
  visitIdSelector(IdSelector node) => visitSimpleSelector(node);

  @override
  visitClassSelector(ClassSelector node) => visitSimpleSelector(node);

  @override
  visitPseudoClassSelector(PseudoClassSelector node) =>
      visitSimpleSelector(node);

  @override
  visitPseudoElementSelector(PseudoElementSelector node) =>
      visitSimpleSelector(node);

  @override
  visitPseudoClassFunctionSelector(PseudoClassFunctionSelector node) =>
      visitSimpleSelector(node);

  @override
  visitPseudoElementFunctionSelector(PseudoElementFunctionSelector node) =>
      visitSimpleSelector(node);

  @override
  visitNegationSelector(NegationSelector node) => visitSimpleSelector(node);

  @override
  visitSelectorExpression(SelectorExpression node) {
    _visitNodeList(node.expressions);
  }

  @override
  visitUnicodeRangeTerm(UnicodeRangeTerm node) {}

  @override
  visitLiteralTerm(LiteralTerm node) {}

  @override
  visitHexColorTerm(HexColorTerm node) {}

  @override
  visitNumberTerm(NumberTerm node) {}

  @override
  visitUnitTerm(UnitTerm node) {}

  @override
  visitLengthTerm(LengthTerm node) {
    visitUnitTerm(node);
  }

  @override
  visitPercentageTerm(PercentageTerm node) {
    visitLiteralTerm(node);
  }

  @override
  visitEmTerm(EmTerm node) {
    visitLiteralTerm(node);
  }

  @override
  visitExTerm(ExTerm node) {
    visitLiteralTerm(node);
  }

  @override
  visitAngleTerm(AngleTerm node) {
    visitUnitTerm(node);
  }

  @override
  visitTimeTerm(TimeTerm node) {
    visitUnitTerm(node);
  }

  @override
  visitFreqTerm(FreqTerm node) {
    visitUnitTerm(node);
  }

  @override
  visitFractionTerm(FractionTerm node) {
    visitLiteralTerm(node);
  }

  @override
  visitUriTerm(UriTerm node) {
    visitLiteralTerm(node);
  }

  @override
  visitResolutionTerm(ResolutionTerm node) {
    visitUnitTerm(node);
  }

  @override
  visitChTerm(ChTerm node) {
    visitUnitTerm(node);
  }

  @override
  visitRemTerm(RemTerm node) {
    visitUnitTerm(node);
  }

  @override
  visitViewportTerm(ViewportTerm node) {
    visitUnitTerm(node);
  }

  @override
  visitFunctionTerm(FunctionTerm node) {
    visitLiteralTerm(node);
    visitExpressions(node._params);
  }

  @override
  visitGroupTerm(GroupTerm node) {
    for (var term in node._terms) {
      term.visit(this);
    }
  }

  @override
  visitItemTerm(ItemTerm node) {
    visitNumberTerm(node);
  }

  @override
  visitIE8Term(IE8Term node) {}

  @override
  visitOperatorSlash(OperatorSlash node) {}

  @override
  visitOperatorComma(OperatorComma node) {}

  @override
  visitOperatorPlus(OperatorPlus node) {}

  @override
  visitOperatorMinus(OperatorMinus node) {}

  @override
  visitVarUsage(VarUsage node) {
    _visitNodeList(node.defaultValues);
  }

  @override
  visitExpressions(Expressions node) {
    _visitNodeList(node.expressions);
  }

  @override
  visitBinaryExpression(BinaryExpression node) {
    // TODO(terry): TBD
    throw UnimplementedError();
  }

  @override
  visitUnaryExpression(UnaryExpression node) {
    // TODO(terry): TBD
    throw UnimplementedError();
  }

  @override
  visitIdentifier(Identifier node) {}

  @override
  visitWildcard(Wildcard node) {}

  @override
  visitThisOperator(ThisOperator node) {}

  @override
  visitNegation(Negation node) {}

  @override
  visitDartStyleExpression(DartStyleExpression node) {}

  @override
  visitFontExpression(FontExpression node) {
    // TODO(terry): TBD
    throw UnimplementedError();
  }

  @override
  visitBoxExpression(BoxExpression node) {
    // TODO(terry): TBD
    throw UnimplementedError();
  }

  @override
  visitMarginExpression(MarginExpression node) {
    // TODO(terry): TBD
    throw UnimplementedError();
  }

  @override
  visitBorderExpression(BorderExpression node) {
    // TODO(terry): TBD
    throw UnimplementedError();
  }

  @override
  visitHeightExpression(HeightExpression node) {
    // TODO(terry): TB
    throw UnimplementedError();
  }

  @override
  visitPaddingExpression(PaddingExpression node) {
    // TODO(terry): TBD
    throw UnimplementedError();
  }

  @override
  visitWidthExpression(WidthExpression node) {
    // TODO(terry): TBD
    throw UnimplementedError();
  }
}
