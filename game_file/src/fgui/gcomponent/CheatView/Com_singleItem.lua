local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_singleItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CheatView/Com_singleItem", Com_singleItem)
function Com_singleItem:onInit()
	self.fields.Text_name:setAlign(0)
	self:addClickListener(handler(self, self.btnClick))
end
function Com_singleItem:onShow()
end
function Com_singleItem:initData(id, style)
	self.id = id
	self.style = style
	if self.id then
		self:setVisible(true)
		self.fields.Com_item:initData(self.id)
		self.fields.Com_item:setTouchEnabled(self.style == 1)
		self.fields.Text_id:setString(self.id)
		if self.style == 3 then
			local armyDesRead = include("armyDesRead")
			local armyLogic = include("armyLogic")
			local alv = armyLogic.getArmyLV(self.id)
			local wlv = armyDesRead.getWarLv(self.id)
			if math.floor(self.id / 100) == 8 then
				alv = armyLogic.getTrapLV(self.id)
			end
			if 0 < wlv then
				self.fields.Text_name:setString("战" .. wlv .. " Lv." .. alv .. armyDesRead.getName(self.id))
			else
				self.fields.Text_name:setString("Lv." .. alv .. armyDesRead.getName(self.id))
			end
		else
			self.fields.Text_name:setString(publicRead.getName(self.id))
		end
	else
		self:setVisible(false)
	end
end
function Com_singleItem:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemId = self.id
	;(nil).style = self.style
	uiManager:show("CheatItemGetView", nil)
end
return Com_singleItem
