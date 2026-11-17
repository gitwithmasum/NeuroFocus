import * as vscode from 'vscode';
import { DimmerEngine } from './core/dimmerEngine';
import { StatusBarManager } from './statusBar/statusBar';
import { FocusMode, GlowTheme, NeuroFocusConfig } from './types';

export function activate(context: vscode.ExtensionContext) {
  const outputChannel = vscode.window.createOutputChannel('NeuroFocus');
  outputChannel.appendLine('╔════════════════════════════════════════════════════════════╗');
  outputChannel.appendLine('║ 🧠 NEUROFOCUS // DEEP-FOCUS & ADHD CODE DIMMER             ║');
  outputChannel.appendLine('║ Initialized. Illuminating active scope, dimming noise.     ║');
  outputChannel.appendLine('╚════════════════════════════════════════════════════════════╝');

  const dimmerEngine = new DimmerEngine();
  const statusBar = new StatusBarManager();

  function getConfig(): NeuroFocusConfig {
    const config = vscode.workspace.getConfiguration('neurofocus');
    return {
      enabled: config.get<boolean>('enabled', true),
      opacity: config.get<number>('opacity', 0.25),
      focusMode: config.get<FocusMode>('focusMode', 'function'),
      radiusLines: config.get<number>('radiusLines', 6),
      enableActiveGlow: config.get<boolean>('enableActiveGlow', true),
      glowColor: config.get<GlowTheme>('glowColor', 'cyan'),
      excludedLanguages: config.get<string[]>('excludedLanguages', ['markdown', 'plaintext'])
    };
  }

  function refresh() {
    const activeEditor = vscode.window.activeTextEditor;
    const currentConfig = getConfig();
    statusBar.update(currentConfig.enabled, currentConfig.focusMode);

    if (activeEditor) {
      if (currentConfig.enabled) {
        dimmerEngine.queueUpdate(activeEditor, currentConfig);
      } else {
        dimmerEngine.clear(activeEditor);
      }
    }
  }

  // 1. Selection change listener (cursor movement)
  context.subscriptions.push(
    vscode.window.onDidChangeTextEditorSelection((e) => {
      const currentConfig = getConfig();
      if (currentConfig.enabled) {
        dimmerEngine.queueUpdate(e.textEditor, currentConfig);
      }
    })
  );

  // 2. Active editor change listener
  context.subscriptions.push(
    vscode.window.onDidChangeActiveTextEditor((editor) => {
      if (editor) {
        refresh();
      }
    })
  );

  // 3. Configuration change listener
  context.subscriptions.push(
    vscode.workspace.onDidChangeConfiguration((e) => {
      if (e.affectsConfiguration('neurofocus')) {
        const currentConfig = getConfig();
        dimmerEngine.recreateDecorations(
          currentConfig.opacity,
          currentConfig.glowColor,
          currentConfig.enableActiveGlow
        );
        refresh();
      }
    })
  );

  // Command: Toggle
  context.subscriptions.push(
    vscode.commands.registerCommand('neurofocus.toggle', async () => {
      const config = vscode.workspace.getConfiguration('neurofocus');
      const current = config.get<boolean>('enabled', true);
      const next = !current;
      await config.update('enabled', next, vscode.ConfigurationTarget.Global);
      refresh();
      vscode.window.showInformationMessage(
        next
          ? '🧠 [NeuroFocus] Deep focus dimmer ACTIVATED.'
          : '👁️ [NeuroFocus] Full code illumination RESTORED.'
      );
    })
  );

  // Command: Cycle Focus Mode
  context.subscriptions.push(
    vscode.commands.registerCommand('neurofocus.cycleMode', async () => {
      const config = vscode.workspace.getConfiguration('neurofocus');
      const current = config.get<FocusMode>('focusMode', 'function');
      const modes: FocusMode[] = ['function', 'block', 'radius'];
      const nextIndex = (modes.indexOf(current) + 1) % modes.length;
      const nextMode = modes[nextIndex];

      await config.update('focusMode', nextMode, vscode.ConfigurationTarget.Global);
      refresh();
      vscode.window.showInformationMessage(
        `🎯 [NeuroFocus] Switched focus mode to: "${nextMode.toUpperCase()}"`
      );
    })
  );

  // Command: Deepen Dimming (Make surrounding code darker)
  context.subscriptions.push(
    vscode.commands.registerCommand('neurofocus.increaseDimming', async () => {
      const config = vscode.workspace.getConfiguration('neurofocus');
      const current = config.get<number>('opacity', 0.25);
      const next = Math.max(0.05, Math.round((current - 0.05) * 100) / 100);
      await config.update('opacity', next, vscode.ConfigurationTarget.Global);
      vscode.window.showInformationMessage(`🌑 [NeuroFocus] Surrounding opacity: ${next * 100}%`);
    })
  );

  // Command: Soften Dimming (Make surrounding code brighter)
  context.subscriptions.push(
    vscode.commands.registerCommand('neurofocus.decreaseDimming', async () => {
      const config = vscode.workspace.getConfiguration('neurofocus');
      const current = config.get<number>('opacity', 0.25);
      const next = Math.min(0.75, Math.round((current + 0.05) * 100) / 100);
      await config.update('opacity', next, vscode.ConfigurationTarget.Global);
      vscode.window.showInformationMessage(`🌕 [NeuroFocus] Surrounding opacity: ${next * 100}%`);
    })
  );

  // Initial trigger
  refresh();

  context.subscriptions.push(dimmerEngine, statusBar, outputChannel);
}

export function deactivate() {}
