local starGiftCtrl = SoraDGetCtrl("starGiftCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Button_gift = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Anniversary2022/Button_gift", Button_gift)
function Button_gift:onInit()
	self.fields.Label_reddot:getController("c1"):setSelectedIndex(1)
	self:addClickListener(handler(self, self.onClickCube))
end
function Button_gift:initData(index, data, state, backFunc)
	self.index = index
	self.rid = data.rid
	self.fields.icon:setURL(data.icon)
	self.fields.icon:setScale(data.scale)
	self.fields.title:setString(i18n(data.des))
	self.backFunc = backFunc
	self.controllers.c1:setSelectedIndex(state - 1)
	self:setReddot(state)
	if state == 3 then
		self.fields.icon:setURL(data.iconOpen)
		self.fields.icon:setScale(data.openScale)
	end
	if index < 2 then
		self.controllers.c1:setSelectedIndex(1)
	end
end
function Button_gift:setReddot(state)
	if state == 1 then
		self.fields.Label_reddot:initData(false, 0)
		return
	end
	local s, num = starGiftCtrl:getGiftRewardNum(self.index)
	self.fields.Label_reddot:initData(s, num)
end
function Button_gift:onClickCube()
	SoraDPlaySound()
	self.backFunc(self.index)
end
function Button_gift:onShow()
end
return Button_gift
