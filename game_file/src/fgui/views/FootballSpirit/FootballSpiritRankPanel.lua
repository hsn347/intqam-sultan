local footballElfCtrl = SoraDGetCtrl("footballElfCtrl")
local footballElfRead = include("footballElfRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local gametop = gModuleMgr.getObject("gametop")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FootballSpiritRankPanel = class("FootballSpiritRankPanel", baseFguiPanel)
function FootballSpiritRankPanel:ctor(...)
	self.super.ctor(self, ...)
	print("FootballSpiritRankPanel:ctor", self.viewName)
end
function FootballSpiritRankPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function FootballSpiritRankPanel:onInit()
	print("=======FootballSpiritRankPanel:onInit")
	self.awardList, _ENV, self.rankList, _ENV, self.tabIndex = print, print, print, print, 0
	self.fields.Com_title:initData(i18n("footballelf_17"), handler(self, self.onClickClose))
	self.fields.text_none:setString(i18n("herobattle_text_05"))
	self.fields.Text_tip:setString(i18n("footballelf_18"))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_award:setVirtual()
	self.fields.List_award:setItemRenderer(handler(self, self.onAwardItemRenderer))
	_ENV = handler(self, self.onAwardItemRenderer)
	_ENV, _ENV, handler(self, self.onAwardItemRenderer).defaultClick = handler(self, self.onAwardItemRenderer)
	handler(self, self.onAwardItemRenderer).title = i18n("Nebulaking_title_06")
	_ENV, self.tabIndex[1], handler(self, self.onAwardItemRenderer).tag = handler(self, self.onAwardItemRenderer)
	handler(self, self.onAwardItemRenderer).title = i18n("snowwolf_text_10")
	handler(self, self.onAwardItemRenderer).tabsetArray, self.tabIndex[2], handler(self, self.onAwardItemRenderer).tag = self.tabIndex, handler(self, self.onAwardItemRenderer)
	handler(self, self.onAwardItemRenderer).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(handler(self, self.onAwardItemRenderer))
end
function FootballSpiritRankPanel:onRankItemRenderer(index, obj)
	obj:initData(0, self.rankList[index + 1], index + 1)
end
function FootballSpiritRankPanel:onAwardItemRenderer(index, obj)
	obj:initData(1, self.awardList[index + 1], index + 1)
end
function FootballSpiritRankPanel:onShow()
	print("=======FootballSpiritRankPanel:onShow")
	self.controllers.c1:setSelectedIndex(self.tabIndex)
	self:updateUI()
end
function FootballSpiritRankPanel:onClickTab(index)
	print("index====", index)
	if self.tabIndex == index then
		return
	end
	self.tabIndex = index
	self.controllers.c1:setSelectedIndex(self.tabIndex)
	self:updateUI()
end
function FootballSpiritRankPanel:updateUI()
	if self.tabIndex == 0 then
		footballElfCtrl:sendRank()
	elseif self.tabIndex == 1 then
		self.fields.text_none:setVisible(false)
		self.awardList = footballElfRead.getRankAward()
		self.fields.List_award:setNumItems(#self.awardList)
	end
end
function FootballSpiritRankPanel:rankDataBack(target, data)
	local rankList = data.rankList
	local selfRank = data.selfRank
	local showCount = math.ceil(self.fields.List_rank:getContentSize().height / 106)
	print("showCount====", showCount, #rankList)
	if not next(rankList) then
		for i = 1, showCount do
			_ENV = nil
			;(nil).empty = true
			table.insert(self.rankList, nil)
		end
		self.fields.List_rank:getScrollPane():setTouchEffect(false)
		self.fields.text_none:setVisible(true)
		self.fields.List_rank:setNumItems(#self.rankList)
		local info = lordInfoCtrl:getBaseInfo()
		_ENV = table.insert
		table.insert.ranking = footballElfCtrl:getExp()
		table.insert.allianceName = allianceMgr:getAllianceProperty("abbr")
		table.insert.nickName = info.nickName
		table.insert.iconID = info.imageId
		table.insert.avatar = info.avatar
		table.insert.uid = gametop.playertop_:getPlayerID()
		self.fields.Com_me:initData(0, table.insert, 0, true)
	else
		self.fields.List_rank:getScrollPane():setTouchEffect(showCount <= #rankList)
		self.fields.text_none:setVisible(false)
		self.rankList = rankList
		if selfRank == 0 or not self.rankList[selfRank] then
			local info = lordInfoCtrl:getBaseInfo()
			_ENV = table.insert
			table.insert.ranking = self.rankList[selfRank] and self.rankList[selfRank].ranking or footballElfCtrl:getExp()
			table.insert.allianceName = allianceMgr:getAllianceProperty("abbr")
			table.insert.nickName = info.nickName
			table.insert.iconID = info.imageId
			table.insert.avatar = info.avatar
			table.insert.uid = gametop.playertop_:getPlayerID()
			self.fields.Com_me:initData(0, table.insert, selfRank, true)
		else
			self.fields.Com_me:initData(0, self.rankList[selfRank], selfRank, true)
		end
		if showCount > #rankList then
			for i = #rankList + 1, showCount do
				_ENV = true
				;(true).empty = true
				table.insert(self.rankList, true)
			end
		end
		self.fields.List_rank:setNumItems(#self.rankList)
	end
end
return FootballSpiritRankPanel
