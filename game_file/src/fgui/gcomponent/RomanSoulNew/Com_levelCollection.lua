local gametop = gModuleMgr.getObject("gametop")
local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_levelCollection = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RomanSoulNew/Com_levelCollection", Com_levelCollection)
function Com_levelCollection:onInit()
	self:addEventListener(fgui.UIEventType.Scroll, handler(self, self.showScrollIcon))
end
function Com_levelCollection:initData(lvData)
	self.lvData = lvData
	self.fields.List_level:setItemRenderer(handler(self, self.onItemRendererLevel))
	self.fields.List_level:setNumItems(table.nums(self.lvData) - 1)
	self.fields.Com_special:initData(10, self.lvData[1])
	self.pan = self:getScrollPane()
	self.pan:scrollTop()
end
function Com_levelCollection:onItemRendererLevel(index, object)
	object:initData(index + 1, self.lvData[10 - index])
end
function Com_levelCollection:showScrollIcon()
	if self:getScrollPane():getPercY() > 0.98 then
		_ENV = self:getScrollPane()
		self:getScrollPane().msg = "MESSAGE_ROMAN_SCROLL_TO_BOTTOM"
		self:getScrollPane().show = false
		SoraDSendMessage((self:getScrollPane()))
	else
		_ENV = self:getScrollPane()
		self:getScrollPane().msg = "MESSAGE_ROMAN_SCROLL_TO_BOTTOM"
		self:getScrollPane().show = true
		SoraDSendMessage((self:getScrollPane()))
	end
end
function Com_levelCollection:addRemindToManager(value)
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:romanChallengeSelectedView:effect~integer", value, nil)
end
function Com_levelCollection:checkNeedRemindOnce(activityID)
	local phase = romeActivityCtrl:getActNthPhase()
	romeActivityCtrl = nil
	;(nil).byUID = true
	local lastPhase = SoraDConfigGet("Game:romanChallengeSelectedView:effect~integer", nil) or -1
	print("phase .." .. phase)
	print("lastPhase .." .. lastPhase)
	if lastPhase == -1 or phase == lastPhase then
		return true
	else
		return false
	end
end
function Com_levelCollection:onShow()
end
return Com_levelCollection
