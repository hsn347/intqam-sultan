local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_item_ice2 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://IceFestival/Com_item_ice2", Com_item_ice2)
function Com_item_ice2:onInit()
	self:addLongPressListener(handler(self, self.onLongPress))
	self.fields.Image_quality:getChild("n20"):setTexture("SinglePicture/G_round.png")
end
function Com_item_ice2:onLongPress(button, startPos, endPos)
	self.isLong = true
	SoraDPlaySound()
	print("self.itemId ====== ", self.id)
	_ENV = "self.itemId ====== "
	;("self.itemId ====== ").msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
	;("self.itemId ====== ").id = self.id
	;("self.itemId ====== ").num = self.num
	;("self.itemId ====== ").pos = startPos
	;("self.itemId ====== ").customName = self.customName
	;("self.itemId ====== ").customTip = self.customTip
	SoraDSendMessage("self.itemId ====== ")
end
function Com_item_ice2:onShow()
end
function Com_item_ice2:initData(id, num)
	print("reward.id", id, num)
	if id == nil or id == 0 then
		self.fields.Image_quality:setIcon("ui://CommonNew/frame_item_base_01")
		self.fields.Image_icon:setVisible(false)
		self.fields.Text_num:setString("")
		return
	end
	self.id = id
	self.num = num or 0
	local qualityPng = publicRead.getBg(self.id)
	self.fields.Image_quality:setIcon(qualityPng)
	local iconPng = publicRead.getIcon(self.id)
	self.fields.Image_icon:setURL(iconPng)
	self.fields.Text_num:setString(self.num)
end
return Com_item_ice2
