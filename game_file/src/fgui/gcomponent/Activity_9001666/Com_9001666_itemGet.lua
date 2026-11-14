local baseComponent = require("fgui.base.baseComponent")
local Com_9001666_itemGet = fgui.extension_class(fgui.GComponent, baseComponent)
local activity_9001666_Ctrl = SoraDGetCtrl("activity_9001666_Ctrl")
fgui.register_extension("ui://Activity_9001666/Com_9001666_itemGet", Com_9001666_itemGet)
function Com_9001666_itemGet:onInit()
	self:fixChildrenPos()
	self.fields.Button_go:addClickEventListener(handler(self, self.onGoClick))
end
function Com_9001666_itemGet:onShow()
end
function Com_9001666_itemGet:initData(data)
	self.data = data
	self.controllers.c1:setSelectedIndex(data.showType)
	self.fields.icon:setURL(data.icon)
	if data.showType == 0 then
		self.fields.Text_title:setString(data.title)
		self.fields.Text_des2:setString(data.desc)
		self.fields.Button_go:setTitle(i18n("NewYear_Gift_02"))
	else
		self.fields.Text_des:setString(data.desc)
		local isHaveFree = activity_9001666_Ctrl:getIsCanGetDailyFreeReward()
		self.fields.Button_go:setTitle(i18n(isHaveFree and "cavalryrise_text_06" or "common_text_1892"))
		self.fields.Button_go:setEnabled(isHaveFree)
	end
end
function Com_9001666_itemGet:onGoClick()
	SoraDPlaySound()
	if self.data.callback then
		self.data.callback(self.data)
	end
end
return Com_9001666_itemGet
