local baseComponent = require("fgui.base.baseComponent")
local Btn_operate = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://newLordView/Btn_operate", Btn_operate)
function Btn_operate:onInit()
	self.fields.new:setVisible(false)
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_operate:onShow()
end
function Btn_operate:initData(data)
	self.data = data
	self.fields.title:setString(self.data.title)
	self.fields.icon:setIcon(self.data.icon)
	self.fields.icon:setScale(self.data.scale or 1)
	self:setStatus(false)
end
function Btn_operate:getIndex()
	return self.data.index
end
function Btn_operate:setRed(ret)
	self.fields.Label_reddot:initData(ret, 0)
end
function Btn_operate:setStatus(isGray)
	self.controllers.c_status:setSelectedIndex(isGray and 1 or 0)
end
function Btn_operate:setNewRet(ret)
	self.fields.new:setVisible(ret)
end
function Btn_operate:btnClick()
	SoraDPlaySound()
	if self.data and self.data.handle then
		self.data.handle()
	end
end
return Btn_operate
