local baseComponent = require("fgui.base.baseComponent")
local Com_List7 = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://newLordView/Com_List7", Com_List7)
function Com_List7:onInit()
	self:fixChildrenPos()
end
function Com_List7:onShow()
end
function Com_List7:initData(data)
	self.fields.icon:setSpriteFrame(SoraDFIsRA() and "frame_red_items_new_ar.png" or "frame_red_items_new.png")
	self.fields.icon:setVisible(data.isNew)
	_ENV = nil
	;(nil).des = data.des
	;(nil).num = fguiHelper.getColorString("#FFD246", data.numDes)
	self.fields.title:setString(i18n("%{des} %{num}", nil))
end
return Com_List7
