local artisanHouseCtrl = SoraDGetCtrl("artisanHouseCtrl")
local basePanel = require("fgui.base.baseFguiPanel")
local ArtisanHouseUnlockPanel = class("ArtisanHouseUnlockPanel", basePanel)
function ArtisanHouseUnlockPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function ArtisanHouseUnlockPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "ArtisanHouse"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function ArtisanHouseUnlockPanel:onInit()
	self.fields.btn_close:setString(i18n("common_text_204"))
	self.fields.title:setString(i18n("Artisan_House_18"))
	self.fields.Usm_Unlock:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.fields.Usm_Unlock:setPrepareCallback(handler(self, self.delayRunAction2))
	self.fields.btn_close:addClickEventListener(handler(self, self.showGiftAndClose))
end
function ArtisanHouseUnlockPanel:onShow()
end
function ArtisanHouseUnlockPanel:delayRunAction2()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.8166666666666667)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.Usm_Unlock:play()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.Usm_Unlock:play()
	end)
	self:runAction(ffa.seq(nil))
end
function ArtisanHouseUnlockPanel:showGiftAndClose()
	if artisanHouseCtrl:getGiftMsgData() then
		artisanHouseCtrl = artisanHouseCtrl
		artisanHouseCtrl.msg = "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
		artisanHouseCtrl.data = artisanHouseCtrl:getGiftMsgData()
		SoraDSendMessage(artisanHouseCtrl)
		artisanHouseCtrl:resetGiftData()
	end
	self:close()
end
return ArtisanHouseUnlockPanel
