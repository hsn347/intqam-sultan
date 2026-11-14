local publicRead = include("publicRead")
local abcClubCtrl = SoraDGetCtrl("abcClubCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local letterClubViewPanel = class("letterClubViewPanel", baseFguiPanel)
function letterClubViewPanel:ctor(...)
	self.isLRU = true
	letterClubViewPanel.super.ctor(self, ...)
	print("letterClubViewPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.ABC_CLUB
end
function letterClubViewPanel:onInit()
	print("=======letterClubViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_2072"))
	self.fields.Text_reward:setString(i18n("common_text_2078"))
	self.fields.Text_letter:setString(i18n("common_text_2077"))
	self.fields.Button_help:addClickListener(handler(self, self.onClickHelp))
	self.fields.List_letter:setItemRenderer(handler(self, self.onLetterItemRenderer))
	self.fields.List:setItemRenderer(handler(self, self.onMainItemRenderer))
	self.fields.Button_buy:setString(i18n("common_text_2076"))
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBuy))
	self.fields.Button_free:setString(i18n("common_text_049"))
	self.fields.Button_free:addClickListener(handler(self, self.onClickRefresh))
	self.fields.Button_refresh:setString(i18n("common_text_911"))
	self.fields.Button_refresh:addClickListener(handler(self, self.onClickRefresh))
	self.fields.Text_reward:fixPos()
	self.fields.Text_letter:fixPos()
	self.fields.Button_help:fixPos()
	self.fields.Button_buy:fixPos()
	self.fields.Button_free:fixPos()
	self.fields.Button_refresh:fixPos()
end
function letterClubViewPanel:onLetterItemRenderer(index, obj)
	local itemID = self.letterData[index + 1]
	obj:initData(itemID, backpackCtrl:getItemCount(itemID))
end
function letterClubViewPanel:onMainItemRenderer(index, obj)
	obj:initData(self.mainData[index + 1])
end
function letterClubViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("common_text_2074")
	uiManager:show("RuleView", nil)
end
function letterClubViewPanel:endShow()
	print("=======letterClubViewPanel:endShow")
	abcClubCtrl:sendOpenPage()
	SoraDShowLoading(self)
end
function letterClubViewPanel:initView(target, data)
	SoraDCloseLoading(self)
	if data.data and data.data.list then
		self.clubData = data.data
		if self.clubData.goods then
			self.letterData = self.clubData.goods
		end
		if self.clubData.list then
			self.mainData = self.clubData.list
		end
		self:refreshLetterList()
		self:refreshMainList()
		self:updateRefreshBtn()
	else
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function letterClubViewPanel:updateRefreshBtn()
	self.fields.Button_free:setVisible(self.clubData.refreshGold <= 0)
	self.fields.Button_refresh:setVisible(self.clubData.refreshGold > 0)
	if self.clubData.refreshGold > 0 then
		self.fields.Button_refresh:setCost(gIDDef.GOLD, self.clubData.refreshGold)
		self.fields.Button_refresh:setIsEnough(SoraDEnoughGold(self.clubData.refreshGold, true))
	end
end
function letterClubViewPanel:updateLetter(target, data)
	self:refreshLetterList()
	if not data or not data.itemMap then
		local _ENV, itemMap = data.itemMap, data.itemMap
	end
	local isBuy = false
	for k, v in pairs(itemMap) do
		if 0 < v and backpackltCtrl:getItemType(tonumber(k)) == gItemType.ACTIVITY_ITEM then
			isBuy = true
			break
		end
	end
	if isBuy then
		self:refreshMainList()
	end
end
function letterClubViewPanel:refreshLetterList()
	self.fields.List_letter:setNumItems(#self.letterData)
end
function letterClubViewPanel:refreshMainList()
	self.fields.List:setNumItems(#self.mainData)
end
function letterClubViewPanel:onClickBuy()
	SoraDPlaySound()
	if self.clubData.goods then
		_ENV = nil
		;(nil).type = 1
		;(nil).mid = self.clubData.goods[1]
		uiManager:show("bagView", nil)
	end
end
function letterClubViewPanel:onClickRefresh()
	SoraDPlaySound()
	if self.clubData.refreshGold and SoraDEnoughGold(self.clubData.refreshGold) then
		SoraDShowLoading(self)
		abcClubCtrl:sendRefresh()
		for _, v in ipairs(self.fields.List:getChildren()) do
			v:runSlot()
		end
	end
end
return letterClubViewPanel
