local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local artifactRuneRead = include("artifactRuneRead")
local publicRead = include("publicRead")
local itemDesRead = include("itemDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneQHXLViewPanel = class("RuneQHXLViewPanel", baseFguiPanel)
function RuneQHXLViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneQHXLViewPanel:ctor", self.viewName)
end
function RuneQHXLViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneQHXLViewPanel:onInit()
	print("=======RuneQHXLViewPanel:onInit")
	self.chooseList, _ENV, self.lockList, _ENV, self.data = self.param.data, self.param.data, self.param.data, self.param.data, self.param.data
	self.xlItemID = 204701
	self.sdItemID = 204801
	self.nextLvAddList, _ENV, self.tag = self.param.tag or 0, self.param.tag or 0, self.param.tag or 0
	self.nextLvAdd = 1
	self.luckyLimit = artifactRuneRead.getLuckyValueLimit()
	self.fields.Usm_Max:setVisible(false)
	self.fields.Usm_Max:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.Usm_Get:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.Usm_Get:setVisible(false)
	self.Usm_Dispear = self.fields.Bar_lucky:getChild("Bar_effect"):getChild("Usm_Dispear")
	self.Usm_Dispear:setSpeed(2, 1)
	self.Usm_Dispear:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.Usm_Get:setCompleteCallback(function()
		self.fields.Usm_Get:setVisible(false)
	end)
	self.fields.Bar_lucky:setMax(self.luckyLimit)
	self.fields.Bar_lucky:fixChildrenPos()
	self.Usm_Dispear:fixPos()
	self.Usm_Dispear:setVisible(false)
	self.fields.Com_title:initData(i18n("Weapon_Rune_button_005"), handler(self, self.onClickClose))
	_ENV = i18n("Weapon_Rune_button_005")
	_ENV, _ENV, i18n("Weapon_Rune_button_005").defaultClick = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("Weapon_Rune_button_007")
	_ENV, self.tag[1], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("Weapon_Rune_button_008")
	i18n("Weapon_Rune_button_005").tabsetArray, self.tag[2], handler(self, self.onClickClose).tag = self.tag, handler(self, self.onClickClose)
	i18n("Weapon_Rune_button_005").callback = handler(self, self.onClickTab)
	self.fields.Tab:initView((i18n("Weapon_Rune_button_005")))
	self.fields.Btn_operate:addClickListener(handler(self, self.onBtnOperate))
	self.fields.Button_question:addClickListener(handler(self, self.onClickLuckyQuestion))
	self.fields.Lab_cost:setTitle(i18n("Weapon_Rune_tips_053"))
	self.fields.Lab_curAttr:setTitle(i18n("Weapon_Rune_tips_028"))
	self.fields.List_review:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_cost:setItemRenderer(handler(self, self.onItemCostRenderer))
	self.fields.com_lock:addClickListener(handler(self, self.onAddSDClick))
	self.fields.Btn_save:setVisible(false)
	self.fields.Btn_save:setString(i18n("Weapon_Rune_button_004"))
	self.fields.Btn_save:addClickListener(handler(self, self.onBtnSave))
	self.fields.Btn_cancel:setVisible(false)
	self.fields.Btn_cancel:setString(i18n("common_text_1372"))
	self.fields.Btn_cancel:addClickListener(handler(self, self.onBtnCancel))
	self.fields.com_info:initData(self.data, 3)
	self.fields.slider:setSliderCallBack(handler(self, self.onSliderChange))
	self.fields.Btn_save:fixPos()
	self.fields.Btn_cancel:fixPos()
	self.fields.com_lock:fixPos()
	self.fields.Button_question:fixPos()
	self.fields.n104:fixPos()
	self.fields.Usm_Max:fixPos()
	self.fields.Usm_Get:fixPos()
	self.fields.slider:setInpuBoxFixPos()
end
function RuneQHXLViewPanel:onItemRenderer(index, obj)
	obj:initData(self.extraProperty[index + 1], index + 1, self.data.rid, self.maxRandomLv, self.nextLvAddList)
end
function RuneQHXLViewPanel:onItemCostRenderer(index, obj)
	obj:initData(self.costArray[index + 1])
end
function RuneQHXLViewPanel:onShow()
	print("=======RuneQHXLViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_bgex:setGradientColor()
	self:initData()
end
function RuneQHXLViewPanel:initData(isRunAction)
	self.controllers.c1:setSelectedIndex(self.tag)
	if self.tag == 1 then
		self.fields.Usm_Max:setVisible(false)
		self.fields.Usm_Get:setVisible(false)
		self.Usm_Dispear:setVisible(false)
		self.fields.Btn_operate:setFreeTitle(i18n("common_text_1340"), 1)
		self:setStrengthCost()
		self.fields.Btn_operate:setVisible(true)
		self.fields.List_cost:setNumItems(#self.costArray)
		local info = artifactRuneRead.getRuneInfo(self.data.rid)
		local lvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, self.data.level)
		self.maxClassLv = artifactRuneRead.getMaxSLevel(info.ExpGrowingType, lvCfg.Class)
		self.maxRandomLv = artifactRuneRead.getRandomMaxSLV(self.data.season, self.data.class)
		self.maxLimit = math.max(self.maxClassLv, self.maxRandomLv)
		self.extraProperty = self.data.extraProperty
		for k, v in ipairs(self.extraProperty) do
			local _, _, _, _, PropertiesGrowingType = artifactRuneRead.getPropertyArray(self.extraProperty[k][1])
			local maxAttrLv = artifactRuneRead.getAttrMaxLv(PropertiesGrowingType)
			local maxALV = math.min(self.maxRandomLv, maxAttrLv)
			if maxALV <= v[2] then
				self.chooseList[k] = nil
			end
		end
		self.fields.List_review:setNumItems(#self.extraProperty)
	else
		self.fields.Btn_operate:setTitle(i18n("common_text_1341"))
		self.fields.Btn_operate:setEnabled(true)
		self.remakeID, self.remakeCount = artifactRuneRead.getRemakeCfg()
		print("remakeID", self.remakeID)
		self.myRemakeCount = backpackCtrl:getItemCount(self.xlItemID)
		self.fields.Btn_operate:setCost(self.remakeID, self.remakeCount)
		self.fields.Btn_operate:setNumTotal(self.remakeCount, self.myRemakeCount, self.remakeCount <= self.myRemakeCount and "#FFFFFF" or "#E02B2B")
		self.fields.Btn_cancel:setCost(self.remakeID, self.remakeCount)
		self.fields.Btn_cancel:setNumTotal(self.remakeCount, self.myRemakeCount, self.remakeCount <= self.myRemakeCount and "#FFFFFF" or "#E02B2B")
		self.myLockCount = backpackCtrl:getItemCount(self.sdItemID)
		local lockCost = artifactRuneRead.getLockCost(math.max(1, self:getLockCount()))
		local costNum = 0
		if self:getLockCount() > 0 then
			costNum = lockCost.count
		end
		self.fields.com_lock:setIcon(publicRead.getIcon(lockCost.id))
		_ENV = publicRead.getIcon(lockCost.id)
		publicRead.getIcon(lockCost.id).var1 = fguiHelper.getColorString(costNum <= self.myLockCount and "#FFFFFF" or "#E02B2B", self.myLockCount)
		publicRead.getIcon(lockCost.id).var2 = costNum
		self.fields.com_lock:setTitle(i18n("%{var1}/%{var2}", publicRead.getIcon(lockCost.id)))
		if self.data.tempExtraProperty then
			self.fields.com_curAttr:initData(i18n("Weapon_Rune_tips_028"), self.data, false, self.lockList)
			self.fields.com_newAttr:initData(i18n("Weapon_Rune_tips_029"), self.data, true, nil, self.data.rid)
			self.fields.Btn_save:setVisible(true)
			self.fields.Btn_cancel:setVisible(true)
			self.fields.Btn_operate:setVisible(false)
		else
			self.fields.com_curAttr:initData(i18n("Weapon_Rune_tips_028"), self.data, false, self.lockList)
			self.fields.com_newAttr:initData(i18n("Weapon_Rune_tips_029"), nil, true, nil, self.data.rid)
			self.fields.Btn_save:setVisible(false)
			self.fields.Btn_cancel:setVisible(false)
			self.fields.Btn_operate:setVisible(true)
		end
		if not isRunAction then
			self:updateLuckyBar()
		end
	end
end
function RuneQHXLViewPanel:updateLuckyBar()
	self.fields.Bar_lucky:setValue(self.data.luckyValue or 0)
	if (self.data.luckyValue or 0) >= self.luckyLimit then
		fguiHelper.get_fields(self.fields.Bar_lucky).title:setString("MAX")
		self.fields.Usm_Max:play(true)
	else
		self.fields.Usm_Max:setVisible(false)
		fguiHelper.get_fields(self.fields.Bar_lucky).title:setString(SoradNumStringNoZero((self.data.luckyValue or 0) / self.luckyLimit * 100))
	end
	self.isRunning = false
end
function RuneQHXLViewPanel:onClickTab(tag)
	self:stopAllActions()
	local click = function()
		self.tag = tag
		self:initData()
	end
	click()
end
function RuneQHXLViewPanel:setStrengthCost()
	self.costArray, _ENV = nil, nil
	local _ENV, tempArray
	local _ENV, tempList
	local maxCount = 0
	local count = 0
	for k, v in ipairs(self.data.extraProperty) do
		local _, _, _, _, PropertiesGrowingType = artifactRuneRead.getPropertyArray(self.data.extraProperty[k][1])
		local maxAttrLv = artifactRuneRead.getAttrMaxLv(PropertiesGrowingType)
		if self.chooseList[k] and v[2] < self.maxRandomLv then
			count = count + 1
		end
		if self.chooseList[k] and maxAttrLv > v[2] then
			local array, quality, power, growType = artifactRuneRead.getPropertyArray(v[1])
			local cost = artifactRuneRead.getCost(growType, v[2])
			for ki, vi in ipairs(cost) do
				table.insert(tempArray, vi)
			end
		elseif self.maxLimit == maxAttrLv then
			maxCount = maxCount + 1
		end
	end
	dump(tempArray, "tempArray=====")
	for k, v in ipairs(tempArray) do
		if not tempList[v.id] then
			tempList[v.id] = v.count
		else
			tempList[v.id] = tempList[v.id] + v.count
		end
	end
	for k, v in pairs(tempList) do
		_ENV = v.count
		v.count.id = k
		v.count.count = v
		table.insert(self.costArray, v.count)
	end
	table.sort(self.costArray, function(a, b)
		return a.id < b.id
	end)
	self.fields.List_cost:setNumItems(#self.costArray)
	self.isCanStrength = true
	for k, v in ipairs(self.costArray) do
		local myCount = backpackCtrl:getItemCount(v.id)
		if myCount < v.count then
			self.isCanStrength = false
			break
		end
	end
	local isEnable = 0 < count and maxCount < #self.data.extraProperty and self.isCanStrength
	self.fields.Btn_operate:setEnabled(0 < count and maxCount < #self.data.extraProperty and self.isCanStrength)
	local isShowStrength = 0 < table.nums(self.chooseList) and isEnable
	self.controllers.c2:setSelectedIndex(isShowStrength and 1 or 0)
	if isShowStrength then
		self:setStrengthShow()
	end
end
function RuneQHXLViewPanel:setStrengthShow()
	local maxVal = 1
	local ownCount = backpackCtrl:getItemCount(self.costArray[1].id)
	local myCount = ownCount
	while 0 < myCount do
		local isToMax = false
		for k, v in ipairs(self.data.extraProperty) do
			local _, _, _, _, PropertiesGrowingType = artifactRuneRead.getPropertyArray(self.data.extraProperty[k][1])
			local maxAttrLv = math.min(artifactRuneRead.getAttrMaxLv(PropertiesGrowingType), self.maxRandomLv)
			if self.chooseList[k] and maxAttrLv > v[2] then
				local array, quality, power, growType = artifactRuneRead.getPropertyArray(v[1])
				local costNum = artifactRuneRead.getCostNeed(growType, v[2], maxVal)
				myCount = myCount - costNum
				print("v[2]+maxVal=====", v[2] + maxVal, maxAttrLv, self.maxRandomLv)
				if maxAttrLv < v[2] + maxVal then
					isToMax = true
					break
				end
			end
		end
		if myCount < 0 or isToMax then
			maxVal = maxVal - 1
			break
		end
		myCount = ownCount
		maxVal = maxVal + 1
	end
	print("maxVal=====", maxVal)
	backpackCtrl = nil
	;(nil).lv = 1
	self.fields.Text_strengthLv:setString(i18n("Weapon_Rune_tips_118", nil))
	backpackCtrl = i18n("Weapon_Rune_tips_118", nil)
	i18n("Weapon_Rune_tips_118", nil).maxValue = maxVal
	i18n("Weapon_Rune_tips_118", nil).minValue = 1
	i18n("Weapon_Rune_tips_118", nil).curValue = 1
	self.fields.slider:initData(i18n("Weapon_Rune_tips_118", nil))
end
function RuneQHXLViewPanel:onSliderChange(value)
	self.nextLvAdd = value
	for k, v in pairs(self.chooseList) do
		self.nextLvAddList[k] = value
	end
	_ENV = nil
	;(nil).lv = value
	self.fields.Text_strengthLv:setString(i18n("Weapon_Rune_tips_118", nil))
	self.fields.List_review:setNumItems(#self.extraProperty)
	local needNum = 0
	for k, v in ipairs(self.data.extraProperty) do
		local _, _, _, _, PropertiesGrowingType = artifactRuneRead.getPropertyArray(self.data.extraProperty[k][1])
		local maxAttrLv = math.min(artifactRuneRead.getAttrMaxLv(PropertiesGrowingType), self.maxRandomLv)
		if self.chooseList[k] and maxAttrLv > v[2] then
			local array, quality, power, growType = artifactRuneRead.getPropertyArray(v[1])
			local costNum = artifactRuneRead.getCostNeed(growType, v[2], value)
			needNum = needNum + costNum
		end
	end
	self.costArray[1].count = needNum
	self.fields.List_cost:setNumItems(#self.costArray)
end
function RuneQHXLViewPanel:getLockCount()
	local count = 0
	for k, v in pairs(self.lockList) do
		if v == 1 then
			count = count + 1
		end
	end
	return count
end
function RuneQHXLViewPanel:lockChoose(target, data)
	self.lockList[data.index] = data.islock and 1 or 0
	local count = self:getLockCount()
	local costNum = 0
	if 0 < count then
		local lockCost = artifactRuneRead.getLockCost(count)
		costNum = lockCost.count
		artifactRuneRead = nil
		;(nil).var1 = fguiHelper.getColorString(costNum <= self.myLockCount and "#FFFFFF" or "#E02B2B", self.myLockCount)
		;(nil).var2 = costNum
		self.fields.com_lock:setTitle(i18n("%{var1}/%{var2}", nil))
	else
		artifactRuneRead = i18n("%{var1}/%{var2}", nil)
		i18n("%{var1}/%{var2}", nil).var1 = self.myLockCount
		i18n("%{var1}/%{var2}", nil).var2 = 0
		self.fields.com_lock:setTitle(i18n("%{var1}/%{var2}", i18n("%{var1}/%{var2}", nil)))
	end
	self.fields.Btn_operate:setEnabled(self.myRemakeCount >= self.remakeCount and costNum <= self.myLockCount)
end
function RuneQHXLViewPanel:strengthChoose(target, data)
	self.chooseList[data.index] = data.isChoose and 1 or nil
	self:setStrengthCost()
end
function RuneQHXLViewPanel:updateXLView(multipleIndex)
	SoraDCloseLoading(self)
	local newData = godArmsRuneCtrl:getRuneInfo(self.data.uid)
	if multipleIndex and newData.luckyValue > 0 then
		self.isRunning = true
		self.fields.Usm_Get:play(false)
		godArmsRuneCtrl = nil
		;(nil)[1] = ffa.delay(0.5)
		;(nil)[2] = ffa.callFunc(function()
			self:updateLuckyBar()
		end)
		;(nil)[3] = ffa.callFunc(function()
			self:updateLuckyBar()
		end)
		;(nil)[4] = ffa.callFunc(function()
			self:updateLuckyBar()
		end)
		;(nil)[5] = ffa.callFunc(function()
			self:updateLuckyBar()
		end)
		;(nil)[6] = ffa.callFunc(function()
			self:updateLuckyBar()
		end)
		self:runAction(ffa.seq(nil))
	elseif multipleIndex then
		self.isRunning = true
		self.Usm_Dispear:play(false)
		local delayTime = 2 * self.fields.Bar_lucky:getValue() / self.luckyLimit
		print("updateXLView", delayTime)
		_UPVALUE3_ = ffa.seq(nil)
		ffa.seq(nil)[1] = ffa.delay(0.2)
		ffa.seq(nil)[2] = ffa.callFunc(function()
			self.fields.Bar_lucky:getChild("bar"):setVisible(false)
		end)
		ffa.seq(nil)[3] = ffa.delay(delayTime)
		ffa.seq(nil)[4] = ffa.callFunc(function()
			self.fields.Bar_lucky:getChild("bar"):setVisible(true)
			self.Usm_Dispear:setVisible(false)
			self:updateLuckyBar()
		end)
		ffa.seq(nil)[5] = ffa.callFunc(function()
			self.fields.Bar_lucky:getChild("bar"):setVisible(true)
			self.Usm_Dispear:setVisible(false)
			self:updateLuckyBar()
		end)
		self:runAction(ffa.seq(ffa.seq(nil)))
	end
	self.data.exp = newData.exp
	self.data.extraProperty = newData.extraProperty
	self.data.level = newData.level
	self.data.luckyValue = newData.luckyValue
	self.data.tempExtraProperty = newData.tempExtraProperty
	print("multipleIndex", multipleIndex)
	if multipleIndex then
		local info = artifactRuneRead.getMultiConfig(multipleIndex)
		if info.isEffect == 1 then
			self.fields.Text_incScore:setString("X" .. tostring(info.multiple / 1000))
			self.transitions.scoreSlide:play()
		end
	end
	self:initData(true)
end
function RuneQHXLViewPanel:onBtnOperate()
	SoraDPlaySound()
	if self.tag == 1 then
		local _ENV, indexList = self.tag, self.tag
		local ret = true
		dump(self.chooseList, "self.chooseList===")
		for k, v in pairs(self.chooseList) do
			local _, _, _, _, PropertiesGrowingType = artifactRuneRead.getPropertyArray(self.extraProperty[k][1])
			local maxAttrLv = artifactRuneRead.getAttrMaxLv(PropertiesGrowingType)
			print("maxAttrLv====", PropertiesGrowingType, maxAttrLv)
			if maxAttrLv > self.extraProperty[k][2] then
				table.insert(indexList, k)
				ret = false
			elseif maxAttrLv == self.maxClassLv then
				ret = true
				break
			end
		end
		print("ret====", ret)
		if ret then
			SoraDShowMsgTip(i18n("Weapon_Rune_tips_035"))
		else
			self.fields.Btn_operate:setEnabled(false)
			SoraDShowLoading(self)
			godArmsRuneCtrl:sendExtraStrengthen(self.data.uid, indexList, self.nextLvAdd)
		end
	else
		if self.isRunning then
			return
		end
		print("洗练========")
		if not self:checkItemNumEnough() then
			return
		end
		for k, v in ipairs(self.data.extraProperty) do
			if not self.lockList[k] then
				self.lockList[k] = 0
			end
		end
		dump(self.lockList, "self.lockList===")
		local isHave3Orange = true
		for k, v in ipairs(self.data.extraProperty) do
			local propertyArray, quality = artifactRuneRead.getPropertyArray(v[1])
			if quality < 5 then
				isHave3Orange = false
				break
			end
		end
		if isHave3Orange then
			local isHaveUnlock = false
			for k, v in ipairs(self.data.extraProperty) do
				if not self.lockList[k] or self.lockList[k] == 0 then
					isHaveUnlock = true
					break
				end
			end
			if isHaveUnlock and not GAME_RUNE_NOTIFY_ORANGE_REPLACE_PRE then
				_ENV = self.lockList
				self.lockList.content = i18n("Weapon_Rune_tips_077")
				function self.lockList.confirmFunc()
					SoraDShowLoading(self)
					godArmsRuneCtrl:sendRemake(self.data.uid, self.lockList)
				end
				function self.lockList.remindFunc(bCheck)
					GAME_RUNE_NOTIFY_ORANGE_REPLACE_PRE = bCheck
				end
				self.lockList.remindString = i18n("build_gold_lvup_tips_name")
				uiManager:show("MessageBox", self.lockList)
			else
				SoraDShowLoading(self)
				godArmsRuneCtrl:sendRemake(self.data.uid, self.lockList)
			end
		else
			SoraDShowLoading(self)
			godArmsRuneCtrl:sendRemake(self.data.uid, self.lockList)
		end
	end
end
function RuneQHXLViewPanel:onBtnSave()
	if self.isRunning then
		return
	end
	SoraDPlaySound()
	local isHaveOrange = false
	dump(self.data.extraProperty, "self.data.extraProperty===")
	for k, v in ipairs(self.data.extraProperty) do
		local propertyArray, quality = artifactRuneRead.getPropertyArray(v[1])
		print("vvvvvv=====", k, quality)
		if 5 <= quality and (not self.lockList[k] or self.lockList[k] == 0) then
			isHaveOrange = true
			break
		end
	end
	if isHaveOrange and not GAME_RUNE_NOTIFY_ORANGE_REPLACE then
		_ENV = nil
		;(nil).content = i18n("Weapon_Rune_tips_077")
		;(nil).confirmFunc = function()
			SoraDShowLoading(self)
			godArmsRuneCtrl:sendRemakeSave(self.data.uid, true)
		end
		;(nil).remindString = i18n("build_gold_lvup_tips_name")
		;(nil).remindFunc = function(value)
			GAME_RUNE_NOTIFY_ORANGE_REPLACE = value
		end
		uiManager:show("MessageBox", nil)
	else
		SoraDShowLoading(self)
		godArmsRuneCtrl:sendRemakeSave(self.data.uid, true)
	end
end
function RuneQHXLViewPanel:checkItemNumEnough()
	local count = self:getLockCount()
	local costNum = 0
	if 0 < count then
		local lockCost = artifactRuneRead.getLockCost(count)
		costNum = lockCost.count
	end
	local isEnough1 = self.myRemakeCount >= self.remakeCount
	local isEnough2 = costNum <= self.myLockCount
	if not isEnough1 then
		SoraDShowMsgTip(i18n("Weapon_Rune_tips_068"))
		local sources = itemDesRead.getOutput(self.xlItemID)
		if 0 < #sources then
			artifactRuneRead = i18n("Weapon_Rune_tips_068")
			i18n("Weapon_Rune_tips_068").sources = sources
			uiManager:show("CommonSourceGuide", i18n("Weapon_Rune_tips_068"))
		else
		end
		return false
	end
	if not isEnough2 then
		SoraDShowMsgTip(i18n("Weapon_Rune_tips_069"))
		return false
	end
	return true
end
function RuneQHXLViewPanel:onBtnCancel()
	SoraDPlaySound()
	if self.isRunning then
		return
	end
	if not self:checkItemNumEnough() then
		return
	end
	if self.data.tempExtraProperty then
		local isHaveOrange = false
		for k, v in ipairs(self.data.tempExtraProperty) do
			local propertyArray, quality = artifactRuneRead.getPropertyArray(v[1])
			if 5 <= quality and (not self.lockList[k] or self.lockList[k] == 0) then
				isHaveOrange = true
				break
			end
		end
		for k, v in ipairs(self.data.extraProperty) do
			if not self.lockList[k] then
				self.lockList[k] = 0
			end
		end
		_ENV = ipairs(self.data.extraProperty)
		ipairs(self.data.extraProperty).byUID = true
		local noticeTime = SoraDConfigGet("Game:runeRemake:timeNotice~integer", ipairs(self.data.extraProperty)) or 0
		local isSameDay = serviceFunctions.isSameDay(noticeTime)
		if isHaveOrange and not isSameDay then
			_ENV = self.lockList
			self.lockList.content = i18n("Weapon_Rune_tips_065")
			function self.lockList.confirmFunc()
				SoraDShowLoading(self)
				godArmsRuneCtrl:sendRemake(self.data.uid, self.lockList)
			end
			self.lockList.cancelString = i18n("heroDes_text_07")
			self.lockList.remindString = i18n("coffeeCraftsman_text_27")
			function self.lockList.remindFunc(value)
				if value then
					_ENV = nil
					;(nil).byUID = true
					SoraDConfigSet("Game:runeRemake:timeNotice~integer", serviceFunctions.systemTime(), nil)
				end
			end
			uiManager:show("MessageBox", self.lockList)
		else
			SoraDShowLoading(self)
			godArmsRuneCtrl:sendRemake(self.data.uid, self.lockList)
		end
	end
end
function RuneQHXLViewPanel:onAddXLClick()
	SoraDPlaySound()
	local sources = itemDesRead.getOutput(self.xlItemID)
	if 0 < #sources then
		_ENV = nil
		;(nil).sources = sources
		uiManager:show("CommonSourceGuide", nil)
	else
		SoraDShowMsgTip(i18n("Weapon_Rune_tips_060"))
	end
end
function RuneQHXLViewPanel:onAddSDClick()
	SoraDPlaySound()
	local sources = itemDesRead.getOutput(self.sdItemID)
	if 0 < #sources then
		_ENV = nil
		;(nil).sources = sources
		uiManager:show("CommonSourceGuide", nil)
	else
		SoraDShowMsgTip(i18n("Weapon_Rune_tips_060"))
	end
end
function RuneQHXLViewPanel:onClickLuckyQuestion()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("herovault_text_12")
	;(nil).content = i18n("Weapon_Rune_tips_113")
	uiManager:show("RuleView", nil)
end
return RuneQHXLViewPanel
