local activity_9001733_Read = include("activity_9001733_Read")
local activity_9001733_Ctrl = SoraDGetCtrl("activity_9001733_Ctrl")
local VIEW_PANEL_NAME = "Activity_9001733_View"
local baseComponent = require("fgui.base.baseComponent")
local Com_pass = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001733/Com_pass", Com_pass)
function Com_pass:onInit()
	self:fixChildrenPos()
	self.fields.List:setDefaultItem("ui://Activity_9001738/Com_9001738_rewardSingle")
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_oneKey:setTitle(i18n("summoned_btn_01"))
	self.fields.Button_oneKey:addClickListener(handler(self, self.onClick_Button_oneKey))
	self.fields.Button_lock:setTitle(i18n("StarlitNight_text_02"))
	self.fields.Button_lock:addClickListener(handler(self, self.onClick_Button_lock))
	self.fields.Text_passTip:setString(i18n("football_treasure_text_024"))
	self.fields.Text_lv:setString(i18n("common_text_748"))
	self.fields.Text_nor:setString(i18n("cityUp_title_03"))
	self.fields.Text_adv:setString(i18n("StarlitNight_text_07"))
	self.rewardList, _ENV = self.fields.Text_adv.setString, self.fields.Text_adv.setString
	self.curLv = nil
	self.curExp = nil
	self.isClaimingAll = false
end
function Com_pass:onShow()
end
function Com_pass:initData(activityID, updateData)
	self.activityID = activityID or gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY
	local subMsg = updateData and updateData.subMsg or nil
	local classType = activity_9001733_Ctrl:getClassType()
	local curLv = activity_9001733_Ctrl:getBattlePassLv()
	local curExp = activity_9001733_Ctrl:getBattlePassExp()
	local maxLv = activity_9001733_Read.getMaxBattlePassRewardID(classType)
	local expNeed = activity_9001733_Read.getBattlePassExpNeed()
	local isMax = 0 < maxLv and curLv >= maxLv
	local preLv = self.curLv
	local preExp = self.curExp
	_ENV = nil
	;(nil).level = curLv
	;(nil).value = curExp
	;(nil).max = expNeed
	;(nil).isMax = isMax
	;(nil).onAdd = handler(self, self.onClick_Button_add)
	;(nil).animate = subMsg == "flip" and preLv ~= nil and preExp ~= nil
	;(nil).fromLevel = preLv
	;(nil).fromValue = preExp
	self.fields.comLv:initData(nil)
	self.curLv = curLv
	self.curExp = curExp
	if not activity_9001733_Read.getBattlePassCfg(classType) then
		_ENV = activity_9001733_Read.getBattlePassCfg(classType)
	end
	self.rewardList = activity_9001733_Read.getBattlePassCfg(classType)
	self.fields.List:setNumItems(#self.rewardList)
	local canReceiveNum = activity_9001733_Ctrl:getBattlePassCanReceiveNum()
	self.fields.Button_oneKey:setEnabled(0 < canReceiveNum and not self.isClaimingAll)
	self.fields.Button_oneKey:setReddot(0 < canReceiveNum, canReceiveNum)
	local isUnlock = activity_9001733_Ctrl:getIsAdvanceRewardUnlock()
	self.fields.Button_lock:setVisible(not isUnlock)
	self.fields.sheer:setVisible(not isUnlock)
	if subMsg == "claimBattleReward" then
		self:continueClaimAll()
	end
end
function Com_pass:itemRenderer_List(index, obj)
	local data = self.rewardList[index + 1]
	if not data then
		return
	end
	local rewardID = tonumber(data.rewardID) or 0
	local maxRewardID = activity_9001733_Read.getMaxBattlePassRewardID(activity_9001733_Ctrl:getClassType())
	local isMax = 0 < maxRewardID and rewardID > maxRewardID
	_ENV = activity_9001733_Ctrl:getClassType()
	activity_9001733_Ctrl:getClassType().rowIndex = index
	activity_9001733_Ctrl:getClassType().levelText = isMax and rewardID .. "+" or tostring(rewardID)
	activity_9001733_Ctrl:getClassType().normalStatus = activity_9001733_Ctrl:getBattlePassRewardStatus(rewardID, false)
	activity_9001733_Ctrl:getClassType().goldStatus = activity_9001733_Ctrl:getBattlePassRewardStatus(rewardID, true)
	activity_9001733_Ctrl:getClassType().advanceBuffReward = activity_9001733_Read.getBattlePassBuffRewardData(data)
	obj:initData(data, activity_9001733_Ctrl:getClassType())
end
function Com_pass:onClick_Button_oneKey(context)
	SoraDPlaySound()
	if self.isClaimingAll then
		return
	end
	if activity_9001733_Ctrl:getBattlePassCanReceiveNum() <= 0 then
		return
	end
	self.isClaimingAll = true
	self.fields.Button_oneKey:setEnabled(false)
	self:requestNextClaimReward()
end
function Com_pass:requestNextClaimReward()
	if activity_9001733_Ctrl:getBattlePassCanReceiveNum() <= 0 then
		return false
	end
	activity_9001733_Ctrl:reqClaimBattleRewardMsg()
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
function Com_pass:onClick_Button_add(context)
	local proxy = uiManager:getProxy(VIEW_PANEL_NAME)
	local view = proxy and proxy:getPanel()
	if view and view.jumpToGame then
		view:jumpToGame()
	end
end
function Com_pass:onClick_Button_lock(context)
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = gActivityTimeActivityID.FOOTBALL_TREASURE_ACTIVITY
	uiManager:show("CommonBuyGift", nil)
end
return Com_pass
