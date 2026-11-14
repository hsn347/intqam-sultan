local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local activity_9001531_Read = include("activity_9001531_Read")
local activity_9001531_Ctrl = SoraDGetCtrl("activity_9001531_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001531_MainPanel = class("Activity_9001531_MainPanel", baseFguiPanel)
function Activity_9001531_MainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001531_MainPanel:ctor", self.viewName)
	self.activityID = activity_9001531_Ctrl:getActivityID()
	self.itemList = activity_9001531_Read.getUseItemList()
end
function Activity_9001531_MainPanel:onInit()
	print("=======Activity_9001531_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_reward:addClickListener(handler(self, self.onClickBtnReward))
	self.fields.bar:getChild("mv_jdtyh"):setAllFrameName("dh_yhcl_jdtyh_%02d.png", 1)
	local bar_v = self.fields.bar:getChild("bar_v")
	bar_v:getChild("mv_jdt"):setAllFrameName("dh_yhcl_jdt_%02d.png", 1)
end
function Activity_9001531_MainPanel:onShow()
	print("=======Activity_9001531_MainPanel:onShow")
	self:updateStageAndScore()
	self.fields.List:setNumItems(#self.itemList)
	local index = activity_9001531_Ctrl:checkUseItem()
	if index then
		self.curSelect = index - 1
		self:setObjSelected(self.curSelect, true)
	end
end
function Activity_9001531_MainPanel:setObjSelected(index, selected)
	local obj = self.fields.List:getChildAt(index)
	if not obj then
		return
	end
	if selected then
		obj.c1:setSelectedIndex(1)
	else
		obj.c1:setSelectedIndex(0)
	end
end
function Activity_9001531_MainPanel:onClickHelp(...)
	SoraDPlaySound()
	_ENV = "Bright_fireworks_01"
	;("Bright_fireworks_01").align = SoraDFLabelR()
	SoraDShowHelpMsgTip(i18n("Bright_fireworks_01"), "Bright_fireworks_01")
end
function Activity_9001531_MainPanel:onItemRenderer(index, obj)
	local itemID = self.itemList[index + 1]
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		obj:addClickListener(handler(self, self.onClickBtnObj))
		obj.c1 = obj:getController("c1")
	end
	obj:setTag(index)
	local _fields = obj._fields
	local iconPng = publicRead.getIcon(itemID)
	_fields.icon:setURL(iconPng)
	_fields.Button_use:addClickListener(handler(self, self.onClickBtnUse))
	_fields.Button_use:setTag(index)
	_fields.mv_uiquan:setAllFrameName("dh_yhcl_uiquan_%02d.png", 1)
	self:updateObjCount(obj, itemID)
end
function Activity_9001531_MainPanel:updateObjCount(obj, itemID)
	local _fields = obj._fields
	local itemCount = backpackCtrl:getItemCount(itemID)
	_fields.title:setString(string.formatnumberthousands(itemCount))
	if itemCount <= 0 then
		_fields.icon:setGrayed(true)
	else
		_fields.icon:setGrayed(false)
	end
	local useCount = activity_9001531_Ctrl:getUseCount(itemID, itemCount)
	backpackCtrl = string.formatnumberthousands(itemCount)
	string.formatnumberthousands(itemCount).num = useCount
	_fields.Button_use:setString(i18n("Bright_fireworks_06", string.formatnumberthousands(itemCount)))
end
function Activity_9001531_MainPanel:onClickBtnUse(EventContext)
	SoraDPlaySound()
	local index = EventContext:getSender():getTag()
	local itemID = self.itemList[index + 1]
	local useCount = activity_9001531_Ctrl:getUseCount(itemID)
	if 0 < useCount then
		activity_9001531_Ctrl:reqUseItem(itemID, useCount)
		SoraDShowLoading(self:displayObject())
	end
end
function Activity_9001531_MainPanel:onClickBtnObj(EventContext)
	SoraDPlaySound()
	print("==Activity_9001531_MainPanel:onClickBtnObj==")
	local obj = EventContext:getSender()
	local index = obj:getTag()
	if self.curSelect == index then
		return
	end
	local itemID = self.itemList[index + 1]
	local useCount = activity_9001531_Ctrl:getUseCount(itemID)
	if useCount <= 0 then
		_ENV = nil
		;(nil).itemID = itemID
		uiManager:show("CommonSourceGuide", nil)
	else
		if self.curSelect then
			self:setObjSelected(self.curSelect, false)
		end
		self:setObjSelected(index, true)
		self.curSelect = index
	end
end
function Activity_9001531_MainPanel:onClickBtnReward(...)
	SoraDPlaySound()
	if activity_9001531_Ctrl:checkCanExchange() then
		activity_9001531_Ctrl:reqExchange()
		SoraDShowLoading(self:displayObject())
	end
end
function Activity_9001531_MainPanel:onMsgItemCountChange(target, event)
	local itemMap = event.itemMap
	if not itemMap then
		return
	end
	for _itemID, v in pairs(itemMap) do
		local index = table.indexof(self.itemList, _itemID)
		if index then
			local obj = self.fields.List:getChildAt(index - 1)
			self:updateObjCount(obj, _itemID)
			local itemCount = backpackCtrl:getItemCount(_itemID)
			if itemCount <= 0 then
				self:setObjSelected(index - 1, false)
				self.curSelect = nil
			end
		end
	end
end
function Activity_9001531_MainPanel:updateScore(...)
	local curScore = activity_9001531_Ctrl:getCurScore()
	local targetScore = activity_9001531_Read.getPointsByStage(self.curStage)
	activity_9001531_Ctrl = nil
	;(nil).num1 = string.formatnumberthousands(curScore)
	;(nil).num2 = string.formatnumberthousands(targetScore)
	self.fields.Label_score:setString(i18n("Bright_fireworks_03", nil))
	self.fields.bar:setMax(targetScore)
	self.fields.bar:setValue(curScore)
	local needScore = math.max(0, targetScore - curScore)
	activity_9001531_Ctrl = i18n("Bright_fireworks_03", nil)
	i18n("Bright_fireworks_03", nil).num = needScore
	self.fields.Button_reward:setString(i18n("Bright_fireworks_02", i18n("Bright_fireworks_03", nil)))
	local c1 = self.fields.Button_reward:getController("c1")
	if curScore >= targetScore then
		c1:setSelectedIndex(1)
	else
		c1:setSelectedIndex(0)
	end
end
function Activity_9001531_MainPanel:updateStageAndScore(...)
	self.curStage = activity_9001531_Ctrl:getCurStage()
	local rewardID = activity_9001531_Read.getRewardIDByStage(self.curStage)
	local iconPng = publicRead.getIcon(rewardID)
	self.fields.Button_reward:setIcon(iconPng)
	self:updateScore()
end
function Activity_9001531_MainPanel:onMsgUpdate(target, event)
	SoraDCloseLoading(self:displayObject())
	local key = event.key
	if key == "updateUseItem" then
		self:updateScore()
	elseif key == "updateExchange" then
		self:updateStageAndScore()
	end
end
return Activity_9001531_MainPanel
