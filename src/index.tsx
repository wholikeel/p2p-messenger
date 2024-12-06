const P2pMessenger = require('./NativeP2pMessenger').default;

export function multiply(a: number, b: number): number {
  return P2pMessenger.multiply(a, b);
}
