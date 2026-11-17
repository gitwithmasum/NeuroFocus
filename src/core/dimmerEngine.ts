import * as vscode from 'vscode';
import { FocusRange, GlowTheme, NeuroFocusConfig } from '../types';
import { ScopeDetector } from './scopeDetector';

export class DimmerEngine {
  private dimDecoration: vscode.TextEditorDecorationType | null = null;
  private glowDecoration: vscode.TextEditorDecorationType | null = null;
  private currentOpacity: number = 0.25;
  private currentGlowTheme: GlowTheme = 'cyan';
  private currentEnableGlow: boolean = true;
  private debounceTimer: NodeJS.Timeout | null = null;

  constructor() {
    this.recreateDecorations(0.25, 'cyan', true);
  }

  /**
   * Recreate VS Code decoration types when settings change.
   */
  public recreateDecorations(opacity: number, glowColor: GlowTheme, enableGlow: boolean): void {
    if (this.dimDecoration) {
      this.dimDecoration.dispose();
    }
    if (this.glowDecoration) {
      this.glowDecoration.dispose();
    }

    this.currentOpacity = opacity;
    this.currentGlowTheme = glowColor;
    this.currentEnableGlow = enableGlow;

    // 1. Surrounding Dim Decoration
    this.dimDecoration = vscode.window.createTextEditorDecorationType({
      opacity: `${opacity}`,
      isWholeLine: true
    });

    // 2. Active Focus Scope Glow
    const glowBorderColor = this.getGlowColorHex(glowColor);
    if (enableGlow && glowBorderColor) {
      this.glowDecoration = vscode.window.createTextEditorDecorationType({
        isWholeLine: true,
        borderWidth: '0 0 0 3px',
        borderStyle: 'solid',
        borderColor: glowBorderColor,
        overviewRulerColor: glowBorderColor,
        overviewRulerLane: vscode.OverviewRulerLane.Left
      });
    } else {
      this.glowDecoration = null;
    }
  }

  private getGlowColorHex(theme: GlowTheme): string | null {
    switch (theme) {
      case 'cyan':
        return '#00f0ff';
      case 'magenta':
        return '#ff007f';
      case 'violet':
        return '#9d00ff';
      case 'matrixGreen':
        return '#00ff66';
      case 'minimal':
        return '#445577';
      default:
        return '#00f0ff';
    }
  }

  /**
   * Debounced update for butter-smooth 60fps cursor tracking.
   */
  public queueUpdate(editor: vscode.TextEditor, config: NeuroFocusConfig): void {
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer);
    }

    this.debounceTimer = setTimeout(() => {
      this.applyFocus(editor, config);
    }, 35);
  }

  /**
   * Calculate active scope and apply dimming + glow decorations.
   */
  public async applyFocus(editor: vscode.TextEditor, config: NeuroFocusConfig): Promise<void> {
    if (!config.enabled) {
      this.clear(editor);
      return;
    }

    const document = editor.document;
    if (config.excludedLanguages.includes(document.languageId)) {
      this.clear(editor);
      return;
    }

    const totalLines = document.lineCount;
    if (totalLines <= 1) {
      this.clear(editor);
      return;
    }

    // Detect active scope
    const scope: FocusRange = await ScopeDetector.detectScope(
      editor,
      config.focusMode,
      config.radiusLines
    );

    const dimRanges: vscode.Range[] = [];

    // Upper dimmed region
    if (scope.startLine > 0) {
      dimRanges.push(
        new vscode.Range(
          new vscode.Position(0, 0),
          new vscode.Position(scope.startLine - 1, document.lineAt(scope.startLine - 1).text.length)
        )
      );
    }

    // Lower dimmed region
    if (scope.endLine < totalLines - 1) {
      dimRanges.push(
        new vscode.Range(
          new vscode.Position(scope.endLine + 1, 0),
          new vscode.Position(totalLines - 1, document.lineAt(totalLines - 1).text.length)
        )
      );
    }

    // Apply Dimming
    if (this.dimDecoration) {
      editor.setDecorations(this.dimDecoration, dimRanges);
    }

    // Apply Active Scope Glow
    if (this.glowDecoration) {
      const activeRange = [
        new vscode.Range(
          new vscode.Position(scope.startLine, 0),
          new vscode.Position(scope.endLine, document.lineAt(scope.endLine).text.length)
        )
      ];
      editor.setDecorations(this.glowDecoration, activeRange);
    }
  }

  /**
   * Clear all decorations from editor.
   */
  public clear(editor: vscode.TextEditor): void {
    if (this.dimDecoration) {
      editor.setDecorations(this.dimDecoration, []);
    }
    if (this.glowDecoration) {
      editor.setDecorations(this.glowDecoration, []);
    }
  }

  public dispose(): void {
    if (this.dimDecoration) {
      this.dimDecoration.dispose();
    }
    if (this.glowDecoration) {
      this.glowDecoration.dispose();
    }
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer);
    }
  }
}
