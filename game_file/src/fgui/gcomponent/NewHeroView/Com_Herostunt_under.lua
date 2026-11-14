local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_Herostunt_under = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/Com_Herostunt_under", Com_Herostunt_under)
function Com_Herostunt_under:onInit()
	self.awakeTimes = 1
	self.fields.Text_maxTip:setString(i18n("heroskill_text_12"))
	self.fields.Button_awake:addClickListener(handler(self, self.btnAwakeClick))
	self.fields.Button_save:setTitleText(i18n("common_text_195"))
	self.fields.Button_save:addClickListener(handler(self, self.onSaveClick))
	self.fields.Button_awakeTimes:setTitleText(i18n("common_text_4946"))
	self.fields.Button_awakeTimes:addClickListener(handler(self, self.onAwakeTimesClick))
end
function Com_Herostunt_under:onShow()
end
function Com_Herostunt_under:initData(heroID, skillID, isMax, isFromMsg, isAutoSave, isAllUp, isAwaked)
	self.heroID = heroID
	self.skillID = skillID
	self.isAutoSave = isAutoSave
	self.isAllUp = isAllUp
	self.isAwaked = isAwaked
	self.costInfo = heroltCtrl:getAwakeCost(self.heroID)
	self.costId = self.costId or self.costInfo.id
	self.costNum = self.costNum or self.costInfo.num
	self.awakeTimes = self.awakeTimes or 1
	self.fields.Text_tip:setVisible(false)
	local index = 0
	if isMax then
		index = 2
	elseif isAwaked and not self.isAllUp then
		index = IsArClient and 1 or 0
	end
	self.index = index
	self.controllers.c1:setSelectedIndex(index)
	self:adjustButtonPos()
	self:updateChips()
	if isAutoSave then
		self.fields.Text_tip:setVisible(true)
		self.fields.Text_tip:setString(i18n("heroskill_text_10"))
	end
	if isFromMsg and not isAllUp then
		self.fields.Text_tip:setVisible(true)
		self.fields.Text_tip:setString(i18n("heroskill_text_14"))
	end
end
function Com_Herostunt_under:adjustButtonPos()
	local center = self:getWidth() / 2
	if self.index == 0 then
		self.fields.Button_awake:setPositionX(SoraDFPosX(center + 125, self:getWidth()))
		self.fields.Button_awakeTimes:setPositionX(SoraDFPosX(center - 125, self:getWidth()))
	else
		local offset = self.fields.Button_awake:getWidth() / 2
		self.fields.Button_awakeTimes:setPositionX(center)
		self.fields.Button_awake:setPositionX(SoraDFPosX(center + offset * 2, self:getWidth()))
		self.fields.Button_save:setPositionX(SoraDFPosX(center - offset * 2, self:getWidth()))
	end
end
function Com_Herostunt_under:updateChips()
	local myNum = backpackCtrl:getItemCount(self.costId)
	self.isEnoughChip = myNum >= self.costNum * self.awakeTimes
	backpackCtrl = nil
	;(nil).num = self.awakeTimes
	self.fields.Button_awake:setTitleText(i18n("common_text_4947", nil))
	self.fields.Button_awake:setCost(self.costId, self.costNum * self.awakeTimes)
	self.fields.Button_awake:setNumTotal(self.costNum * self.awakeTimes, myNum, "#FFFF00")
end
function Com_Herostunt_under:onSaveClick()
	local save = function(isChcek)
		if isChcek ~= nil then
			GAME_HERO_SAVE_SHOW = isChcek
		end
		SoraDPlaySound("uicontrol", 3)
		heroCtrl:saveRemakeSkillReq(self.heroID)
	end
	if GAME_HERO_SAVE_SHOW then
		local panel = SoraDCreatePanel("heroUskillPromptBox")
		panel:initData(i18n("weapon_text_07"), save, GAME_HERO_SAVE_SHOW)
		panel:show()
	else
		save()
	end
end
function Com_Herostunt_under:btnAwakeClick(button, eventType)
	SoraDPlaySound()
	if self.isEnoughChip then
		if not IsArClient and not self.skillID then
			SoraDShowMsgTip(i18n("skill_text_17"))
			return
		end
		if self:checkIsMax() then
			return
		end
		local remake = function(isChcek)
			if isChcek ~= nil then
				GAME_HERO_REMAKE_SHOW = isChcek
			end
			if self.awakeTimes > 1 then
				local dailyRemindManager = include("dailyRemindManager")
				if not dailyRemindManager.checkNeedRemind(dailyRemindManager.REMIND_TYPE.herostnt_times) then
					SoraDPlaySound("uicontrol", 21)
					heroCtrl:remakeSkillReq(self.heroID, self.skillID, self.costId, self.awakeTimes)
					SoraDShowLoading()
					return
				end
				_ENV = self.skillID
				_ENV = nil
				;(nil).num1 = self.awakeTimes
				;(nil).num2 = self.awakeTimes
				self.skillID.content = i18n("common_text_4948", nil)
				function self.skillID.confirmFunc()
					SoraDPlaySound("uicontrol", 21)
					heroCtrl:remakeSkillReq(self.heroID, self.skillID, self.costId, self.awakeTimes)
					SoraDShowLoading()
				end
				self.skillID.cancel = true
				function self.skillID.remindFunc(value)
					if value then
						dailyRemindManager.addRemindToManager(dailyRemindManager.REMIND_TYPE.herostnt_times)
					end
				end
				uiManager:show("MessageBox", self.skillID)
			else
				SoraDPlaySound("uicontrol", 21)
				heroCtrl:remakeSkillReq(self.heroID, self.skillID, self.costId, self.awakeTimes)
				SoraDShowLoading()
			end
		end
		if IsArClient and GAME_HERO_REMAKE_SHOW and self.isAwaked and not self.isAllUp and not self.isAutoSave then
			local panel = SoraDCreatePanel("heroUskillPromptBox")
			panel:initData(i18n("heroskill_text_06"), remake, GAME_HERO_REMAKE_SHOW)
			panel:show()
		else
			remake()
		end
	elseif self.costInfo.spId and self.costId == self.costInfo.spId then
		SoraDShowMsgTip(i18n("common_text_2512"))
	else
		SoraDShowMsgBox(i18n("heroskill_text_04"), i18n("common_text_054"), i18n("common_text_185"), function(eventType)
			if MSGBOX_CALLBACK_YES == eventType and self.costInfo ~= nil then
				_ENV = nil
				;(nil).itemID = self.costId
				;(nil).needCount = self.costNum * self.awakeTimes
				uiManager:show("newHeroGainChipMethodView", nil)
			end
		end)
	end
end
function Com_Herostunt_under:onAwakeTimesClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).costInfo = self.costInfo
	;(nil).costId = self.costId
	;(nil).costNum = self.costNum
	;(nil).handler = handler(self, self.chooseBack)
	uiManager:show("heroAwakeTimesPop", nil)
end
function Com_Herostunt_under:chooseBack(id, num, times)
	print("chooseBack=====", id, num, times)
	self.costId = id
	self.costNum = num
	self.awakeTimes = times
	self:updateChips()
end
function Com_Herostunt_under:onLevelUpgrade(context)
	self.isLongUse = true
	if backpackCtrl:getItemCount(self.costInfo.spId) >= 1 then
		local useNum = 1
		_ENV = self.costInfo.spId
		self.costInfo.spId[1] = ffa.callFunc(function()
			if backpackCtrl:getItemCount(self.costInfo.spId) >= 1 then
				if self:checkIsMax() then
					self:stopAllActions()
					return
				end
				heroCtrl:remakeSkillReq(self.heroID, self.skillID, self.costInfo.spId)
				SoraDShowLoading()
			else
				self.isLongUse = false
				self:stopAllActions()
			end
		end)
		self.costInfo.spId[2] = ffa.delay(0.1)
		self.costInfo.spId[3] = ffa.delay(0.1)
		local seq = ffa.seq(self.costInfo.spId)
		self:runAction(ffa.repeatForever(seq))
	else
		SoraDShowMsgTip(i18n("common_text_2512"))
	end
end
function Com_Herostunt_under:checkIsMax()
	self.skillList, heroCtrl = nil, nil
	self.heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	for k, v in pairs(self.heroInfo.powerSkill) do
		table.insert(self.skillList, v)
	end
	local isMax = true
	for k, v in ipairs(self.skillList) do
		if v.skillID and v.buffValue < heroltCtrl:getMaxBuffValue(v.skillID) then
			isMax = false
			break
		end
	end
	return isMax
end
function Com_Herostunt_under:onOutClick()
	self:stopAllActions()
end
return Com_Herostunt_under
