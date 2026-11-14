local activity_9001719_Ctrl = SoraDGetCtrl("activity_9001719_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_passSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001719/Com_passSingle", Com_passSingle)
function Com_passSingle:onInit()
	self.fields.List_normal:setItemRenderer(handler(self, self.onItem1Renderer))
	self.fields.List_adv:setItemRenderer(handler(self, self.onItem2Renderer))
	self.fields.Text_lv:fixPos()
	self.fields.List_normal:fixPos()
	self.fields.List_adv:fixPos()
	self.fields.bk:fix()
end
function Com_passSingle:onItem1Renderer(index, obj)
	obj:initData(self.data.normalReward[index + 1].id, self.data.normalReward[index + 1].count)
	obj:setStatus(activity_9001719_Ctrl:getSignLvStatus(self.data.lv))
end
function Com_passSingle:onItem2Renderer(index, obj)
	obj:initData(self.data.advanceReward[index + 1].id, self.data.advanceReward[index + 1].count)
	obj:setStatus(activity_9001719_Ctrl:getSignLvStatus(self.data.lv, true))
end
function Com_passSingle:onShow()
end
function Com_passSingle:initData(data)
	self.data = data
	self.fields.Text_lv:setString(self.data.lv)
	self.fields.List_normal:setNumItems(#self.data.normalReward)
	self.fields.List_adv:setNumItems(#self.data.advanceReward)
end
return Com_passSingle
