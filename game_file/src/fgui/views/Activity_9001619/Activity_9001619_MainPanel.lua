local gametop = gModuleMgr.getObject("gametop")
local activity_9001619_Ctrl = gametop.playertop_:getModule("activity_9001619_Ctrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local activity_9001619_Read = include("activity_9001619_Read")
local publicRead = include("publicRead")
local starRhapsodyDef = include("starRhapsodyDef")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001619_MainPanel = class("Activity_9001619_MainPanel", baseFguiPanel)
function Activity_9001619_MainPanel:ctor(...)
	Activity_9001619_MainPanel.super.ctor(self, ...)
	self.debug = true
	self.itemID = 868501
	self.activityID = gActivityTimeActivityID.RAMADAN_RHAPSODY
	print("Activity_9001619_MainPanel:ctor", self.viewName)
end
function Activity_9001619_MainPanel:onInit()
	print("=======Activity_9001619_MainPanel:onInit")
	self.isHideCurrentSceneView = true
	self.txtTipOne = SoraDGetChildByName(self, "Text_tip_one")
	self.txtTipTwo = SoraDGetChildByName(self, "Text_tip_two")
	self.btnReset = SoraDGetChildByName(self, "CCS_commonGoldSmallBtn_reset")
	self.txtDesAward = SoraDGetChildByName(self, "Text_des_award")
	self.btnAward = SoraDGetChildByName(self, "Button_award")
	self.txtItemNum = SoraDGetChildByName(self, "Text_item_num")
	self.btnBuy = SoraDGetChildByName(self, "Button_buy")
	self.btnTask = SoraDGetChildByName(self, "Button_task")
	self.Node_times = SoraDGetChildByName(self, "Node_times")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.imgHourglass = SoraDGetChildByName(self, "icon_hourglass")
	self.spGreen = SoraDGetChildByName(self, "Sprite_green")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.nodeCenter = SoraDGetChildByName(self, "Center_Node_lamp")
	self.btnReset:addTouchEventListener(handler(self, self.onClickReset))
	self.btnAward:addTouchEventListener(handler(self, self.onClickAward))
	self.btnBuy:addTouchEventListener(handler(self, self.onClickGet))
	self.btnTask:addTouchEventListener(handler(self, self.onClickBuy))
	self.txtTipOne:setString(i18n("ramadan_rhapsody_text1"))
	self.txtTipTwo:setString(i18n("starlight_text_08"))
	self.txtDesAward:setString(i18n("starlight_title_01"))
	self.btnAward:setTitleText(i18n("decrypt_text_03"))
	self.btnTask:setTitleText(i18n("common_text_675"))
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	self.Button_item = SoraDGetChildByName(self, "Button_item")
	self.btnTask:fixPos()
	self.btnAward:fixPos()
	self.Node_times:fixPos()
	self.fields.bottom:fixChildrenPos(true)
	self.Node_item:fixChildrenPos(true)
	self.Image_icon = SoraDGetChildByName(self, "Image_icon")
	self.tableItem = SoraDGetChildsArrayByName(self, "CCS_starRhapsodyLamp_", 9, 1, true)
	local lampInfo = activity_9001619_Read:getCombCfg()[1]
	local tableItem = SoraDGetChildsArrayByName(self, "CCS_commonItemAward1_", 4, 1, true)
	dump(lampInfo.reward, "lampInfo.reward")
	for i, v in ipairs(tableItem) do
		local item = lampInfo.reward[i]
		if item then
			v:setVisible(true)
			v:initData(item.id, item.count)
		else
			v:setVisible(false)
		end
	end
	dump(tableItem, "self.tableItem")
	self:initView()
end
function Activity_9001619_MainPanel:onShow()
	print("=======Activity_9001619_MainPanel:onShow")
end
function Activity_9001619_MainPanel:closeLoading()
	SoraDCloseLoading(self)
end
function Activity_9001619_MainPanel:initView()
	self:setTime()
	self:initLampCombInfo()
	self:updateViewInfo()
end
function Activity_9001619_MainPanel:updateViewInfo()
	self:setItemInfo()
	self:setTaskInfo()
	self:setLampInfo()
	self:setResetTimes()
end
function Activity_9001619_MainPanel:initLampCombInfo()
	local lampInfo = activity_9001619_Read:getCombCfg(1)
	if lampInfo then
		local isCompRound = true
		local tableItem = SoraDGetChildsArrayByName(self, "CCS_starRhapsodyLamp_award_", 3, 1, true)
		for i, v in ipairs(tableItem) do
			if lampInfo.colorComb[i] then
				v:setLampColor(lampInfo.colorComb[i], isCompRound)
			end
		end
	end
end
function Activity_9001619_MainPanel:setTime()
end
function Activity_9001619_MainPanel:setResetTimes()
	if activity_9001619_Ctrl:isStarLampAllLight() then
		self.btnReset:setBright(true)
		self.btnReset:setFree(i18n("starlight_btn_0"))
		self.btnReset:setCostNum(0)
		self:checkShowFinger()
	else
		local times = activity_9001619_Ctrl:getResetTimes()
		local gold = activity_9001619_Ctrl:getResetCost()
		activity_9001619_Ctrl = i18n("starlight_btn_0")
		i18n("starlight_btn_0").num1 = starRhapsodyDef.GOLD_RESET_MAX_NUM - times
		i18n("starlight_btn_0").num2 = starRhapsodyDef.GOLD_RESET_MAX_NUM
		self.btnReset:setTitle(i18n("ramadan_rhapsody_text4", i18n("starlight_btn_0")))
		self.btnReset:setCostNum(gold)
		local enableReset = 0 < times
		self.btnReset:setBright(enableReset)
	end
end
function Activity_9001619_MainPanel:setLampInfo()
	for i, v in ipairs(self.tableItem) do
		local lampInfo = activity_9001619_Ctrl:getStarLampDataByIndex(i)
		v:initView(i, lampInfo)
		v:setHandle(handler(self, self.opClickCallBack))
	end
end
function Activity_9001619_MainPanel:setItemInfo()
	local num = activity_9001619_Ctrl:getItemMoonCount()
	self.txtItemNum:setString(string.formatnumberthousands(num))
	local itemID = self.itemID
	publicRead = string.formatnumberthousands(num)
	string.formatnumberthousands(num)[1] = publicRead.getIcon(itemID)
	string.formatnumberthousands(num)[2] = itemID
	dump(string.formatnumberthousands(num))
	self.Button_item:setURL(publicRead.getIcon(itemID))
end
function Activity_9001619_MainPanel:setTaskInfo()
	local taskNum = activity_9001619_Ctrl:getTaskAwardNum()
	self.btnTask:setReddot(0 < taskNum)
end
function Activity_9001619_MainPanel:opClickCallBack(index, data)
	local bright = activity_9001619_Ctrl:getStarLampStatus(index)
	print("Activity_9001619_MainPanel:opClickCallBack 1")
	if bright then
		return
	end
	print("Activity_9001619_MainPanel:opClickCallBack 2")
	local num = activity_9001619_Ctrl:getItemMoonCount()
	if num <= 0 then
		SoraDPlaySound()
		local itemID = self.itemID
		local itemName = publicRead.getName(itemID)
		activity_9001619_Ctrl = nil
		;(nil).name = itemName
		SoraDShowMsgTip(i18n("commom_text_4302", nil))
		return
	end
	SoraDPlaySound("uicontrol", 46)
	activity_9001619_Ctrl:reqLightUpInStarLamp(index)
	SoraDShowLoading(self)
end
function Activity_9001619_MainPanel:onClickHelp(sender, event)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("ramadan_rhapsody_text2")
	uiManager:show("RuleView", nil)
end
function Activity_9001619_MainPanel:onClickReset(sender, event)
	SoraDPlaySound()
	if activity_9001619_Ctrl:isStarLampAllLight() then
		if self.spriteHand then
			self.spriteHand:stopAllActions()
			self.spriteHand:removeFromParent()
			self.spriteHand = nil
			self.guide = false
		end
		activity_9001619_Ctrl:reqResetInStarLamp()
		SoraDShowLoading(self)
	elseif activity_9001619_Ctrl:isHasGoldResetNum() then
		local gold = activity_9001619_Ctrl:getResetCost()
		_ENV = nil
		;(nil).num = gold
		local showMsg = i18n("starlight_text_09", nil)
		self.msgBox = SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES and not tolua.isnull(self) and SoraDEnoughGold(gold) then
				activity_9001619_Ctrl:reqResetInStarLamp()
				SoraDShowLoading(self)
			end
			self.msgBox = nil
		end)
	else
		SoraDShowMsgTip(i18n("starlight_text_05"))
	end
end
function Activity_9001619_MainPanel:onClickAward(sender, event)
	SoraDPlaySound()
	uiManager:show("Activity_9001619_AwardPreviewView")
end
function Activity_9001619_MainPanel:onClickBuy(sender, event)
	SoraDPlaySound()
	uiManager:show("Activity_9001619_TaskView")
end
function Activity_9001619_MainPanel:onClickGet(sender, event)
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonSourceGuide", nil)
end
function Activity_9001619_MainPanel:judgeClose()
	if not _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RAMADAN_RHAPSODY) then
		SoraDRemoveAllAfterPanelFromManager()
	end
end
function Activity_9001619_MainPanel:checkShowFinger()
	if self.guide then
		return
	end
	self:openGuide()
end
function Activity_9001619_MainPanel:openGuide()
	if self.guide then
		return
	end
	self.guide = true
	self:showFinger()
end
function Activity_9001619_MainPanel:showFinger()
	local pos = cc.p(35, 45)
	local spriteHand = SoraDFingerAction(false, false, 10)
	spriteHand:setPosition(pos)
	spriteHand:setName("animationFinger")
	spriteHand:addTo(self.btnReset, 99)
	self.spriteHand = spriteHand
end
function Activity_9001619_MainPanel:gemEffect(target, data)
	if self.hasHD and data.index then
		local item = self.tableItem[data.index]
		if item then
			do return end
			_ENV = nil
			;(nil).cssFileName = "gemRhapsodyNode"
			;(nil).loop = false
			local effectNode = _G.SoraDCreatAnimationParam(nil)
			effectNode:addTo(self.nodeCenter, 200)
			effectNode:setPosition(cc.p(item:getPosition()))
			_UPVALUE1_ = cc.p(item:getPosition())
			cc.p(item:getPosition())[1] = cca.delay(5.0)
			cc.p(item:getPosition())[2] = cca.callFunc(function()
				effectNode:removeFromParent()
			end)
			cc.p(item:getPosition())[3] = cca.callFunc(function()
				effectNode:removeFromParent()
			end)
			effectNode:runAction(cca.seq(cc.p(item:getPosition())))
		end
	end
end
function Activity_9001619_MainPanel:starLine(target, data)
	if data.rewardStatus then
		local _ENV, combArray = data.rewardStatus, data.rewardStatus
		local _ENV, lines
		for k, v in pairs(data.rewardStatus) do
			combArray[#combArray + 1] = tonumber(k)
			local _ENV, line = #combArray + 1, #combArray + 1
			for i2, v2 in ipairs(v) do
				local index = starRhapsodyDef.xyToIndex(v2.x, v2.y)
				table.insert(line, index)
			end
			table.sort(line, function(a, b)
				return a < b
			end)
			table.insert(lines, line)
		end
		table.sort(combArray, function(a, b)
			return a < b
		end)
		local _ENV, itemList = table.sort, table.sort
		local _ENV, awardList = combArray, combArray
		for i, v in ipairs(combArray) do
			local lampInfo = activity_9001619_Read:getCombCfg(v)
			table.insert(itemList, lampInfo)
			for i2, v2 in ipairs(lampInfo.reward) do
				table.insert(awardList, v2)
			end
		end
		SoraDShowLoading(nil, nil, nil, true, 0.8)
		for i, v in ipairs(lines) do
			local lineName = string.format("line_%d_%d_%d", v[1], v[2], v[3])
			dump(lineName, "Activity_9001619_MainPanel:starLine")
			local lineEffect = SoraDGetChildByName(self, lineName)
			if lineEffect then
				lineEffect:setVisible(true)
				lineEffect:setAllFrameName("frame_9001619_line_%02d.png", 1)
				lineEffect:setPlaySettings(0, -1, 1, -1, function()
					lineEffect:setVisible(false)
				end)
			end
		end
		self:runAction(ffa.seq(ffa.delay(0.8), ffa.callFunc(function()
			SoraDCloseLoading()
			_ENV = nil
			;(nil).itemType = 3
			;(nil).rewards = itemList
			;(nil).width = 640
			;(nil).rewards2 = awardList
			uiManager:show("CommonCongratulations", nil)
		end)))
	end
end
return Activity_9001619_MainPanel
