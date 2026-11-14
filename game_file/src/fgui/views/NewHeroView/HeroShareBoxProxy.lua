local baseProxy = require("fgui.base.baseProxy")
local HeroShareBoxProxy = class("HeroShareBoxProxy", baseProxy)
function HeroShareBoxProxy:onRegisterEvent()
	print("=======HeroShareBoxProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_FACEBOOK_SHARE_SUCCESS", handler(self, self.msgHandlerFbSuccess))
	SoraDAddMessage(self, "MESSAGE_FACEBOOK_SHARE_FAIL", handler(self, self.msgHandlerFbFail))
	SoraDAddMessage(self, "MESSAGE_FACEBOOK_SHARE_CANCEL", handler(self, self.msgHandlerFbCancel))
	SoraDAddMessage(self, "MESSAGE_WHATSAPP_SHARE_SUCCESS", handler(self, self.msgHandlerWhatsAppSuccess))
	SoraDAddMessage(self, "MESSAGE_WHATSAPP_SHARE_FAIL", handler(self, self.msgHandlerWhatsAppFail))
	SoraDAddMessage(self, "MESSAGE_WHATSAPP_SHARE_CANCEL", handler(self, self.msgHandlerWhatsAppCancel))
end
function HeroShareBoxProxy:msgHandlerFbSuccess()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.facebook
	userSDKManager.logEvent(gSDKDef.TDonEvent.pet_share_success, nil)
end
function HeroShareBoxProxy:msgHandlerFbFail()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.facebook
	userSDKManager.logEvent(gSDKDef.TDonEvent.pet_share_fail, nil)
end
function HeroShareBoxProxy:msgHandlerFbCancel()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.facebook
	userSDKManager.logEvent(gSDKDef.TDonEvent.pet_share_cancel, nil)
end
function HeroShareBoxProxy:msgHandlerWhatsAppSuccess()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.whatsapp
	userSDKManager.logEvent(gSDKDef.TDonEvent.pet_share_success, nil)
end
function HeroShareBoxProxy:msgHandlerWhatsAppFail()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.whatsapp
	userSDKManager.logEvent(gSDKDef.TDonEvent.pet_share_fail, nil)
end
function HeroShareBoxProxy:msgHandlerWhatsAppCancel()
	_ENV = nil
	;(nil).channel = gSDKDef.shareChannel.whatsapp
	userSDKManager.logEvent(gSDKDef.TDonEvent.pet_share_cancel, nil)
end
return HeroShareBoxProxy
