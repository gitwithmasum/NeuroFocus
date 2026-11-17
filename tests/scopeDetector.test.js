const assert = require('assert');
const { ScopeUtils } = require('../out/core/scopeUtils');

console.log('--- RUNNING NEUROFOCUS SCOPE DETECTOR TESTS ---');

// Test 1: Radius Scope
const radiusScope = ScopeUtils.getRadiusScope(10, 100, 5);
assert.strictEqual(radiusScope.startLine, 5);
assert.strictEqual(radiusScope.endLine, 15);
console.log('✔ Radius scope calculation passed');

// Test 2: Radius at edges
const topEdge = ScopeUtils.getRadiusScope(2, 50, 5);
assert.strictEqual(topEdge.startLine, 0);
assert.strictEqual(topEdge.endLine, 7);

const bottomEdge = ScopeUtils.getRadiusScope(48, 50, 5);
assert.strictEqual(bottomEdge.startLine, 43);
assert.strictEqual(bottomEdge.endLine, 49);
console.log('✔ Edge boundary radius passed');

// Test 3: Bracket Scope simulation
const mockJsLines = [
  'const a = 1;',
  'function calculateTotal() {',
  '  const tax = 0.1;',
  '  const total = 100 * (1 + tax);',
  '  return total;',
  '}',
  'const b = 2;'
];

const mockJsDoc = {
  lineCount: mockJsLines.length,
  lineAt: (i) => ({ text: mockJsLines[i] })
};

const jsScope = ScopeUtils.getBracketScope(mockJsDoc, 3);
assert.strictEqual(jsScope.startLine, 1);
assert.strictEqual(jsScope.endLine, 5);
console.log('✔ Bracket scope matching passed');

// Test 4: Python Scope simulation
const mockPyLines = [
  'import math',
  '',
  'def compute_matrix(x, y):',
  '    val = x * 2',
  '    if val > 10:',
  '        return val + y',
  '    return y',
  '',
  'print("done")'
];

const mockPyDoc = {
  lineCount: mockPyLines.length,
  lineAt: (i) => ({ text: mockPyLines[i] })
};

const pyScope = ScopeUtils.getPythonScope(mockPyDoc, 4);
assert.strictEqual(pyScope.startLine, 2);
assert.strictEqual(pyScope.endLine, 6);
console.log('✔ Python indentation scope matching passed');

console.log('\n[PASS] All NeuroFocus scope tests passed with 100% precision!\n');
