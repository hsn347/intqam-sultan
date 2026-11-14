local divineBeastMarkRead = include("divineBeastMarkRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemDiveneBeastMark = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/Com_itemDiveneBeastMark", Com_itemDiveneBeastMark)
function Com_itemDiveneBeastMark:onInit()
	self.fields.list_element:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
end
function Com_itemDiveneBeastMark:onShow()
end
function Com_itemDiveneBeastMark:initData(markCfgOrId, lv, star, randomElement)
	local markCfg = markCfgOrId
	if type(markCfg) ~= "table" then
		markCfg = divineBeastMarkRead.getDbMarkCfg(markCfgOrId)
	end
	self.randomElement = randomElement or 0
	self.elements = markCfg.elements
	self.elements_lv = markCfg.elements_lv
	self.lv = lv or 0
	self.starLv = star or 0
	self.controllers.c1:setSelectedIndex(0 < self.starLv and 1 or 0)
	if 0 < self.starLv then
		self.fields.text_star:setString(self.starLv)
	end
	self.fields.list_element:setNumItems(#markCfg.elements)
	_ENV = nil
	;(nil).lv = self.lv
	self:getParent().fields.Text_lv:setString(i18n("common_text_100", nil))
end
function Com_itemDiveneBeastMark:hideSelf()
	self:setVisible(false)
	self:hideLv()
end
function Com_itemDiveneBeastMark:hideLv()
	self:getParent().fields.Text_lv:setVisible(false)
	self:getParent().fields.lv_bg:setVisible(false)
	self.controllers.c1:setSelectedIndex(0)
end
function Com_itemDiveneBeastMark:hideElement()
	self.fields.list_element:setVisible(false)
end
function Com_itemDiveneBeastMark:onItemRenderer(index, obj)
	local element = self.elements[index + 1]
	element = element == 5 and self.randomElement > 0 and self.randomElement or element
	obj:setIcon(divineBeastMarkRead.getElementIcon(element))
	obj:setGrayed((self.elements_lv[index + 1] or 0) > (self.lv or 0))
end
return Com_itemDiveneBeastMark
