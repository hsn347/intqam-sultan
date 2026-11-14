local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local autokillSetItemSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://autokill/autokillSetItemSingle", autokillSetItemSingle)
function autokillSetItemSingle:onInit()
	self.fields.slider:setSliderCallBack(handler(self, self.sliderChange))
	self.fields.slider:setInpuBoxFixPos()
	self:fixChildrenPos()
end
function autokillSetItemSingle:onShow()
end
function autokillSetItemSingle:initData(data)
	self.data = data
	self.fields.item:initData(self.data.id)
	self.fields.Text_name:setString(publicRead.getName(self.data.id))
	self.fields.Com_inp:getChildByName("Text_input"):setString(self.data.num)
	self.fields.Com_inp:getChildByName("Text_totalCount"):setString("/" .. self.data.count)
	publicRead = "/" .. self.data.count
	;("/" .. self.data.count).maxValue = self.data.count
	;("/" .. self.data.count).minValue = 0
	;("/" .. self.data.count).curValue = self.data.num
	;("/" .. self.data.count).allowZero = true
	self.fields.slider:initData("/" .. self.data.count)
end
function autokillSetItemSingle:sliderChange(value)
	self.fields.Com_inp:getChildByName("Text_input"):setString(value)
	_ENV = self.fields.Com_inp:getChildByName("Text_input")
	self.fields.Com_inp:getChildByName("Text_input").msg = "MESSAGE_UI_AUTO_KILL_ITEM_SET"
	self.fields.Com_inp:getChildByName("Text_input").id = self.data.id
	self.fields.Com_inp:getChildByName("Text_input").count = value
	SoraDSendMessage((self.fields.Com_inp:getChildByName("Text_input")))
end
return autokillSetItemSingle
