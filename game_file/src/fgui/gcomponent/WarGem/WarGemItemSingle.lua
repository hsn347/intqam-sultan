local wargemResRead = include("wargemResRead")
local warGemltCtrl = include("warGemltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local WarGemItemSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WarGem/WarGemItemSingle", WarGemItemSingle)
function WarGemItemSingle:onInit()
	self:addClickListener(handler(self, self.onClick))
	self:resetItem()
	if not SoraDFIsRA() then
		self.fields.Image_num:fixPos()
		self.fields.Image_num:fix()
		self.fields.Text_num:fixPos()
		self.fields.Image_num_level:fixPos()
		self.fields.Image_num_level:fix()
		self.fields.Text_num_level:fixPos()
		self.fields.Image_new:fixPos()
		self.fields.aniArrowUp:fixPos()
	end
end
function WarGemItemSingle:onShow()
end
function WarGemItemSingle:resetItem(...)
	self.controllers.c_empty:setSelectedIndex(0)
	self.controllers.c_level:setSelectedIndex(1)
	self.controllers.c_new:setSelectedIndex(1)
	self.controllers.c_tag:setSelectedIndex(1)
end
function WarGemItemSingle:initData(data, pos)
	self.data = data
	self.pos = pos
	self:resetItem()
	if data then
		self.controllers.c_empty:setSelectedIndex(1)
		self.fields.imgBg:setSpriteFrame(wargemResRead.getBg(data.id))
		self.fields.Image_item:setSpriteFrame(wargemResRead.getIcon(data.id))
		self.fields.Text_num:setString(string.formatnumberthousands(data.count))
		if not warGemltCtrl:isEnchantedItem(data.id) then
			self.controllers.c_level:setSelectedIndex(0)
			local lv = wargemResRead.getLevel(data.id)
			self.fields.Text_num_level:setString("LV." .. lv)
		end
		if data.tag then
			self.controllers.c_tag:setSelectedIndex(0)
		end
		if data.new then
			self.controllers.c_new:setSelectedIndex(0)
		end
	end
end
function WarGemItemSingle:setSelected(val)
end
function WarGemItemSingle:setNewVisible(val)
end
function WarGemItemSingle:getItemData(...)
end
function WarGemItemSingle:onClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_BAG_ITEM_CHOOSE"
	;(nil).pos = self.pos
	;(nil).data = self.data
	SoraDSendMessage(nil)
end
return WarGemItemSingle
