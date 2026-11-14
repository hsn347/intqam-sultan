local activity_9001654_Read = include("activity_9001654_Read")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001654_Ctrl = gametop.playertop_:getModule("activity_9001654_Ctrl")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local dailyRemindManager = include("dailyRemindManager")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001654_MainPanel = class("Activity_9001654_MainPanel", baseFguiPanel)
function Activity_9001654_MainPanel:ctor(...)
	Activity_9001654_MainPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001654_MainPanel:ctor", self.viewName)
end
function Activity_9001654_MainPanel:onInit()
	print("=======Activity_9001654_MainPanel:onInit")
	self:fixNodePos()
	self.enter = true
	self:setAniFrameConfig()
	self.itemID = constantRead.getConstValue("FLOWER_BLOOM_REQ_ITEM", 870201)
	self.totalLucky = constantRead.getConstValue("FLOWER_BLOOM_STARLIGHT_LIMIT", 1000)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001654
	self.stageData = activity_9001654_Read.getExtraConfig()
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_getAll:setString(i18n("universe_text_04"))
	self.fields.Button_reward:setTitle(i18n("decrypt_text_03"))
	self.fields.Button_reward:addClickListener(handler(self, self.onClickReward))
	self.boxfields = fguiHelper.get_fields(self.fields.Com_listBox)
	self.fields.Button_cost:setTitle(i18n("common_text_246"))
	self.fields.Button_cost:addClickListener(handler(self, self.onClickRun))
	self.boxfields.List_cumuReward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_luck:addClickListener(handler(self, self.onClickLuckDetail))
	self.fields.Com_have:initData(self.itemID)
	self.stageRewardFlag = activity_9001654_Read.hadStageReward()
	self.hadLuckRewardFlag = activity_9001654_Read.hadLuckReward()
	self.boxfields.List_cumuReward:setVisible(self.stageRewardFlag)
	self.boxfields.process_highLight:setVisible(self.stageRewardFlag)
	fguiHelper.get_fields(self.boxfields.process_highLight).title:setVisible(false)
	self.fields.Button_luck:setVisible(self.hadLuckRewardFlag)
	self.boxfields.List_cumuReward:setItemRenderer(handler(self, self.onItemRendererStage))
	self.enterUsmComplete = true
	self:initData()
end
function Activity_9001654_MainPanel:fixNodePos()
	self.fields.Com_listBox:fixChildrenPos()
	self.fields.Button_reward:fixPos()
	self.fields.Button_luck:fixPos()
end
function Activity_9001654_MainPanel:enterUsmReady()
end
function Activity_9001654_MainPanel:playEnterAction()
	local origX = self.fields.Com_rewardCol:getPositionX()
	local origY = self.fields.Com_rewardCol:getPositionY()
	_UPVALUE2_ = nil
	;(nil)[1] = origX
	;(nil)[2] = origY + 193
	self.transitions.itemScale:setValue("point1", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = origX
	;(nil)[2] = origY + 193
	self.transitions.itemScale:setValue("point2", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = origX - 2
	;(nil)[2] = origY
	self.transitions.itemScale:setValue("point3", nil)
	self.transitions.itemScale:setHook("actionEnd", function()
		self.enterUsmComplete = true
	end)
	self.transitions.itemScale:play()
end
function Activity_9001654_MainPanel:initData(data)
	if data and data.subMsg == "extract" and data.reward then
		self:tryOnceSuccess(data.reward, data.subMsg)
	end
	if data and data.subMsg == "stageReward" and data.reward then
		activity_9001654_Ctrl = data.reward
		data.reward.rewards = data.reward
		self:getReward(data.reward)
	end
	if self.enter then
		self.fields.Com_rewardCol:initData()
	end
	self.fields.Com_have:updateNum()
	self.getAllFlag = activity_9001654_Ctrl:getTreasureNum() >= activity_9001654_Read.getConfigNum(activity_9001654_Ctrl:getGroup())
	if self.getAllFlag then
		self.fields.Text_getAll:setVisible(true)
		self.fields.Button_cost:setVisible(false)
	else
		local nth = activity_9001654_Ctrl:getTreasureNum() + 1
		self.fields.Button_cost:setCost(self.itemID, activity_9001654_Read.getCost(nth))
	end
	if self.hadLuckRewardFlag and self.enter then
		self:updateLuckFill()
	end
	if self.stageRewardFlag then
		self.boxfields.List_cumuReward:setNumItems(table.nums(self.stageData))
		local per = activity_9001654_Read:getStagePercent(activity_9001654_Ctrl:getTreasureNum())
		self.boxfields.process_highLight:setValue(per * 100)
	end
	self.enter = false
end
function Activity_9001654_MainPanel:updateLuckFill()
	_ENV = activity_9001654_Ctrl
	activity_9001654_Ctrl.color = "#E02B2B"
	local countStr = SoraDWrapHtmlTagByStyle(activity_9001654_Ctrl:getLuckyPoint(), activity_9001654_Ctrl)
	_ENV = "/%s"
	;("/%s").color = "#F0E6D2"
	local totalStr = SoraDWrapHtmlTagByStyle(string.format("/%s", self.totalLucky), "/%s")
	local value = string.format([[

%s%s]], countStr, totalStr)
	_ENV = nil
	;(nil).var = value
	self.fields.Button_luck:setTitle(i18n_html("herovault_text_08", nil))
	local luckPercent = activity_9001654_Read:getLuckyPercent(activity_9001654_Ctrl:getLuckyPoint())
end
function Activity_9001654_MainPanel:setAniFrameConfig()
end
function Activity_9001654_MainPanel:setToLocal()
	activity_9001654_Ctrl:sendInitMsg()
end
function Activity_9001654_MainPanel:requestInitData()
	activity_9001654_Ctrl:sendInitMsg()
end
function Activity_9001654_MainPanel:onItemRendererStage(index, object)
	local data = self.stageData[index + 1]
	local times = activity_9001654_Ctrl:curTimesTries()
	local stageReward = activity_9001654_Ctrl:getExtraReward()
	local state = 1
	if stageReward[tostring(index + 1)] then
		state = 3
	elseif times >= data.lotteryTime then
		state = 1
	else
		state = 2
	end
	object:initData(index + 1, data.lotteryTime, state, handler(self, self.onClickExtraReward))
end
function Activity_9001654_MainPanel:onClickExtraReward(index)
	SoraDPlaySound()
	local data = self.stageData[index]
	local times = activity_9001654_Ctrl:curTimesTries()
	local stageReward = activity_9001654_Ctrl:getExtraReward()
	local state = 1
	if stageReward[tostring(index)] then
		state = 3
	elseif times >= data.lotteryTime then
		state = 1
	else
		state = 2
	end
	if state == 1 then
		activity_9001654_Ctrl:sendGetStageMsg(data.Index)
	else
		local _ENV, btnTitle = "common_text_1892", state == 2 and i18n("common_text_204") or i18n("common_text_1892")
		;("common_text_1892").data = data.extraReward
		local ("common_text_1892").controller, param = state == 3 and 1 or 0, "common_text_1892"
		uiManager:show("CommonPopBox2", param):setOwnerKey(self)
	end
end
function Activity_9001654_MainPanel:showUsm()
	self.fields.Com_usm:showUsm(3)
	local pos = activity_9001654_Ctrl:getPointTo()
	_UPVALUE1_ = nil
	;(nil)[1] = 1440 + (pos - 1) * 30
	self.transitions.anchorRotate:setValue("angle", nil)
	self.transitions.anchorRotate:play(function()
		self.fields.Com_rewardCol:showUsm(pos)
		self:updateLuckFill()
	end)
end
function Activity_9001654_MainPanel:getReward(data)
	if not data.rewards and not self.rewards then
		local _ENV, rewards = self.rewards, self.rewards
	end
	local _ENV, t
	for i, v in pairs(rewards) do
		if v.id then
			table.insert(t, v)
		end
	end
	SoraDMailGainItems(t, true)
	self.tryEffectComplete = true
end
function Activity_9001654_MainPanel:tryOnceSuccess(rewards, msg)
	self:showUsm()
	self.rewards = rewards
end
function Activity_9001654_MainPanel:onItemRenderer(index, object)
	object:initData(index + 1, activity_9001654_Read.getStageRewardByIndex(index + 1))
end
function Activity_9001654_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("flowers_bloom_text1")
	;(nil).contentColor = cc.c3b(255, 235, 185)
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function Activity_9001654_MainPanel:onClickLuckDetail()
	SoraDPlaySound()
	if activity_9001654_Read.hadLuckGearReward() then
		uiManager:show("Activity_9001654_Luck"):setOwnerKey(self)
	else
		_ENV = nil
		;(nil).title = i18n("Mermaid_title_06")
		;(nil).content = i18n("flowers_bloom_text2")
		;(nil).contentColor = cc.c3b(255, 235, 185)
		uiManager:show("RuleView", nil):setOwnerKey(self)
	end
end
function Activity_9001654_MainPanel:onClickRun()
	SoraDPlaySound()
	local nth = activity_9001654_Ctrl:getTreasureNum() + 1
	if backpackCtrl:getItemCount(self.itemID) >= activity_9001654_Read.getCost(nth) then
		self.tryEffectComplete = false
		self:requestTryOnce()
	else
		_ENV = nil
		;(nil).itemID = self.itemID
		uiManager:show("CommonSourceGuide", nil)
	end
end
function Activity_9001654_MainPanel:requestTryOnce()
	activity_9001654_Ctrl:sendExtractMsg()
end
function Activity_9001654_MainPanel:onClickReward()
	SoraDPlaySound()
	local group = activity_9001654_Ctrl:getGroup()
	local rewards = activity_9001654_Ctrl:setRewardGetFlag(activity_9001654_Read.getAward(group))
	_ENV = activity_9001654_Ctrl
	activity_9001654_Ctrl.title = i18n("hero_title_02")
	local activity_9001654_Ctrl.data, param = rewards, activity_9001654_Ctrl
	uiManager:show("CommonPopBox", param):setOwnerKey(self)
end
function Activity_9001654_MainPanel:resizeNoStageReward()
	local offset = self.fields.Button_cost:getPositionY() - (display.height - self.fields.Button_cost:getHeight())
	if -20 < offset then
		self.fields.Com_ownNum:setPositionY(self.fields.Com_ownNum:getPositionY() - 15)
	end
end
function Activity_9001654_MainPanel:resizeForRoom(stageRewardFlag)
end
function Activity_9001654_MainPanel:onShow()
	print("=======Activity_9001654_MainPanel:onShow")
end
function Activity_9001654_MainPanel:onHide()
	print("=======Activity_9001654_MainPanel:onHide")
end
function Activity_9001654_MainPanel:onDispose()
	print("=======Activity_9001654_MainPanel:onDispose")
end
return Activity_9001654_MainPanel
