local equipDesRead = include("equipDesRead")
local baseComponent = require("fgui.base.baseComponent")
local List_suitSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/List_suitSingle", List_suitSingle)
function List_suitSingle:onInit()
	self.fields.btn_lookup:addClickListener(handler(self, self.btnLookUpClick))
	self.fields.List_suit:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
end
function List_suitSingle:onShow()
end
function List_suitSingle:onItemRenderer(index, obj)
	obj:initData(self.suitList[index + 1])
end
function List_suitSingle:initData(data)
	self.suitID = data.suitID
	self.suitList = data.suitList
	local suitName, propertyName = equipDesRead.getSuitTendencyByID(self.suitID)
	self.fields.Com_title:setString(i18n(suitName))
	self.fields.txt_suitAttribute:setString(string.format("%s%s", i18n("suit_text_01"), i18n(propertyName)))
	self.fields.List_suit:setNumItems(#self.suitList)
end
function List_suitSingle:btnLookUpClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).suitTag = self.suitID
	uiManager:show("suitInfoView", nil)
end
return List_suitSingle
