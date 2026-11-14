local BAR_LEN = 480
local baseComponent = require("fgui.base.baseComponent")
local Bar_review = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://NewHeroView/Bar_review", Bar_review)
function Bar_review:onInit()
	self:fixChildrenPos()
end
function Bar_review:onShow()
end
function Bar_review:setBar(oriVal, preVal, maxVal, isNoPreVal, len)
	if oriVal <= preVal then
		self.fields.bar_cur:setContentSize(cc.size((len or BAR_LEN) * (oriVal / maxVal), 24))
		self.fields.bar_pre:setContentSize(cc.size((len or BAR_LEN) * (preVal / maxVal), 24))
		self.fields.bar_cur:setAlpha(1.0)
		self.fields.bar_pre:setAlpha(0.5)
	else
		self.fields.bar_cur:setContentSize(cc.size((len or BAR_LEN) * (preVal / maxVal), 24))
		self.fields.bar_pre:setContentSize(cc.size((len or BAR_LEN) * (oriVal / maxVal), 24))
		self.fields.bar_cur:setAlpha(0.5)
		self.fields.bar_pre:setAlpha(1.0)
	end
end
return Bar_review
