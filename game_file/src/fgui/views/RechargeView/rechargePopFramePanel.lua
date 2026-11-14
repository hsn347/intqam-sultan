local rechargeRead = include("rechargeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local rechargePopFramePanel = class("rechargePopFramePanel", baseFguiPanel)
function rechargePopFramePanel:ctor(...)
	self.super.ctor(self, ...)
	print("rechargePopFramePanel:ctor", self.viewName)
end
function rechargePopFramePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function rechargePopFramePanel:onInit()
	print("=======rechargePopFramePanel:onInit")
	self.isHideCurrentSceneView = true
	self.groupList, _ENV, self.packageList, _ENV, self.isAddToPopManager = print, print, print, print, true
	self.packageIndex = 1
	self.targetID = nil
	self.fromCenter = nil
	self.isPageTurn = false
	self.fields.Button_left:addTouchEventListener(handler(self, self.btnLeftPageClick))
	self.fields.Button_right:addTouchEventListener(handler(self, self.btnRightPageClick))
	self.fields.List:setVirtualAndLoop()
	self.fields.List:setItemRenderer(handler(self, self.onPageItemRenderer))
end
function rechargePopFramePanel:onPageItemRenderer(index, obj)
	obj:initGroupData(self.groupList[index + 1], self.fromCenter, self.isPageTurn, self.targetID)
end
function rechargePopFramePanel:onShow()
	print("=======rechargePopFramePanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.fromCenter = self.param.fromCenter
	self.isChoiceGift = self.param.isChoiceGift
	self.pointID = self.param.id
	self.fields.List:addEventListener(fgui.UIEventType.ScrollEnd, function()
		local itemIndex = self.fields.List:childIndexToItemIndex(0)
		self.packageIndex = itemIndex % #self.groupList + 1
		print("itemIndex=====", itemIndex, self.packageIndex)
		self:setCurLight()
	end)
	self:initData()
end
function rechargePopFramePanel:initData()
	local _
	_, self.packageList, self.packageIndex = SoraDCheckShow(self.pointID, self.isChoiceGift)
	if not next(self.packageList) then
		self:close()
		return
	end
	self.groupList, self.packageIndex = self:sortGroupData()
	if self.groupList[self.packageIndex] then
		self:initView()
		return true
	else
		return false
	end
end
function rechargePopFramePanel:sortGroupData()
	local _ENV, newList
	local _ENV, groupList
	local index = 1
	self.targetID = nil
	table.sort(self.packageList, function(a, b)
		return a.id < b.id
	end)
	for k, v in ipairs(self.packageList) do
		local rInfo = rechargeRead.getPageViewData(v.id)
		if rInfo then
			if rInfo.rechargeGroup then
				if not groupList[rInfo.rechargeGroup] then
					groupList[rInfo.rechargeGroup], _ENV = nil, nil
				end
				table.insert(groupList[rInfo.rechargeGroup], v)
			else
				table.insert(newList, v)
			end
		else
			dump("无配置信息========", v.id)
		end
	end
	for k, v in pairs(groupList) do
		_ENV = "无配置信息========"
		;("无配置信息========").group = v
		;("无配置信息========").groupID = k
		table.insert(newList, "无配置信息========")
	end
	table.sort(newList, function(a, b)
		if a.groupID and b.groupID then
			return a.groupID < b.groupID
		end
	end)
	if self.pointID then
		for k, v in ipairs(newList) do
			if v.id and tonumber(v.id) == tonumber(self.pointID) then
				index = k
				break
			end
			if v.group then
				for ki, vi in ipairs(v.group) do
					if tonumber(vi.id) == tonumber(self.pointID) then
						index = k
						self.targetID = self.pointID
						break
					end
				end
			end
		end
	end
	print("index=======", self.pointID, index, self.targetID)
	return newList, index
end
function rechargePopFramePanel:initView(notNeedAdd)
	self.fields.Button_left:setVisible(#self.groupList > 1)
	self.fields.Button_right:setVisible(#self.groupList > 1)
	self.fields.Com_indicator:setVisible(#self.groupList > 1)
	self.fields.Com_indicator:reserLastIndex()
	_UPVALUE0_ = #self.groupList > 1
	;(#self.groupList > 1).count = #self.groupList
	;(#self.groupList > 1).intervalWidth = 8
	;(#self.groupList > 1).begin = self.packageIndex
	self.fields.Com_indicator:initData(#self.groupList > 1)
	self.fields.List:setNumItems(#self.groupList)
	self.fields.List:scrollToView(self.packageIndex - 1)
end
function rechargePopFramePanel:setCurLight()
	self.fields.Com_indicator:setCurLight(self.packageIndex)
end
function rechargePopFramePanel:setPageView(isAni)
	self.fields.List:scrollToView(self.packageIndex - 1, isAni)
	self:setCurLight()
end
function rechargePopFramePanel:turnPage(actionFoward)
	self.packageIndex = actionFoward and self.packageIndex - 1 or self.packageIndex + 1
	local isAni = true
	if self.packageIndex < 1 then
		self.packageIndex = #self.groupList
		isAni = false
	elseif self.packageIndex > #self.groupList then
		self.packageIndex = 1
		isAni = false
	end
	self:setPageView(isAni)
end
function rechargePopFramePanel:btnLeftPageClick()
	SoraDPlaySound()
	advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_switch_gift)
	self:turnPage(true)
end
function rechargePopFramePanel:btnRightPageClick()
	SoraDPlaySound()
	advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_switch_gift)
	self:turnPage(false)
end
function rechargePopFramePanel:reInitDataEx(target, data)
	if data and data.isForceClose then
		self:close()
	else
		self:reInitData()
	end
end
function rechargePopFramePanel:reInitData(target, data)
	local rid = (not data or not data.rid) and data.data and data.data.rid
	if rid then
		self.pointID = rid
	end
	self:initData()
end
function rechargePopFramePanel:doubleClose()
	SoraDCloseLoading()
	self:close()
end
return rechargePopFramePanel
