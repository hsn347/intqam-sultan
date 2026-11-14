local gametop = gModuleMgr.getObject("gametop")
local chatCtrl = gametop.playertop_:getModule("chatCtrl")
local chatConst = include("chatConst")
local mailFunctions = include("mailFunctions")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local chatUnReadMgr = gChatMgrs:getMgr("chatUnReadMgr")
local chatDataMgr = gChatMgrs:getMgr("chatDataMgr")
local DjContentView = class("djContentView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("djContentView")
	end
	return target
end)
function DjContentView:ctor()
	self._isInit = false
	self.Com_djContentView = fguiHelper.createObject("DjView", "Com_djContentView")
	self:addChild(self.Com_djContentView)
	self.Com_djContentView:setPosition(0, -(display.height - 70))
	self.Com_djContentView:setSize(640, display.height - 70)
end
function DjContentView:onMessageListener()
end
function DjContentView:isInit()
	return self._isInit
end
function DjContentView:resetInit()
	self._isInit = false
end
function DjContentView:init(data)
	print("DjContentView:init")
	self.Com_djContentView:init(data)
	self._isInit = true
end
function DjContentView:updateView()
	self.Com_djContentView:update()
end
function DjContentView:initInputView(chatInputType)
	self.Com_djContentView:initInputView(chatInputType)
end
function DjContentView:setChatDelegate(chatDelegate)
	self.Com_djContentView:setChatDelegate(chatDelegate)
end
function DjContentView:onOffsetUI(data)
	dump(data, "chatContentView:onOpenEmotionUI(data)")
end
return DjContentView
