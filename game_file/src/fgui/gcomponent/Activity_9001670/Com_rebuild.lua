local activity_9001670_Read = include("activity_9001670_Read")
local activity_9001670_Ctrl = SoraDGetCtrl("activity_9001670_Ctrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_rebuild = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001670/Com_rebuild", Com_rebuild)
function Com_rebuild:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001670_UPDATE", handler(self, self.onMsgUpdateData))
end
function Com_rebuild:onInit()
	self.activityID = gActivityTimeActivityID.REBUILD_BUBBLE_LAND
	self.rewardConfig = activity_9001670_Read.getNormalRewardConfig()
	self.fields.Button_rank:setString(i18n("pyramid_btn_29"))
	self.fields.Button_rank:addClickListener(handler(self, self.onClickBtnRank))
	self.fields.Button_task:setString(i18n("common_text_4498"))
	self.fields.Button_task:addClickListener(handler(self, self.onClickBtnTask))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward:setVirtual()
	self.fields.Button_get:setString(i18n("summoned_btn_01"))
	self.fields.Button_get:addClickListener(handler(self, self.onClickBtnGet))
	self.fields.Button_lock1:setString(i18n("StarlitNight_text_02"))
	self.fields.Button_lock1:addClickListener(handler(self, self.onClickBtnLock1))
	self.fields.Button_lock2:setString(i18n("Braque_text_07"))
	self.fields.Button_lock2:addClickListener(handler(self, self.onClickBtnLock2))
	local _fields = fguiHelper.get_fields(self.fields.Com_lv)
	_fields.Button_add:addClickListener(handler(self, self.onClickBtnTask))
	_fields.bar:setTitleType(fgui.ProgressTitleType.VALUE_MAX)
	local _fields = fguiHelper.get_fields(self.fields.Com_rewardTitle)
	_fields.Text_level:setString(i18n("common_text_748"))
	_fields.Text_reward1:setString(i18n("warmongering_text_7"))
	_fields.Text_reward2:setString(i18n("StarlitNight_text_07"))
	_fields.Text_reward3:setString(i18n("Braque_text_05"))
	local _fields = fguiHelper.get_fields(self.fields.Com_giftbox)
	_fields.mv_bx:setAllFrameName("9001670_bx_%02d.png", 1)
	_fields.Image_box:addClickListener(handler(self, self.onClickBtnBox))
	_fields.Text_name:setString(i18n("Bubble_island_rebuild_text_07"))
	_fields.Text_des:setString(i18n("Bubble_island_rebuild_text_09"))
	_fields.bar:setTitleType(fgui.ProgressTitleType.VALUE_MAX)
	_fields.bar:setValue(0)
	local expMax = activity_9001670_Read.getMaxExp()
	_fields.bar:setMax(expMax)
	if not SoraDFIsRA() then
		self.fields.Com_rewardTitle:fixChildrenPos()
		self.fields.Com_mask:fixChildrenPos()
		self.fields.Com_giftbox:fixChildrenPos()
		self.fields.Com_lockMask1:fixPos()
		self.fields.Com_lockMask2:fixPos()
		self.fields.Button_lock1:fixPos()
		self.fields.Button_lock2:fixPos()
	end
end
function Com_rebuild:onShow()
	self.unlock = activity_9001670_Ctrl:getUnlockList()
	self.gotRewardLv = activity_9001670_Ctrl:getRewardLvList()
	self:updateLockMask()
	self:updateExp()
	self:updateBtnGet()
	self:updateRewardList()
	self:updateBtnTask()
	self:updateGiftBoxRedNum()
	self:updateTextTip()
end
function Com_rebuild:onClickBtnRank(...)
	SoraDPlaySound()
	local allianceMgr = SoraDGetCtrl("allianceMgr")
	if not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("Bubble_island_rebuild_text_04"))
		return
	end
	uiManager:show("Activity_9001670_rank")
end
function Com_rebuild:onClickBtnTask(...)
	SoraDPlaySound()
	if not activity_9001670_Ctrl:checkDoStage1() then
		SoraDShowMsgTip(i18n("Bubble_island_rebuild_text_38"))
		return
	end
	uiManager:show("Activity_9001670_Task")
end
function Com_rebuild:onClickBtnGet(...)
	SoraDPlaySound()
	if not self:checkBtnGetState() then
		SoraDShowMsgTip(i18n("eidalfitr_market_text_02"))
		return
	end
	activity_9001670_Ctrl:reqStageReward()
end
function Com_rebuild:onClickBtnLock1()
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).rewardType = 2
	uiManager:show("Activity_9001637_BuyGift", nil)
end
function Com_rebuild:onClickBtnLock2()
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).rewardType = 3
	uiManager:show("Activity_9001637_BuyGift", nil)
end
function Com_rebuild:onClickBtnBox(...)
	SoraDPlaySound()
	local cfg = activity_9001670_Read.getSpecialRewardCfg()
	local rewards = cfg.normalReward
	local itemList = backpackltCtrl:getShowItems(rewards[1] and rewards[1].id) or rewards
	_ENV = nil
	;(nil).title = i18n("Bubble_island_rebuild_text_07")
	;(nil).rewards = itemList
	;(nil).tip = i18n("Bubble_island_rebuild_text_15")
	;(nil).tipAlign = cc.TEXT_ALIGNMENT_CENTER
	uiManager:show("CommonPopBox3", nil)
end
function Com_rebuild:onItemRenderer(index, obj)
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	local level = index + 1
	_fields.Text_level:setString(tostring(level))
	local cfg = self.rewardConfig[level]
	local _ENV, dataList = _fields.Text_level, _fields.Text_level
	local rewards1 = cfg.normalReward
	_ENV = tostring(level)
	tostring(level).rewardType = 1
	tostring(level).reward = rewards1[1]
	table.insert(dataList, tostring(level))
	local rewards2 = cfg.advanceReward
	_ENV = rewards1[1]
	rewards1[1].rewardType = 2
	rewards1[1].reward = rewards2[1]
	table.insert(dataList, rewards1[1])
	_ENV = rewards1[1]
	rewards1[1].rewardType = 2
	rewards1[1].reward = rewards2[2]
	table.insert(dataList, rewards1[1])
	local rewards3 = cfg.seniorReward
	_ENV = rewards2[2]
	rewards2[2].rewardType = 3
	rewards2[2].reward = rewards3[1]
	table.insert(dataList, rewards2[2])
	_ENV = rewards2[2]
	rewards2[2].rewardType = 3
	rewards2[2].reward = rewards3[2]
	table.insert(dataList, rewards2[2])
	for i, data in ipairs(dataList) do
		data.lv = level
		local Com_item = _fields["Com_item" .. i]
		self:updateItemLevel(Com_item, data)
	end
end
function Com_rebuild:updateItemLevel(obj, data)
	local reward = data.reward
	if reward and next(reward) then
		obj:setVisible(true)
		local _fields = fguiHelper.get_fields(obj)
		_fields.Com_item:initData(reward.id, reward.count)
		local c_state = obj:getController("state")
		c_state:setSelectedIndex(self:getItemSingleState(data))
		if not self.isAniItemInit then
			_fields.Ani_item:setAllFrameName("dh_chuanqijunwang_%02d.png", 1)
			self.isAniItemInit = true
		end
	else
		obj:setVisible(false)
	end
end
function Com_rebuild:getItemSingleState(data)
	local rewardType = data.rewardType
	if not self.unlock[rewardType] then
		return 0
	end
	local gotLv = self.gotRewardLv[rewardType] or 0
	local showLv = data.lv
	if gotLv >= showLv then
		return 2
	elseif showLv <= self.curLv then
		return 1
	else
		return 3
	end
end
function Com_rebuild:updateExp(...)
	local _fields = fguiHelper.get_fields(self.fields.Com_lv)
	local exp = activity_9001670_Ctrl:getExp()
	local lv, _exp = activity_9001670_Read.getLvByExp(exp)
	self.curLv = lv
	_fields.Label_lv:setString(tostring(lv))
	_fields.bar:setTitleType(fgui.ProgressTitleType.VALUE_MAX)
	_fields.bar:setValue(_exp)
	local expMax = activity_9001670_Read.getLvExpMax(lv + 1)
	_fields.bar:setMax(expMax)
	local _fields = fguiHelper.get_fields(self.fields.Com_giftbox)
	if self.curLv < activity_9001670_Read.getMaxLv() then
		_fields.Text_des:setString(i18n("Bubble_island_rebuild_text_09"))
		_fields.bar:setValue(0)
	else
		_fields.Text_des:setString(i18n("Bubble_island_rebuild_text_10"))
		_fields.bar:setValue(_exp)
	end
	local totalScore = activity_9001670_Ctrl:getTotalScore()
	local lv = activity_9001670_Read.getAllianceLv(totalScore)
	local usmPath = activity_9001670_Read.getAllianceCastleUsm(lv)
	local Usm_2 = self.fields.Com_bg:getChild("Usm_2")
	Usm_2:setEffectPath(usmPath)
end
function Com_rebuild:checkBtnGetState(...)
	return activity_9001670_Ctrl:getRewardLvRedNum()
end
function Com_rebuild:updateBtnGet(...)
	if self:checkBtnGetState() then
		self.fields.Button_get:setGrayed(false)
	else
		self.fields.Button_get:setGrayed(true)
	end
end
function Com_rebuild:updateLockMask(...)
	if self.unlock[2] then
		self.fields.Com_lockMask1:setVisible(false)
		self.fields.Button_lock1:setVisible(false)
	end
	if self.unlock[3] then
		self.fields.Com_lockMask2:setVisible(false)
		self.fields.Button_lock2:setVisible(false)
	end
end
function Com_rebuild:updateRewardList(...)
	self.fields.List_reward:setNumItems(#self.rewardConfig)
end
function Com_rebuild:updateBtnTask(...)
	local ret, num = activity_9001670_Ctrl:getTaskRedNum()
	self.fields.Button_task:setReddot(ret, num)
end
function Com_rebuild:updateGiftBoxRedNum(...)
	local rewardLv = math.max(#self.rewardConfig, self.gotRewardLv[1])
	local redNum = math.max(0, self.curLv - rewardLv)
	self.fields.Com_giftbox:setReddot(0 < redNum, redNum)
end
function Com_rebuild:onMsgUpdateData(target, event)
	SoraDCloseLoading()
	local subMsg = event.subMsg
	if subMsg == "stageReward" then
		self.gotRewardLv = activity_9001670_Ctrl:getRewardLvList()
		self:updateRewardList()
		self:updateBtnGet()
		self:updateGiftBoxRedNum()
	elseif subMsg == "buyGift" then
		self.unlock = activity_9001670_Ctrl:getUnlockList()
		self:updateLockMask()
		self:updateRewardList()
		self:updateBtnGet()
		self:updateBtnTask()
	elseif subMsg == "questReward" then
		self:updateExp()
		self:updateRewardList()
		self:updateBtnGet()
		self:updateBtnTask()
		self:updateGiftBoxRedNum()
	elseif subMsg == "initData" then
		self:updateExp()
		self:updateRewardList()
		self:updateBtnGet()
	end
end
function Com_rebuild:updateTextTip(...)
	if activity_9001670_Ctrl:checkDoStage1() then
		self.fields.Text_tip:setString(i18n("Bubble_island_rebuild_text_52"))
	else
		self.fields.Text_tip:setString(i18n("Bubble_island_rebuild_text_59"))
	end
end
return Com_rebuild
