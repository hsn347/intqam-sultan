local gametop = gModuleMgr.getObject("gametop")
local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_historyRank = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RomanSoulNew/Com_historyRank", Com_historyRank)
function Com_historyRank:onInit()
	self.fields.List_rank:setVirtual()
	self.fields.List_allianceRank:setVirtual()
	self.fields.List_rank:setVirtual()
	self.fields.List_allianceRank:setVirtual()
	_ENV, _UPVALUE2_ = self.fields.List_allianceRank, self.fields.List_allianceRank.setVirtual
	self.fields.List_allianceRank.tag = 1
	self.fields.List_allianceRank.title = i18n("common_text_1491")
	self.fields.List_allianceRank.handle = self.onStageView
	_ENV, self.fields.List_allianceRank.parent = self.onStageView, self
	self.onStageView.tag = 2
	self.onStageView.title = i18n("common_text_1490")
	self.onStageView.handle = self.onHistoryView
	self.onStageView.parent = self
	self.param, self.fields.List_allianceRank.setVirtual[1] = self.fields.List_allianceRank.setVirtual, self.fields.List_allianceRank
	self.param, self.fields.List_allianceRank.setVirtual[2] = self.fields.List_allianceRank.setVirtual, self.onStageView
	self.fields.Text_none:setString(i18n("common_text_1464"))
	self.fields.Text_none:setVisible(false)
	self.fields.List_tab:setItemRenderer(handler(self, self.onItemRendererTab))
	self.fields.List_tab:setNumItems(table.nums(self.param))
end
function Com_historyRank:initData(index)
	if not self.index then
		self:onStageView()
		self.index = 1
	elseif self.index == 1 then
		self:onStageView()
	else
		self:onHistoryView()
	end
end
function Com_historyRank:setStageData(target, data)
	SoraDCloseLoading(self:displayObject())
	self.index = 1
	self:setTab(1)
	self.personInfo = self:packageData(data.redata, 2)
	self.fields.List_rank:setItemRenderer(handler(self, self.onItemRendererPerson))
	self.fields.List_rank:setNumItems(table.nums(self.personInfo))
	if table.nums(self.personInfo) > 0 then
		self.fields.Text_none:setVisible(false)
		self.fields.List_rank:scrollToView(0)
	else
		self.fields.Text_none:setVisible(true)
	end
end
function Com_historyRank:setTotalData(target, data)
	SoraDCloseLoading(self:displayObject())
	self.index = 2
	self:setTab(2)
	self.allianceInfo = self:packageData(data.redata, 2)
	self.fields.List_allianceRank:setItemRenderer(handler(self, self.onItemRendererAlliance))
	self.fields.List_allianceRank:setNumItems(table.nums(self.allianceInfo))
	if table.nums(self.allianceInfo) > 0 then
		self.fields.Text_none:setVisible(false)
		self.fields.List_allianceRank:scrollToView(0)
	else
		self.fields.Text_none:setVisible(true)
	end
end
function Com_historyRank:setTab(index)
	self.controllers.state:setSelectedIndex(index - 1)
	for i = 1, 2 do
		if i == index then
			self.fields.List_tab:getChildAt(i - 1):setTitleColor(cc.c3b(255, 245, 175))
			self.fields.List_tab:getChildAt(i - 1):setMask(true)
		else
			self.fields.List_tab:getChildAt(i - 1):setTitleColor(cc.c3b(144, 132, 97))
			self.fields.List_tab:getChildAt(i - 1):setMask(false)
		end
	end
end
function Com_historyRank:onItemRendererPerson(index, object)
	object:initData(index, self.personInfo[index + 1])
end
function Com_historyRank:onItemRendererAlliance(index, object)
	object:initData(index, self.allianceInfo[index + 1])
end
function Com_historyRank:packageData(rankData, rType)
	local _ENV, tab
	if rankData == nil then
	end
	if table.nums(rankData) == 0 then
	end
	for i = table.nums(rankData), 1, -1 do
		local stage = i
		_ENV = nil
		;(nil).rType = rType
		;(nil).uType = 1
		;(nil).stage = stage
		;(nil).time = rankData[i].time
		table.insert(tab, nil)
		local data = rankData[i].list
		for rank, info in ipairs(data) do
			_ENV = nil
			;(nil).rType = rType
			;(nil).uType = 2
			;(nil).info = info
			table.insert(tab, nil)
		end
	end
	return tab
end
function Com_historyRank:onStageView()
	SoraDShowLoading(self:displayObject())
	romeActivityCtrl:reqMemberRankInfo()
end
function Com_historyRank:onHistoryView()
	SoraDShowLoading(self:displayObject())
	romeActivityCtrl:reqAllianceRankInfo()
end
function Com_historyRank:onItemRendererTab(index, object)
	object:initData(index, self.param[index + 1])
end
function Com_historyRank:onShow()
end
return Com_historyRank
