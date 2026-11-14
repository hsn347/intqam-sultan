local activityCommonDrawCtrl = SoraDGetCtrl("activityCommonDrawCtrl")
local activityCommonDrawRead = include("activityCommonDrawRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemDesRead = include("itemDesRead")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001640_MainPanel = class("Activity_9001640_MainPanel", baseFguiPanel)
function Activity_9001640_MainPanel:ctor(...)
	Activity_9001640_MainPanel.super.ctor(self, ...)
	print("Activity_9001640_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.PHOENIX_ARRIVAL
	self.itemID = activityCommonDrawCtrl:getItemID(self.activityID)
	self.boxConfig = activityCommonDrawRead.activity_9001640_getBoxConfig()
	self.scoreList = activityCommonDrawRead.activity_9001640_getScoreList()
	self.ownaid = allianceMgr:hasJoinAlliance()
end
function Activity_9001640_MainPanel:onInit()
	print("=======Activity_9001640_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_reward:setString(i18n("nebulaemperor_text_86"))
	self.fields.Button_reward:addClickListener(handler(self, self.onClickBtnReward))
	self.fields.List_box:setItemRenderer(handler(self, self.onBoxItemRenderer))
	self.fields.List_box:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickBoxItem))
	self.fields.Com_have:initData(self.itemID)
	self.fields.Button_draw:addClickListener(handler(self, self.onClickBtnDraw))
	if not SoraDFIsRA() then
		self.fields.bar:getChild("bar"):fixPos()
	end
end
function Activity_9001640_MainPanel:onShow()
	print("=======Activity_9001640_MainPanel:onShow")
	self:updateAllianceScore()
	self:updateItemCount()
	self:updateAllianceState()
	activityCommonDrawCtrl:reqInit(self.activityID)
end
function Activity_9001640_MainPanel:onIntoPanel(...)
	local newAid = allianceMgr:hasJoinAlliance()
	if self.ownaid ~= newAid then
		self.ownaid = newAid
		activityCommonDrawCtrl:reqInit(self.activityID)
		self:updateAllianceState()
	end
end
function Activity_9001640_MainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("phoenix_arrival_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001640_MainPanel:onClickBtnReward(...)
	SoraDPlaySound()
	uiManager:show("Activity_9001640_Reward")
end
function Activity_9001640_MainPanel:onClickBtnDraw(...)
	SoraDPlaySound()
	if not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("EidalAdha_King_text_09"))
		self:updateAllianceState()
		return
	end
	local itemCount = backpackCtrl:getItemCount(self.itemID)
	if itemCount <= 0 then
		local itemName = itemDesRead.getName(self.itemID)
		_ENV = i18n("EidalAdha_King_text_09")
		i18n("EidalAdha_King_text_09").item = itemName
		SoraDShowMsgTip(i18n("jinn_skill_23", i18n("EidalAdha_King_text_09")))
		return
	end
	_ENV = i18n("jinn_skill_23", i18n("EidalAdha_King_text_09"))
	i18n("jinn_skill_23", i18n("EidalAdha_King_text_09")).itemCount = itemCount
	uiManager:show("Activity_9001640_Draw", i18n("jinn_skill_23", i18n("EidalAdha_King_text_09")))
end
function Activity_9001640_MainPanel:onBoxItemRenderer(index, obj)
	local cfg = self.boxConfig[index + 1]
	local point = activityCommonDrawRead.activity_9001640_getPoint(cfg)
	obj:setString(string.formatnumberthousands(point))
end
function Activity_9001640_MainPanel:onClickBoxItem(EventContext)
	SoraDPlaySound()
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List_box:getChildIndex(obj)
	local cfg = self.boxConfig[childIndex + 1]
	local reward = activityCommonDrawRead.activity_9001640_getReward(cfg)
	_ENV = nil
	;(nil).activityID = self.activityID
	;(nil).point = activityCommonDrawRead.activity_9001640_getPoint(cfg)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	;(nil).rewards = serviceFunctions.tableFormat(reward, nil)
	;(nil).rewardDes = cfg.rewardDes
	uiManager:show("CommonStageReward", nil)
end
function Activity_9001640_MainPanel:updateAllianceScore(...)
	local activityData = activityCommonDrawCtrl:getActivityData(self.activityID)
	local score = activityData.allianceScore or 0
	if self.curScore == score then
		return
	end
	self.curScore = score
	activityCommonDrawCtrl = nil
	;(nil).num = string.formatnumberthousands(score)
	self.fields.Text_point:setString(i18n("phoenix_arrival_text_03", nil))
	local percent = SoraDGetStageValue(score, self.scoreList)
	self.fields.bar:setValue(percent)
	local boxCount = #self.boxConfig
	if 1 < boxCount then
		local totalW = self.fields.List_box:getWidth()
		local gap = math.floor((totalW - (boxCount + 1) * 80) / boxCount)
		self.fields.List_box:setColumnGap(gap)
	end
	self.fields.List_box:setNumItems(boxCount)
end
function Activity_9001640_MainPanel:updateItemCount(...)
	local itemCount = backpackCtrl:getItemCount(self.itemID)
	self.fields.Com_have:updateNum(itemCount)
	self:updateButtonDrawColor()
end
function Activity_9001640_MainPanel:updateAllianceState(...)
	if not allianceMgr:hasJoinAlliance() then
		self.fields.Button_draw:setBright(false)
		self.fields.Button_draw:setString(i18n("pyramid_text_02"))
	else
		self.fields.Button_draw:setBright(true)
		self.fields.Button_draw:setString(i18n("Eidal_feast_text_06"))
	end
	self:updateButtonDrawColor()
end
function Activity_9001640_MainPanel:updateButtonDrawColor(...)
	local itemCount = backpackCtrl:getItemCount(self.itemID)
	if allianceMgr:hasJoinAlliance() and itemCount <= 0 then
		self.fields.Button_draw:setTitleColor(cc.c3b(255, 0, 0))
	else
		self.fields.Button_draw:setTitleColor(cc.c3b(255, 251, 213))
	end
end
function Activity_9001640_MainPanel:onMsgCommonDrawUpdate(target, event)
	local subMsg = event.subMsg
	if subMsg == "init" then
		self:updateAllianceScore()
	elseif subMsg == "drawOne" then
		self:updateAllianceScore()
		self:updateItemCount()
		self.fields.Usm_draw:play()
	end
end
return Activity_9001640_MainPanel
