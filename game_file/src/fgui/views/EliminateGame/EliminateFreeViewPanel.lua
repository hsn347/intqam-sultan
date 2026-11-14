local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EliminateFreeViewPanel = class("EliminateFreeViewPanel", baseFguiPanel)
local starsWishingGameCtrl = SoraDGetCtrl("starsWishingGameCtrl")
function EliminateFreeViewPanel:ctor(...)
	EliminateFreeViewPanel.super.ctor(self, ...)
	print("EliminateFreeViewPanel:ctor", self.viewName)
end
function EliminateFreeViewPanel:onInit()
	print("=======EliminateFreeViewPanel:onInit")
	self.fields.Button_buy:setTitle(i18n("common_text_204"))
	self.fields.Button_buy:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Button_free:setTitle(i18n("common_text_049"))
	self.fields.Button_free:addClickListener(handler(self, self.onClickFree))
	self.fields.text_free:setString(i18n("nebula_stars_wishing_text27"))
	self.view:fixChildrenPos()
end
function EliminateFreeViewPanel:onShow()
	print("=======EliminateFreeViewPanel:onShow")
	local param = self.param
	self:setHandle(param.handle)
	self:initData(param)
end
function EliminateFreeViewPanel:setHandle(handle)
	self.callBackHandle = handle
end
function EliminateFreeViewPanel:initData(showData)
	self.tableShowData = showData
	local msgStr = self.tableShowData.msg
	self.fields.Text_msg:setString(msgStr)
	self.fields.Button_buy:setCostTitle(string.formatnumberthousands(self.tableShowData.gold))
end
function EliminateFreeViewPanel:onClickFree()
	SoraDPlaySound()
	self:close()
	starsWishingGameCtrl:sendNewDayPlusStep()
end
function EliminateFreeViewPanel:btnClickCallBack()
	SoraDPlaySound()
	if SoraDEnoughGold(self.tableShowData.gold) then
		dump(self.callBackHandle, " self.callBackHandle")
		if self.callBackHandle then
			self.callBackHandle()
		end
	end
	self:close()
end
return EliminateFreeViewPanel
