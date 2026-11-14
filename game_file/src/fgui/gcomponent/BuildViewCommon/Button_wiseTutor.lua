local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local wiseTutorCtrl = SoraDGetCtrl("wiseTutorCtrl")
local ExtremelySkillfulCtrl = SoraDGetCtrl("ExtremelySkillfulCtrl")
local artisanHouseCtrl = SoraDGetCtrl("artisanHouseCtrl")
local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
local warOrderCtrl = SoraDGetCtrl("warOrderCtrl")
local activityTimeRead = include("activityTimeRead")
local baseComponent = require("fgui.base.baseComponent")
local Button_wiseTutor = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://BuildViewCommon/Button_wiseTutor", Button_wiseTutor)
function Button_wiseTutor:onInit()
	self:addClickListener(handler(self, self.onClick_btn))
end
function Button_wiseTutor:onShow()
end
function Button_wiseTutor:initData(data)
	self.activityID = data.activityID
	self.handle = data.handle
	local buildID = data.bid
	local iid = data.iid
	local wiseTutorIsOpen = data.wiseTutorIsOpen
	self.buffBuildType = data.buffBuildType
	local _leftTime = 0
	self.fields.icon:setScale(1)
	if self.activityID == gActivityTimeActivityID.WISE_TUTOR_ACTIVITY then
		self:setIcon("icon_activity_9001368.png")
		local __, leftTime = wiseTutorCtrl:getStateInfo()
		_leftTime = leftTime
		self.wiseTutorIsOpen = wiseTutorCtrl:isBuffEffect()
	elseif self.activityID == gActivityTimeActivityID.ARTISAN_HOUSE_ACTIVITY then
		self:setIcon("icon_artisanhouse_9001368.png")
		self.fields.icon:setScale(0.8)
		local __, leftTime = artisanHouseCtrl:getStateInfo()
		_leftTime = leftTime
		self.wiseTutorIsOpen = artisanHouseCtrl:isBuffEffect()
	elseif self.activityID == gActivityTimeActivityID.EXTREMELY_SKILLFUIL then
		self:setIcon("icon_activity_9001488.png")
		local leftTime = activityShowCtrl:getRemainTime(self.activityID)
		_leftTime = leftTime
		self.wiseTutorIsOpen = ExtremelySkillfulCtrl:isBuffEffect()
	elseif self.activityID == gActivityTimeActivityID.RADIANT_DECREE_ACTIVITY then
		self:setIcon("icon_ghyl_brave.png")
		self.fields.icon:setScale(0.8)
		local __, leftTime = radiantDecreeCtrl:getStateInfo()
		_leftTime = leftTime
		if wiseTutorIsOpen ~= nil then
			self.wiseTutorIsOpen = wiseTutorIsOpen
		else
			self.wiseTutorIsOpen = radiantDecreeCtrl:isBuffEffect(buildID, iid)
		end
	elseif self.activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY then
		self:setIcon(activityTimeRead.getActivityIconByID(self.activityID, activityShowCtrl:getParamClassType(self.activityID)))
		local leftTime = activityShowCtrl:getRemainTime(self.activityID)
		_leftTime = leftTime
		self.wiseTutorIsOpen = warOrderCtrl:isBuffEffect(self.buffBuildType)
	elseif self.activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581 then
		self:setIcon(activityTimeRead.getActivityIconByID(self.activityID, activityShowCtrl:getParamClassType(self.activityID)))
		local leftTime = activityShowCtrl:getRemainTime(self.activityID)
		_leftTime = leftTime
		local curCtrl = warOrderCtrl:getCurCtrl(self.activityID)
		self.wiseTutorIsOpen = curCtrl:isBuffEffect(self.buffBuildType)
	elseif self.activityID == gActivityTimeActivityID.CRESCENT_ORDER_ACTIVITY then
		local activityIcon = activityTimeRead.getActivityIconByID(self.activityID)
		self:setIcon(activityIcon)
		local leftTime = activityShowCtrl:getRemainTime(self.activityID)
		_leftTime = leftTime
		local activity_9001710_Ctrl = SoraDGetCtrl("activity_9001710_Ctrl")
		self.wiseTutorIsOpen = activity_9001710_Ctrl:isBuffEffect(self.buffBuildType, buildID)
	elseif self.activityID == gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY or self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001601 or self.activityID == gActivityTimeActivityID.PREPARE_FOR_WAR_ACTIVITY or self.activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY or self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
		local activityIcon = activityTimeRead.getActivityIconByID(self.activityID)
		self:setIcon(activityIcon)
		local leftTime = activityShowCtrl:getRemainTime(self.activityID)
		_leftTime = leftTime
		local curCtrl = warOrderCtrl:getCurCtrl(self.activityID)
		self.wiseTutorIsOpen = curCtrl:isBuffEffect(self.buffBuildType)
	end
	self.fields.Image_time:setVisible(self.wiseTutorIsOpen)
	self.fields.Text_time:setVisible(self.wiseTutorIsOpen)
	if _leftTime and 0 < _leftTime and self.wiseTutorIsOpen then
		self.wiseTutorTimer = SoradCreateTimer(self, handler(self, self.openWiseTutorTime))
		self:openWiseTutorTime()
	end
	self.fields.icon:setGrayed(not self.wiseTutorIsOpen)
end
function Button_wiseTutor:openWiseTutorTime(dt)
	if self.activityID == gActivityTimeActivityID.WISE_TUTOR_ACTIVITY then
		local state, leftTime = wiseTutorCtrl:getStateInfo()
		self.fields.Text_time:setString(SoraDConvertSecondToString(leftTime))
		if leftTime <= 0 or not self.wiseTutorIsOpen then
			self:removeTimer()
		end
	elseif self.activityID == gActivityTimeActivityID.ARTISAN_HOUSE_ACTIVITY then
		local state, leftTime = artisanHouseCtrl:getStateInfo()
		if state == gActivityState.CLOSE or not self.wiseTutorIsOpen then
			self:removeTimer()
		else
			self.fields.Text_time:setString(SoraDConvertSecondToString(leftTime))
		end
	elseif self.activityID == gActivityTimeActivityID.RADIANT_DECREE_ACTIVITY then
		local state, leftTime = radiantDecreeCtrl:getStateInfo()
		if state == gActivityState.CLOSE or not self.wiseTutorIsOpen then
			self:removeTimer()
		else
			self.fields.Text_time:setString(SoraDConvertSecondToString(leftTime))
		end
	else
		local leftTime = activityShowCtrl:getRemainTime(self.activityID) or 0
		self.fields.Text_time:setString(SoraDConvertSecondToString(leftTime))
		if leftTime <= 0 or not self.wiseTutorIsOpen then
			self:removeTimer()
		end
	end
end
function Button_wiseTutor:removeTimer(...)
	SoraDManagerRemoveTimer(self, self.wiseTutorTimer)
	self.wiseTutorTimer = nil
	if self.handle then
		self.handle()
	end
end
function Button_wiseTutor:onClick_btn(...)
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.WISE_TUTOR_ACTIVITY then
		uiManager:show("wiseTutorBuffPop")
	elseif self.activityID == gActivityTimeActivityID.ARTISAN_HOUSE_ACTIVITY then
		local state, _ = artisanHouseCtrl:getStateInfo()
		if state then
			_ENV = "wiseTutorBuffPop"
			;("wiseTutorBuffPop").title = i18n("activity_name_9001399")
			;("wiseTutorBuffPop").goHandle = function()
				uiManager:show("ArtisanHouseMain")
			end
			local ("wiseTutorBuffPop").actltCtrl, param = include("artisanHouseltCtrl"), "wiseTutorBuffPop"
			uiManager:show("ArisanHouseBuffPop", param)
		else
			SoraDShowMsgTip("common_text_2486")
		end
	elseif self.activityID == gActivityTimeActivityID.EXTREMELY_SKILLFUIL then
		uiManager:show("ExtremelySkillfulBuffPop")
	elseif self.activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY or self.activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581 or self.activityID == gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY or self.activityID == gActivityTimeActivityID.PREPARE_FOR_WAR_ACTIVITY or self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001601 or self.activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY or self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
		_ENV = "common_text_2486"
		;("common_text_2486").activityID = self.activityID
		;("common_text_2486").buffBuildType = self.buffBuildType
		uiManager:show("BraqueTestBuffPop", "common_text_2486")
	elseif self.activityID == gActivityTimeActivityID.CRESCENT_ORDER_ACTIVITY then
		_ENV = "common_text_2486"
		;("common_text_2486").buildType = self.buffBuildType
		uiManager:show("Activity_9001710_Buff", "common_text_2486")
	elseif self.activityID == gActivityTimeActivityID.RADIANT_DECREE_ACTIVITY then
		local state, _ = radiantDecreeCtrl:getStateInfo()
		if state then
			_ENV = "Activity_9001710_Buff"
			;("Activity_9001710_Buff").title = i18n("GloriousDecree_29")
			;("Activity_9001710_Buff").goHandle = function()
				uiManager:show("RadiantDecreeMain")
			end
			local ("Activity_9001710_Buff").actltCtrl, param = include("radiantDecreeRead"), "Activity_9001710_Buff"
			uiManager:show("RadiantDecreeBuffPop", param)
		else
			SoraDShowMsgTip("common_text_2486")
		end
	end
end
return Button_wiseTutor
