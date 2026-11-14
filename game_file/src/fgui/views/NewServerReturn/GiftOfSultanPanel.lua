local rechargeRead = include("rechargeRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local GiftOfSultanPanel = class("GiftOfSultanPanel", baseFguiPanel)
function GiftOfSultanPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("GiftOfSultanPanel:ctor", self.viewName)
end
function GiftOfSultanPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "fonts"
		self._packageList, self._packageList[2] = self._packageList, "WarGem"
	end
	return self._packageList
end
function GiftOfSultanPanel:onInit()
	print("=======GiftOfSultanPanel:onInit")
	self.fields.Com_title:initData(i18n("newstart_text_18"), handler(self, self.onClickClose))
	self.fields.btnLeft:setVisible(false)
	self.fields.btnRight:setVisible(false)
	self.fields.Node_menu:setVisible(false)
	self.fields.ScrollView_category:setItemRenderer(handler(self, self.onItemRendererTab))
	self.curGiftIndex = 1
	self.canClick = true
	self.tblRecycleBtns, _ENV, self.tblBtns, _ENV, self.curGiftData, _ENV, self.curTabTag = self.fields.ScrollView_category.setItemRenderer, self.fields.ScrollView_category.setItemRenderer, self.fields.ScrollView_category.setItemRenderer, self.fields.ScrollView_category.setItemRenderer, self.fields.ScrollView_category.setItemRenderer, self.fields.ScrollView_category.setItemRenderer, nil
	self:bindMsg()
	self:initData()
end
function GiftOfSultanPanel:initData()
	self.categoryData, _ENV, self.limitGiftData = self:getLimitData(), self:getLimitData(), self:getLimitData()
	for i, v in ipairs(self.limitGiftData) do
		if v.rType == gRechargeActiveModelType.CLIENTLADDER then
			_ENV = gRechargeActiveModelType.CLIENTLADDER
			self.categoryData[20], gRechargeActiveModelType.CLIENTLADDER[1] = gRechargeActiveModelType.CLIENTLADDER, v
		elseif v.data.category then
			if not self.categoryData[v.data.category] then
				self.categoryData[v.data.category], _ENV = nil, nil
			end
			table.insert(self.categoryData[v.data.category], v)
			if type(v.data.extraCategory) == "string" and string.len(v.data.extraCategory) > 0 then
				local tmpList = SoraDStringSplit(v.data.extraCategory, ",")
				for _, category in ipairs(tmpList) do
					if not self.categoryData[tonumber(category)] then
						self.categoryData[tonumber(category)], _ENV = category, category
					end
					table.insert(self.categoryData[tonumber(category)], v)
				end
			end
		else
			if not self.categoryData[0] then
				self.categoryData[0], _ENV = ipairs(tmpList)
			end
			table.insert(self.categoryData[0], v)
		end
	end
	dump(self.limitGiftData, "self.limitGiftData")
	if next(self.limitGiftData) then
		self:initBtnScroll()
		self:categoryBtnClick(self.firstTag)
	elseif self.handleRefreshHead then
		self.handleRefreshHead()
	end
	self:updateMenu()
end
function GiftOfSultanPanel:updateMenu()
	local diffData = self:makeDiffData()
	function self.btnHandle(tag)
		SoraDPlaySound()
		self:initView(tag)
	end
	if next(diffData) then
		dump(diffData, "GiftOfSultanPanel:updateMenu")
		self.fields.Node_menu:initData(diffData, self.btnHandle)
	end
end
function GiftOfSultanPanel:initView(giftIndex)
	dump(self.curGiftData, "GiftOfSultanPanel:initView")
	if self.curGiftData and #self.curGiftData >= 1 then
		self.curGiftIndex = math.min(giftIndex or 1, #self.curGiftData)
		local diffData = self:makeDiffData()
		self:createGiftNode(diffData[self.curGiftIndex], self.fields.nodeInSide, false)
		self:refreshPagePoint()
		self:setBtnVisiable(1 < #diffData)
		local giftName = ""
		dump(diffData, "GiftOfSultanPanel:initView")
		dump(self.curGiftIndex, "GiftOfSultanPan43543534545")
		local giftStyle = rechargeRead.getInheritPageViewData(diffData[self.curGiftIndex].rid)
		local gStyle = diffData[self.curGiftIndex].giftStyle or giftStyle
		giftName = i18n(gStyle.activeName)
		self.fields.Text_giftName:setString(giftName)
	else
		self:setBtnVisiable(false)
	end
end
function GiftOfSultanPanel:createGiftNode(_info, curNode, _turnPage)
	dump(_info, "GiftOfSultanPanel:createGiftNode")
	local rType = _info.rType
	local actID = gActivityTimeActivityID.WEALTH_ACTIVITY
	curNode:initData(_info, gRechargeActiveFromEnum.ROAD18 .. string.format("%0.2d", self.curTabTag), _turnPage, actID)
	self:cutNode(curNode)
end
function GiftOfSultanPanel:cutNode(_parent)
	self.fields.nodeOutSide:setVisible(_parent == self.fields.nodeOutSide)
	self.fields.nodeInSide:setVisible(_parent == self.fields.nodeInSide)
end
function GiftOfSultanPanel:refreshPagePoint()
	local diffData = self:makeDiffData()
	if table.nums(diffData) > 1 then
		_ENV = nil
		;(nil).count = table.nums(diffData)
		;(nil).intervalWidth = 8
		;(nil).begin = self.curGiftIndex or 1
		self.fields.pagePoint:initData(nil)
		self.fields.pagePoint:setVisible(true)
	else
		self.fields.pagePoint:setVisible(false)
	end
end
function GiftOfSultanPanel:makeDiffData()
	local _UPVALUE0_, packageDiffData
	return self.curGiftData
end
function GiftOfSultanPanel:setBtnVisiable(bool)
	self.fields.btnLeft:setVisible(bool)
	self.fields.btnRight:setVisible(bool)
	self.canTurnPage = bool
end
function GiftOfSultanPanel:initBtnScroll()
	local sortTbl = activityShowCtrl:getLabelSort()
	self.keys = table.keys(self.categoryData)
	dump(self.keys, " GiftOfSultanPanel:initBtnScroll")
	table.sort(self.keys, function(l, r)
		local ls = sortTbl[l] or 999
		local rs = sortTbl[r] or 999
		return ls < rs
	end)
	self.fields.ScrollView_category:setNumItems(table.nums(self.keys))
	self.firstTag = self.keys[1]
end
function GiftOfSultanPanel:onItemRendererTab(index, object)
	dump(self.keys[index + 1], "self.keys3534535 + 1]")
	local info = rechargeRead.getCategoryConfig(self.keys[index + 1])
	self.btnHandle = handler(self, self.categoryBtnClick)
	_ENV = nil
	;(nil).tag = self.keys[index + 1]
	;(nil).title = info.name and i18n(info.name)
	;(nil).iconURL = info.icon
	object:initData(index + 1, nil, self.btnHandle)
end
function GiftOfSultanPanel:categoryBtnClick(tag)
	local index = tag
	_ENV = nil
	;(nil).tab = "limitGift"
	;(nil).class = index
	userSDKManager.logEvent(gSDKDef.TDonEvent.click_rechargeview_switchtab, nil)
	if tag == self.firstTag then
		self.fields.ScrollView_category:setSelectedIndex(0)
		self.fields.ScrollView_category:scrollToView(0)
	end
	self.curTabTag = index
	self.curGiftData = self.categoryData[self.curTabTag]
	self.fields.pagePoint:reserLastIndex()
	self:initView()
	self.fields.Node_menu:setVisible(false)
	if #self.curGiftData > 1 then
		self:updateMenu()
		self.fields.Button_menu:setVisible(true)
	else
		self.fields.Button_menu:setVisible(false)
	end
end
function GiftOfSultanPanel:packageBtnClick(noSound)
	if not noSound then
		SoraDPlaySound()
	end
	if button:getTag() == self.curGiftIndex then
		return
	end
	self.curGiftIndex = button:getTag()
	local diffData = self:makeDiffData()
	local page = self:createGiftNode(diffData[self.curGiftIndex], self.fields.nodeOutSide, true)
	self.fields.pagePoint:setCurLight(self.curGiftIndex, false)
	self.fields.nodeOutSide, self.fields.nodeInSide = self.fields.nodeInSide, self.fields.nodeOutSide
end
function GiftOfSultanPanel:menuBtnClick()
	SoraDPlaySound()
	self.fields.Node_menu:setVisible(not self.fields.Node_menu:isVisible())
end
function GiftOfSultanPanel:closeMenu()
	if self.fields.Node_menu:isVisible() then
		self.fields.Node_menu:setVisible(false)
	end
end
function GiftOfSultanPanel:getLimitData()
	local rechargePresentUtil = include("rechargePresentUtil")
	local _ENV, activeDataList = "rechargePresentUtil", "rechargePresentUtil"
	local rType = gRechargeActiveModelType.RECHARGE_PRESENT
	local activityID = rechargePresentUtil.getActivityIDByCategory(self.tabType)
	local group = 1
	activeDataList = rechargeRead.getSultanPresentCfgByGroup(group)
	dump(activeDataList, "GiftOfSultanPanel:getLimitData")
	local _ENV, normalSortList = dump, dump
	for i, v in ipairs(activeDataList) do
		local extraData = rechargePresentUtil.getInheritGiftNum(v)
		v.payType = v.limitType
		v.extraData = extraData
		_ENV = nil
		;(nil).rid = v.rechargeID
		;(nil).rType = rType
		;(nil).data = v
		table.insert(normalSortList, nil)
	end
	if next(normalSortList) then
		table.sort(normalSortList, function(l, r)
			local lWeight = l.data.weight or 0
			local rWeight = r.data.weight or 0
			if lWeight ~= rWeight then
				return lWeight > rWeight
			else
				return l.rid < r.rid
			end
		end)
	end
	return normalSortList
end
function GiftOfSultanPanel:bindMsg()
	self.fields.Button_menu:addClickListener(handler(self, self.menuBtnClick))
	self.fields.btnLeft:addClickListener(handler(self, self.onClickTurnPageLeft))
	self.fields.btnRight:addClickListener(handler(self, self.onClickTurnPageRight))
end
function GiftOfSultanPanel:onClickTurnPageLeft()
	self:turnPage(true, notSound)
end
function GiftOfSultanPanel:onClickTurnPageRight()
	self:turnPage(false, notSound)
end
function GiftOfSultanPanel:turnPage(isLeft, notSound)
	if self.canClick and self.canTurnPage then
		if not notSound then
			SoraDPlaySound()
		end
		self.canClick = false
		self:reNewNum(isLeft)
		local diffData = self:makeDiffData()
		local page = self:createGiftNode(diffData[self.curGiftIndex], self.fields.nodeOutSide, true)
		self.fields.pagePoint:setCurLight(self.curGiftIndex, false)
		local giftName = ""
		if diffData[self.curGiftIndex].data then
			giftName = i18n(diffData[self.curGiftIndex].data.giftStyle.activeName)
		else
			giftName = i18n(diffData[self.curGiftIndex].giftStyle.activeName)
		end
		self.fields.Text_giftName:setString(giftName)
		self.fields.nodeOutSide, self.fields.nodeInSide = self.fields.nodeInSide, self.fields.nodeOutSide
		self.canClick = true
		self:updateMenuSelect()
	end
end
function GiftOfSultanPanel:updateMenuSelect()
	self.fields.Node_menu:setCurSelection(self.curGiftIndex - 1)
end
function GiftOfSultanPanel:reNewNum(isLeft)
	local diffData = self:makeDiffData()
	local _max = #diffData
	local _cur = self.curGiftIndex
	local _min = 1
	if isLeft then
		_cur = _cur - 1
		if _cur < 1 then
			_cur = _max
		end
	else
		_cur = _cur + 1
		if _max < _cur then
			_cur = _min
		end
	end
	self.curGiftIndex = _cur
end
function GiftOfSultanPanel:onShow()
	print("=======GiftOfSultanPanel:onShow")
end
function GiftOfSultanPanel:onHide()
	print("=======GiftOfSultanPanel:onHide")
end
function GiftOfSultanPanel:onDispose()
	print("=======GiftOfSultanPanel:onDispose")
end
return GiftOfSultanPanel
