local activity_9001746_Read = include("activity_9001746_Read")
local activity_9001746_Ctrl = SoraDGetCtrl("activity_9001746_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_pass = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001746/Com_pass", Com_pass)
function Com_pass:onInit()
	self:fixChildrenPos()
	self.fields.List:setDefaultItem("ui://Activity_9001746/Com_9001746_rewardSingle")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_oneKey:setTitle(i18n("summoned_btn_01"))
	self.fields.Button_oneKey:addClickListener(handler(self, self.onClick_Button_oneKey))
	self.fields.Button_lock:setTitle(i18n("StarlitNight_text_02"))
	self.fields.Button_lock:addClickListener(handler(self, self.onClick_Button_lock))
	self.fields.Text_lv:setString(i18n("daily_salute_text21"))
	self.fields.Text_nor:setString(i18n("cityUp_title_03"))
	self.fields.Text_adv:setString(i18n("StarlitNight_text_07"))
	self.fields.Button_lock:getChild("Usm_1"):clearEffect()
	self.rewardList, _ENV = self.fields.Button_lock:getChild("Usm_1").clearEffect, self.fields.Button_lock:getChild("Usm_1").clearEffect
	self.isClaimingAll = false
	self.fields.Text_passTip:setVisible(false)
end
function Com_pass:onShow()
end
function Com_pass:initData(activityID, updateData)
	self.activityID = activityID or gActivityTimeActivityID.UNDERWATER_TREASURE_ACTIVITY
	local subMsg = updateData and updateData.subMsg or nil
	local classType = activity_9001746_Ctrl:getClassType()
	local loginDays = activity_9001746_Ctrl:getLoginDays()
	local maxLv = activity_9001746_Read.getMaxBattlePassRewardID(classType)
	local isMax = 0 < maxLv and loginDays >= maxLv
	self.fields.comLv:setVisible(false)
	if not activity_9001746_Read.getBattlePassCfg(classType) then
		_ENV = activity_9001746_Read.getBattlePassCfg(classType)
	end
	self.rewardList = activity_9001746_Read.getBattlePassCfg(classType)
	self.fields.List:setNumItems(#self.rewardList)
	local canReceiveNum = activity_9001746_Ctrl:getBattlePassCanReceiveNum()
	self.fields.Button_oneKey:setEnabled(0 < canReceiveNum and not self.isClaimingAll)
	self.fields.Button_oneKey:setReddot(0 < canReceiveNum, canReceiveNum)
	local isUnlock = activity_9001746_Ctrl:getIsAdvanceRewardUnlock()
	self.fields.Button_lock:setVisible(not isUnlock)
	self.fields.sheer:setVisible(not isUnlock)
	if subMsg == "claimBattleReward" then
		self:continueClaimAll()
	end
	self.fields.Button_lock:getChild("Usm_1"):clearEffect()
end
function Com_pass:itemRenderer_List(index, obj)
	local data = self.rewardList[index + 1]
	if not data then
		return
	end
	local rewardID = tonumber(data.rewardID) or 0
	local maxRewardID = activity_9001746_Read.getMaxBattlePassRewardID(activity_9001746_Ctrl:getClassType())
	local isMax = 0 < maxRewardID and rewardID > maxRewardID
	_ENV = activity_9001746_Ctrl:getClassType()
	activity_9001746_Ctrl:getClassType().rowIndex = index
	activity_9001746_Ctrl:getClassType().levelText = isMax and rewardID .. "+" or tostring(rewardID)
	activity_9001746_Ctrl:getClassType().normalStatus = activity_9001746_Ctrl:getBattlePassRewardStatus(rewardID, false)
	activity_9001746_Ctrl:getClassType().goldStatus = activity_9001746_Ctrl:getBattlePassRewardStatus(rewardID, true)
	activity_9001746_Ctrl:getClassType().noAdvanceReward = not data.advanceReward or #data.advanceReward == 0
	obj:initData(data, activity_9001746_Ctrl:getClassType())
end
function Com_pass:onClick_Button_oneKey(context)
	SoraDPlaySound()
	if self.isClaimingAll then
		return
	end
	if activity_9001746_Ctrl:getBattlePassCanReceiveNum() <= 0 then
		return
	end
	self.isClaimingAll = true
	self.fields.Button_oneKey:setEnabled(false)
	self:requestNextClaimReward()
end
function Com_pass:requestNextClaimReward()
	if activity_9001746_Ctrl:getBattlePassCanReceiveNum() <= 0 then
		return false
	end
	activity_9001746_Ctrl:reqClaimBattleRewardMsg()
	return true
end
function Com_pass:continueClaimAll()
	if not self.isClaimingAll then
		return
	end
	if self:requestNextClaimReward() then
		return
	end
	self.isClaimingAll = false
end
function Com_pass:onClick_Button_lock(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = gActivityTimeActivityID.UNDERWATER_TREASURE_ACTIVITY
	uiManager:show("CommonBuyGift", nil)
end
return Com_pass
