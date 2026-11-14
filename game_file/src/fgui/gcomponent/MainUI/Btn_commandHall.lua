local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
local commandHallUtil = include("commandHallUtil")
local baseComponent = require("fgui.base.baseComponent")
local Btn_commandHall = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_commandHall", Btn_commandHall)
function Btn_commandHall:onInit()
	self.activityID = gActivityTimeActivityID.COMMAND_HALL_ACTIVITY
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.icon:setSpriteFrame("img_commandhall_entrance.png")
end
function Btn_commandHall:onShow()
end
function Btn_commandHall:onBtnClick()
	SoraDPlaySound()
	clientEventMgr.singleClickEvent(self.activityID)
end
function Btn_commandHall:initData(data)
	if data and data.activityID then
		self.activityID = data.activityID
		self:updateActivityCommandHall()
	end
end
function Btn_commandHall:setRed(num)
	self.fields.Label_reddot:initData(0 < num, num)
end
function Btn_commandHall:updateActivityCommandHall(...)
	self:updateTextTime()
	self:updateEffect()
end
function Btn_commandHall:updateTextTime(...)
	if not commandHallCtrl:getArmyGroupTaskData() then
		local commandHallCtrl, task = commandHallCtrl:getArmyGroupTaskData(), commandHallCtrl:getArmyGroupTaskData()
	end
	if task.statue and task.statue ~= gCommandHallTaskStatue.FINISH then
		local armyGroupID = task.armyGroupID
		local groupStr = commandHallUtil.getArmyGroupIDStr(armyGroupID)
		commandHallCtrl = nil
		;(nil).num = groupStr
		groupStr = i18n("GS_commandhall_guide_8", nil)
		if not commandHallUtil.checkShowCountDown(armyGroupID) then
			self.Text_Time:setString(groupStr)
			return
		end
		local remainTime = task.moveEndTime - serviceFunctions.systemTime()
		if 0 < remainTime then
			self.Text_Time:setTimeEndListener(function()
				self:updateActivityCommandHall()
			end)
			self.Text_Time:setTimeLast(function(timeStr)
				return groupStr .. "\n" .. timeStr
			end)
			self.Text_Time:beginTime(remainTime)
		else
			do
				local str = groupStr .. "\n" .. i18n("commandhall_text_18")
				self.Text_Time:setString(str)
			end
		end
	else
		self.Text_Time:setString(i18n("commandhall_text_1"))
	end
end
function Btn_commandHall:updateEffect(...)
	if self.Node_tsdt_gth then
		self.Node_tsdt_gth:setVisible(false)
	end
	if self.Node_tsdt_jb then
		self.Node_tsdt_jb:setVisible(false)
	end
	if self.Sprite_tsdt_bx then
		self.Sprite_tsdt_bx:setVisible(false)
	end
	local taskList = commandHallCtrl:getTaskList()
	if #taskList == 0 then
		return
	end
	if commandHallCtrl:getTaskReceiveStatus() then
		if not self.Sprite_tsdt_bx then
			local sprite = display.newSprite("#frame_sdbns_baoxinag.png")
			sprite:addTo(self:displayObject())
			sprite:setPosition(cc.p(58, 58))
			self.Sprite_tsdt_bx = sprite
		end
		self.Sprite_tsdt_bx:setVisible(true)
	else
		local count = commandHallCtrl:getTaskNotFinishCount()
		if 0 < count then
			self:setRed(count)
		end
	end
	if not commandHallCtrl:getArmyGroupTaskData() then
		local commandHallCtrl, task = commandHallCtrl:getArmyGroupTaskData(), commandHallCtrl:getArmyGroupTaskData()
	end
	if next(task) then
		if not task.armyGroupIsMoving then
			if not self.Node_tsdt_jb then
				local effect = SoraDCreatAnimation("Node_GS_tsdt_jb")
				effect:addTo(self:displayObject())
				effect:setPosition(cc.p(35, 35))
				self.Node_tsdt_jb = effect
			end
			self.Node_tsdt_jb:setVisible(true)
		end
	else
		if not self.Node_tsdt_gth then
			local effect = SoraDCreatAnimation("Node_tsdt_gth")
			effect:addTo(self:displayObject())
			effect:setPosition(cc.p(35, 35))
			local Node_1 = effect:getChildByName("Node_1")
			if Node_1 then
				Node_1:setPositionX(-Node_1:getPositionX())
			end
			self.Node_tsdt_gth = effect
		end
		self.Node_tsdt_gth:setVisible(true)
	end
end
return Btn_commandHall
