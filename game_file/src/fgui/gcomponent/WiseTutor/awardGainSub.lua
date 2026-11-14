local baseComponent = require("fgui.base.baseComponent")
local awardGainSub = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WiseTutor/awardGainSub", awardGainSub)
function awardGainSub:onInit()
	self.fields.Scroll_award:setItemRenderer(handler(self, self.onItemRender))
end
function awardGainSub:onShow()
end
function awardGainSub:initData(awards, isSpecial, normalText, specialText)
	self.awards = awards
	dump(awards, "awards")
	local normalTitle = normalText or "Battle_Towers_15"
	local specialTitle = specialText or "Battle_Towers_16"
	_ENV = nil
	;(nil).num = #awards
	self.fields.Text_Title:setString(i18n(isSpecial and specialTitle or normalTitle, nil))
	self.controllers.c1:setSelectedIndex(isSpecial and 1 or 0)
	self.fields.Scroll_award:setNumItems(#awards)
	self.fields.Scroll_award:resizeToFit(#awards)
end
function awardGainSub:onItemRender(index, object)
	object:initData(self.awards[index + 1].id, self.awards[index + 1].count)
end
return awardGainSub
