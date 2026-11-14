local baseComponent = require("fgui.base.baseComponent")
local Com_tab3 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RomanSoulNew/Com_tab3", Com_tab3)
function Com_tab3:onInit()
end
function Com_tab3:initData(index, param)
	self:setTag(param.tag)
	self.fields.Text_title:setString(param.title)
	self.handle = param.handle
	self:addClickListener(handler(self, self.onClickTab))
end
function Com_tab3:onClickTab(eventContext)
	SoraDPlaySound()
	self.handle(tonumber(eventContext:getSender():getTag()))
end
function Com_tab3:setTitleColor(color)
	self.fields.Text_title:setColor(color)
end
function Com_tab3:setMask(flag)
	self.fields.btn_mask:setVisible(flag)
end
function Com_tab3:setGray(flag)
	self:setGrayed(flag)
end
function Com_tab3:onShow()
end
return Com_tab3
