local baseProxy = require("fgui.base.baseProxy")
local PetShareBoxProxy = class("PetShareBoxProxy", baseProxy)
function PetShareBoxProxy:onRegisterEvent()
	print("=======PetShareBoxProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_FACEBOOK_SHARE_SUCCESS", handler(self, self.msgHandlerFbSuccess))
	SoraDAddMessage(self, "MESSAGE_FACEBOOK_SHARE_FAIL", handler(self, self.msgHandlerFbFail))
	SoraDAddMessage(self, "MESSAGE_FACEBOOK_SHARE_CANCEL", handler(self, self.msgHandlerFbCancel))
	SoraDAddMessage(self, "MESSAGE_WHATSAPP_SHARE_SUCCESS", handler(self, self.msgHandlerWhatsAppSuccess))
	SoraDAddMessage(self, "MESSAGE_WHATSAPP_SHARE_FAIL", handler(self, self.msgHandlerWhatsAppFail))
	SoraDAddMessage(self, "MESSAGE_WHATSAPP_SHARE_CANCEL", handler(self, self.msgHandlerWhatsAppCancel))
end
function PetShareBoxProxy:msgHandlerFbSuccess()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.facebook
	userSDKManager.logEvent(gSDKDef.TDonEvent.pet_share_success, nil)
end
function PetShareBoxProxy:msgHandlerFbFail()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.facebook
	userSDKManager.logEvent(gSDKDef.TDonEvent.pet_share_fail, nil)
end
function PetShareBoxProxy:msgHandlerFbCancel()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.facebook
	userSDKManager.logEvent(gSDKDef.TDonEvent.pet_share_cancel, nil)
end
function PetShareBoxProxy:msgHandlerWhatsAppSuccess()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.whatsapp
	userSDKManager.logEvent(gSDKDef.TDonEvent.pet_share_success, nil)
end
function PetShareBoxProxy:msgHandlerWhatsAppFail()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.whatsapp
	userSDKManager.logEvent(gSDKDef.TDonEvent.pet_share_fail, nil)
end
function PetShareBoxProxy:msgHandlerWhatsAppCancel()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.whatsapp
	userSDKManager.logEvent(gSDKDef.TDonEvent.pet_share_cancel, nil)
end
return PetShareBoxProxy
