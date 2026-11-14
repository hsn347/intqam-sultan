local activity_9001616_Ctrl = SoraDGetCtrl("activity_9001616_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemDesRead = include("itemDesRead")
local activity_9001616_Read = include("activity_9001616_Read")
local activityTimeRead = include("activityTimeRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_Activity_9001616 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001616/Com_Activity_9001616", Com_Activity_9001616)
function Com_Activity_9001616:onInit()
	self.activityID = gActivityTimeActivityID.GHOLD_EMERGENCE_ACTIVITY
	self.jumpActivityID = gActivityTimeActivityID.HONOR_BACK_LOTTERY
	self.itemID = activity_9001616_Ctrl:getItemID()
	self.itemCost = activity_9001616_Ctrl:getItemCost()
	self.buffConfig = activity_9001616_Read.getBuffConfig()
	self.buffPointList = activity_9001616_Read.getBuffPointList()
	self.buffIndex = 0
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.fields.Button_help:addClickListener(handler(self, self.onClickBtnHelp))
	self.fields.List_buff:setItemRenderer(handler(self, self.onBuffItemRenderer))
	self.fields.List_buff:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickBuffItem))
	self.fields.Text_tip:setString(i18n("sunmmon_ghoul_text1"))
	local cfg = activityTimeRead.getNormalEventConfig(self.jumpActivityID)
	self.fields.Button_activity:setString(cfg.name)
	self.fields.Button_activity:setIcon(cfg.icon)
	self.fields.Button_activity:fitIconSize()
	self.fields.Button_activity:addClickListener(handler(self, self.onClickBtnActivity))
	self.fields.Text_reward:setString(i18n("common_text_488"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.Image_item:setURL(itemDesRead.getIcon(self.itemID))
	self.fields.Button_call:setString(i18n("common_text_2341"))
	self.fields.Button_call:addClickListener(handler(self, self.onClickBtnCall))
	self.fields.Button_record:setString(i18n("common_text_829"))
	self.fields.Button_record:addClickListener(handler(self, self.onClickBtnRecord))
	if not SoraDFIsRA() then
		self.fields.Button_help:fixPos()
		self.fields.bar:fixPos()
		self.fields.bar:getChild("bar"):fixPos()
		self.fields.List_buff:fixPos()
		self.fields.Com_item:fixPos()
	end
end
function Com_Activity_9001616:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001616_UPDATE", handler(self, self.onMsgUpdateData))
end
function Com_Activity_9001616:onShow()
	self.rewardIDList = worldMapDefine.getWorldBossReward(gBossType.gholdEmergenceBoss, 1)
	self.fields.List_reward:setNumItems(#self.rewardIDList)
	self:updateItemCount()
	if activity_9001616_Ctrl:getIsDataInit() then
		self:updateCallNum()
		self:updateScore()
	else
		SoraDShowLoading(self)
		activity_9001616_Ctrl:reqAllinceData()
	end
	self.fields.List_buff:setNumItems(#self.buffConfig)
end
function Com_Activity_9001616:onClickBtnHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("sunmmon_ghoul_text17")
	uiManager:show("RuleView", nil)
end
function Com_Activity_9001616:onClickBtnActivity()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_ACTIVITY_9001608_JUMP_ACTIVITY"
	;(nil).activityID = self.jumpActivityID
	SoraDSendMessage(nil)
end
function Com_Activity_9001616:onBuffItemRenderer(index, obj)
	local _fields = obj._fields
	if not _fields then
		obj._fields = fguiHelper.get_fields(obj)
		_fields = obj._fields
	end
	local buffIndex = index + 1
	local point = activity_9001616_Read.getBuffPoint(buffIndex)
	obj:setString(string.formatnumberthousands(point))
	local buffIcon = activity_9001616_Read.getBuffIcon(buffIndex)
	if buffIcon then
		obj:setIcon(buffIcon)
	end
	local c_state = obj:getController("c_state")
	if self.buffIndex == buffIndex then
		c_state:setSelectedIndex(1)
	else
		c_state:setSelectedIndex(0)
	end
end
function Com_Activity_9001616:onClickBuffItem(EventContext)
	SoraDPlaySound()
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List_buff:getChildIndex(obj)
	_ENV = nil
	;(nil).buffIndex = childIndex + 1
	uiManager:show("Activity_9001616_Buff", nil)
end
function Com_Activity_9001616:onRewardItemRenderer(index, obj)
	local rewardID = self.rewardIDList[index + 1]
	obj:getChild("Com_item"):initData(rewardID)
	obj:setString(itemDesRead.getName(rewardID))
end
function Com_Activity_9001616:onClickBtnCall()
	local checkCondition = function()
		local allianceMgr = SoraDGetCtrl("allianceMgr")
		if not allianceMgr:hasJoinAlliance() then
			SoraDShowMsgTip(i18n("sunmmon_ghoul_text3"))
			return
		end
		if self.itemCount < self.itemCost then
			SoraDShowMsgTip(i18n("sunmmon_ghoul_text5"))
			return
		end
		return true
	end
	SoraDPlaySound()
	if not checkCondition() then
		return
	end
	local bossType = gBossType.gholdEmergenceBoss
	local bossName = worldMapDefine.getWorldBossName(bossType)
	local removeAfterSec = worldMapDefine.getWorldBossRemoveAfterSec(bossType)
	local time = math.ceil(removeAfterSec / 3600)
	_ENV = nil
	;(nil).boss = i18n(bossName)
	;(nil).time = time
	local showMsg = i18n("sunmmon_ghoul_text19", nil)
	SoraDShowMsgBox(showMsg, i18n("common_text_2341"), i18n("common_text_185"), function(callType)
		if callType == MSGBOX_CALLBACK_YES then
			if not checkCondition() then
				return
			end
			SoraDShowLoading(self)
			activity_9001616_Ctrl:reqSummonBoss()
		end
	end)
end
function Com_Activity_9001616:onClickBtnRecord()
	SoraDPlaySound()
	uiManager:show("Activity_9001616_Record")
end
function Com_Activity_9001616:updateItemCount(...)
	self.itemCount = backpackCtrl:getItemCount(self.itemID)
	local backpackCtrl, style = backpackCtrl:getItemCount(self.itemID), backpackCtrl:getItemCount(self.itemID)
	if self.itemCount < self.itemCost then
		backpackCtrl, backpackCtrl = self.itemCost, self.itemCount
		style, self.itemCount.num1, self.itemCost.color = self.itemCount, self.itemCost, "#ff0000"
	end
	backpackCtrl = nil
	;(nil).num1 = self.itemCount
	;(nil).num2 = self.itemCost
	self.fields.Text_count1:setString(i18n_html("sunmmon_ghoul_text2", nil, style))
end
function Com_Activity_9001616:updateCallNum(...)
	local count = activity_9001616_Ctrl:getInitDataCount()
	self.fields.Text_count2:setString(i18n("sunmmon_ghoul_text6") .. count)
end
function Com_Activity_9001616:updateScore(...)
	local score = activity_9001616_Ctrl:getInitDataScore()
	local percent = SoraDGetStageValue(score, self.buffPointList)
	self.fields.bar:setValue(percent)
	self.fields.Com_item:setString(string.formatnumberthousands(score))
	self.buffIndex = activity_9001616_Read.getBuffIndexByPoint(score)
end
function Com_Activity_9001616:onMsgUpdateData(target, event)
	if event.key == "initData" then
		SoraDCloseLoading(self)
		self:updateCallNum()
		self:updateScore()
		self.fields.List_buff:setNumItems(#self.buffConfig)
	elseif event.key == "itemCount" then
		self:updateItemCount()
	end
end
return Com_Activity_9001616
