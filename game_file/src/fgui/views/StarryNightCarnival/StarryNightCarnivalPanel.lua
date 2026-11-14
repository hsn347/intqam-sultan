local constantRead = include("constantRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local constantRead = include("constantRead")
local starryNightCarnivalltCtrl = include("starryNightCarnivalltCtrl")
local starryNightCarnivalCtrl = SoraDGetCtrl("starryNightCarnivalCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local StarryNightCarnivalPanel = class("StarryNightCarnivalPanel", baseFguiPanel)
function StarryNightCarnivalPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("StarryNightCarnivalPanel:ctor", self.viewName)
end
function StarryNightCarnivalPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "fonts"
		self._packageList, self._packageList[2] = self._packageList, "ThemTake"
	end
	return self._packageList
end
function StarryNightCarnivalPanel:onInit()
	print("=======StarryNightCarnivalPanel:onInit")
	self:fixChildrenPos()
	self.fields.n2:fix(false)
	self.fields.n3:fix(false)
	self.fields.n4:fix(false)
	self.fields.Button_levelLock:fixPos()
	self.fields.Button_levelLock2:fixPos()
	self.fields.Button_add:fixPos()
	self.fields.Text_advance:fixPos()
	self.fields.Text_advance2:fixPos()
	self.fields.Text_normal:fixPos()
	self.fields.Text_level:fixPos()
	self.fields.Progress_score:fixPos()
	self.fields.n44:fixPos()
	self.fields.mask:fixPos()
	self.fields.mask2:fixPos()
	self.fields.Com_itemStarry:fixPos()
	self.fields.n5:fixPos()
	self.fields.Label_incScore:fixPos()
	self.fields.Usm_1:fixPos()
	self.donateSpeed = constantRead.getConstValue("STARLIT_LEVELUP_SPEED")
	if SoraDGetDefaultLanguage() ~= "ar" then
		local pos = self.fields.n5:getPositionX()
		self.fields.n5:setPositionX(pos - 30)
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Usm_1:setScaleX(-1)
	end
	starryNightCarnivalCtrl:sendReqInitDataMsg()
	self.activityID = gActivityTimeActivityID.STARRY_NIGHT_CARNIVAL
	self.itemID = constantRead.getConstValue("STARLIT_NIGHT_REQ_ITEM", 1655)
	self.classType = activityShowCtrl:getParamByID(gActivityTimeActivityID.STARRY_NIGHT_CARNIVAL).classtype
	self.config = starryNightCarnivalltCtrl.getPointRewardDataByClassType(self.classType)
	self.configSize = table.nums(self.config)
	dump(self.configSize, "self.configSize")
	self.fields.Com_title:initData(i18n("activity_name_9001427"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.tableLabelSpare, _ENV = self.fields.Com_title.initData, self.fields.Com_title.initData
	self.functionCol = self:initFunc()
	self:setActivityTime()
	self.fields.Text_advance:setString(i18n("StarlitNight_text_07"))
	self.fields.Text_advance2:setString(i18n("StarlitNight_text_11"))
	self.fields.Text_normal:setString(i18n("cityUp_title_03"))
	self.fields.Text_level:setString(i18n("common_text_748"))
	self.fields.Button_get:setTitleText(i18n("cavalryrise_text_07"))
	self.fields.Button_levelLock:addClickListener(handler(self, self.onClickAdvance))
	self.fields.Button_levelLock:initData(i18n("StarlitNight_text_02"))
	self.fields.Button_levelLock2:addClickListener(handler(self, self.onClickSenior))
	self.fields.Button_levelLock2:initData(i18n("StarlitNight_text_12"))
	self.fields.Button_get:addClickListener(handler(self, self.onClickGetAllReward))
	self.fields.Button_add:addClickListener(handler(self, self.onClickAddItem))
	self.fields.Com_itemStarry:addClickListener(handler(self, self.onClickAddItem))
	self.fields.List_reward:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onAwardScrolling))
	self.fields.List_reward:setVirtual()
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function StarryNightCarnivalPanel:initData(isDonate)
	self.level = starryNightCarnivalCtrl:getCurLevel()
	if self.level > self.configSize then
		self.level = self.configSize
	end
	self.fields.List_reward:setNumItems(self.configSize)
	self.fields.Button_get:setTouchable(starryNightCarnivalCtrl:haveRewardNotGot())
	self.fields.Button_get:setGrayed(not starryNightCarnivalCtrl:haveRewardNotGot())
	starryNightCarnivalCtrl = not starryNightCarnivalCtrl:haveRewardNotGot()
	;(not starryNightCarnivalCtrl:haveRewardNotGot()).visible = starryNightCarnivalCtrl:haveRewardNotGot()
	;(not starryNightCarnivalCtrl:haveRewardNotGot()).num = -1
	self.fields.Button_get:setRedDot(not starryNightCarnivalCtrl:haveRewardNotGot())
	self.fields.Progress_score:setValue(starryNightCarnivalCtrl:getCurScore(), self.config[self.level].score)
	self.fields.Text_curLevel:setString(starryNightCarnivalCtrl:getCanGetLevel())
	if starryNightCarnivalCtrl:getUnlockFurther() then
		self.fields.Button_levelLock:setVisible(false)
		self.fields.mask:setVisible(false)
	end
	if starryNightCarnivalCtrl:getUnlockFurtherEx() then
		self.fields.Button_levelLock2:setVisible(false)
		self.fields.mask2:setVisible(false)
	end
	if not self.firstComeIn then
		if self.level >= self.configSize then
			self.fields.List_reward:scrollToView(self.configSize - 1)
		else
			self.fields.List_reward:scrollToView(starryNightCarnivalCtrl:getAviRewardLevel())
		end
		self.firstComeIn = true
	elseif isDonate and starryNightCarnivalCtrl:getCanGetLevel() >= 1 then
		self.fields.List_reward:scrollToView(starryNightCarnivalCtrl:getCanGetLevel() - 1)
	end
	local maxShowIndex = self:getMaxShowIndex()
	self.fields.Next_Reward:initData(maxShowIndex, self.config[maxShowIndex], true, self.configSize == maxShowIndex)
end
local LONG_EVENT_TIME = 1
function StarryNightCarnivalPanel:onLevelUpgrade(context)
	self.isLongUse = true
	if backpackCtrl:getItemCount(self.itemID) >= 1 then
		local useNum = 1
		_ENV = self.itemID
		self.itemID[1] = ffa.callFunc(function()
			if backpackCtrl:getItemCount(self.itemID) >= 1 then
				if starryNightCarnivalCtrl:getCanGetLevel() == self.configSize then
					self:stopAllActions()
					if IsArClient then
						SoraDShowMsgTip(i18n("StarlitNight_text_09"))
					else
						SoraDShowMsgTip(i18n("common_text_283"))
					end
				else
					starryNightCarnivalCtrl:sendDonateMsg()
				end
			else
				self.isLongUse = false
				self:stopAllActions()
			end
		end)
		self.itemID[2] = ffa.delay(self.donateSpeed)
		self.itemID[3] = ffa.delay(self.donateSpeed)
		local seq = ffa.seq(self.itemID)
		self:runAction(ffa.repeatForever(seq))
	else
		SoraDShowMsgTip(i18n("common_text_2512"))
	end
end
function StarryNightCarnivalPanel:onOutClick()
	self:stopAllActions()
end
function StarryNightCarnivalPanel:onAwardScrolling()
	local maxShowIndex = self:getMaxShowIndex()
	self.fields.Next_Reward:initData(maxShowIndex, self.config[maxShowIndex], true, self.configSize == maxShowIndex)
end
function StarryNightCarnivalPanel:getMaxShowIndex()
	local singleHeight = 105
	local contentHeight = self.fields.List_reward:getContentSize().height
	local posY = self.fields.List_reward:getScrollPane():getPosY()
	local index = math.ceil((posY + contentHeight) / singleHeight)
	if index == self.configSize - 1 then
		return self.configSize
	elseif index == 0 then
		return 5
	end
	return math.min(self.configSize, math.ceil(index / 5) * 5)
end
function StarryNightCarnivalPanel:refreshItem()
	self.fields.Com_itemStarry:initData()
end
function StarryNightCarnivalPanel:refreshView(data)
	if not data then
		return self:initData()
	end
	dump(data, "SnowyNightCarnivalPanel:refreshView")
	self.rewards = data.reward
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end
function StarryNightCarnivalPanel:initFunc()
	_ENV = nil
	;(nil).init = function()
		self:initData()
	end
	;(nil).notOpen = function()
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
	;(nil).further = function()
		self.fields.mask:setVisible(false)
		self.fields.Button_levelLock.transitions.t0:play(function()
			self:initData()
		end)
	end
	;(nil).furtherEx = function()
		self.fields.mask2:setVisible(false)
		self.fields.Button_levelLock2.transitions.t0:play(function()
			self:initData()
		end)
	end
	;(nil).donate = function()
		if starryNightCarnivalCtrl:getIncScore() > 1 then
			local comp
			if table.nums(self.tableLabelSpare) > 10 then
				comp = table.remove(self.tableLabelSpare, 1)
				comp:setText("x" .. tostring(starryNightCarnivalCtrl:getIncScore()))
				comp:getTransition("t0"):play()
			else
				comp = fgui.UIPackage:createObjectFromURL("ui://StarryNightCarnival/Label_pointEffect")
				comp:addTo(self.fields.Label_incScore)
				comp:setPositionX(math.random(-40, 40) + math.random(-20, 20))
				comp:setPositionY(math.random(-40, 40) + math.random(-20, 20))
				comp:setText("x" .. tostring(starryNightCarnivalCtrl:getIncScore()))
				comp:getTransition("t0"):play()
			end
			table.insert(self.tableLabelSpare, comp)
		end
		self:initData(true)
	end
	;(nil).reward = function()
		self:showRewards()
		self:initData()
	end
	;(nil).noReward = function()
		SoraDShowMsgTip(i18n("common_text_1892"))
	end
	;(nil).alreadyFurther = function()
		SoraDShowMsgTip(i18n("common_text_3833"))
	end
	local (nil).notEnoughGold, functionCol = function()
		SoraDShowMsgTip(i18n("alliance_landSet_006"))
	end, nil
	return functionCol
end
function StarryNightCarnivalPanel:showRewards()
	if not self.rewards then
		return
	end
	local _ENV, t = self.rewards, self.rewards
	for i, v in pairs(self.rewards) do
		if v.id then
			table.insert(t, v)
		end
	end
	SoraDMailGainItems(t, true)
end
function StarryNightCarnivalPanel:onItemRenderer(index, object)
	object:initData(index + 1, self.config[index + 1], false, index == #self.config - 1)
end
function StarryNightCarnivalPanel:onClickDonate()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.itemID) >= 1 then
		if starryNightCarnivalCtrl:getCanGetLevel() == self.configSize then
			if IsArClient then
				SoraDShowMsgTip(i18n("StarlitNight_text_09"))
			else
				SoraDShowMsgTip(i18n("common_text_283"))
			end
		else
			starryNightCarnivalCtrl:sendDonateMsg()
		end
	else
		SoraDShowMsgTip(i18n("common_text_2512"))
		_ENV = i18n("common_text_2512")
		i18n("common_text_2512").itemID = self.itemID
		uiManager:show("CommonSourceGuide", i18n("common_text_2512"))
	end
end
function StarryNightCarnivalPanel:onClickGetAllReward()
	SoraDPlaySound()
	starryNightCarnivalCtrl:sendGetAllRewardMsg()
end
function StarryNightCarnivalPanel:onClickAddItem()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonSourceGuide", nil)
end
function StarryNightCarnivalPanel:onClickAdvance()
	SoraDPlaySound()
	_ENV = nil
	;(nil).isEx2 = false
	uiManager:show("StarryNightCarnivalBuyGift", nil):setOwnerKey(self)
end
function StarryNightCarnivalPanel:onClickSenior()
	SoraDPlaySound()
	_ENV = nil
	;(nil).isEx2 = true
	uiManager:show("StarryNightCarnivalBuyGift", nil):setOwnerKey(self)
end
function StarryNightCarnivalPanel:resizeBannerEffect()
	if not self.originSize then
		self.originSize = self.fields.n1:getSize()
	end
	local scale = self.view:getWidth() / self.originSize.width
	self.fields.n1:setSize(self.view:getWidth(), self.originSize.height * scale)
	self.fields.en:setSize(self.view:getWidth(), self.originSize.height * scale)
	self.fields.ar:setSize(self.view:getWidth(), self.originSize.height * scale)
end
function StarryNightCarnivalPanel:setActivityTime()
	self.fields.Label_time:setUbbOn()
	self.fields.Label_time:setTimeLast(function(strTime)
		local str = fguiHelper.getColorString("#FFC864", i18n("common_text_2669")) .. fguiHelper.getColorString("#FFFFFF", strTime)
		return str
	end)
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		self.fields.Label_time:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
end
function StarryNightCarnivalPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("StarlitNight_text_01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function StarryNightCarnivalPanel:onShow()
	print("=======StarryNightCarnivalPanel:onShow")
	self:resizeBannerEffect()
end
return StarryNightCarnivalPanel
