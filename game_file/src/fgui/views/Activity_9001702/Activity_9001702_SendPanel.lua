local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local activity_9001702_Read = include("activity_9001702_Read")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001702_SendPanel = class("Activity_9001702_SendPanel", baseFguiPanel)
_ENV = "Activity_9001702_SendPanel"
;("Activity_9001702_SendPanel").name = 1
local ("Activity_9001702_SendPanel").uid, SEARCH_TYPE = 2, "Activity_9001702_SendPanel"
function Activity_9001702_SendPanel:ctor(...)
	self.isLRU = true
	Activity_9001702_SendPanel.super.ctor(self, ...)
	print("Activity_9001702_SendPanel:ctor", self.viewName)
end
function Activity_9001702_SendPanel:onInit()
	print("=======Activity_9001702_SendPanel:onInit")
	self.searchType = SEARCH_TYPE.name
	self.giftItemID = activity_9001702_Read.getGiftItemID()
	self.searchLis, _ENV, self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001702, gActivityTimeActivityID.NORMAL_ACTIVITY_9001702, gActivityTimeActivityID.NORMAL_ACTIVITY_9001702
	self.fields.Panel_bg:setString(i18n("Eidal_celebration_text_10"))
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.onClickBtnSearch))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self:initComboBoxSearch()
	if not SoraDFIsRA() then
		self.fields.ComboBox:fixPos()
		self.fields.input:fixPos()
		self.fields.Button_search:fixPos()
	end
end
function Activity_9001702_SendPanel:endShow()
	print("=======Activity_9001702_SendPanel:endShow")
	self.lastSendUid = nil
	self.fields.input:clearInput()
	self.fields.Com_have:initItemID(self.giftItemID)
	_ENV = self.giftItemID
	self.giftItemID.activityID = self.activityID
	function self.giftItemID.updateHandler(searchList)
		self.searchList = searchList
		self:updateSearchList()
	end
	self.fields.Data_searchList:initData(self.giftItemID)
end
function Activity_9001702_SendPanel:initComboBoxSearch(...)
	_ENV = nil
	;(nil)[1] = i18n("common_text_3155")
	local (nil)[2], config = i18n("UID"), nil
	_ENV = nil
	;(nil).items = config
	;(nil).changedCallback = handler(self, self.onComboBoxChanged)
	;(nil).selectedIndex = self.searchType - 1
	;(nil).showCurSelect = true
	self:setComboBox(self.fields.ComboBox, nil)
end
function Activity_9001702_SendPanel:onComboBoxChanged()
	local index = self.fields.ComboBox:getSelectedIndex()
	self.searchType = index + 1
end
function Activity_9001702_SendPanel:onClickBtnSearch()
	SoraDPlaySound()
	local keyname = self.fields.input:getSearchInput()
	if not keyname then
		return
	end
	local name, pid
	if self.searchType == SEARCH_TYPE.uid then
		pid = keyname
	else
		name = keyname
	end
	local gametop = gModuleMgr.getObject("gametop")
	local kid = gametop.playertop_:getMapID()
	lordInfoCtrl:searchLordInThisKingdomReq(name, 1, kid, pid, lordSearchType.PIGEON)
	self.lastSendUid = nil
end
function Activity_9001702_SendPanel:onItemRenderer(index, obj)
	local data = self.searchList[index + 1]
	obj:initData(data)
	obj:setLastSendUid(self.lastSendUid)
end
function Activity_9001702_SendPanel:updateSearchList()
	self.fields.List:setNumItems(#self.searchList)
	self.fields.Text_noData:setString(i18n("friend_text_12"))
	self.fields.Text_noData:setVisible(#self.searchList <= 0)
end
function Activity_9001702_SendPanel:onMsgSearchBack(target, event)
	local uinfolist = event.data.uinfolist
	self.searchList = lordInfoCtrl:filterSearchList(uinfolist)
	self:updateSearchList()
	if #self.searchList <= 0 then
		SoraDShowMsgTip(i18n("friend_text_19"))
	end
end
function Activity_9001702_SendPanel:onMsgUpdate(target, event)
	local subMsg = event.subMsg
	if subMsg == "send" then
		if backpackCtrl:getItemCount(self.giftItemID) >= 5 then
			self.lastSendUid = event.uid
		end
		self:updateSearchList()
	elseif subMsg == "itemCount" and event.itemID == self.giftItemID then
		self.fields.Com_have:updateNum()
		self:updateSearchList()
	end
end
return Activity_9001702_SendPanel
