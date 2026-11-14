local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001629_WishPanel = class("Activity_9001629_WishPanel", baseFguiPanel)
local activity_9001629_Read = include("activity_9001629_Read")
local constantRead = include("constantRead")
local activity_9001629_Ctrl = SoraDGetCtrl("activity_9001629_Ctrl")
function Activity_9001629_WishPanel:ctor(...)
	Activity_9001629_WishPanel.super.ctor(self, ...)
	print("Activity_9001629_WishPanel:ctor", self.viewName)
	self.debug = true
end
function Activity_9001629_WishPanel:onInit()
	print("=======Activity_9001629_WishPanel:onInit")
	self.fields.text_choose_tip:setString(i18n("nebula_stars_wishing_text12"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.btn_bless_self:setString(i18n("nebula_stars_wishing_text13"))
	self.fields.btn_bless_self:addClickListener(handler(self, self.onBlessSelfClick))
	self.fields.btn_bless_other:setString(i18n("nebula_stars_wishing_text15"))
	self.fields.btn_bless_other:addClickListener(handler(self, self.onBlessOtherClick))
	self.selectedIndex, _ENV, self.blessList = activity_9001629_Read.getWishingTextList(), activity_9001629_Read.getWishingTextList(), activity_9001629_Read.getWishingTextList()
	self.maxSelectedNum = constantRead.getConstValue("STARS_BATTLE_TEXT_NUM", 3)
	self.fields.btn_bless_self:fixPos()
	self.fields.btn_bless_other:fixPos()
end
function Activity_9001629_WishPanel:onShow()
	print("=======Activity_9001629_WishPanel:onShow")
	self:updateView()
end
function Activity_9001629_WishPanel:updateView()
	self.fields.list:setNumItems(#self.blessList)
	self:updateNum()
end
function Activity_9001629_WishPanel:updateNum()
	self.selectedNum = 0
	for i, v in pairs(self.selectedIndex) do
		if v then
			self.selectedNum = self.selectedNum + 1
		end
	end
	_UPVALUE2_ = pairs(self.selectedIndex)
	pairs(self.selectedIndex)[1] = self.selectedIndex
	pairs(self.selectedIndex)[2] = self.selectedNum
	dump(pairs(self.selectedIndex))
	_ENV = nil
	;(nil).num1 = self.selectedNum
	;(nil).num2 = self.maxSelectedNum
	self.fields.text_choose:setString(i18n("nebula_stars_wishing_text10", nil))
	self.fields.btn_bless_self:setBright(self.selectedNum > 0)
	self.fields.btn_bless_other:setBright(self.selectedNum > 0)
end
function Activity_9001629_WishPanel:onItemRenderer(index, obj)
	obj:initData(self.blessList[index + 1], index + 1)
	obj:setIsSelectedText(self.selectedIndex[index + 1])
	obj:setClickCallback(handler(self, self.onTextClicked))
end
function Activity_9001629_WishPanel:onBlessSelfClick()
	SoraDPlaySound()
	if self.selectedNum <= 0 then
		SoraDShowMsgTip(i18n("nebula_stars_wishing_text14"))
		return
	end
	local _ENV, texts = SoraDShowMsgTip, SoraDShowMsgTip
	for i, v in pairs(self.selectedIndex) do
		if v then
			table.insert(texts, i)
		end
	end
	activity_9001629_Ctrl:reqWish(nil, texts)
	self:close()
end
function Activity_9001629_WishPanel:onBlessOtherClick()
	SoraDPlaySound()
	if self.selectedNum <= 0 then
		SoraDShowMsgTip(i18n("nebula_stars_wishing_text14"))
		return
	end
	local _ENV, texts = SoraDShowMsgTip, SoraDShowMsgTip
	for i, v in pairs(self.selectedIndex) do
		if v then
			table.insert(texts, i)
		end
	end
	_ENV = i18n("nebula_stars_wishing_text14")
	i18n("nebula_stars_wishing_text14").texts = texts
	uiManager:show("Activity_9001629_Choose", i18n("nebula_stars_wishing_text14"))
	self:close()
end
function Activity_9001629_WishPanel:onTextClicked(obj, idx)
	local isSelected = not self.selectedIndex[idx]
	if isSelected and self.selectedNum + 1 > self.maxSelectedNum then
		SoraDShowMsgTip(i18n("nebula_stars_wishing_text11"))
		return
	end
	self.selectedIndex[idx] = not self.selectedIndex[idx]
	obj:setIsSelectedText(self.selectedIndex[idx])
	self:updateNum()
end
return Activity_9001629_WishPanel
