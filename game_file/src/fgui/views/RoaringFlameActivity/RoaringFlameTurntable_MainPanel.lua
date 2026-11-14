local roaringFlameWarRead = include("roaringFlameWarRead")
local activityCommonDrawCtrl = SoraDGetCtrl("activityCommonDrawCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameTurntable_MainPanel = class("RoaringFlameTurntable_MainPanel", baseFguiPanel)
function RoaringFlameTurntable_MainPanel:ctor(...)
	self.isLRU = true
	RoaringFlameTurntable_MainPanel.super.ctor(self, ...)
	print("RoaringFlameTurntable_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.ROARING_FLAME_WAR_ACTIVITY
	self.itemID = activityCommonDrawCtrl:getItemID(self.activityID)
	self.itemCost = activityCommonDrawCtrl:getItemCost(self.activityID)
	self.rewards = roaringFlameWarRead.getTurntableAward()
end
function RoaringFlameTurntable_MainPanel:onInit()
	print("=======RoaringFlameTurntable_MainPanel:onInit")
	self.fields.Com_title:initData(i18n("flames_dunes_text130"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_reward:setTitle(i18n("decrypt_text_03"))
	self.fields.Button_reward:addClickListener(handler(self, self.onClickReward))
	self.fields.Com_have:initData(self.itemID, handler(self, self.onClickAdd))
	_ENV = handler(self, self.onClickAdd)
	handler(self, self.onClickAdd).num = 1
	self.fields.Button_costOne:setTitle(i18n("magic_flip_5", handler(self, self.onClickAdd)))
	self.fields.Button_costOne:addClickListener(handler(self, self.onClickRun))
	_ENV = handler(self, self.onClickRun)
	handler(self, self.onClickRun).num = 10
	self.fields.Button_costTen:setTitle(i18n("magic_flip_5", handler(self, self.onClickRun)))
	self.fields.Button_costTen:addClickListener(handler(self, self.onClickRunTen))
end
function RoaringFlameTurntable_MainPanel:endShow()
	print("=======RoaringFlameTurntable_MainPanel:endShow")
	self.rotation = 0
	self:initView()
	_ENV = nil
	;(nil).byUID = true
	self.isIgnore = SoraDConfigGet("Game:RoaringFlame_notice:zp~bool", nil) or false
	self.fields.Com_skip_notice:initData(self.isIgnore, i18n("common_text_2273"), handler(self, self.onClickNotice))
	_ENV = self.isIgnore
	self.isIgnore.byUID = true
	self.isSkip = SoraDConfigGet("Game:RoaringFlame_ani:zp~bool", self.isIgnore) or false
	self.fields.Com_skip_ani:initData(self.isSkip, i18n("weapon_creating_10"), handler(self, self.onClickSkipAni))
end
function RoaringFlameTurntable_MainPanel:onClickNotice(ret)
	self.isIgnore = ret
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:RoaringFlame_notice:zp~bool", self.isIgnore, nil)
	_ENV = "Game:RoaringFlame_notice:zp~bool"
	;("Game:RoaringFlame_notice:zp~bool").msg = "MESSAGE_ROARINGFLAMEWAR_ACTIVITY_RED"
	SoraDSendMessage("Game:RoaringFlame_notice:zp~bool")
end
function RoaringFlameTurntable_MainPanel:onClickSkipAni(ret)
	self.isSkip = ret
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:RoaringFlame_ani:zp~bool", self.isSkip, nil)
end
function RoaringFlameTurntable_MainPanel:runDrawOnce()
	self.rotation = (self.position[self.bTimes] - 1) * 30 + math.random(-10, 10)
	local targetRotation = self.rotation + 720
	self.fields.Usm_xz:setVisible(true)
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(0.2)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.Usm_xz:play()
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.Usm_xz:play()
	end)
	self.fields.Usm_xz:runAction(ffa.seq(nil))
	self.fields.Com_zhp:playAni(targetRotation, function()
		self.fields.Usm_xz:setVisible(false)
		self.fields.Com_zhp:setRotation(self.rotation)
		local self, reward = self.fields.Com_zhp.setRotation, self.fields.Com_zhp.setRotation
		local targetReward = self.rewards[self.position[self.bTimes]]
		self = nil
		;(nil).id = targetReward.itemid
		;(nil).count = targetReward.count
		table.insert(reward, nil)
		SoraDMailGainItems(reward, true)
		if self.bTimes < #self.position then
			self.bTimes = self.bTimes + 1
			self:runDrawOnce()
		else
			SoraDCloseLoading(self)
			if #self.position > 1 then
				self = targetReward.count
				targetReward.count.rewards = self.gRewards
				uiManager:show("CommonCongratulations", targetReward.count)
			end
		end
	end)
end
function RoaringFlameTurntable_MainPanel:initView(target, data)
	if data and data.key == "lottery" then
		if self.isSkip then
			SoraDCloseLoading(self)
			local rewards = data.rspdata.rewards
			if rewards and next(rewards) then
				_ENV = nil
				;(nil).rewards = rewards
				uiManager:show("CommonCongratulations", nil)
			end
		else
			self.position = data.rspdata.position
			self.gRewards = data.rspdata.rewards
			dump(self.position, "self.position=====")
			dump(self.gRewards, "self.gRewards=====")
			self.bTimes = 1
			self:runDrawOnce()
		end
	end
	self:initRewardCol()
	self.fields.Com_listBox:initData()
	self.fields.Com_have:updateNum()
	self.fields.Button_costOne:setCost(self.itemID, self.itemCost)
	self.fields.Button_costOne:setIsEnough(backpackCtrl:getItemCount(self.itemID) >= self.itemCost)
	self.fields.Button_costTen:setCost(self.itemID, self.itemCost * 10)
	self.fields.Button_costTen:setIsEnough(backpackCtrl:getItemCount(self.itemID) >= self.itemCost * 10)
end
function RoaringFlameTurntable_MainPanel:onClickAdd()
	SoraDPlaySound()
	uiManager:show("RoaringFlame_MileStone")
end
function RoaringFlameTurntable_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("flames_dunes_second_rule19")
	;(nil).content = i18n("flames_dunes_second_rule20")
	uiManager:show("RuleView", nil)
end
function RoaringFlameTurntable_MainPanel:onClickReward()
	SoraDPlaySound()
	_ENV = nil
	;(nil).data = self.rewards
	uiManager:show("CommonPopBox", nil)
end
function RoaringFlameTurntable_MainPanel:onClickRun()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.itemID) >= self.itemCost then
		activityCommonDrawCtrl:reqDrawOne(self.activityID)
		SoraDShowLoading(self, nil, nil, true)
	else
		_ENV = nil
		;(nil).item = publicRead.getName(self.itemID)
		SoraDShowMsgTip(i18n("common_text_1806", nil))
	end
end
function RoaringFlameTurntable_MainPanel:onClickRunTen()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.itemID) >= self.itemCost * 10 then
		activityCommonDrawCtrl:reqDrawOne(self.activityID, 10)
		SoraDShowLoading(self, nil, nil, true)
	else
		_ENV = nil
		;(nil).item = publicRead.getName(self.itemID)
		SoraDShowMsgTip(i18n("common_text_1806", nil))
	end
end
function RoaringFlameTurntable_MainPanel:initRewardCol(...)
	local obj = self.fields.Com_rewardCol
	local i, getFlag
	for i = 1, 12 do
		local Com_itemSingle = obj:getChildAt(i - 1)
		self:initItemSingle(Com_itemSingle, self.rewards[i])
	end
end
function RoaringFlameTurntable_MainPanel:initItemSingle(obj, data)
	local _fields = fguiHelper.get_fields(obj)
	_fields.Com_item:initData(data.itemid)
	_fields.Icon_rare:setVisible(data.rare == 1)
	if data.rare == 1 then
		local rare = obj:getTransition("rare")
		rare:play(-1, 0, 0, -1)
	end
end
function RoaringFlameTurntable_MainPanel:showUsm(index)
	local obj = self.fields.Com_rewardCol
	local Com_itemSingle = obj:getChildAt(index - 1)
	local Usm_get = Com_itemSingle:getChild("Usm_get")
	Usm_get:setVisible(true)
end
return RoaringFlameTurntable_MainPanel
