import * as vscode from 'vscode';
import { FocusMode } from '../types';

export class StatusBarManager {
  private statusBarItem: vscode.StatusBarItem;

  constructor() {
    this.statusBarItem = vscode.window.createStatusBarItem(
      vscode.StatusBarAlignment.Right,
      100
    );
    this.statusBarItem.command = 'neurofocus.toggle';
    this.update(true, 'function');
    this.statusBarItem.show();
  }

  public update(enabled: boolean, mode: FocusMode): void {
    if (enabled) {
      const modeLabel = mode.charAt(0).toUpperCase() + mode.slice(1);
      this.statusBarItem.text = `$(eye) NEUROFOCUS: ON (${modeLabel})`;
      this.statusBarItem.tooltip = `NeuroFocus Active [Mode: ${modeLabel}]. Click to toggle off (Alt + N).`;
      this.statusBarItem.backgroundColor = undefined;
    } else {
      this.statusBarItem.text = `$(eye-closed) NEUROFOCUS: OFF`;
      this.statusBarItem.tooltip = `NeuroFocus Disabled. Click to activate deep focus dimmer (Alt + N).`;
      this.statusBarItem.backgroundColor = new vscode.ThemeColor(
        'statusBarItem.warningBackground'
      );
    }
  }

  public dispose(): void {
    this.statusBarItem.dispose();
  }
}
