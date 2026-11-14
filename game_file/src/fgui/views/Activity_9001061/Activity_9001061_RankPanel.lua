local gametop = gModuleMgr.getObject("gametop")
local activityCtrl = gametop.playertop_:getModule("activityCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001061_RankPanel = class("Activity_9001061_RankPanel", baseFguiPanel)
function Activity_9001061_RankPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001061_RankPanel:ctor", self.viewName)
end
function Activity_9001061_RankPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001061_RankPanel:onInit()
	print("=======Activity_9001061_RankPanel:onInit")
	self.totalData, _ENV, self.stageData, _ENV = print, print, print, print
	self.isStageRequested = false
	self.isTotalRequested = false
	self.fields.Text_none:setString(i18n("common_text_1464"))
	self.fields.Panel_bg:setString(i18n("common_text_2713"))
	self.fields.Text_lord:setString(i18n("common_text_1536"))
	self.fields.Text_lord:setVisible(false)
	self.fields.Text_score:setString(i18n("common_text_4881"))
	self.fields.Text_score:setVisible(false)
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
	self.fields.List:setVirtual()
	self.fields.List_cur:setItemRenderer(handler(self, self.onRankRender))
	self.fields.List_cur:setVirtual()
	self.fields.List_cur:setVisible(false)
	local _ENV, tabsetArray = self.fields.List_cur.setVisible, self.fields.List_cur.setVisible
	local defaultType = self.proxy.param.defaultType
	if self.proxy.param.isOnly then
		_ENV, _ENV = handler(self, self.onRankRender)
		handler(self, self.onRankRender).title = i18n("common_text_615")
		tabsetArray, self.proxy.param.isOnly[1], handler(self, self.onRankRender).tag = self.proxy.param.isOnly, handler(self, self.onRankRender)
	else
		_ENV, _ENV = handler(self, self.onRankRender)
		handler(self, self.onRankRender).title = i18n("common_text_4880")
		_ENV, self.proxy.param.isOnly[1], handler(self, self.onRankRender).tag = handler(self, self.onRankRender)
		handler(self, self.onRankRender).title = i18n("common_text_614")
		_ENV, self.proxy.param.isOnly[2], handler(self, self.onRankRender).tag = handler(self, self.onRankRender)
		handler(self, self.onRankRender).title = i18n("common_text_615")
		tabsetArray, self.proxy.param.isOnly[3], handler(self, self.onRankRender).tag = self.proxy.param.isOnly, handler(self, self.onRankRender)
		if self.proxy.param.defaultType == 1 then
			defaultType = 0
		end
	end
	_ENV = i18n("common_text_615")
	i18n("common_text_615").defaultClick = defaultType
	i18n("common_text_615").tabsetArray = tabsetArray
	i18n("common_text_615").callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView((i18n("common_text_615")))
	self.fields.Text_lord:fixPos()
	self.fields.Text_score:fixPos()
end
function Activity_9001061_RankPanel:onShow()
	print("=======Activity_9001061_RankPanel:onShow")
	self.curStageData, _ENV = print, print
	self.isCurStageRequested = false
end
function Activity_9001061_RankPanel:onClickTab(tag)
	self.tag = tag
	self.fields.Text_lord:setVisible(tag == 0)
	self.fields.Text_score:setVisible(tag == 0)
	self.fields.List_cur:setVisible(tag == 0)
	self.fields.List:setVisible(tag ~= 0)
	if tag == 1 then
		self:onStageView()
	elseif tag == 2 then
		self:onHistoryView()
	else
		self:onCurStageView()
	end
end
function Activity_9001061_RankPanel:onRankRender(index, obj)
	obj:initData(self.curStageData[index + 1])
end
function Activity_9001061_RankPanel:onItemRender(index, target)
	if self.tag == 1 then
		target:initData(self.stageData[index + 1], self.tag, index + 1)
	else
		target:initData(self.totalData[index + 1], self.tag, #self.totalData - index)
	end
end
function Activity_9001061_RankPanel:packageData(rankData, rType)
	local _ENV, tab
	for k, v in ipairs(rankData) do
		local stage = rType == 1 and k or #rankData - k + 1
		_ENV = nil
		;(nil).rType = rType
		;(nil).uType = 1
		;(nil).stage = stage
		;(nil).time = v.time
		table.insert(tab, nil)
		local data = rType == 1 and v or v.list
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
function Activity_9001061_RankPanel:onStageView()
	if not self.isStageRequested and not next(activityCtrl.stageRank) then
		self.fields.List:setVisible(false)
		SoraDShowLoading(self)
		activityCtrl:reqStageRankInfo()
		self.isStageRequested = true
	else
		self.stageData = activityCtrl.stageRank
		self.fields.List:setNumItems(#self.stageData)
		self.fields.List:jumpToTop()
		self.fields.List:setVisible(true)
		self.fields.Text_none:setVisible(#self.stageData < 1)
	end
end
function Activity_9001061_RankPanel:onHistoryView()
	if not self.isTotalRequested and not next(activityCtrl.historyRank) then
		self.fields.List:setVisible(false)
		SoraDShowLoading(self)
		activityCtrl:reqHistoryRankInfo()
		self.isTotalRequested = true
	else
		local reverseData = self:reverseTable(activityCtrl.historyRank)
		self.totalData = reverseData
		self.fields.List:setNumItems(#self.totalData)
		self.fields.List:jumpToTop()
		self.fields.List:setVisible(true)
		self.fields.Text_none:setVisible(#self.totalData < 1)
	end
end
function Activity_9001061_RankPanel:onCurStageView()
	if not self.isCurStageRequested then
		self.fields.List_cur:setVisible(false)
		SoraDShowLoading(self)
		activityCtrl:reqCurStageRankInfo()
		self.isCurStageRequested = true
	else
		self.curStageData = activityCtrl.curStageRankList
		self.fields.List_cur:setVisible(#self.curStageData > 0)
		self.fields.List_cur:setNumItems(#self.curStageData)
		self.fields.List_cur:jumpToTop()
		self.fields.Text_none:setVisible(#self.curStageData < 1)
	end
end
function Activity_9001061_RankPanel:reverseTable(tab)
	local _ENV, tmp
	local tabClone = clone(tab)
	for i = 1, #tabClone do
		tmp[i] = table.remove(tabClone)
	end
	return tmp
end
return Activity_9001061_RankPanel
