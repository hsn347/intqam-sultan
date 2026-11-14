local baseComponent = require("fgui.base.baseComponent")
local Com_getWaySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonBoxSingle/Com_getWaySingle", Com_getWaySingle)
function Com_getWaySingle:onInit()
	self.fields.Text_item:fixPos()
	self.fields.Button_jump:fixPos()
	self.fields.Button_Gold:fixPos()
	self.fields.Button_Gold:addClickListener(handler(self, self.onClickBtn))
end
function Com_getWaySingle:initData(index, btnTitle, itemTitle, btnCallBack, param, notCloseSelf)
	self.notCloseSelf = notCloseSelf
	if not btnCallBack then
		self.fields.Button_jump:setVisible(false)
	else
		self.handle = btnCallBack
	end
	self.param = param
	if self.param and self.param.price then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Button_Gold:setCost(1001, self.param.price)
		self.fields.Button_Gold:setTitle(btnTitle)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self.fields.Button_jump:setTitle(btnTitle)
	print("itemTitle  " .. itemTitle)
	self.fields.Text_item:setString(itemTitle)
	self.fields.Button_jump:addClickListener(handler(self, self.onClickBtn))
end
function Com_getWaySingle:onClickBtn()
	self.handle(self.param)
	if not self.notCloseSelf then
		_ENV = self.param
		self.param.msg = "MESSAGE_COMMON_BOX_CLOSE"
		SoraDSendMessage(self.param)
	end
end
function Com_getWaySingle:setLineVisible(flag)
	self.fields.line:setVisible(flag)
end
function Com_getWaySingle:onShow()
end
return Com_getWaySingle
