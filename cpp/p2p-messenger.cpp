// Generated by uniffi-bindgen-react-native
#include "p2p-messenger.h"
#include "generated/p2p_messenger_rs.hpp"

namespace p2pmessenger {
	using namespace facebook;

	uint8_t installRustCrate(jsi::Runtime &runtime, std::shared_ptr<react::CallInvoker> callInvoker) {
		NativeP2pMessengerRs::registerModule(runtime, callInvoker);
		return true;
	}

	uint8_t cleanupRustCrate(jsi::Runtime &runtime) {
		return false;
	}
}