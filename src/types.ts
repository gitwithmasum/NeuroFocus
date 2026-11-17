export type FocusMode = 'function' | 'block' | 'radius';

export type GlowTheme = 'cyan' | 'magenta' | 'violet' | 'matrixGreen' | 'minimal';

export interface FocusRange {
  startLine: number;
  endLine: number;
}

export interface NeuroFocusConfig {
  enabled: boolean;
  opacity: number;
  focusMode: FocusMode;
  radiusLines: number;
  enableActiveGlow: boolean;
  glowColor: GlowTheme;
  excludedLanguages: string[];
}
