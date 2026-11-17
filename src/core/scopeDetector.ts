import * as vscode from 'vscode';
import { FocusMode, FocusRange } from '../types';
import { ScopeUtils } from './scopeUtils';

export class ScopeDetector {
  /**
   * Determine the active focus range based on mode and cursor position.
   */
  public static async detectScope(
    editor: vscode.TextEditor,
    mode: FocusMode,
    radiusLines: number
  ): Promise<FocusRange> {
    const document = editor.document;
    const cursorLine = editor.selection.active.line;
    const totalLines = document.lineCount;

    if (totalLines <= 1) {
      return { startLine: 0, endLine: 0 };
    }

    if (mode === 'radius') {
      return ScopeUtils.getRadiusScope(cursorLine, totalLines, radiusLines);
    }

    if (mode === 'function') {
      // 1. Try VS Code Document Symbol Provider first
      const symbolRange = await this.getSymbolScope(editor, cursorLine);
      if (symbolRange) {
        return symbolRange;
      }

      // 2. Fallback to Python indentation scope if Python
      if (document.languageId === 'python') {
        return ScopeUtils.getPythonScope(document, cursorLine);
      }

      // 3. Fallback to bracket matching
      return ScopeUtils.getBracketScope(document, cursorLine);
    }

    // mode === 'block'
    if (document.languageId === 'python') {
      return ScopeUtils.getPythonScope(document, cursorLine);
    }
    return ScopeUtils.getBracketScope(document, cursorLine);
  }

  /**
   * Query native VS Code Document Symbols to find enclosing function/class/method.
   */
  private static async getSymbolScope(
    editor: vscode.TextEditor,
    cursorLine: number
  ): Promise<FocusRange | null> {
    try {
      const symbols = await vscode.commands.executeCommand<vscode.DocumentSymbol[]>(
        'vscode.executeDocumentSymbolProvider',
        editor.document.uri
      );

      if (!symbols || symbols.length === 0) {
        return null;
      }

      const match = this.findDeepestSymbol(symbols, cursorLine);
      if (match) {
        return {
          startLine: match.range.start.line,
          endLine: match.range.end.line
        };
      }
    } catch {
      // Ignore symbol provider errors gracefully
    }
    return null;
  }

  /**
   * Recursively find the deepest symbol (function/method) containing the line.
   */
  private static findDeepestSymbol(
    symbols: vscode.DocumentSymbol[],
    line: number
  ): vscode.DocumentSymbol | null {
    let deepest: vscode.DocumentSymbol | null = null;

    for (const sym of symbols) {
      if (line >= sym.range.start.line && line <= sym.range.end.line) {
        deepest = sym;
        if (sym.children && sym.children.length > 0) {
          const childMatch = this.findDeepestSymbol(sym.children, line);
          if (childMatch) {
            deepest = childMatch;
          }
        }
      }
    }

    return deepest;
  }
}
