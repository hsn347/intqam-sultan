local baseComponent = require("fgui.base.baseComponent")
local Com_guideTips = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_guideTips", Com_guideTips)
function Com_guideTips:onInit()
	self:setVisible(false)
end
function Com_guideTips:onShow()
end
function Com_guideTips:setString(tips)
	self.fields.title:setString(tips)
	if self.widthMax then
		self:updateWidthMax(self.widthMax)
	end
end
function Com_guideTips:updateWidthMax(widthMax)
	if widthMax < self.fields.title:getContentSize().width then
		self.fields.title:setSize(cc.size(widthMax, 0))
		self.fields.title:setAutoSize(fgui.AutoSizeType.HEIGHT)
	end
end
function Com_guideTips:initMLData(data)
	self:setVisible(false)
	_ENV = false
	;(false).byUID = true
	local hasShowGuideTips = SoraDConfigGet("Game:Com_ML_BlessDetials:hasShowGuideTips~bool", false)
	if hasShowGuideTips then
		return
	end
	if not data.showTips then
		return
	end
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:Com_ML_BlessDetials:hasShowGuideTips~bool", true, nil)
	self:setVisible(true)
	self.widthMax = data.widthMax
	self:setString(data.tips)
	self.transitions.t0:play()
end
return Com_guideTips
