local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_giftInfoSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewServerReturn/Com_giftInfoSingle", Com_giftInfoSingle)
function Com_giftInfoSingle:onInit()
	self:fixChildrenPos()
	if SoraDGetDefaultLanguage() ~= "ar" then
		self.fields.Effect_1:setScale(-1)
	end
	self:addLongPressListener(handler(self, self.onPressItemnfo))
end
function Com_giftInfoSingle:initData(index, v)
	self.itemID = v.id
	self.data = v
	self.fields.bg:setVisible(bit.band(index, 1) == 1 and true or false)
	if v.type == nil or v.type == "item" then
		self.fields.Text_itemName:setString(publicRead.getName(v.id))
		if publicRead.checkLevelCondition(v.id) then
			self.fields.Text_itemName:setColor(display.COLOR_RED)
		else
			self.fields.Text_itemName:setColor(cc.c3b(204, 189, 147))
		end
		if v.count then
			self.fields.Text_itemCount:setString("x" .. v.count)
		else
			self.fields.Text_itemCount:setString("x" .. v.num)
		end
		self.fields.Com_item:initData(v.id)
	elseif v.type == "buff" then
		self.fields.Text_itemName:setString(publicRead.getName(v.id))
		self.fields.Text_itemCount:setVisible(false)
		self.fields.Com_item:initData(v.id)
	end
	self.fields.Effect_1:setVisible(v.highlight and true or false)
end
function Com_giftInfoSingle:onPressItemnfo(button, startPos, endPos)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
	;(nil).id = self.itemID
	;(nil).num = self.data.num
	;(nil).pos = startPos
	;(nil).customName = nil
	;(nil).customTip = nil
	SoraDSendMessage(nil)
end
function Com_giftInfoSingle:onShow()
end
return Com_giftInfoSingle
