local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local dailyRemindManager = include("dailyRemindManager")
local baseComponent = require("fgui.base.baseComponent")
local Com_challengeCol = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RomanSoulNew/Com_challengeCol", Com_challengeCol)
function Com_challengeCol:onInit()
	self.diffLVTbl = require("app." .. LocalTblPath .. ".config_client.romanSoulDiffLevel")
	local alliance = allianceMgr:getAlliance()
	self.limitLevel = alliance and alliance:getProperty("open_level") or 1
	self.time = 0.1
end
function Com_challengeCol:initData()
	local index
	for index = 1, 10 do
		self:getChildAt(index - 1):initData(index, index <= self.limitLevel, self.diffLVTbl[index], self.limitLevel)
	end
	local pan = self:getScrollPane()
	self.showFlag = true
	local key = dailyRemindManager.REMIND_TYPE.romanSoulChallengeEnter
	if dailyRemindManager.checkNeedRemind(key) then
		dailyRemindManager.addRemindToManager(key)
		self:scrollAnimate()
	else
		local offset = self:getChildAt(self.limitLevel - 1):getPositionY() - (display.height / 2 - 187)
		pan:setPosY(offset)
		pan:updatePositionImmediately()
		self:getChildAt(self.limitLevel - 1):showUpAni()
	end
	pan:setSnapToItem(true)
end
function Com_challengeCol:scrollAnimate()
	local pan = self:getScrollPane()
	local offset = self:getChildAt(self.limitLevel - 1):getPositionY() - (display.height / 2 - 187)
	local time = self.time * self.limitLevel
	fgui.GTween:to(0, offset, time):onUpdate(function(tweener)
		local v = tweener.value.x
		pan:setPosY(v)
		pan:updatePositionImmediately()
		if self.showFlag and v > offset * 0.9 then
			self.showFlag = false
			self:getChildAt(self.limitLevel - 1):showUpAni()
		end
	end):setTarget(self)
end
function Com_challengeCol:onShow()
end
return Com_challengeCol
