local gametop = gModuleMgr.getObject("gametop")
local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
local legendMDesRead = include("legendMDesRead")
local baseComponent = require("fgui.base.baseComponent")
local WarSummary = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChronicleView/WarSummary", WarSummary)
_ENV = fgui.register_extension
fgui.register_extension.sort_by_time = 1
local fgui.register_extension.sort_by_hot, SortType = 2, fgui.register_extension
function WarSummary:onInit()
	self.wGet = false
	self.itemsData, SortType, self.listData, SortType, self.sIndex = nil, nil, nil, nil, 1
	self.sortType = SortType.sort_by_time
	_UPVALUE2_, self.isSelfKindom = SortType.sort_by_time, true
	self.ticksList, SortType.sort_by_time[1] = SortType.sort_by_time, "history_text_15"
	self.ticksList, SortType.sort_by_time[2] = SortType.sort_by_time, "history_text_14"
	self.fields.List_Ticks:setItemRenderer(handler(self, self.onItemTicksRederer))
	self.fields.List_Ticks:addClickListener(handler(self, self.onTickClick))
	self.fields.List_Ticks:setNumItems(#self.ticksList)
	self.fields.List_Ticks:setSelectedIndex(self.sortType - 1)
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onScrollEnd))
end
function WarSummary:onChooseClick(curKid)
	SoraDPlaySound()
	self.curKid = curKid
	self.isSelfKindom = gametop.playertop_:getMapID() == curKid
	self.itemsData, _ENV, self.listData, _ENV, self.sIndex = gametop.playertop_:getMapID() == curKid, gametop.playertop_:getMapID() == curKid, gametop.playertop_:getMapID() == curKid, gametop.playertop_:getMapID() == curKid, 1
	self:req4Data(self.sIndex)
	self.fields.List:jumpToTop()
end
function WarSummary:onShow()
end
function WarSummary:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_CIVIL_REPORT_DATA_BACK", handler(self, self.sMsgBattlesDataBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_COUNTRY_REPORT_DATA_BACK", handler(self, self.sMsgBattlesDataBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_LEGENDM_PRAISE_BACK", handler(self, self.sMsgPraiseDataBack))
end
function WarSummary:setPageType(pageType)
	self.wGet = false
	self.itemsData, SortType, self.listData, SortType, self.sIndex = nil, nil, nil, nil, 1
	self.sortType = SortType.sort_by_time
	self.pageType = pageType
	if pageType == legendMDesRead.PageType.SERVERROAD then
		self.pageTitle = i18n("history_text_35")
	elseif pageType == legendMDesRead.PageType.ALLIANCEROAD then
		self.pageTitle = i18n("history_text_43")
	end
	self:req4Data(self.sIndex)
	self.fields.List:jumpToTop()
end
function WarSummary:req4Data(index)
	SoraDShowLoading()
	if self.pageType == legendMDesRead.PageType.KINGDOM_BATTLE then
		legendMCtrl:reqCivilReport(index, self.curKid)
	elseif self.pageType == legendMDesRead.PageType.SERVER_BATTLE then
		legendMCtrl:reqCountryReport(index, self.curKid)
	end
end
function WarSummary:sMsgBattlesDataBack(target, data)
	print("WarSummary:sMsgBattlesDataBack(target, data)")
	self.sIndex = data.idx
	self.wGet = data.wget
	self.isDataBack = true
	self.tempDataList = data.dataList
	self:initScroll()
end
function WarSummary:initScroll()
	SoraDCloseLoading()
	if next(self.tempDataList) ~= nil then
		local cpyTbl = self.tempDataList
		for _, v in ipairs(cpyTbl) do
			table.insert(self.itemsData, v)
		end
		self:reSortData()
	end
end
function WarSummary:reSortData()
	self.listData, _ENV = nil, nil
	for i, v in ipairs(self.itemsData) do
		v.index = i
		_ENV = nil
		;(nil).index = i
		;(nil).pageType = self.pageType
		;(nil).data = v
		table.insert(self.listData, nil)
	end
	if self.sortType == SortType.sort_by_hot then
		table.sort(self.listData, function(l, r)
			return l.data.praiseNum > r.data.praiseNum
		end)
		for i, v in ipairs(self.listData) do
			v.index = i
			v.data.index = i
		end
	end
	self.fields.List:setNumItems(#self.listData)
end
function WarSummary:sMsgPraiseDataBack(target, data)
	dump(data, "WarSummary:sMsgPraiseDataBack(target, data)")
	local reportData = data.reportData
	self.fields.List:setNumItems(#self.listData)
end
function WarSummary:onItemRederer(index, target)
	target:initData(self.listData[index + 1], self.isSelfKindom)
end
function WarSummary:onItemTicksRederer(index, target)
	target:setString(i18n(self.ticksList[index + 1]))
end
function WarSummary:onScrollEnd()
	if self.wGet then
		self:req4Data(self.sIndex)
	end
end
function WarSummary:onTickClick()
	SoraDPlaySound()
	local index = self.fields.List_Ticks:getSelectedIndex()
	self.itemsData, _ENV, self.sortType = index + 1, index + 1, index + 1
	self:initScroll()
end
function WarSummary:getTitle()
	return self.pageTitle
end
return WarSummary
