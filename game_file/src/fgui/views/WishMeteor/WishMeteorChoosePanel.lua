local wishingMeteorCtrl = SoraDGetCtrl("wishingMeteorCtrl")
local wishingMeteorRead = include("wishingMeteorRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WishMeteorChoosePanel = class("WishMeteorChoosePanel", baseFguiPanel)
function WishMeteorChoosePanel:ctor(...)
	self.super.ctor(self, ...)
	print("WishMeteorChoosePanel:ctor", self.viewName)
end
function WishMeteorChoosePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function WishMeteorChoosePanel:onInit()
	print("=======WishMeteorChoosePanel:onInit")
	self.chooseList, _ENV = print, print
	self.chooseNum = 0
	self.awardConfig = wishingMeteorRead.getAwardConfig()
	self.fields.panel_normal:setString(i18n("Lamp_secret_text_12"))
	self.fields.Button_Sure:setString(i18n("common_text_204"))
	self.fields.Button_Sure:addTouchEventListener(handler(self, self.onClickSure))
	self.fields.Text_Tips:setString(i18n("Wishing_Meteor_08"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
end
function WishMeteorChoosePanel:onShow()
	print("=======WishMeteorChoosePanel:onShow")
	self.fields.List:setNumItems(#self.awardConfig)
end
function WishMeteorChoosePanel:onItemRender(index, target)
	target:initData(index, self.awardConfig[index + 1])
	target:setHandle(handler(self, self.itemChooseBack))
end
function WishMeteorChoosePanel:itemChooseBack(index, isChoosed, chooseList)
	if isChoosed then
		dump(chooseList, "chooseList")
		local _ENV, ret = dump, dump
		for i, id in ipairs(chooseList) do
			if id then
				table.insert(ret, id)
			end
		end
		self.chooseList[index] = ret
	else
		self.chooseList[index], _ENV = self.chooseList, self.chooseList
	end
end
function WishMeteorChoosePanel:onClickSure()
	SoraDPlaySound()
	print("self.chooseNum", self.chooseNum)
	if self:isAllChoosed() then
		_ENV = nil
		;(nil).content = i18n("Wishing_Meteor_11")
		;(nil).confirmString = i18n("common_text_204")
		;(nil).confirmFunc = function()
			wishingMeteorCtrl = nil
			;(nil).wish = self.chooseList
			wishingMeteorCtrl:reqWishingMeteorWish(nil)
			self:close()
		end
		uiManager:show("MessageBox", nil)
	else
		SoraDShowMsgTip(i18n("Wishing_Meteor_10"))
	end
end
function WishMeteorChoosePanel:isAllChoosed()
	for i, v in ipairs(self.chooseList) do
		if not next(v) then
			return false
		end
	end
	return table.nums(self.chooseList) == 4
end
return WishMeteorChoosePanel
