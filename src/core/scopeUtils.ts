import { FocusRange } from '../types';

export class ScopeUtils {
  /**
   * Radius Mode: Fixed number of lines above and below the cursor.
   */
  public static getRadiusScope(
    cursorLine: number,
    totalLines: number,
    radius: number
  ): FocusRange {
    return {
      startLine: Math.max(0, cursorLine - radius),
      endLine: Math.min(totalLines - 1, cursorLine + radius)
    };
  }

  /**
   * Python Indentation Scope matching (finds def/class header and scope block).
   */
  public static getPythonScope(
    document: { lineCount: number; lineAt: (i: number) => { text: string } },
    cursorLine: number
  ): FocusRange {
    const totalLines = document.lineCount;

    let startLine = cursorLine;
    let targetIndent = -1;

    // Search backwards for def or class definition
    for (let l = cursorLine; l >= 0; l--) {
      const text = document.lineAt(l).text;
      const match = /^\s*(def|class|async\s+def)\s+/.exec(text);
      if (match) {
        startLine = l;
        targetIndent = text.search(/\S/);
        break;
      }
    }

    if (targetIndent === -1) {
      return this.getRadiusScope(cursorLine, totalLines, 8);
    }

    // Search forwards until an equal or lesser indented non-empty line
    let endLine = startLine;
    for (let l = startLine + 1; l < totalLines; l++) {
      const text = document.lineAt(l).text;
      if (!text.trim() || text.trim().startsWith('#')) {
        continue;
      }
      const indent = text.search(/\S/);
      if (indent <= targetIndent) {
        break;
      }
      endLine = l;
    }

    return { startLine, endLine };
  }

  /**
   * Universal Bracket Scope matching ({ ... }).
   */
  public static getBracketScope(
    document: { lineCount: number; lineAt: (i: number) => { text: string } },
    cursorLine: number
  ): FocusRange {
    const totalLines = document.lineCount;
    let openCount = 0;
    let startLine = cursorLine;

    // Search upwards for enclosing '{'
    for (let l = cursorLine; l >= 0; l--) {
      const lineText = document.lineAt(l).text;
      const opens = (lineText.match(/\{/g) || []).length;
      const closes = (lineText.match(/\}/g) || []).length;

      openCount += opens - closes;
      if (openCount > 0) {
        startLine = l;
        break;
      }
    }

    // Search downwards for corresponding '}'
    let endLine = cursorLine;
    let balance = 0;
    for (let l = startLine; l < totalLines; l++) {
      const lineText = document.lineAt(l).text;
      const opens = (lineText.match(/\{/g) || []).length;
      const closes = (lineText.match(/\}/g) || []).length;

      balance += opens - closes;
      if (balance <= 0 && l >= cursorLine) {
        endLine = l;
        break;
      }
    }

    // Fallback to reasonable radius
    if (startLine === cursorLine && endLine === cursorLine) {
      return this.getRadiusScope(cursorLine, totalLines, 8);
    }

    return { startLine, endLine };
  }
}
