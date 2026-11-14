local gametop = gModuleMgr.getObject("gametop")
local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local intetiorResourceRecordPanel = class("intetiorResourceRecordPanel", baseFguiPanel)
function intetiorResourceRecordPanel:ctor(...)
	self.super.ctor(self, ...)
	print("intetiorResourceRecordPanel:ctor", self.viewName)
end
_ENV, intetiorResourceRecordPanel.getPackageList = function(self)
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
end).REWARD_VIEW_TYPE_DOATE = 1
local (function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end).REWARD_VIEW_TYPE_TRICK, REWARD_VIEW_TYPE = 2, function(self)
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
local MAX_REQ_NUM = 10
function intetiorResourceRecordPanel:onInit()
	print("=======intetiorResourceRecordPanel:onInit")
	self.wGet = false
	self.rankData, print[2], _ENV, print[1], _ENV, _ENV, self.sIndex = print, "=======intetiorResourceRecordPanel:onInit", "=======intetiorResourceRecordPanel:onInit", "=======intetiorResourceRecordPanel:onInit", "=======intetiorResourceRecordPanel:onInit", print, 1
	self.fields.Panel_bg:setString(i18n("parliament_btn_10"))
	self.fields.Text_des:setString(i18n("parliament_text_11"))
	_ENV = self.fields.Text_des.setString
	_ENV, _ENV, self.fields.Text_des.setString.defaultClick = i18n("parliament_text_11")
	i18n("parliament_text_11").title = i18n("parliament_btn_11")
	_ENV, self.fields.Text_des[1], i18n("parliament_text_11").tag = i18n("parliament_text_11")
	i18n("parliament_text_11").title = i18n("parliament_btn_12")
	self.fields.Text_des.setString.tabsetArray, self.fields.Text_des[2], i18n("parliament_text_11").tag = self.fields.Text_des, i18n("parliament_text_11")
	local self.fields.Text_des.setString.callback, tableData = handler(self, self.onClickTab), self.fields.Text_des.setString
	self.fields.com_TabW:initView(tableData)
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.scrollEventCallBack))
	self.fields.text_tips:setString(i18n("common_text_927"))
end
function intetiorResourceRecordPanel:onShow()
	print("=======intetiorResourceRecordPanel:onShow")
end
function intetiorResourceRecordPanel:onClickTab(showViewType)
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
function intetiorResourceRecordPanel:reqSendMsg(index)
	SoraDShowLoading(self)
	if self.showViewType == REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_DOATE then
		intetiorCtrl:reqParliamentTreasuryDonateRecord(index, MAX_REQ_NUM)
	elseif self.showViewType == REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_TRICK then
		intetiorCtrl:reqParliamentTrickStealRecord(index, MAX_REQ_NUM)
	end
end
function intetiorResourceRecordPanel:initScrollData(data)
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
			v.dataType = 3 - self.showViewType
			table.insert(self.rankData[self.showViewType], v)
		end
	end
	self:initScrollView()
end
function intetiorResourceRecordPanel:initScrollView()
	if #self.rankData <= 0 then
		self.fields.text_tips:setVisible(true)
		self.fields.List:setVisible(false)
	else
		self.fields.text_tips:setVisible(false)
		self.fields.List:setVisible(true)
		self.fields.List:setNumItems(#self.rankData[self.showViewType])
	end
end
function intetiorResourceRecordPanel:onItemRederer(index, target)
	target:initData(self.rankData[self.showViewType][index + 1], index + 1)
end
function intetiorResourceRecordPanel:scrollEventCallBack()
	if self.wGet then
		self:reqSendMsg(self.sIndex)
	end
end
return intetiorResourceRecordPanel
