local gametop = gModuleMgr.getObject("gametop")
local legendMCtrl = gametop.playertop_:getModule("legendMCtrl")
local legendMDesRead = include("legendMDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LegendMPopListPanel = class("LegendMPopListPanel", baseFguiPanel)
function LegendMPopListPanel:ctor(...)
	self.super.ctor(self, ...)
	print("LegendMPopListPanel:ctor", self.viewName)
end
function LegendMPopListPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function LegendMPopListPanel:onInit()
	print("=======LegendMPopListPanel:onInit")
	self.data = self.proxy.param
	self.wGet = false
	self.itemsData, _ENV, self.listData, _ENV, self.sIndex = self.proxy.param, self.proxy.param, self.proxy.param, self.proxy.param, 1
	self.fields.Text_Time:setString(i18n("history_text_42"))
	self.fields.List:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.scrollBounceBack))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.Button_Close:addClickListener(handler(self, self.onClickClose))
end
function LegendMPopListPanel:onShow()
	print("=======LegendMPopListPanel:onShow")
	self.pageType = self.data.pageType
	self.achieveID = self.data.data.achievementID
	if self.pageType == legendMDesRead.PageType.SERVERROAD then
		self.fields.title:setString(i18n("common_text_082"))
		self.fields.Text_Name:setString(i18n("common_text_069"))
	elseif self.pageType == legendMDesRead.PageType.ALLIANCEROAD then
		self.fields.title:setString(i18n("chat_btn_07"))
		self.fields.Text_Name:setString(i18n("history_text_57"))
	end
	self:req4Data(self.sIndex)
end
function LegendMPopListPanel:req4Data(index)
	SoraDShowLoading()
	if self.pageType == legendMDesRead.PageType.ALLIANCEROAD then
		legendMCtrl:reqAllianceAchieveContent(self.achieveID, index)
	elseif self.pageType == legendMDesRead.PageType.SERVERROAD then
		legendMCtrl:reqKingdomAchieveContent(self.achieveID, index)
	end
end
function LegendMPopListPanel:scrollBounceBack()
	if self.wGet then
		self:req4Data(self.sIndex)
	end
end
function LegendMPopListPanel:onItemRederer(index, target)
	target:initData(self.listData[index + 1])
end
function LegendMPopListPanel:updateList(data)
	self.sIndex = data.idx
	self.wGet = data.wget
	if next(data.dataList) ~= nil then
		local cpyTbl = clone(data.dataList)
		for _, v in ipairs(cpyTbl) do
			table.insert(self.itemsData, v)
		end
		self.listData, _ENV = ipairs(cpyTbl)
		for i, v in ipairs(self.itemsData) do
			v.index = i
			_ENV = v
			v.index = i
			v.data = v
			table.insert(self.listData, v)
		end
		dump(self.listData, "self.listData", 10)
		self.fields.List:setNumItems(#self.listData)
	end
end
return LegendMPopListPanel
