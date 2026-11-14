local buffDesRead = include("buffDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Label_attrx = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://HeroWeapon/Label_attrx", Label_attrx)
function Label_attrx:onInit()
	self:fixChildrenPos()
	self.fields.arrow:setScaleX(SoraDFIsRA() and 0.55 or -0.55)
	self.fields.up:setVisible(false)
end
function Label_attrx:onShow()
end
function Label_attrx:initData(data)
	self.fields.Text_name:setString(buffDesRead.getTitleBase(data.id))
	self.controllers.c1:setSelectedIndex(data.isMax and 1 or 0)
	if data.type == 1 then
		if data.isMax then
			self.fields.Text_max:setString("+" .. data.result / 100 .. "%")
			self.fields.up:setVisible(false)
		else
			self.fields.Text_val:setString("+" .. data.result / 100 .. "%")
			self.fields.Text_pre:setString("+" .. data.pre / 100 .. "%")
			self.fields.up:setVisible(data.result ~= data.pre)
		end
	elseif data.isMax then
		self.fields.Text_max:setString("+" .. data.result)
		self.fields.up:setVisible(false)
	else
		self.fields.Text_val:setString("+" .. data.result)
		self.fields.Text_pre:setString("+" .. data.pre)
		self.fields.up:setVisible(data.result ~= data.pre)
	end
end
return Label_attrx
