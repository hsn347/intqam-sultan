local activity_9001736_Read = include("activity_9001736_Read")
local activity_9001736_Ctrl = SoraDGetCtrl("activity_9001736_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001736_ActionPanel = class("Activity_9001736_ActionPanel", baseFguiPanel)
function Activity_9001736_ActionPanel:ctor(...)
	self.isLRU = true
	Activity_9001736_ActionPanel.super.ctor(self, ...)
	print("Activity_9001736_ActionPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001736
end
function Activity_9001736_ActionPanel:getPackageList()
	_UPVALUE1_ = nil
	;(nil)[1] = "Activity_9001736_Action"
	return nil
end
function Activity_9001736_ActionPanel:onInit()
	print("=======Activity_9001736_ActionPanel:onInit")
	self.fields.Text_tip:setString(i18n("football_match_text_086"))
	self.transitions.t_start:setHook("start", handler(self, self.showGameStart))
end
function Activity_9001736_ActionPanel:endShow()
	print("=======Activity_9001736_ActionPanel:endShow")
	self.isWin = self.param.isWin or false
	local resultStr = self.isWin and i18n("football_match_text_087") or i18n("football_match_text_088")
	self.fields.Text_result:setString(resultStr)
	local nodeIdx = self.param.nodeIdx or math.random(1, 3)
	self.fields.Node_action:setURL("ui://Activity_9001736_Action/Node_" .. nodeIdx)
	self.Node_component = self.fields.Node_action:getComponent()
	local needFlip = not self.isWin
	if nodeIdx == 3 then
		needFlip = self.isWin
	end
	self.Node_component:setFlippedY(needFlip)
	local __ALL__ = self.Node_component:getTransition("__ALL__")
	__ALL__:play()
	__ALL__:setPaused(true)
	local _fields = fguiHelper.get_fields(self.Node_component)
	local mv_football = _fields.football:getChild("mv_football")
	self.mv_football = mv_football
	self.mv_football:setAllFrameName("an_2026sjbbs_%02d.png", 1)
	if _fields.activity_bg then
		_fields.activity_bg:setVisible(false)
	end
	if not self.param.seedList then
		_UPVALUE8_ = self.param.seedList
		self.param.seedList[1] = 34011
		self.param.seedList[2] = 34021
		self.param.seedList[3] = 34031
		self.param.seedList[4] = 34041
		self.param.seedList[5] = 34051
		self.param.seedList[6] = 34061
		self.param.seedList[7] = 34071
		local self.param.seedList[8], enemySeedList = 34081, self.param.seedList
	end
	local selfSeedList = activity_9001736_Ctrl:getBattleSeedList()
	for i = 1, 8 do
		local obj1 = _fields[string.format("Z_%02d", i)]
		local seedID = selfSeedList[i]
		local imageName = activity_9001736_Read.getSeedImage(seedID)
		obj1:setIcon(imageName)
		obj1:setFlippedY(needFlip)
		local obj2 = _fields[string.format("F_%02d", i)]
		local seedID = enemySeedList[i]
		local imageName = activity_9001736_Read.getSeedImage(seedID)
		obj2:setIcon(imageName)
		obj2:setFlippedY(needFlip)
		local qiuyi1 = obj1:getChild("frame_9001736_qiuyi1")
		local qiuyi2 = obj2:getChild("frame_9001736_qiuyi2")
		if needFlip then
			qiuyi1:setURL("frame_9001736_qiuyi2.png")
			qiuyi2:setURL("frame_9001736_qiuyi1.png")
		else
			qiuyi1:setURL("frame_9001736_qiuyi1.png")
			qiuyi2:setURL("frame_9001736_qiuyi2.png")
		end
	end
	local posY = self:getHeight() / 2
	if needFlip then
		posY = posY + 112
	end
	self.fields.Node_action:setPositionY(posY)
end
function Activity_9001736_ActionPanel:showGameStart()
	local __ALL__ = self.Node_component:getTransition("__ALL__")
	__ALL__:play(function()
		self = nil
		;(nil).activityID = self.activityID
		if not self.param.rewards then
			self = self.param.rewards
		end
		local (nil).rewards, param = self.param.rewards, nil
		local score = self.param.score or 0
		if 0 < score then
			self = nil
			;(nil).num = score
			local tipStr = i18n("football_match_text_090", nil)
			param.tipStr = tipStr
			uiManager:show("Activity_9001735_win", param)
		else
			self = uiManager
			uiManager.num = score
			local tipStr = i18n("football_match_text_091", uiManager)
			param.tipStr = tipStr
			uiManager:show("Activity_9001735_lose", param)
		end
		self:closePanel()
	end)
end
return Activity_9001736_ActionPanel
