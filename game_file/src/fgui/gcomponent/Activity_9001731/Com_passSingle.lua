local activity_9001731_Ctrl = SoraDGetCtrl("activity_9001731_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_passSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001731/Com_passSingle", Com_passSingle)
function Com_passSingle:onInit()
	self.fields.List_normal:setItemRenderer(handler(self, self.itemRenderer_List_normal))
	self.fields.List_adv:setItemRenderer(handler(self, self.itemRenderer_List_adv))
	self:fixChildrenPos()
	self.fields.bg:fix()
end
function Com_passSingle:onShow()
end
function Com_passSingle:initData(data)
	self.data = data
	self.fields.Text_lv:setString(self.data.lv)
	self.fields.List_normal:setNumItems(#self.data.normalReward)
	self.fields.List_adv:setNumItems(#self.data.advanceReward)
	self.fields.cur:setVisible(activity_9001731_Ctrl:getLoginDay() == self.data.lv)
end
function Com_passSingle:itemRenderer_List_normal(index, obj)
	obj:initData(self.data.normalReward[index + 1].id, self.data.normalReward[index + 1].count)
	obj:setStatus(activity_9001731_Ctrl:getSignLvStatus(self.data.lv))
end
function Com_passSingle:itemRenderer_List_adv(index, obj)
	obj:initData(self.data.advanceReward[index + 1].id, self.data.advanceReward[index + 1].count)
	obj:setStatus(activity_9001731_Ctrl:getSignLvStatus(self.data.lv, true))
end
return Com_passSingle
