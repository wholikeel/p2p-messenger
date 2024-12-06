package com.p2pmessenger

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule

@ReactModule(name = P2pMessengerModule.NAME)
class P2pMessengerModule(reactContext: ReactApplicationContext) :
  NativeP2pMessengerSpec(reactContext) {

  override fun getName(): String {
    return NAME
  }

  // Example method
  // See https://reactnative.dev/docs/native-modules-android
  override fun multiply(a: Double, b: Double): Double {
    return a * b
  }

  companion object {
    const val NAME = "P2pMessenger"
  }
}
