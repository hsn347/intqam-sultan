local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001666_ResultPanel = class("Activity_9001666_ResultPanel", baseFguiPanel)
function Activity_9001666_ResultPanel:ctor(...)
	Activity_9001666_ResultPanel.super.ctor(self, ...)
	print("Activity_9001666_ResultPanel:ctor", self.viewName)
end
function Activity_9001666_ResultPanel:onInit()
	print("=======Activity_9001666_ResultPanel:onInit")
	self.fields.title:setString(i18n("snow_competition_text_24"))
	self.fields.title:enableGradient(cc.c3b(230, 219, 197), cc.c3b(178, 140, 68))
	self.fields.title:enableShadow(cc.c3b(15, 6, 2), cc.size(2, -2))
	self.fields.Label_title:setTitle(i18n("feast_the_world_text_14"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.btn_sure:setTitle(i18n("HeroWeapon_25"))
	self.fields.btn_sure:addClickEventListener(handler(self, self.onBackClick))
	self.fields.close_click:addEventListener(fgui.UIEventType.Click, handler(self, self.onBackClick))
	if not self.param or not self.param.data then
		_ENV = self.param.data
	end
	self.data = self.param.data
	if not self.param or not self.param.reward then
		_ENV = self.param.reward
	end
	self.reward = self.param.reward
	self.backCallback = self.param and self.param.backCallback or nil
end
function Activity_9001666_ResultPanel:onShow()
	print("=======Activity_9001666_ResultPanel:onShow")
	self:updateView()
end
function Activity_9001666_ResultPanel:onHide()
	if self.backCallback then
		self.backCallback()
	end
end
function Activity_9001666_ResultPanel:updateView()
	local distance = self.data.distance or 0
	self.fields.text_distance:setString(distance .. "m")
	self.fields.list:setNumItems(#self.reward)
end
function Activity_9001666_ResultPanel:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Activity_9001666_ResultPanel:onBackClick()
	SoraDPlaySound()
	self:close()
end
return Activity_9001666_ResultPanel
