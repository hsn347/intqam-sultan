local nebulaAllStarRead = include("nebulaAllStarRead")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local publicRead = include("publicRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarReceiveGiftRecordPanel = class("NebulaAllStarReceiveGiftRecordPanel", baseFguiPanel)
function NebulaAllStarReceiveGiftRecordPanel:ctor(...)
	NebulaAllStarReceiveGiftRecordPanel.super.ctor(self, ...)
	print("NebulaAllStarReceiveGiftRecordPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
end
function NebulaAllStarReceiveGiftRecordPanel:onInit()
	print("=======NebulaAllStarReceiveGiftRecordPanel:onInit")
	self.tag = 1
	self.recvGiftRankList, _ENV, self.recvGiftShowList, _ENV, self.recvGiftRecordList, _ENV, self.curSortType = print, print, print, print, print, print, 0
	self.fields.Com_title:initData(i18n("NebulaAllstar_167"), handler(self, self.onClickClose))
	self.fields.Text_sendGift:setString(i18n("NebulaAllstar_179"))
	self.fields.Text_gainScore:setString(i18n("NebulaAllstar_177"))
	self.fields.Text_gainItem:setString(i18n("NebulaAllstar_176"))
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_name:setString(i18n("common_text_2037"))
	self.fields.Text_score:setString(i18n("NebulaAllstar_180"))
	self.fields.Text_none:setString(i18n("NebulaAllstar_311"))
	self.fields.Text_none:setVisible(false)
	self.fields.List_gift:setVirtual()
	self.fields.List_gift:setItemRenderer(handler(self, self.onGiftRenderer))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankRenderer))
	_ENV = self.fields.List_rank.setItemRenderer
	backpackltCtrl, self.fields.List_rank.setItemRenderer[1] = i18n("NebulaAllstar_175")
	backpackltCtrl, self.fields.List_rank.setItemRenderer[2] = i18n("NebulaAllstar_175")
	backpackltCtrl, self.fields.List_rank.setItemRenderer[3] = i18n("NebulaAllstar_175")
	backpackltCtrl, self.fields.List_rank.setItemRenderer[4] = i18n("NebulaAllstar_175")
	backpackltCtrl, self.fields.List_rank.setItemRenderer[5] = i18n("NebulaAllstar_175")
	backpackltCtrl, self.fields.List_rank.setItemRenderer[6] = i18n("NebulaAllstar_175")
	backpackltCtrl, self.fields.List_rank.setItemRenderer[7] = i18n("NebulaAllstar_175")
	backpackltCtrl, self.fields.List_rank.setItemRenderer[8] = i18n("NebulaAllstar_175")
	backpackltCtrl, self.fields.List_rank.setItemRenderer[9] = i18n("NebulaAllstar_175")
	backpackltCtrl, self.fields.List_rank.setItemRenderer[10] = i18n("NebulaAllstar_175")
	backpackltCtrl, self.fields.List_rank.setItemRenderer[11] = i18n("NebulaAllstar_175")
	local backpackltCtrl, self.fields.List_rank.setItemRenderer[12], items = i18n("NebulaAllstar_175")
	local self.itemList, _ENV, i18n("NebulaAllstar_175")[1], values = 0, 0, 0, i18n("NebulaAllstar_175")
	local itemList = backpackltCtrl:getItemListByType(gItemEffectDef.NEBULA_ALLSTAR_GIFT)
	for k, v in ipairs(itemList) do
		local result = backpackltCtrl:getResult(v)
		_ENV = i18n("NebulaAllstar_175")
		i18n("NebulaAllstar_175").id = v
		i18n("NebulaAllstar_175").resultVal = result[1]
		i18n("NebulaAllstar_175").resultType = result[2]
		table.insert(self.itemList, i18n("NebulaAllstar_175"))
	end
	table.sort(self.itemList, function(a, b)
		if a.resultType < b.resultType then
			return true
		end
		if a.resultVal < b.resultVal then
			return true
		end
		return a.id < b.id
	end)
	for k, v in ipairs(self.itemList) do
		table.insert(values, k)
		table.insert(items, publicRead.getName(v.id))
	end
	_ENV = i18n("NebulaAllstar_175")
	i18n("NebulaAllstar_175").items = items
	i18n("NebulaAllstar_175").values = values
	i18n("NebulaAllstar_175").changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox_sort, i18n("NebulaAllstar_175"))
	local dropdown = self.fields.ComboBox_sort:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox_sort:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.curSortType)
	end)
	self.fields.ComboBox_sort:fixChildrenPos()
	self.fields.nbg:fix()
	self.fields.Text_myVal:fixPos()
	self.fields.Text_myRank:fixPos()
	self.fields.Text_myReceived:fixPos()
	self.fields.Text_sendGift:fixPos()
	self.fields.Text_gainScore:fixPos()
	self.fields.Text_gainItem:fixPos()
	self.fields.Text_rank:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_score:fixPos()
end
function NebulaAllStarReceiveGiftRecordPanel:onShow()
	print("=======NebulaAllStarReceiveGiftRecordPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	SoraDShowLoading(self)
	nebulaAllStarCtrl:reqRankData(nebulaAllStarRead.NEBULA_ALLSTAR_WAR_PLAYER_RANK_TYPE.CHARM, 1, 10, self:getName())
	nebulaAllStarCtrl:reqPlayerData(SoraDGetPlayerID(), self:getName())
	_ENV = SoraDGetPlayerID()
	_ENV, _ENV, SoraDGetPlayerID().defaultClick = self:getName()
	self:getName().title = i18n("NebulaAllstar_173")
	_ENV, self.tag[1], self:getName().tag = self:getName()
	self:getName().title = i18n("NebulaAllstar_174")
	SoraDGetPlayerID().tabsetArray, self.tag[2], self:getName().tag = self.tag, self:getName()
	SoraDGetPlayerID().callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView((SoraDGetPlayerID()))
end
function NebulaAllStarReceiveGiftRecordPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.tag == 1 then
		SoraDShowLoading(self)
		nebulaAllStarCtrl:reqRecvGiftRecord()
	elseif self.tag == 2 then
		SoraDShowLoading(self)
		nebulaAllStarCtrl:reqRecvGiftRank()
	end
end
function NebulaAllStarReceiveGiftRecordPanel:onGiftRenderer(index, obj)
	obj:initData(self.recvGiftShowList[index + 1])
end
function NebulaAllStarReceiveGiftRecordPanel:onRankRenderer(index, obj)
	obj:initData(self.recvGiftRankList[index + 1], index + 1)
end
function NebulaAllStarReceiveGiftRecordPanel:onMsgRecvGiftRecord(target, data)
	SoraDCloseLoading(self)
	if not data.list then
		_ENV = data.list
	end
	self.recvGiftRecordList = data.list
	self:setRecordList()
end
function NebulaAllStarReceiveGiftRecordPanel:onMsgRecvGiftRank(target, data)
	SoraDCloseLoading(self)
	if not data.list then
		_ENV = data.list
	end
	self.recvGiftRankList = data.list
	self.fields.Text_none:setVisible(#self.recvGiftRankList == 0)
	self.fields.List_rank:setNumItems(#self.recvGiftRankList)
end
function NebulaAllStarReceiveGiftRecordPanel:onComboBoxClick()
	SoraDPlaySound()
	self.curSortType = tonumber(self.fields.ComboBox_sort:getValue())
	print("self.curSortType", self.curSortType)
	self:setRecordList()
end
function NebulaAllStarReceiveGiftRecordPanel:setRecordList()
	self.recvGiftShowList = self:sortRecord(self.recvGiftRecordList)
	self.fields.Text_none:setVisible(#self.recvGiftShowList == 0)
	self.fields.List_gift:setNumItems(#self.recvGiftShowList)
end
function NebulaAllStarReceiveGiftRecordPanel:sortRecord(list)
	local newList = list
	if self.curSortType ~= 0 then
		newList, _ENV = self.curSortType, self.curSortType
		local id = self.itemList[self.curSortType].id
		for k, v in ipairs(list) do
			if v.itemId == id then
				table.insert(newList, v)
			end
		end
	end
	return newList
end
function NebulaAllStarReceiveGiftRecordPanel:updateMyRankInfo(myInfo)
	SoraDCloseLoading(self)
	local rankStr = nebulaAllStarUtil.getRankStr(myInfo.rank or 0)
	_ENV = nil
	;(nil).num = fguiHelper.getColorString("#FFD43E", rankStr)
	self.fields.Text_myRank:setString(i18n("NebulaAllstar_171", nil))
	local charmStr = string.formatnumberthousands(myInfo.charm or 0)
	_ENV = i18n("NebulaAllstar_171", nil)
	i18n("NebulaAllstar_171", nil).num = fguiHelper.getColorString("#FFD43E", charmStr)
	self.fields.Text_myVal:setString(i18n("NebulaAllstar_170", i18n("NebulaAllstar_171", nil)))
end
function NebulaAllStarReceiveGiftRecordPanel:onMsgPlayerData(target, data)
	local giftBandage = data.player.giftBandageCount or 0
	local maxBandage = nebulaAllStarRead.getConstValue("MaxBandage", 0)
	nebulaAllStarRead = nil
	;(nil).num1 = fguiHelper.getColorString(giftBandage >= maxBandage and "#E02B2B" or "#FFD43E", string.formatnumberthousands(giftBandage))
	;(nil).num2 = fguiHelper.getColorString("#FFD43E", string.formatnumberthousands(maxBandage))
	self.fields.Text_myReceived:setString(i18n("NebulaAllstar_172", nil))
end
return NebulaAllStarReceiveGiftRecordPanel
