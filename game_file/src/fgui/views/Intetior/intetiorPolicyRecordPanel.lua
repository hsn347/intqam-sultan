local gametop = gModuleMgr.getObject("gametop")
local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local intetiorPolicyRecordPanel = class("intetiorPolicyRecordPanel", baseFguiPanel)
local MAX_REQ_NUM = 10
function intetiorPolicyRecordPanel:ctor(...)
	self.super.ctor(self, ...)
	print("intetiorPolicyRecordPanel:ctor", self.viewName)
end
_ENV, intetiorPolicyRecordPanel.getPackageList = function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end, function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
;(function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end).REWARD_VIEW_TYPE_BASE = 1
local (function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end).REWARD_VIEW_TYPE_ORDER, REWARD_VIEW_TYPE = 2, function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function intetiorPolicyRecordPanel:onInit()
	print("=======intetiorPolicyRecordPanel:onInit")
	self.wGet = false
	self.rankData, print[2], _ENV, print[1], _ENV, _ENV, self.sIndex = print, "=======intetiorPolicyRecordPanel:onInit", "=======intetiorPolicyRecordPanel:onInit", "=======intetiorPolicyRecordPanel:onInit", "=======intetiorPolicyRecordPanel:onInit", print, 1
	self.fields.Panel_bg:setString(i18n("parliament_text_57"))
	self.fields.Text_des:setString(i18n("parliament_text_60"))
	_ENV = self.fields.Text_des.setString
	_ENV, _ENV, self.fields.Text_des.setString.defaultClick = i18n("parliament_text_60")
	i18n("parliament_text_60").title = i18n("parliament_text_58")
	_ENV, self.fields.Text_des[1], i18n("parliament_text_60").tag = i18n("parliament_text_60")
	i18n("parliament_text_60").title = i18n("parliament_text_59")
	self.fields.Text_des.setString.tabsetArray, self.fields.Text_des[2], i18n("parliament_text_60").tag = self.fields.Text_des, i18n("parliament_text_60")
	local self.fields.Text_des.setString.callback, tableData = handler(self, self.onClickTab), self.fields.Text_des.setString
	self.fields.com_TabW:initView(tableData)
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.scrollEventCallBack))
	self.fields.text_tips:setString(i18n("common_text_927"))
end
function intetiorPolicyRecordPanel:onShow()
	print("=======intetiorPolicyRecordPanel:onShow")
end
function intetiorPolicyRecordPanel:onClickTab(showViewType)
	if showViewType == self.showViewType then
		return
	end
	self.showViewType = showViewType
	self.sIndex = #self.rankData[showViewType] + 1
	self.wGet = true
	if self.sIndex == 1 then
		self:reqSendMsg(self.sIndex)
	else
		self:initScrollView()
	end
	self.fields.List:jumpToTop()
end
function intetiorPolicyRecordPanel:reqSendMsg(index)
	SoraDShowLoading(self)
	if self.showViewType == REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_BASE then
		intetiorCtrl:reqParliamentPolicyRecord(index, MAX_REQ_NUM)
	elseif self.showViewType == REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_ORDER then
		intetiorCtrl:reqParliamentDecreeRecord(index, MAX_REQ_NUM)
	end
end
function intetiorPolicyRecordPanel:initScrollData(data)
	dump(data, "data", 10)
	if not data.rankList then
		local _ENV, rankList = data.rankList, data.rankList
	end
	local num = #rankList
	self.sIndex = self.sIndex + #rankList
	if data.wGet ~= nil then
		self.wGet = data.wGet
	else
		self.wGet = num >= MAX_REQ_NUM
	end
	if next(rankList) ~= nil then
		local cpyTbl = clone(rankList)
		for _, v in ipairs(cpyTbl) do
			table.insert(self.rankData[self.showViewType], v)
		end
	end
	self:initScrollView()
end
function intetiorPolicyRecordPanel:initScrollView()
	if #self.rankData <= 0 then
		self.fields.text_tips:setVisible(true)
		self.fields.List:setVisible(false)
	else
		self.fields.text_tips:setVisible(false)
		self.fields.List:setVisible(true)
		self.fields.List:setNumItems(#self.rankData[self.showViewType])
	end
end
function intetiorPolicyRecordPanel:onItemRederer(index, target)
	target:initPolicyData(self.rankData[self.showViewType][index + 1], self.showViewType, index + 1)
end
function intetiorPolicyRecordPanel:scrollEventCallBack()
	if self.wGet then
		self:reqSendMsg(self.sIndex)
	end
end
return intetiorPolicyRecordPanel
