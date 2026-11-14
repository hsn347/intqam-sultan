local activity_9001738_Read = include("activity_9001738_Read")
local activity_9001738_Ctrl = SoraDGetCtrl("activity_9001738_Ctrl")
local activity_9001736_Read = include("activity_9001736_Read")
local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_pass = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001738/Com_pass", Com_pass)
function Com_pass:onInit()
	self:fixChildrenPos()
	self.fields.List:setDefaultItem("ui://Activity_9001738/Com_9001738_rewardSingle")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_oneKey:setTitle(i18n("summoned_btn_01"))
	self.fields.Button_oneKey:addClickListener(handler(self, self.onClick_Button_oneKey))
	self.fields.Button_lock:setTitle(i18n("StarlitNight_text_02"))
	self.fields.Button_lock:addClickListener(handler(self, self.onClick_Button_lock))
	self.fields.Text_day:setString(i18n("daily_salute_text21"))
	self.fields.Text_nor:setString(i18n("cityUp_title_03"))
	self.fields.Text_adv:setString(i18n("StarlitNight_text_07"))
	self.fields.floor:fix()
	self.fields.sheer:fixPos()
	self.fields.line1:fixPos()
	self.fields.line2:fixPos()
	self.fields.line3:fixPos()
	self.fields.line4:fixPos()
	self.fields.Text_day:fixPos()
	self.fields.Text_nor:fixPos()
	self.fields.Text_adv:fixPos()
	self.fields.Button_lock:fixPos()
end
function Com_pass:onShow()
end
function Com_pass:itemRenderer_List(index, obj)
	local data = self.rewards[index + 1]
	local rewardID = data.rewardID
	_UPVALUE0_ = nil
	;(nil).rowIndex = index
	;(nil).normalStatus = self:getSignLvStatus(rewardID, false)
	;(nil).goldStatus = self:getSignLvStatus(rewardID, true)
	obj:initData(data, nil)
end
function Com_pass:onClick_Button_oneKey(context)
	SoraDPlaySound()
	if not self.canReceive then
		SoraDShowMsgTip(i18n("Stellar_Odyssey_text_03"))
		return
	end
	self:reqSignMsg()
end
function Com_pass:onClick_Button_lock(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID or gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY
	uiManager:show("CommonBuyGift", nil)
end
function Com_pass:initData(activityID)
	_ENV, self.activityID = activityID or gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY, activityID or gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY
	;(activityID or gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY)[gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY] = "activity_bg_9001738_banner.png"
	local (activityID or gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001736], config = "activity_bg_9001736_banner.png", activityID or gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY
	local bannerName = config[self.activityID]
	if bannerName then
		self.fields.pbg:setURL(bannerName)
	end
	_ENV = self.fields.pbg.setURL
	self.fields.pbg.setURL[gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY] = i18n("Ramadan_treasure_hunt_text_02")
	local self.fields.pbg.setURL[gActivityTimeActivityID.NORMAL_ACTIVITY_9001736], config = i18n("football_match_text_068"), self.fields.pbg.setURL
	local passTip = config[self.activityID]
	if passTip then
		self.fields.Text_passTip:setString(passTip)
	end
	self.activityDay = self:getBattlePassOpenDay()
	if not self:getBattlePassCfg() then
		_ENV = self:getBattlePassCfg()
	end
	self.rewards = self:getBattlePassCfg()
	self.fields.List:setNumItems(#self.rewards)
	self.fields.List:scrollToView(self.activityDay - 1)
	local canReceive = self:getBattlePassCanReceive()
	self.canReceive = canReceive
	self.fields.Button_oneKey:setGrayed(not canReceive)
	self.fields.Button_oneKey:setReddot(canReceive)
	local isUnlock = self:getIsAdvanceRewardUnlock()
	self.fields.Button_lock:setVisible(not isUnlock)
	self.fields.sheer:setVisible(not isUnlock)
end
function Com_pass:getBattlePassOpenDay()
	if self.activityID == gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY then
		return activity_9001738_Ctrl:getBattlePassOpenDay()
	elseif self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001736 then
		return activity_9001736_Ctrl:getBattlePassOpenDay()
	end
	return 0
end
function Com_pass:getBattlePassCfg()
	if self.activityID == gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY then
		return activity_9001738_Read.getBattlePassCfg(activity_9001738_Ctrl:getClassType())
	elseif self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001736 then
		return activity_9001736_Read.getBattlePassCfg()
	end
	_ENV = activity_9001736_Read.getBattlePassCfg
	return activity_9001736_Read.getBattlePassCfg
end
function Com_pass:getBattlePassCanReceive()
	if self.activityID == gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY then
		return activity_9001738_Ctrl:getBattlePassCanReceive()
	elseif self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001736 then
		return activity_9001736_Ctrl:getBattlePassRedPointAndNum()
	end
	return false
end
function Com_pass:getIsAdvanceRewardUnlock()
	if self.activityID == gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY then
		return activity_9001738_Ctrl:getIsAdvanceRewardUnlock()
	elseif self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001736 then
		return activity_9001736_Ctrl:getIsAdvanceRewardUnlock()
	end
	return false
end
function Com_pass:reqSignMsg()
	if self.activityID == gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY then
		activity_9001738_Ctrl:reqSignMsg()
	elseif self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001736 then
		activity_9001736_Ctrl:reqSign()
	end
end
function Com_pass:getSignLvStatus(rewardID, isAdv)
	if self.activityID == gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY then
		return activity_9001738_Ctrl:getSignLvStatus(rewardID, isAdv)
	elseif self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001736 then
		return activity_9001736_Ctrl:getSignLvStatus(rewardID, isAdv)
	end
	return gBtnTargetStatusDef.NONE
end
return Com_pass
