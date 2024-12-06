#include <jni.h>
#include "p2p-messenger.h"

extern "C"
JNIEXPORT jdouble JNICALL
Java_com_p2pmessenger_P2pMessengerModule_nativeMultiply(JNIEnv *env, jclass type, jdouble a, jdouble b) {
    return p2pmessenger::multiply(a, b);
}
