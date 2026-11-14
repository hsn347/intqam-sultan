local activity_9001617_Ctrl = SoraDGetCtrl("activity_9001617_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemDesRead = include("itemDesRead")
local activity_9001617_Read = include("activity_9001617_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_Activity_9001617 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001617/Com_Activity_9001617", Com_Activity_9001617)
function Com_Activity_9001617:onInit()
	self.activityID = gActivityTimeActivityID.HONOR_BACK_LOTTERY
	self.itemID = activity_9001617_Ctrl:getItemID()
	self.itemName = itemDesRead.getName(self.itemID)
	self.itemCount = 0
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.fields.Button_help:addClickListener(handler(self, self.onClickBtnHelp))
	self.fields.Button_reward:setString(i18n("decrypt_text_03"))
	self.fields.Button_reward:addClickListener(handler(self, self.onClickBtnReward))
	self.fields.Com_have:initData(self.itemID)
	_ENV = handler(self, self.onClickBtnReward)
	handler(self, self.onClickBtnReward).num = 1
	self.fields.Button_open1:setString(i18n("magic_flip_5", handler(self, self.onClickBtnReward)))
	self.fields.Button_open1:addClickListener(handler(self, self.onClickBtnOpen1))
	self.fields.Button_open1:setCost(self.itemID, 1)
	_ENV = handler(self, self.onClickBtnOpen1)
	handler(self, self.onClickBtnOpen1).num = 10
	self.fields.Button_open2:setString(i18n("magic_flip_5", handler(self, self.onClickBtnOpen1)))
	self.fields.Button_open2:addClickListener(handler(self, self.onClickBtnOpen2))
	self.fields.Button_open2:setCost(self.itemID, 10)
	if not SoraDFIsRA() then
		self.fields.Button_help:fixPos()
	end
end
function Com_Activity_9001617:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001617_UPDATE", handler(self, self.onMsgUpdateData))
end
function Com_Activity_9001617:onShow()
	self:updateItemCount()
end
function Com_Activity_9001617:onClickBtnHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("sunmmon_ghoul_text17")
	uiManager:show("RuleView", nil)
end
function Com_Activity_9001617:onClickBtnReward()
	SoraDPlaySound()
	local rewards = activity_9001617_Read.getRewardShowList()
	_ENV = nil
	;(nil).rewards = rewards
	uiManager:show("CommonRewardPreview", nil)
end
function Com_Activity_9001617:onClickBtnOpen1()
	SoraDPlaySound()
	if self.itemCount < 1 then
		_ENV = nil
		;(nil).item = self.itemName
		SoraDShowMsgTip(i18n("common_text_1806", nil))
		return
	end
	SoraDShowLoading(self)
	activity_9001617_Ctrl:reqLotteryDraw(1)
end
function Com_Activity_9001617:onClickBtnOpen2()
	SoraDPlaySound()
	if self.itemCount < 10 then
		_ENV = nil
		;(nil).item = self.itemName
		SoraDShowMsgTip(i18n("common_text_1806", nil))
		return
	end
	SoraDShowLoading(self)
	activity_9001617_Ctrl:reqLotteryDraw(10)
end
function Com_Activity_9001617:updateItemCount(...)
	self.itemCount = backpackCtrl:getItemCount(self.itemID)
	self.fields.Com_have:updateNum(string.formatnumberthousands(self.itemCount))
	self.fields.Button_open1:setCostNum(1, self.itemCount)
	self.fields.Button_open2:setCostNum(10, self.itemCount)
end
function Com_Activity_9001617:onMsgUpdateData(target, event)
	local key = event.key
	if key == "itemCount" then
		self:updateItemCount()
	elseif key == "lotteryDraw" then
		SoraDCloseLoading(self)
		SoraDShowLoading(self, nil, nil, true)
		self.fields.Usm_1:setCompleteCallback(function()
			SoraDCloseLoading(self)
			self.fields.Usm_1:setVisible(false)
			local times = event.times
			local itemType = 1 < times and 2 or 1
			local rewards = event.rewards
			_ENV = nil
			;(nil).rewards = rewards
			;(nil).itemType = itemType
			uiManager:show("CommonCongratulations", nil)
		end)
		self.fields.Usm_1:play()
	end
end
return Com_Activity_9001617
