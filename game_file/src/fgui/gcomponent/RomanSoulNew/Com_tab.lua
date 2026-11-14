local baseComponent = require("fgui.base.baseComponent")
local Com_tab = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RomanSoulNew/Com_tab", Com_tab)
function Com_tab:onInit()
end
function Com_tab:initData(index, param)
	self:setTag(param.tag)
	self.fields.Text_title:setString(param.title)
	self.handle = param.handle
	self.parent = param.parent
	self:addClickListener(handler(self, self.onClickTab))
end
function Com_tab:onClickTab(eventContext)
	SoraDPlaySound()
	if self.parent then
		self.handle(self.parent, tonumber(eventContext:getSender():getTag()))
	else
		self.handle(tonumber(eventContext:getSender():getTag()))
	end
end
function Com_tab:setTitleColor(color)
	self.fields.Text_title:setColor(color)
end
function Com_tab:setMask(flag)
	self.fields.btn_mask:setVisible(flag)
end
function Com_tab:setGray(flag)
	self:setGrayed(flag)
end
function Com_tab:onShow()
end
return Com_tab
