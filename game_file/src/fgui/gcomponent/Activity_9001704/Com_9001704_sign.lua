local activity_9001704_Ctrl = SoraDGetCtrl("activity_9001704_Ctrl")
local activity_9001704_Read = include("activity_9001704_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001704_sign = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001704/Com_9001704_sign", Com_9001704_sign)
function Com_9001704_sign:onInit()
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001704
	self.itemID, self.itemNum = activity_9001704_Ctrl:getCostItemID()
	self.config = activity_9001704_Read.getConfig_battlepass()
	self.stageConfig = activity_9001704_Read.getConfig_signin_reward()
	local _ENV, stageData = activity_9001704_Read.getConfig_signin_reward(), activity_9001704_Read.getConfig_signin_reward()
	for i, cfg in ipairs(self.stageConfig) do
		_ENV = nil
		;(nil).stage = i
		;(nil).point = cfg.days
		;(nil).rewards = cfg.reward
		table.insert(stageData, nil)
	end
	self.stageData = stageData
	self.fields.Text_title1:setString(i18n("daily_salute_text21"))
	self.fields.Text_title2:setString(i18n("warmongering_text_7"))
	self.fields.Text_title3:setString(i18n("StarlitNight_text_07"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_levelLock:setString(i18n("StarlitNight_text_02"))
	self.fields.Button_levelLock:addClickListener(handler(self, self.onClickLevelLock))
	self.fields.Button_receive:setString(i18n("common_text_3681"))
	self.fields.Button_receive:addClickListener(handler(self, self.onClickReceive))
	_ENV = handler(self, self.onClickReceive)
	handler(self, self.onClickReceive).activityID = self.activityID
	handler(self, self.onClickReceive).stageMax = #self.stageConfig
	handler(self, self.onClickReceive).handler = handler(self, self.onClickBox)
	self.fields.Com_boxList:initData(handler(self, self.onClickReceive))
	self.fields.Com_boxList:setBarColor(3)
	if not SoraDFIsRA() then
		self.fields.bg_title:fix()
		_UPVALUE8_ = self.fields.bg_title
		self.fields.bg_title[1] = self.fields.Text_title1
		self.fields.bg_title[2] = self.fields.Text_title2
		self.fields.bg_title[3] = self.fields.Text_title3
		self.fields.bg_title[4] = self.fields.bg_day
		self.fields.bg_title[5] = self.fields.line1
		self.fields.bg_title[6] = self.fields.line2
		self.fields.bg_title[7] = self.fields.mask
		self.fields.bg_title[8] = self.fields.Button_levelLock
		for __, v in ipairs(self.fields.bg_title) do
			v:fixPos()
		end
	end
end
function Com_9001704_sign:onShow()
	self.fields.Com_have:initData(self.itemID)
	self.fields.Com_have:hideBtnAdd()
	self:updateDaysReward()
	self:updateLock()
end
function Com_9001704_sign:onItemRenderer(index, obj)
	local day = index + 1
	local cfg = self.config[day]
	obj:initData(cfg, day, self.curLv)
end
function Com_9001704_sign:onClickLevelLock(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("CommonBuyGift", nil)
end
function Com_9001704_sign:onClickReceive()
	SoraDPlaySound()
	activity_9001704_Ctrl:reqReward()
end
function Com_9001704_sign:updateBtnReceive()
	local isRed = activity_9001704_Ctrl:getBattlePassRedNum()
	self.fields.Button_receive:setEnabled(isRed)
end
function Com_9001704_sign:updateReceive()
	self.fields.List:setNumItems(#self.config)
	self:updateBtnReceive()
end
function Com_9001704_sign:updateLock()
	local isUnlock = activity_9001704_Ctrl:getIsAdvanceRewardUnlock()
	self.fields.Button_levelLock:setVisible(not isUnlock)
	self.fields.mask:setVisible(not isUnlock)
	self.fields.List:setNumItems(#self.config)
	self:updateBtnReceive()
end
function Com_9001704_sign:updateBuyGift()
	self.fields.Button_levelLock:showUnlockEffect(function()
		self:updateLock()
	end)
end
function Com_9001704_sign:onClickBox(data)
	if data.state == gBtnTargetStatusDef.GET then
		activity_9001704_Ctrl:reqDaysReward(data.point)
	else
		_ENV = nil
		;(nil).activityID = self.activityID
		;(nil).rewards = data.rewards
		_ENV = nil
		;(nil).num = data.point
		;(nil).tipStr = i18n("sky_island_text14", nil)
		_ENV = nil
		;(nil).num = self.curLv
		;(nil).pointStr = i18n("sky_island_text15", nil)
		;(nil).state = data.state
		uiManager:show("CommonStageReward", nil)
	end
end
function Com_9001704_sign:updateDaysReward()
	self.curLv = activity_9001704_Ctrl:getCurLv()
	for stage, v in ipairs(self.stageData) do
		v.state = activity_9001704_Ctrl:getBoxState(stage)
	end
	activity_9001704_Ctrl = ipairs(self.stageData)
	ipairs(self.stageData).stageData = self.stageData
	ipairs(self.stageData).score = self.curLv
	self.fields.Com_boxList:updateData(ipairs(self.stageData))
end
return Com_9001704_sign
