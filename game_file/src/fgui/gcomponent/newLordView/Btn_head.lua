local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_head = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://newLordView/Btn_head", Btn_head)
function Btn_head:onInit()
	self.itemID = 500201
	self.needGold = 400
	self.fields.title:setString(i18n("common_text_360"))
end
function Btn_head:onShow()
end
function Btn_head:initData(ret)
	if ret then
		self.controllers.c1:setSelectedIndex(1)
		self.haveItem = backpackCtrl:getItemCount(self.itemID) > 0
		if self.haveItem then
			self.fields.Icon_gold:setSpriteFrame(publicRead.getIcon(self.itemID))
			self.fields.Text_gold:setString("1")
		else
			self.fields.Icon_gold:setSpriteFrame(publicRead.getIcon(gIDDef.GOLD))
			self.fields.Text_gold:setString(self.needGold)
		end
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
return Btn_head
