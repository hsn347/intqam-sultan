local beastCanyonCtrl = SoraDGetCtrl("beastCanyonCtrl")
local beastCanyonRead = include("beastCanyonRead")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BeastCanyonMainPanel = class("BeastCanyonMainPanel", baseFguiPanel)
function BeastCanyonMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("BeastCanyonMainPanel:ctor", self.viewName)
end
function BeastCanyonMainPanel:onInit()
	print("=======BeastCanyonMainPanel:onInit")
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	_ENV = handler(self, self.onClickHelp)
	handler(self, self.onClickHelp).time = constantRead.getConstValue("DIVINEBEASTCANYON_ADD_TIME", 7200) / 3600
	self.fields.Text_TimeTip:setString(i18n("Divinebeastcanyon_text_4", handler(self, self.onClickHelp)))
	self.fields.Label_TimeLeft:getChild("Button_Add"):addClickListener(handler(self, self.onClickAdd))
	self.fields.Button_Task:setString(i18n("common_text_2078"))
	self.fields.Button_Task:addClickListener(handler(self, self.onClickTask))
	self.fields.Button_Exchange:setString(i18n("common_text_1889"))
	self.fields.Button_Exchange:addClickListener(handler(self, self.onClickExchange))
	self.fields.Label_TimeLeft:getChild("Button_Add"):fixPos()
	self.fields.Label_TimeLeft:getChild("title"):fixPos()
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		self.controllers.c_viewType:setSelectedIndex(1)
	else
		self.controllers.c_viewType:setSelectedIndex(0)
	end
end
function BeastCanyonMainPanel:endShow()
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		local guideCtrl = SoraDGetCtrl("guideCtrl")
		guideCtrl:updateGuideModule(gGuideModule.ELITE_DIVINE_BEAST_CANYON)
	else
		self:runAction(ffa.seq(ffa.delay(0.2), ffa.callFunc(function()
			local guideCtrl = SoraDGetCtrl("guideCtrl")
			guideCtrl:updateGuideModule(gGuideModule.DIVINE_BEAST_CANYON)
		end)))
	end
end
function BeastCanyonMainPanel:onShow()
	print("=======BeastCanyonMainPanel:onShow")
	SoraDShowLoading(self)
	beastCanyonCtrl:sendReqInitDataMsg(self.activityID)
	for i, v in ipairs(beastCanyonRead.getBossConfig(self.activityID)) do
		self.fields["Com_Entrance" .. i]:initData(self.activityID, v)
	end
	self:updateChallenge()
end
function BeastCanyonMainPanel:updateBossEnter()
	for i = 1, 3 do
		self.fields["Com_Entrance" .. i]:updateStatus()
	end
end
function BeastCanyonMainPanel:updateTaskRed()
	if tolua.isnull(self) then
		return
	end
	local btnTask = self.fields and self.fields.Button_Task
	if not btnTask or tolua.isnull(btnTask) then
		return
	end
	btnTask:setReddot(beastCanyonCtrl:getTaskStatusAndNum(self.activityID))
end
function BeastCanyonMainPanel:updateChallenge()
	self.challengeNum = beastCanyonCtrl:getChallengeTimes(self.activityID)
	beastCanyonCtrl = nil
	beastCanyonCtrl, beastCanyonCtrl, (nil).num = nil, self.challengeNum, self.challengeNum
	beastCanyonCtrl, self.challengeNum.num, (nil).color = nil, nil, self.challengeNum > 0 and "#FFFBD5" or "#FF0000"
	self.challengeNum.__default, (nil).color = nil, "#FFFBD5"
	self.fields.Label_TimeLeft:setString(i18n_html("Divinebeastcanyon_text_5", nil, self.challengeNum))
end
function BeastCanyonMainPanel:onClickExchange()
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("BeastCanyonExchange", nil)
end
function BeastCanyonMainPanel:onClickTask()
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.activityID
	uiManager:show("BeastCanyonTask", nil)
end
function BeastCanyonMainPanel:onClickAdd()
	SoraDPlaySound()
	local buyNum = beastCanyonCtrl:getBuyTimes(self.activityID)
	local max = constantRead.getConstValue("DIVINEBEASTCANYON_BASE_BUYNUM", 5)
	if buyNum >= max then
		SoraDShowMsgTip(i18n("Divinebeastcanyon_text_6"))
	else
		_ENV = i18n("Divinebeastcanyon_text_6")
		i18n("Divinebeastcanyon_text_6").activityID = self.activityID
		uiManager:show("BeastCanyonBuyPop", i18n("Divinebeastcanyon_text_6"))
	end
end
function BeastCanyonMainPanel:onClickHelp()
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001650 then
		_ENV = nil
		_ENV = nil
		;(nil).num = constantRead.getConstValue("ELITEBEASTCANYON_BASE_NUM", 3)
		;(nil).time = constantRead.getConstValue("ELITEBEASTCANYON_ADD_TIME", 7200) / 3600
		;(nil).buy = constantRead.getConstValue("ELITEBEASTCANYON_BASE_BUYNUM", 5)
		;(nil).content = i18n("Divinebeastcanyon_text_2", nil)
		uiManager:show("RuleView", nil)
	else
		_ENV = nil
		_ENV = nil
		;(nil).num = constantRead.getConstValue("DIVINEBEASTCANYON_BASE_NUM", 3)
		;(nil).time = constantRead.getConstValue("DIVINEBEASTCANYON_ADD_TIME", 7200) / 3600
		;(nil).buy = constantRead.getConstValue("DIVINEBEASTCANYON_BASE_BUYNUM", 5)
		;(nil).content = i18n("Divinebeastcanyon_text_2", nil)
		uiManager:show("RuleView", nil)
	end
end
function BeastCanyonMainPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "Com_Entrance" then
		for i = 1, 3 do
			if self.fields["Com_Entrance" .. i]:checkOpen() then
				return self.fields["Com_Entrance" .. i]
			end
		end
	end
	return self.fields[itemName]
end
return BeastCanyonMainPanel
