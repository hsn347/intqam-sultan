local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RadiantDecreeUnlockPanel = class("RadiantDecreeUnlockPanel", baseFguiPanel)
function RadiantDecreeUnlockPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("RadiantDecreeUnlockPanel:ctor", self.viewName)
end
function RadiantDecreeUnlockPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RadiantDecreeUnlockPanel:onInit()
	_UPVALUE1_ = nil
	;(nil)[1] = "role"
	for i, v in ipairs(nil) do
		self.fields[v]:fixPos()
	end
	_UPVALUE1_ = ipairs(nil)
	ipairs(nil)[1] = "role"
	for i, v in ipairs(ipairs(nil)) do
		self.fields[v]:fix(false)
	end
	self.fields.btn_close:setString(i18n("common_text_204"))
	if self.proxy.param.isStatue then
		self.fields.title:setString(i18n("GloriousDecree_21"))
	else
		self.fields.title:setString(i18n("GloriousDecree_20"))
	end
	self.fields.Usm_Unlock:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	self.fields.Usm_Unlock:setPrepareCallback(handler(self, self.delayRunAction2))
	self.fields.btn_close:addClickEventListener(handler(self, self.showGiftAndClose))
end
function RadiantDecreeUnlockPanel:onShow()
end
function RadiantDecreeUnlockPanel:delayRunAction2()
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
function RadiantDecreeUnlockPanel:showGiftAndClose()
	SoraDPlaySound()
	if radiantDecreeCtrl:getGiftMsgData() then
		_ENV = radiantDecreeCtrl
		radiantDecreeCtrl.msg = "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
		radiantDecreeCtrl.data = radiantDecreeCtrl:getGiftMsgData()
		SoraDSendMessage(radiantDecreeCtrl)
		radiantDecreeCtrl:resetGiftData()
	end
	self:close()
end
function RadiantDecreeUnlockPanel:onHide()
	_ENV = nil
	;(nil).msg = "MESSAGE_RADIANT_DECREE_REFRESH"
	;(nil).subMsg = "unlockRefresh"
	SoraDSendMessage(nil)
end
return RadiantDecreeUnlockPanel
