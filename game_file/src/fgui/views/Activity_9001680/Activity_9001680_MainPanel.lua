local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001680_MainPanel = class("Activity_9001680_MainPanel", baseFguiPanel)
local activity_9001680_Ctrl = SoraDGetCtrl("activity_9001680_Ctrl")
local activity_9001680_Read = include("activity_9001680_Read")
local constantRead = include("constantRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
function Activity_9001680_MainPanel:ctor(...)
	self.isLRU = true
	Activity_9001680_MainPanel.super.ctor(self, ...)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001680
	print("Activity_9001680_MainPanel:ctor", self.viewName)
	self.itemID = 1698
	self.itemID2 = activity_9001680_Read.getBoomItemID()
end
function Activity_9001680_MainPanel:onInit()
	self.view:fixChildrenPos()
	self.fields.n20:fix()
	self.fields.n21:fix()
	print("=======Activity_9001680_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.treasureMax = constantRead.getConstValue("GLODMINER_BOX_MAXNUM", 120)
	self.fields.Button_battlePass:setTitle(i18n("minecraft_text_11"))
	self.fields.Button_battlePass:addClickEventListener(handler(self, self.onClickBattlePass))
	self.fields.text_reset:setString(i18n("minecraft_text_10"))
	self.fields.Button_reset:addClickEventListener(handler(self, self.onClickReset))
	self.fields.text_item_num:initData(self.itemID, handler(self, self.onClickAdd1))
	self.fields.text_boom_num:initData(self.itemID2, handler(self, self.onClickAdd2))
	self.fields.Com_9001680_game:setBossAndMonsterHead(self.fields.head_boss, self.fields.head_monster)
	self.fields.Button_reward:setString(i18n("decrypt_text_03"))
	self.fields.Button_reward:addClickEventListener(handler(self, self.onClickBtnReward))
	self.fields.Button_record:setString(i18n("minecraft_text_47"))
	self.fields.Button_record:addClickEventListener(handler(self, self.onClickBtnRecord))
	self.fields.Button_task:setString(i18n("common_text_675"))
	self.fields.Button_task:addClickEventListener(handler(self, self.onClickBtnTask))
	if device.platform == "mac" or userSDKManager.isBeta() or userSDKManager.isGameDevelop() then
		self.fields.Button_debug:setVisible(true)
		self.fields.Button_debug:setTitle("坐标显示")
		self.fields.Button_debug:addClickEventListener(function()
			self.fields.Com_9001680_game:debugSwitch()
		end)
	end
end
function Activity_9001680_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).num = self.itemMax
	_ENV = nil
	;(nil).num = self.treasureMax
	local str = string.format([[
%s
%s
%s
%s
%s]], i18n("minecraft_text_35", nil), i18n("minecraft_text_36"), i18n("minecraft_text_37"), i18n("minecraft_text_38", nil), i18n("minecraft_text_39"))
	_ENV = i18n("minecraft_text_37")
	i18n("minecraft_text_37").content = str
	uiManager:show("RuleView", (i18n("minecraft_text_37")))
end
function Activity_9001680_MainPanel:endShow()
	print("=======Activity_9001680_MainPanel:endShow")
	if self.ox == nil then
		self.oY = self.fields.text_add:getPositionY()
		self.oX = self.fields.text_add:getPositionX()
	end
	self.lastItemNum = nil
	self:updateView()
	self.fields.text_add:setVisible(false)
end
function Activity_9001680_MainPanel:updateView(data)
	local msgType = data and data.msgType or nil
	self:updateItem()
	self.fields.Com_9001680_game:updateView(data)
end
function Activity_9001680_MainPanel:updateItem()
	local itemNum, itemMax = activity_9001680_Ctrl:getItemCount()
	if self.lastItemNum and itemNum < self.lastItemNum then
		local costItem = itemNum - self.lastItemNum
		self.fields.text_add:setVisible(true)
		self.fields.text_add:setString(costItem)
		self.fields.text_add:setPositionY(self.oY)
		self.fields.text_add:stopActionByTag(995)
		if -1 <= costItem then
			self.fields.text_add:setScaleX(1)
			self.fields.text_add:setScaleY(1)
			self.fields.text_add:setAlpha(1)
			self.fields.text_add:setFontSize(24)
			local seq = ffa.spawn(ffa.fadeOut(0.5), ffa.moveTo(0.5, self.oX, self.oY - 30))
			seq:setTag(995)
			self.fields.text_add:runAction(seq)
		else
			self.fields.text_add:setScaleX(0.5)
			self.fields.text_add:setScaleY(0.6)
			self.fields.text_add:setAlpha(0)
			self.fields.text_add:setFontSize(34)
			local seq1 = ffa.seq(ffa.fadeIn(0.1), ffa.delay(0.4), ffa.fadeOut(0.1))
			local seq2 = ffa.scaleTo(0.1, 1, 1)
			local seq3 = ffa.seq(ffa.moveTo(0.1, self.oX, self.oY - 20))
			local seq = ffa.spawn(seq1, seq2, seq3)
			seq:setTag(995)
			self.fields.text_add:runAction(seq)
		end
	end
	self.lastItemNum = itemNum
	self.itemMax = itemMax
	self.fields.text_item_num:setTitle(string.format("%s/%s", string.formatnumberthousands(itemNum), string.formatnumberthousands(itemMax)))
	self.fields.text_boom_num:updateNum()
	local treasurePos = activity_9001680_Ctrl:getTreasurePos()
	if treasurePos ~= nil or not i18n("minecraft_text_9") then
		activity_9001680_Ctrl = string.format("%s/%s", string.formatnumberthousands(itemNum), string.formatnumberthousands(itemMax))
		activity_9001680_Ctrl, activity_9001680_Ctrl, string.format("%s/%s", string.formatnumberthousands(itemNum), string.formatnumberthousands(itemMax)).code = "X:%d Y:%d", string.format("X:%d Y:%d", treasurePos[1], treasurePos[2]), string.format("X:%d Y:%d", treasurePos[1], treasurePos[2])
		string.format("X:%d Y:%d", treasurePos[1], treasurePos[2]).code, ("X:%d Y:%d").color = "X:%d Y:%d", "#4ce61a"
	end
	self.fields.text_box_pos:setString((i18n_html("minecraft_text_7", string.format("%s/%s", string.formatnumberthousands(itemNum), string.formatnumberthousands(itemMax)))))
	local treasureCount = activity_9001680_Ctrl:getTreasureCount()
	activity_9001680_Ctrl = string.format("X:%d Y:%d", treasurePos[1], treasurePos[2])
	string.format("X:%d Y:%d", treasurePos[1], treasurePos[2]).num1 = treasureCount
	string.format("X:%d Y:%d", treasurePos[1], treasurePos[2]).num2 = self.treasureMax
	self.fields.text_box_count:setString(i18n("minecraft_text_8", (string.format("X:%d Y:%d", treasurePos[1], treasurePos[2]))))
	self.fields.Button_battlePass:setReddot(activity_9001680_Ctrl:hasAward())
	self.fields.Button_task:setReddot(activity_9001680_Ctrl:hasTaskCanReceive())
end
function Activity_9001680_MainPanel:onClickBattlePass()
	SoraDPlaySound()
	uiManager:show("Activity_9001680_BattlePass")
end
function Activity_9001680_MainPanel:onClickReset()
	SoraDPlaySound()
	uiManager:show("Activity_9001680_Reset")
end
function Activity_9001680_MainPanel:onClickAdd1()
	SoraDPlaySound()
	uiManager:show("Activity_9001680_ItemGet")
end
function Activity_9001680_MainPanel:onClickAdd2()
	SoraDPlaySound()
	uiManager:show("Activity_9001680_ItemGet2")
end
function Activity_9001680_MainPanel:onClickBtnReward(...)
	SoraDPlaySound()
	local _ENV, rewards = SoraDPlaySound, SoraDPlaySound
	local itemIDList = activity_9001680_Read.getDropidItemIDList()
	for __, itemID in ipairs(itemIDList) do
		_ENV = nil
		;(nil).id = itemID
		table.insert(rewards, nil)
	end
	_ENV = nil
	;(nil).rewards = rewards
	uiManager:show("CommonRewardPreview", nil)
end
function Activity_9001680_MainPanel:onClickBtnRecord(...)
	SoraDPlaySound()
	uiManager:show("Activity_9001680_Record")
end
function Activity_9001680_MainPanel:onClickBtnTask()
	SoraDPlaySound()
	uiManager:show("Activity_9001680_Task")
end
function Activity_9001680_MainPanel:gameGuide_getTarget(itemName, parameters)
	print("Activity_9001665_MainPanel:gameGuide_getTarget", itemName)
	if itemName == "Guide_Cell" then
		_UPVALUE2_ = itemName
		itemName[1] = 151
		itemName[2] = 2
		local cellPos = constantRead.getConstValueArray("GOLDMINER_INITIAL_ROAD_GUIDE", itemName)
		return self.fields.Com_9001680_game:getCell(nil, cellPos[1], cellPos[2])
	end
	return self.fields[itemName]
end
return Activity_9001680_MainPanel
