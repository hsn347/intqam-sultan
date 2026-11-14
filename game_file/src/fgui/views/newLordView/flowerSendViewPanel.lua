local flowerSysCtrl = SoraDGetCtrl("flowerSysCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local itemLogic = include("itemLogic")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local flowerSendViewPanel = class("flowerSendViewPanel", baseFguiPanel)
function flowerSendViewPanel:ctor(...)
	self.isLRU = true
	flowerSendViewPanel.super.ctor(self, ...)
	print("flowerSendViewPanel:ctor", self.viewName)
end
function flowerSendViewPanel:onInit()
	print("=======flowerSendViewPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("common_text_2302"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	_ENV = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).num = ""
	self.fields.Text_cur:setString(i18n("common_text_2310", handler(self, self.onClickHelp)))
	self.fields.Label_title:setString(i18n("common_text_2309"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function flowerSendViewPanel:onItemRenderer(index, obj)
	obj:initData(self.resList[index + 1], self.uid)
end
function flowerSendViewPanel:endShow()
	print("=======flowerSendViewPanel:endShow")
	self.uid = self.param.uid
	self.kid = self.param.kid or lordInfoCtrl:getMapSourceKid()
	self.playerInfo = self.param.playerInfo
	if self.playerInfo then
		self.uid = self.playerInfo.base.uid
		self:initView()
	else
		_ENV = nil
		;(nil).targetName = self.__cname
		lordInfoCtrl:getLordInfoByUid(self.uid, self.kid, nil)
		SoraDShowLoading(self)
	end
end
function flowerSendViewPanel:sendFlower(target, data)
	local goodType = backpackltCtrl:getItemType(data.itemID)
	if goodType == gItemType.FLOWER then
		local same = self.playerInfo.flowerSysInfo.same
		local lordInfo = lordInfoCtrl:getLordInfo()
		local ownSame = lordInfo.flowerSysInfo.same
		if not same or not ownSame then
			SoraDShowMsgTip(i18n("common_text_2413"))
			return
		end
	end
	flowerSysCtrl:sendBuy(self.uid, data.itemID, data.itemCount)
end
function flowerSendViewPanel:refreshData(target, data)
	local itemIcon = publicRead.getIcon(data.id)
	local itemName = publicRead.getName(data.id)
	publicRead = nil
	;(nil).itemName = itemName .. "*" .. data.num
	SoraDShowMsgTip(i18n("common_text_422", nil), "#" .. itemIcon)
	publicRead = SoraDShowMsgTip
	SoraDShowMsgTip[802901] = 1
	SoraDShowMsgTip[803001] = 10
	SoraDShowMsgTip[803101] = 100
	SoraDShowMsgTip[809101] = 1
	SoraDShowMsgTip[809201] = 10
	local SoraDShowMsgTip[809301], flowerConfig = 100, SoraDShowMsgTip
	local resultNum = flowerConfig[data.id] * data.num
	self.giftednums = self.giftednums + resultNum
	self.fields.Text_flower:setString(self.giftednums)
end
function flowerSendViewPanel:initView(target, data)
	SoraDCloseLoading(self)
	if data and data.clientData and data.clientData.targetName == self.__cname then
		self.playerInfo = data.lord
	end
	self.fields.Com_head:setHeadSprite(self.playerInfo.base.imageId, self.playerInfo.base.avatar)
	self.fields.Text_name:setString(textParser.formatPlayerName(self.playerInfo.abbr, self.playerInfo.base.nickName))
	self.giftednums = self.playerInfo.flowerSysInfo.giftednums or 0
	self.fields.Text_flower:setString(self.giftednums)
	self:initScroll()
end
function flowerSendViewPanel:initScroll()
	self.resList, lordInfoCtrl = nil, nil
	local lordInfoCtrl, resList
	local same = self.playerInfo.flowerSysInfo.same
	local lordInfo = lordInfoCtrl:getLordInfo()
	local ownSame = lordInfo.flowerSysInfo.same
	local flowerList = backpackltCtrl:getItemArray(gItemType.FLOWER)
	local roseList = backpackltCtrl:getItemArray(gItemType.ROSE)
	if not same or not ownSame then
		resList = roseList
	else
		resList = flowerList
		for k, v in ipairs(roseList) do
			if not SoraDisInList(v, resList) then
				table.insert(resList, v)
			end
		end
	end
	for k, v in ipairs(resList) do
		local itemInfo = shopltCtrl:getShopItemByItemID(v)
		local itemCount = backpackCtrl:getItemCount(v)
		if itemLogic.checkUseCond(v) and (itemInfo or 0 < itemCount) then
			table.insert(self.resList, v)
		end
	end
	self:refreshScroll()
end
function flowerSendViewPanel:refreshScroll()
	self.fields.List:setNumItems(#self.resList)
end
function flowerSendViewPanel:onClickHelp()
	SoraDPlaySound()
	userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.FLOWER_HELP)
end
return flowerSendViewPanel
