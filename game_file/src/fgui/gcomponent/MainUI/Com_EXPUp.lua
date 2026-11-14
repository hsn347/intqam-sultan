local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_EXPUp = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Com_EXPUp", Com_EXPUp)
function Com_EXPUp:onInit()
	self.fields.Effect_1:setIsLoop(false)
end
function Com_EXPUp:onShow()
end
function Com_EXPUp:playAct(addEXP)
	local lordInfo = lordInfoCtrl:getBaseInfo()
	local isReachFullExp = lordInfo.isReachFullExp
	if isReachFullExp then
		self:setVisible(false)
		return
	end
	self:setScaleY(0)
	self:setVisible(true)
	lordInfoCtrl = nil
	;(nil).exp = addEXP
	local str = tostring(i18n("common_text_918", nil))
	self.fields.title:setString(str)
	self.fields.n1:fixPos()
	self.fields.title:fixPos()
	_UPVALUE5_ = self.fields.title
	self.fields.title[1] = ffa.scaleTo(0.25, 1, 1)
	self.fields.title[2] = ffa.delay(0.2)
	self.fields.title[3] = ffa.callFunc(function()
		self.fields.Effect_1:playOnce()
	end)
	self.fields.title[4] = ffa.delay(1.2)
	self.fields.title[5] = ffa.scaleTo(0.25, 1, 0)
	self.fields.title[6] = ffa.callFunc(function()
		self:setVisible(false)
	end)
	self.fields.title[7] = ffa.callFunc(function()
		self:setVisible(false)
	end)
	self.fields.title[8] = ffa.callFunc(function()
		self:setVisible(false)
	end)
	local seq = ffa.seq(self.fields.title)
	self:runAction(seq)
end
return Com_EXPUp
