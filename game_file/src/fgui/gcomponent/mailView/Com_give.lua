local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_give = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://mailView/Com_give", Com_give)
function Com_give:onInit()
	self.fields.Text_title:setString(i18n("common_text_307"))
	self.fields.Text_des:setString(i18n("common_text_993"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_Help:addClickListener(handler(self, self.onBtnHelp))
	self.fields.Button_Help:fixPos()
end
function Com_give:onShow()
end
function Com_give:onItemRenderer(index, obj)
	obj:initData(index + 1, self.itemList[index + 1])
end
function Com_give:init(itemID)
	self.itemID = itemID
	self.itemKey = self.itemID == 511701 and "pigeon_text_03" or "common_text_2800"
end
function Com_give:initData(itemList)
	self.itemList = itemList
	_ENV = nil
	;(nil).num = backpackCtrl:getItemCount(self.itemID)
	self.fields.Text_num:setString(i18n(self.itemKey, nil))
	self.fields.List:setNumItems(#self.itemList)
	local line = math.ceil(#self.itemList / 3)
	self.fields.List:setHeight(line * 115 + (line - 1) * 10)
end
function Com_give:onBtnHelp()
	SoraDPlaySound()
	uiManager:show("mailGivePersentHelp")
end
return Com_give
