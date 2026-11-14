local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceQuery = gametop.playertop_:getModule("allianceQuery")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local gameSearchPanel = class("gameSearchPanel", baseFguiPanel)
local SearchLord = 1
local SearchAlliance = 2
function gameSearchPanel:ctor(...)
	self.super.ctor(self, ...)
	print("gameSearchPanel:ctor", self.viewName)
end
function gameSearchPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "AllianceCreateView"
	end
	return self._packageList
end
function gameSearchPanel:onInit()
	print("=======gameSearchPanel:onInit")
	self.curType = SearchLord
	self.isAllianceMax = false
	self.allianceDataList, _ENV, self.lordDataList, _ENV, self.isLordMax = SearchLord, SearchLord, SearchLord, SearchLord, false
	self.fields.Button_search:fixPos()
	self.fields.TextField_word:fixPos()
	self.fields.n4:fixPos()
	self.fields.Com_title:initData(i18n("common_text_166"), handler(self, self.onClickClose))
	self.fields.List_Player:setItemRenderer(handler(self, self.onItemPlayerRederer))
	self.fields.List_Alliance:setItemRenderer(handler(self, self.onItemAllianceRederer))
	self.fields.Button_search:addTouchEventListener(handler(self, self.btnSearchClickCallBack))
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.allianceScrollFooter = self.fields.List_Alliance:getScrollPane():getFooter()
	self.playerScrollFooter = self.fields.List_Player:getScrollPane():getFooter()
	self.fields.List_Player:getScrollPane():lockFooter(40)
	self.fields.List_Alliance:getScrollPane():lockFooter(40)
end
function gameSearchPanel:onShow()
	print("=======gameSearchPanel:onShow")
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, SearchLord, SearchLord
	;(nil).title = i18n("common_text_1536")
	_ENV, SearchLord[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("common_text_069")
	;(nil).tabsetArray, SearchLord[2], (nil).tag = SearchLord, nil, 2
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(nil)
end
function gameSearchPanel:updateScrollWithData()
	if self.curType == SearchLord then
		self.fields.List_Player:setNumItems(#self.lordDataList)
	else
		self.fields.List_Alliance:setNumItems(#self.allianceDataList)
	end
	self:updateNotice()
end
function gameSearchPanel:updateNotice()
	self.playerScrollFooter:setString("")
	self.allianceScrollFooter:setString("")
	local isMax = self.curType == SearchLord and self.isLordMax or self.isAllianceMax
	local isNull = (self.curType == SearchLord and #self.lordDataList or #self.allianceDataList) == 0 and self.fields.TextField_word:getText() ~= ""
	local isAll = not isMax and (self.curType == SearchLord and #self.lordDataList or #self.allianceDataList) > 0
	local notice
	if isNull then
		if self.curType == SearchLord then
			notice = i18n("common_text_963")
		else
			notice = i18n("common_text_1061")
		end
	elseif isMax then
		if self.curType == SearchLord then
			self.playerScrollFooter:setString(i18n("common_text_1534"))
		else
			self.allianceScrollFooter:setString(i18n("common_text_1535"))
		end
	elseif isAll then
		if self.curType == SearchLord then
			self.playerScrollFooter:setString(i18n("common_text_1060"))
		else
			self.allianceScrollFooter:setString(i18n("common_text_1060"))
		end
	elseif self.curType == SearchLord then
		notice = i18n("common_text_961")
	else
		notice = i18n("common_text_962")
	end
	if notice then
		self.fields.Text_notice:setVisible(true)
		self.fields.Text_notice:setString(notice)
	else
		self.fields.Text_notice:setVisible(false)
	end
end
function gameSearchPanel:onItemPlayerRederer(index, target)
	target:initData(self.lordDataList[index + 1])
end
function gameSearchPanel:onItemAllianceRederer(index, target)
	target:initSearchData(self.allianceDataList[index + 1])
end
function gameSearchPanel:onClickTab(tag)
	self.curType = tag
	SoraDPlaySound()
	self.controllers.c1:setSelectedIndex(self.curType - 1)
	self.fields.TextField_word:setText("")
	self:updateScrollWithData()
end
function gameSearchPanel:btnSearchClickCallBack()
	SoraDPlaySound()
	local key = string.match(self.fields.TextField_word:getText(), "%s*(.-)%s*$")
	local keyLen = string.utf8len(key)
	if keyLen >= SEARCH_MIN_LEN then
		if self.curType == SearchLord then
			lordInfoCtrl:searchLordAllWorld(key)
		else
			allianceQuery:queryAllianceInfoAllWorld(key)
		end
		SoraDShowLoading(self)
	else
		local typeLabel = ""
		if self.curType == SearchLord then
			typeLabel = i18n("common_text_961")
		else
			typeLabel = i18n("common_text_962")
		end
		SoraDShowMsgBox(typeLabel, i18n("common_text_054"))
	end
end
return gameSearchPanel
