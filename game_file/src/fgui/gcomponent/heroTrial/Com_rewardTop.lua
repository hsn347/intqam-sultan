local baseComponent = require("fgui.base.baseComponent")
local Com_rewardTop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://heroTrial/Com_rewardTop", Com_rewardTop)
function Com_rewardTop:onInit()
	self.fields.title:setString(i18n("common_text_094"))
	self.fields.Text_tl:setString(i18n("common_text_124"))
	self.fields.Text_ss:setString(i18n("common_text_116"))
	self.fields.Text_js:setString(i18n("common_text_115"))
	self.fields.Text_ch:setString(i18n("common_text_117"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
end
function Com_rewardTop:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Com_rewardTop:onShow()
end
function Com_rewardTop:initData(isAttackWin, reward)
	self.controllers.c1:setSelectedIndex(isAttackWin and 0 or 1)
	if isAttackWin then
		self.reward = reward
		self.fields.List:setNumItems(#self.reward)
		self.fields.List:setHeight(math.ceil(#self.reward / 5) * 91)
	end
end
return Com_rewardTop
