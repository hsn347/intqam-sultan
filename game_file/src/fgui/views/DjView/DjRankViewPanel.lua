local djCtrl = SoraDGetCtrl("djCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DjRankViewPanel = class("DjRankViewPanel", baseFguiPanel)
_ENV = "DjRankViewPanel"
;("DjRankViewPanel").ONE_KINGDOM_WEEK = 1
;("DjRankViewPanel").ONE_KINGDOM_MONTH = 2
;("DjRankViewPanel").ONE_KINGDOM_TOTAL = 3
;("DjRankViewPanel").ALL_KINGDOM_WEEK = 4
;("DjRankViewPanel").ALL_KINGDOM_MONTH = 5
;("DjRankViewPanel").ALL_KINGDOM_TOTAL = 6
;("DjRankViewPanel").DJ_WEEK = 7
;("DjRankViewPanel").DJ_MONTH = 8
;("DjRankViewPanel").DJ_TOTAL = 9
;("DjRankViewPanel").MEMBER_MONTH = 10
local ("DjRankViewPanel").MEMBER_TOTAL, ChatAnchorRankType = 11, "DjRankViewPanel"
function DjRankViewPanel:ctor(...)
	self.isLRU = true
	DjRankViewPanel.super.ctor(self, ...)
	print("DjRankViewPanel:ctor", self.viewName)
end
function DjRankViewPanel:onInit()
	self.fields.Com_title:initData(i18n("Anchor_text_103"), handler(self, self.onClickClose))
	self.labelTip = SoraDGetChildByName(self, "Text_tip")
	self.labelTip:setString(i18n("Anchor_text_41"))
	self.labelTip:setVisible(false)
	self.fields.list_tab:setItemRenderer(handler(self, self.updateTabCell))
	self.fields.List_rank:setItemRenderer(handler(self, self.updateCell))
	self.scroll = self.fields.List_rank
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.nodeTab = self.fields.com_Tab
	self.fields.Text_name:fixPos()
	self.fields.Text_rank:fixPos()
	self.fields.Text_score:fixPos()
end
function DjRankViewPanel:endShow()
	print("=======DjRankViewPanel:endShow")
	self.djuid = self.param.uid
	self.selfuid = include("chatFunctions"):getSelfId()
	self.rankSelfData, _ENV, self.rankData, _ENV, self.rankNum = include("chatFunctions"):getSelfId(), include("chatFunctions"):getSelfId(), include("chatFunctions"):getSelfId(), include("chatFunctions"):getSelfId(), 0
	self.startRankType = djCtrl.isBroadcastDJ and ChatAnchorRankType.ALL_KINGDOM_WEEK or ChatAnchorRankType.ONE_KINGDOM_WEEK
	djCtrl:cleanRankList()
	self.rankType = self.startRankType
	self.fields.list_tab:setNumItems(3)
	self.fields.list_tab:setSelectedIndex(0)
	self:updateTab()
end
function DjRankViewPanel:btnJumpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.rankNum > 0 and self.rankNum <= #self.rankData[self.djuid][self.rankType] then
			self.scroll:scrollToView(self.rankNum - 1)
		end
	end
end
function DjRankViewPanel:updateTab()
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.startRankType, self.startRankType
	;(nil).title = i18n("broadcasting_ui_test_2")
	_ENV, self.startRankType[1], (nil).tag = nil, nil, ChatAnchorRankType.ONE_KINGDOM_WEEK
	;(nil).title = i18n("broadcasting_ui_test_3")
	_ENV, self.startRankType[2], (nil).tag = nil, nil, ChatAnchorRankType.ALL_KINGDOM_WEEK
	;(nil).title = i18n("broadcasting_ui_test_4")
	;(nil).tabsetArray, self.startRankType[3], (nil).tag = self.startRankType, nil, ChatAnchorRankType.DJ_WEEK
	;(nil).callback = handler(self, self.tabUpdate)
	self.nodeTab:initView(nil)
end
_UPVALUE3_, DjRankViewPanel.tabUpdate = function(self, tag, name)
	self.rankNum = 0
	self.rankType = tag
	self.startRankType = tag
	self.fields.list_tab:setSelectedIndex(0)
	self:getData()
	self.fields.Text_score:setString(self.startRankType == ChatAnchorRankType.DJ_WEEK and i18n("broadcasting_ui_test_8") or i18n("Anchor_text_104"))
end, function(self, tag, name)
	self.rankNum = 0
	self.rankType = tag
	self.startRankType = tag
	self.fields.list_tab:setSelectedIndex(0)
	self:getData()
	self.fields.Text_score:setString(self.startRankType == ChatAnchorRankType.DJ_WEEK and i18n("broadcasting_ui_test_8") or i18n("Anchor_text_104"))
end
;(function(self, tag, name)
	self.rankNum = 0
	self.rankType = tag
	self.startRankType = tag
	self.fields.list_tab:setSelectedIndex(0)
	self:getData()
	self.fields.Text_score:setString(self.startRankType == ChatAnchorRankType.DJ_WEEK and i18n("broadcasting_ui_test_8") or i18n("Anchor_text_104"))
end)[1] = "broadcasting_ui_test_7"
;(function(self, tag, name)
	self.rankNum = 0
	self.rankType = tag
	self.startRankType = tag
	self.fields.list_tab:setSelectedIndex(0)
	self:getData()
	self.fields.Text_score:setString(self.startRankType == ChatAnchorRankType.DJ_WEEK and i18n("broadcasting_ui_test_8") or i18n("Anchor_text_104"))
end)[2] = "broadcasting_ui_test_6"
local (function(self, tag, name)
	self.rankNum = 0
	self.rankType = tag
	self.startRankType = tag
	self.fields.list_tab:setSelectedIndex(0)
	self:getData()
	self.fields.Text_score:setString(self.startRankType == ChatAnchorRankType.DJ_WEEK and i18n("broadcasting_ui_test_8") or i18n("Anchor_text_104"))
end)[3], titles = "broadcasting_ui_test_5", function(self, tag, name)
	self.rankNum = 0
	self.rankType = tag
	self.startRankType = tag
	self.fields.list_tab:setSelectedIndex(0)
	self:getData()
	self.fields.Text_score:setString(self.startRankType == ChatAnchorRankType.DJ_WEEK and i18n("broadcasting_ui_test_8") or i18n("Anchor_text_104"))
end
function DjRankViewPanel:updateTabCell(index, obj)
	if not obj.addedClick then
		dump(i18n(titles[index + 1]), "i18n(titles[index+1])")
		obj:setTitle(i18n(titles[index + 1]))
		obj:addClickEventListener(handler(self, self.btnClickCallBack), index)
	end
end
function DjRankViewPanel:btnClickCallBack(button, tag)
	SoraDPlaySound()
	self.rankType = tag + self.startRankType
	self:getData()
end
function DjRankViewPanel:getData()
	if djCtrl:initChatDJRank(self.djuid, self.rankType) then
		SoraDShowLoading(self)
	end
end
function DjRankViewPanel:updateView()
	self.rankData = djCtrl:getChatDJRank()
	self.rankSelfData = djCtrl:getChatDJRankSelfInfo()
	self:updateScroll()
	self:updateMine()
	SoraDCloseLoading(self)
end
function DjRankViewPanel:updateMine()
	local _ENV, data
	if not self.rankData[self.djuid] or not self.rankData[self.djuid][self.rankType] then
		local _ENV, rankData = self.rankData[self.djuid][self.rankType], self.rankData[self.djuid][self.rankType]
	end
	for i, v in ipairs(rankData) do
		if v.uid == self.selfuid then
			data = v
			self.rankNum = i
			break
		end
	end
	if next(data) == nil then
		if not self.rankData[self.djuid] or not self.rankData[self.djuid][self.rankType] then
			local _ENV, rankData = self.rankData[self.djuid][self.rankType], self.rankData[self.djuid][self.rankType]
		end
		data = rankData
	end
	_ENV = nil
	;(nil).rankType = self.rankType
	;(nil).isOwnRank = true
	self.fields.Com_ownRank:initData(data, nil)
end
function DjRankViewPanel:updateScroll()
	local count = 0
	if self.rankData and self.djuid and self.rankData[self.djuid] and self.rankType and self.rankData[self.djuid][self.rankType] then
		count = #self.rankData[self.djuid][self.rankType]
	end
	self.labelTip:setVisible(count <= 0)
	self.scroll:setNumItems(count)
	if 0 < count then
		self.scroll:scrollToView(0)
	end
end
function DjRankViewPanel:updateCell(index, obj)
	if self.rankData and self.djuid and self.rankData[self.djuid] and self.rankType and self.rankData[self.djuid][self.rankType] then
		local data = self.rankData[self.djuid][self.rankType][index + 1]
		_UPVALUE2_ = nil
		;(nil)[1] = data
		;(nil)[2] = self.rankType
		dump(nil, "DjRankViewPanel:updateCell")
		_ENV = self.rankType
		self.rankType.rankType = self.rankType
		obj:initData(data, self.rankType)
	end
end
return DjRankViewPanel
