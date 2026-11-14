local badgeExchangeCtrl = SoraDGetCtrl("badgeExchangeCtrl")
local publicRead = include("publicRead")
local badgeExchangeRead = include("badgeExchangeRead")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local badgeBourseViewPanel = class("badgeBourseViewPanel", baseFguiPanel)
function badgeBourseViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("badgeBourseViewPanel:ctor", self.viewName)
end
function badgeBourseViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function badgeBourseViewPanel:onInit()
	print("=======badgeBourseViewPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_1906"))
	self.fields.slider:setVisible(false)
	self.fields.slider:setSliderCallBack(handler(self, self.onSliderChange))
	self.fields.btn_exchange:setString(i18n("common_text_1889"))
	self.fields.btn_exchange:addClickListener(handler(self, self.reqExchange))
	self.fields.btn_exchange:setVisible(false)
	self.fields.Text_tip:setString(i18n("common_text_4742"))
	self.fields.Text_time:setTimeLast(function(timeStr)
		return i18n("common_text_1907") .. timeStr
	end)
	self.fields.Text_time:setTimeEndListener(function()
		self:updateView()
	end)
	self.fields.Button_help:addTouchEventListener(handler(self, self.btnHelpClick))
	self.fields.btnPrev:addClickListener(handler(self, self.onPrevClick))
	self.fields.btnNext:addClickListener(handler(self, self.onNextClick))
end
function badgeBourseViewPanel:onShow()
	print("=======badgeBourseViewPanel:onShow")
	self.targetID = self.param and self.param.targetID or gBadgeItemID.COMMON_BADGE_ID
	self.nType = nil
	self.exchangeNum = 0
	self.tabsetArray, self.tag = self:checkShowTab(self.param and self.param.targetID)
	if #self.tabsetArray > 1 then
		_ENV = self.param and self.param.targetID
		;(self.param and self.param.targetID).defaultClick = self.tag
		;(self.param and self.param.targetID).tabsetArray = self.tabsetArray
		;(self.param and self.param.targetID).callback = handler(self, self.btnTabClick)
		self.fields.com_TabW:initView(self.param and self.param.targetID)
		self.fields.com_TabW:setVisible(true)
		self.fields.Text_time:setPositionY(self.view:getHeight() / 2 - 243)
		self.fields.Button_help:setPositionY(self.view:getHeight() / 2 - 243)
	else
		self.targetID = gBadgeItemID.COMMON_BADGE_ID
		self.tag = 1
		self.fields.com_TabW:setVisible(false)
		self.fields.Text_time:setPositionY(self.view:getHeight() / 2 - 243 - 40)
		self.fields.Button_help:setPositionY(self.view:getHeight() / 2 - 243 - 40)
		self:btnTabClick(gBadgeExchangeType.COMMON_BADGE_TYPE)
	end
end
function badgeBourseViewPanel:checkShowTab(toTargetID)
	local cfg = badgeExchangeRead.getExchangeLimitCfg()
	local badgeExchangeRead, ret
	local targetStage = 1
	local badgeExchangeRead, targetMap
	for k, v in ipairs(cfg) do
		local isReach = badgeExchangeCtrl:isOpenBadge(v.badgeType)
		if isReach then
			if not ret[v.badgeStage] then
				badgeExchangeRead = v.badgeType
				ret[v.badgeStage], v.badgeType.title = v.badgeType, i18n(badgeExchangeRead.getBadgeStageNameKey(v.badgeStage))
			end
			if not targetMap[v.badgeStage] then
				badgeExchangeRead = v.badgeType
				targetMap[v.badgeStage], v.badgeType.tarIndex = v.badgeType, 1
			end
			local targetID = v.exchangeItem[1]
			if not targetMap[v.badgeStage][targetID] then
				local tarIndex = targetMap[v.badgeStage].tarIndex
				targetMap[v.badgeStage][targetID] = tarIndex
				targetMap[v.badgeStage].tarIndex = tarIndex + 1
				_ENV, badgeExchangeRead = badgeExchangeRead.getBadgeStageNameKey(v.badgeStage)
				badgeExchangeRead.getBadgeStageNameKey(v.badgeStage).badgeType, badgeExchangeRead.getBadgeStageNameKey(v.badgeStage)[1] = badgeExchangeRead.getBadgeStageNameKey(v.badgeStage)
				badgeExchangeRead.getBadgeStageNameKey(v.badgeStage).limitType = v.limitType
				_ENV, badgeExchangeRead.getBadgeStageNameKey(v.badgeStage).targetID = v.limitType, targetID
				badgeExchangeRead.getBadgeStageNameKey(v.badgeStage).targetNum, v.limitType[1] = v.limitType, v.exchangeItem[2]
				badgeExchangeRead.getBadgeStageNameKey(v.badgeStage).limitNum = v.limitNum
				badgeExchangeRead.getBadgeStageNameKey(v.badgeStage).title = publicRead.getName(targetID)
				table.insert(ret[v.badgeStage], badgeExchangeRead.getBadgeStageNameKey(v.badgeStage))
			else
				local badgeIndex = targetMap[v.badgeStage][targetID]
				table.insert(ret[v.badgeStage][badgeIndex].badgeType, v.badgeType)
				table.insert(ret[v.badgeStage][badgeIndex].targetNum, v.exchangeItem[2])
			end
			if toTargetID and toTargetID == targetID then
				targetStage = v.badgeStage
			end
		end
	end
	local badgeExchangeRead, stageList = (for generator), ipairs(cfg)
	for stage in pairs(ret) do
		table.insert(stageList, stage)
	end
	table.sort(stageList)
	local badgeExchangeRead, retTable = table.sort, table.sort
	local retIndex = 1
	for index, stage in ipairs(stageList) do
		table.insert(retTable, ret[stage])
		if stage == targetStage then
			retIndex = index
		end
	end
	return retTable, toTargetID and retIndex or #retTable
end
function badgeBourseViewPanel:btnTabClick(tag)
	self.tag = tag
	self.nType = nil
	self.exchangeNum = 0
	self.isEnoughCost = false
	self.fields.bg:setURL(self.tag == 1 and "icon_technology_huiji01.png" or "icon_technology_huiji02.png")
	self.indexInTag = 1
	self.fields.arrow:init(self.tabsetArray[self.tag][self.indexInTag])
	self.controllers.ctrlSwitch:setSelectedIndex(0 < #self.tabsetArray[self.tag] and 1 or 0)
	self.fields.btnPrev:setVisible(false)
	self:updateView()
end
function badgeBourseViewPanel:updateView()
	local badgeType = self.tabsetArray[self.tag][self.indexInTag].badgeType[1]
	local leftTime = badgeExchangeCtrl:getLeftTime(badgeType)
	if 0 < leftTime then
		self.fields.Text_time:beginTime(leftTime)
	end
	self.fields.arrow:updateData()
	self:updateBottom()
	self.fields.btnPrev:setVisible(self.indexInTag > 1)
	self.fields.btnNext:setVisible(self.indexInTag < #self.tabsetArray[self.tag])
end
function badgeBourseViewPanel:exchangeIDSelect(target, data)
	self.nType = data.exchangeID
	self:updateBottom()
	self:runUnSelectAct()
end
function badgeBourseViewPanel:updateBottom()
	self.fields.Text_tip:setVisible(self.nType == nil)
	self.fields.slider:setVisible(self.nType ~= nil)
	self.fields.btn_exchange:setVisible(self.nType ~= nil)
	if self.nType then
		local badgeType = badgeExchangeRead.getExchangeBadgeType(self.nType, self.tabsetArray[self.tag][self.indexInTag].badgeType)
		self.maxExNum = badgeExchangeRead.getLimitNum(badgeType)
		self.hasExCount = badgeExchangeCtrl:getCurExchageNum(badgeType)
		local maxExNum = badgeExchangeCtrl:getMaxExchangeNum(self.nType, badgeType) or 1
		maxExNum = math.max(maxExNum, 1)
		local max = math.max(1, math.min(maxExNum, self.maxExNum - self.hasExCount))
		local curValue = math.min(1, max)
		badgeExchangeRead = math.min(maxExNum, self.maxExNum - self.hasExCount)
		math.min(maxExNum, self.maxExNum - self.hasExCount).maxValue = max
		math.min(maxExNum, self.maxExNum - self.hasExCount).minValue = 1
		math.min(maxExNum, self.maxExNum - self.hasExCount).curValue = curValue
		self.fields.slider:initData(math.min(maxExNum, self.maxExNum - self.hasExCount))
		self.fields.btn_exchange:setCostIcon(publicRead.getIcon(self.nType))
		self:updateBtnExchagne(curValue, badgeType)
	end
end
function badgeBourseViewPanel:updateBtnExchagne(curValue, badgeType)
	local costNum = badgeExchangeCtrl:getCostByType(self.nType, curValue, badgeType)
	local isEnough = costNum <= badgeExchangeCtrl:getOwnCount(self.nType)
	self.fields.btn_exchange:setCostTitle(string.formatnumberthousands(costNum))
	self.fields.btn_exchange:setGoldColor(isEnough and cc.c3b(240, 230, 210) or cc.c3b(224, 43, 43))
	self.isEnoughCost = isEnough
end
function badgeBourseViewPanel:runUnSelectAct()
	self.fields.arrow:runUnSelectAct(self.nType)
end
function badgeBourseViewPanel:onSliderChange(num)
	if self.nType then
		self.exchangeNum = num
		local badgeType = badgeExchangeRead.getExchangeBadgeType(self.nType, self.tabsetArray[self.tag][self.indexInTag].badgeType)
		local index = table.indexof(self.tabsetArray[self.tag][self.indexInTag].badgeType, badgeType)
		self.rewardNum = self.tabsetArray[self.tag][self.indexInTag].targetNum[index]
		self:updateBtnExchagne(self.exchangeNum, badgeType)
		self.fields.arrow:setResNum("x" .. string.formatnumberthousands(self.exchangeNum * self.rewardNum))
		self.fields.arrow:updateData(self.nType, self.exchangeNum, badgeType)
	end
end
function badgeBourseViewPanel:reqExchange()
	SoraDPlaySound()
	if not self.isEnoughCost then
		if self.nType == gIDDef.GOLD then
			SoraDShowMsgBox(i18n("common_text_423"), i18n("common_text_282"), nil, function(msgType)
				if MSGBOX_CALLBACK_YES == msgType then
					if GLOBAL_GAME_RECHARGE_MODE then
						uiManager:show("rechargeView")
					else
						SoraDCreatePanel("rechargeView"):show()
					end
				end
			end)
		elseif self.nType == gBadgeItemID.COMMON_BADGE_ID then
			_ENV = nil
			;(nil).name = publicRead.getName(self.nType)
			SoraDShowMsgBox(i18n("common_text_3874", nil), i18n("common_text_204"), nil, function(msgType)
				if MSGBOX_CALLBACK_YES == msgType then
					if #self.tabsetArray > 1 then
						self.fields.com_TabW:setTabIndex(gBadgeExchangeType.COMMON_BADGE_TYPE, true)
					else
						self.targetID = gBadgeItemID.COMMON_BADGE_ID
						self.tag = 1
						self:btnTabClick(gBadgeExchangeType.COMMON_BADGE_TYPE)
					end
				end
			end)
		elseif serviceFunctions.isCanBuyResource(self.nType) then
			SoraDShowMsgBox(i18n("common_text_565"), i18n("common_text_282"), nil, function(msgType)
				if MSGBOX_CALLBACK_YES == msgType then
					_ENV = nil
					;(nil).rid = self.nType
					uiManager:show("resourceBuyView", nil)
				end
			end)
		else
			SoraDShowMsgTip(i18n("exchange_crystal_02"))
		end
		return
	end
	if self.hasExCount >= self.maxExNum then
		_ENV = i18n("exchange_crystal_02")
		i18n("exchange_crystal_02").max = self.maxExNum
		i18n("exchange_crystal_02").name = publicRead.getName(self.tabsetArray[self.tag][self.indexInTag].targetID)
		SoraDShowMsgTip(i18n("exchange_crystal_05", i18n("exchange_crystal_02")))
		return
	end
	local badgeType = badgeExchangeRead.getExchangeBadgeType(self.nType, self.tabsetArray[self.tag][self.indexInTag].badgeType)
	local costNum = badgeExchangeCtrl:getCostByType(self.nType, self.exchangeNum, badgeType)
	_ENV = badgeType
	badgeType.resID = self.nType
	badgeType.resNum = costNum
	badgeType.targetID = self.tabsetArray[self.tag][self.indexInTag].targetID
	badgeType.exchangeNum = self.exchangeNum
	badgeType.rewardNum = self.rewardNum
	badgeType.tabPage = badgeType
	uiManager:show("badgeExchangeView", badgeType)
end
function badgeBourseViewPanel:btnHelpClick()
	SoraDPlaySound()
	local msgTip = ""
	local targetID = self.tabsetArray[self.tag][self.indexInTag].targetID
	if targetID == gBadgeItemID.METEOR_CRYSTAL then
		_ENV = nil
		;(nil).var = constantRead.getConstValue("EXCHANGE_CRYSTAL_BRILLIANCE_LV")
		msgTip = i18n("exchange_crystal_03", nil)
	elseif targetID == gBadgeItemID.GILDED_CRYSTAL then
		msgTip = i18n("exchange_crystal_04")
	elseif targetID == gBadgeItemID.OIL_ID then
		_ENV = nil
		;(nil).num = badgeExchangeRead.getLimitNum(self.tabsetArray[self.tag][self.indexInTag].badgeType[1])
		msgTip = i18n("exchange_text_04", nil)
	else
		_ENV = nil
		;(nil).item = publicRead.getName(targetID)
		msgTip = i18n("common_text_1909", nil)
	end
	_ENV = nil
	;(nil).align = SoraDFLabelR()
	SoraDShowHelpMsgTip(msgTip, nil)
end
function badgeBourseViewPanel:onPrevClick(...)
	if self.indexInTag > 1 then
		self.indexInTag = self.indexInTag - 1
		self.fields.arrow:init(self.tabsetArray[self.tag][self.indexInTag])
		self:updateView()
	end
end
function badgeBourseViewPanel:onNextClick(...)
	if self.indexInTag < #self.tabsetArray[self.tag] then
		self.indexInTag = self.indexInTag + 1
		self.fields.arrow:init(self.tabsetArray[self.tag][self.indexInTag])
		self:updateView()
	end
end
return badgeBourseViewPanel
