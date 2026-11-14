local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activity_9001601_Ctrl = SoraDGetCtrl("activity_9001601_Ctrl")
local activity_9001601_Read = include("activity_9001601_Read")
local itemDesRead = include("itemDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001601_MainPanel = class("Activity_9001601_MainPanel", baseFguiPanel)
function Activity_9001601_MainPanel:ctor(...)
	Activity_9001601_MainPanel.super.ctor(self, ...)
	print("Activity_9001601_MainPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.itemID = 867901
	self.itemName = itemDesRead.getName(self.itemID)
	self.tableLabelSpare, Activity_9001601_MainPanel, self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001601, gActivityTimeActivityID.NORMAL_ACTIVITY_9001601, gActivityTimeActivityID.NORMAL_ACTIVITY_9001601
	self.curLv = 0
	self.blessRewards = activity_9001601_Read.getBlessRewardConfig()
	self.configMax = activity_9001601_Read.getLevelConfigMax()
end
function Activity_9001601_MainPanel:onInit()
	print("=======Activity_9001601_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_item:setIcon(itemDesRead.getIcon(self.itemID))
	self.fields.Button_item:addClickListener(handler(self, self.onClickBtnItem))
	if include("constantRead").checkRamadanBlessBuffSwitch() then
		self.fields.Button_buff:setString(i18n("Battle_Towers_23"))
		self.fields.Button_buff:addClickListener(handler(self, self.onClickBtnBuff))
	else
		self.fields.Button_buff:setVisible(false)
	end
	self.fields.Button_upgrade:setString(i18n("meteoritesmagic_text_62"))
	self.fields.Button_upgrade:addClickListener(handler(self, self.onClickBtnUpgrade))
	self.fields.Label_lv = self.fields.bar:getChild("Label_lv")
	local _fields = fguiHelper.get_fields(self.fields.Com_rewardTitle)
	_fields.Text_level:setString(i18n("common_text_748"))
	_fields.Text_reward1:setString(i18n("Braque_text_03"))
	_fields.Text_reward2:setString(i18n("StarlitNight_text_07"))
	_fields.Text_reward3:setString(i18n("Braque_text_05"))
	_ENV, _ENV = _fields.Text_reward3, _fields.Text_reward3.setString
	_fields.Text_reward3.widget = self.fields.Button_lock1
	_fields.Text_reward3.title = i18n("StarlitNight_text_02")
	_ENV, _fields.Text_reward3.setString[1], _fields.Text_reward3.handle = _fields.Text_reward3, _fields.Text_reward3, handler(self, self.onClickBtnLock1)
	_fields.Text_reward3.widget = self.fields.Button_lock2
	_fields.Text_reward3.title = i18n("Braque_text_07")
	_fields.Text_reward3.setString[2], _fields.Text_reward3.handle = _fields.Text_reward3, handler(self, self.onClickBtnLock2)
	local config = _fields.Text_reward3.setString
	for __, cfg in ipairs(config) do
		local Button_lock = cfg.widget
		Button_lock:setString(cfg.title)
		Button_lock:addClickListener(cfg.handle)
	end
	self.fields.List_reward:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onAwardScrolling))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward:setVirtual()
	self.fields.Button_get:setString(i18n("summoned_btn_01"))
	self.fields.Button_get:addClickListener(handler(self, self.onClickBtnGet))
	if not SoraDFIsRA() then
		_UPVALUE8_ = SoraDFIsRA()
		SoraDFIsRA()[1] = self.fields.bar
		SoraDFIsRA()[2] = self.fields.bar:getChild("bar")
		SoraDFIsRA()[3] = self.fields.Label_lv
		SoraDFIsRA()[4] = self.fields.Button_upgrade
		SoraDFIsRA()[5] = self.fields.Com_lockMask1
		SoraDFIsRA()[6] = self.fields.Button_lock1
		SoraDFIsRA()[7] = self.fields.Com_lockMask2
		local SoraDFIsRA()[8], widgetList = self.fields.Button_lock2, SoraDFIsRA()
		for __, widget in ipairs(widgetList) do
			widget:fixPos()
		end
		self.fields.Com_rewardTitle:fixChildrenPos()
		self.fields.Com_rewardTitle:fixChildren()
		self.fields.Com_mask:fixChildrenPos()
	end
end
function Activity_9001601_MainPanel:onShow()
	print("=======Activity_9001601_MainPanel:onShow")
	if activity_9001601_Ctrl:getIsDataInit() then
		self:updateView()
	else
		SoraDShowLoading(self)
		activity_9001601_Ctrl:reqInitData()
	end
end
function Activity_9001601_MainPanel:updateView(...)
	self.unlock = activity_9001601_Ctrl:getUnlock()
	self.gotRewardLv = activity_9001601_Ctrl:getGotRewardLv()
	self:updateProgressBar()
	self:updateItemCount()
	self:updateBtnGet()
	self:updateLockMask()
	self:updateRewardList()
	self:onAwardScrolling()
	local jumpLv = math.min(self.configMax, math.max(1, self.curLv))
	self.fields.List_reward:scrollToView(jumpLv - 1)
end
function Activity_9001601_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("ramadan_bless_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001601_MainPanel:onClickBtnItem()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonSourceGuide", nil)
end
function Activity_9001601_MainPanel:onClickBtnBuff()
	SoraDPlaySound()
	local warOrderRead = include("warOrderRead")
	warOrderRead.openSkillBuffView(self.activityID)
end
function Activity_9001601_MainPanel:onClickBtnUpgrade()
	SoraDPlaySound()
	if self.itemCount < 1 then
		_ENV = nil
		;(nil).item = self.itemName
		SoraDShowMsgTip(i18n("common_text_1806", nil))
		_ENV = i18n("common_text_1806", nil)
		i18n("common_text_1806", nil).itemID = self.itemID
		uiManager:show("CommonSourceGuide", i18n("common_text_1806", nil))
		return
	end
	SoraDShowLoading(self)
	activity_9001601_Ctrl:reqDonate()
end
function Activity_9001601_MainPanel:onClickBtnLock1()
	SoraDPlaySound()
	if include("constantRead").checkRamadanBlessBuffSwitch() then
		_ENV = nil
		;(nil).giftType = 1
		uiManager:show("Activity_9001601_BuyGiftROS", nil)
	else
		_ENV = nil
		;(nil).giftType = 1
		uiManager:show("Activity_9001601_BuyGift", nil)
	end
end
function Activity_9001601_MainPanel:onClickBtnLock2()
	SoraDPlaySound()
	if include("constantRead").checkRamadanBlessBuffSwitch() then
		_ENV = nil
		;(nil).giftType = 2
		uiManager:show("Activity_9001601_BuyGiftROS", nil)
	else
		_ENV = nil
		;(nil).giftType = 2
		uiManager:show("Activity_9001601_BuyGift", nil)
	end
end
function Activity_9001601_MainPanel:updateRewardList(...)
	self.fields.List_reward:setNumItems(#self.blessRewards)
end
function Activity_9001601_MainPanel:onItemRenderer(index, obj)
	local cfg = self.blessRewards[index + 1]
	self:updateRewardSingle(obj, cfg)
end
function Activity_9001601_MainPanel:updateRewardSingle(obj, cfg, isSpecial)
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		obj._controllers = fguiHelper.get_controllers(obj)
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
			obj._fields.n2:fix()
		end
	end
	local _fields = obj._fields
	_fields.Text_level:setString(activity_9001601_Read.getLevelStr(cfg.lv))
	_UPVALUE3_ = _fields.Text_level
	_fields.Text_level[1] = cfg.normalReward
	_fields.Text_level[2] = cfg.advanceReward
	_fields.Text_level[3] = cfg.seniorReward
	for i, item in ipairs(_fields.Text_level) do
		local Com_item = _fields["Com_item" .. i]
		local Ani_canget = _fields["Ani_canget" .. i]
		_ENV = activity_9001601_Read.getLevelStr(cfg.lv)
		activity_9001601_Read.getLevelStr(cfg.lv).lv = cfg.lv
		activity_9001601_Read.getLevelStr(cfg.lv).index = i
		activity_9001601_Read.getLevelStr(cfg.lv).id = item[1]
		activity_9001601_Read.getLevelStr(cfg.lv).count = item[2]
		activity_9001601_Read.getLevelStr(cfg.lv).isSpecial = isSpecial
		self:updateItemSingle(Com_item, Ani_canget, activity_9001601_Read.getLevelStr(cfg.lv))
	end
end
function Activity_9001601_MainPanel:updateItemSingle(obj, ani, data)
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		obj._controllers = fguiHelper.get_controllers(obj)
	end
	local _fields = obj._fields
	_fields.Com_item:initData(data.id, data.count)
	local _controllers = obj._controllers
	local state = self:getItemSingleState(data)
	_controllers.state:setSelectedIndex(state)
	if state == 1 then
		if not self.isInitAni then
			self.isInitAni = true
			_fields.Ani_item:setAllFrameName("dh_chuanqijunwang_%02d.png", 1)
			ani:setAllFrameName("dh_xingyekhnew_%02d.png", 1)
		end
		ani:setVisible(true)
	else
		ani:setVisible(false)
	end
end
function Activity_9001601_MainPanel:getItemSingleState(data)
	if data.isSpecial then
		return 3
	end
	local index = data.index
	if not self.unlock[index] then
		return 0
	end
	local gotLv = self.gotRewardLv[index] or 0
	local showLv = data.lv
	if showLv < self.configMax then
		if gotLv >= showLv then
			return 2
		elseif showLv <= self.curLv then
			return 1
		else
			return 3
		end
	elseif gotLv < self.curLv then
		return 1
	else
		return 3
	end
end
function Activity_9001601_MainPanel:onAwardScrolling()
	local maxShowLv = self:getMaxShowIndex()
	if maxShowLv == self.maxShowLv then
		return
	end
	self.maxShowLv = maxShowLv
	local cfg = activity_9001601_Read.getLevelConfig(maxShowLv)
	self:updateRewardSingle(self.fields.Next_Reward, cfg, true)
end
function Activity_9001601_MainPanel:getMaxShowIndex()
	local singleH = 100
	local contentHeight = self.fields.List_reward:getContentSize().height
	local posY = self.fields.List_reward:getScrollPane():getPosY()
	local index = math.ceil((posY + contentHeight) / singleH)
	if index <= 0 then
		return 5
	else
		return math.ceil(index / 5) * 5
	end
end
function Activity_9001601_MainPanel:onClickBtnGet()
	SoraDPlaySound()
	SoraDShowLoading(self)
	activity_9001601_Ctrl:reqAllReward()
end
function Activity_9001601_MainPanel:updateProgressBar(...)
	local curLv = activity_9001601_Ctrl:getScorCurLv()
	local curExp = activity_9001601_Ctrl:getScorCurExp()
	self.curLv = curLv
	self.fields.Label_lv:setString(curLv)
	local nextLv = curLv + 1
	local expMax = activity_9001601_Read.getLevelConfigExp(nextLv)
	self.fields.bar:setMax(expMax)
	self.fields.bar:setValue(curExp)
end
function Activity_9001601_MainPanel:updateItemCount(...)
	self.itemCount = backpackCtrl:getItemCount(self.itemID)
	self.fields.Button_item:setString(string.formatnumberthousands(self.itemCount))
	if self.itemCount > 0 then
		self.fields.Button_upgrade:setTitleColor(cc.c3b(255, 251, 213))
	else
		self.fields.Button_upgrade:setTitleColor(cc.c3b(255, 0, 0))
	end
end
function Activity_9001601_MainPanel:updateScoreRateEffect(rate)
end
function Activity_9001601_MainPanel:updateBtnGet(...)
	local canReceive = false
	for i, gotLv in ipairs(self.gotRewardLv) do
		if self.unlock[i] and gotLv < self.curLv then
			canReceive = true
			break
		end
	end
	self.fields.Button_get:setEnabled(canReceive)
end
function Activity_9001601_MainPanel:updateLockMask(...)
	if self.unlock[2] then
		self.fields.Com_lockMask1:setVisible(false)
		self.fields.Button_lock1:setVisible(false)
	end
	if self.unlock[3] then
		self.fields.Com_lockMask2:setVisible(false)
		self.fields.Button_lock2:setVisible(false)
	end
end
function Activity_9001601_MainPanel:onMsgUpdateData(target, event)
	local key = event.key
	if key == "init" then
		SoraDCloseLoading(self)
		self:updateView()
	elseif key == "donate" then
		SoraDCloseLoading(self)
		local oldLv = self.curLv
		self:updateProgressBar()
		if oldLv ~= self.curLv then
			self:updateRewardList()
			self:updateBtnGet()
		end
		local rate = event.rate or 1
		self:updateScoreRateEffect(rate)
	elseif key == "reward" then
		SoraDCloseLoading(self)
		self.gotRewardLv = activity_9001601_Ctrl:getGotRewardLv()
		self:updateRewardList()
		self:updateBtnGet()
	elseif key == "itemCount" then
		self:updateItemCount()
	elseif key == "buyGift" then
		self.unlock = activity_9001601_Ctrl:getUnlock()
		self:updateRewardList()
		self:updateBtnGet()
		self:updateLockMask()
	end
end
return Activity_9001601_MainPanel
