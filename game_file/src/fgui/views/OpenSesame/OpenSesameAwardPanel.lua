local baseFguiPanel = require("fgui.base.baseFguiPanel")
local OpenSesameAwardPanel = class("OpenSesameAwardPanel", baseFguiPanel)
function OpenSesameAwardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("OpenSesameAwardPanel:ctor", self.viewName)
end
function OpenSesameAwardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function OpenSesameAwardPanel:onInit()
	print("=======OpenSesameAwardPanel:onInit")
	self.fields.Title:setString(i18n("Mermaid_title_10"))
	self.fields.Text_Title:setString(i18n("Battle_Towers_14"))
	self.fields.Scroll_award:setItemRenderer(handler(self, self.onOneItemRenderer))
	self.fields.Scroll_award_ten:setItemRenderer(handler(self, self.onTenItemRenderer))
	self.fields.btn_close:setTitle(i18n("common_text_247"))
	self.fields.btn_close:addClickEventListener(handler(self, self.close))
end
function OpenSesameAwardPanel:onShow()
	print("=======OpenSesameAwardPanel:onShow")
	self.rewards = self.param.rewards
	self.closeCallback = self.param.onCloseCallback
	self.controllers.c1:setSelectedIndex(#self.rewards <= 1 and 0 or 1)
	if #self.rewards <= 1 then
		self.fields.Scroll_award:setNumItems(#self.rewards)
	else
		self.fields.Scroll_award_ten:setNumItems(#self.rewards)
	end
	self:doShowAnimation()
end
function OpenSesameAwardPanel:onHide()
	if self.closeCallback then
		self.closeCallback()
	end
end
function OpenSesameAwardPanel:doShowAnimation()
	self.view:setScale(0)
	self.isCanCloseSelf = false
	_UPVALUE2_ = nil
	;(nil)[1] = ffa.scaleTo(0.1, 1.05)
	;(nil)[2] = ffa.scaleTo(0.13333333333333333, 1)
	;(nil)[3] = ffa.callFunc(function()
	end)
	;(nil)[4] = ffa.callFunc(function()
	end)
	;(nil)[5] = ffa.callFunc(function()
	end)
	self.view:runAction(ffa.seq(nil))
	self.Bg_black:setAlpha(0)
	_UPVALUE2_ = ffa.seq(nil)
	ffa.seq(nil)[1] = ffa.delay(0.16666666666666666)
	ffa.seq(nil)[2] = ffa.fadeTo(0.11666666666666667, 0.3)
	ffa.seq(nil)[3] = ffa.fadeTo(0.16666666666666666, 0.7)
	ffa.seq(nil)[4] = ffa.fadeTo(0.16666666666666666, 0.7)
	ffa.seq(nil)[5] = ffa.fadeTo(0.16666666666666666, 0.7)
	self.Bg_black:runAction(ffa.seq(ffa.seq(nil)))
end
function OpenSesameAwardPanel:onOneItemRenderer(index, obj)
	local reward = self.rewards[index + 1]
	obj:initData(reward.id, reward.count)
end
function OpenSesameAwardPanel:onTenItemRenderer(index, obj)
	local reward = self.rewards[index + 1]
	obj:initData(reward, index)
end
return OpenSesameAwardPanel
