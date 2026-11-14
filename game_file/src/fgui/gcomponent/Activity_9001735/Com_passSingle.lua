local activity_9001735_Ctrl = SoraDGetCtrl("activity_9001735_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_passSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001735/Com_passSingle", Com_passSingle)
function Com_passSingle:onInit()
	self.fields.List_normal:setItemRenderer(handler(self, self.itemRenderer_List_normal))
	self.fields.List_adv:setItemRenderer(handler(self, self.itemRenderer_List_adv))
	self:fixChildrenPos()
	self.fields.n1:fix()
	self.fields.n2:fix()
end
function Com_passSingle:onShow()
end
function Com_passSingle:initData(data)
	self.data = data
	self.fields.n1:setVisible(self.data.rewardID % 2 ~= 0)
	self.fields.n2:setVisible(self.data.rewardID % 2 == 0)
	self.fields.title:setString(self.data.rewardID)
	self.fields.List_normal:setNumItems(#self.data.normalReward)
	self.fields.List_adv:setNumItems(#self.data.advanceReward)
end
function Com_passSingle:itemRenderer_List_normal(index, obj)
	obj:initData(self.data.normalReward[index + 1].id, self.data.normalReward[index + 1].count)
	obj:setStatus(activity_9001735_Ctrl:getSignLvStatus(self.data.rewardID))
end
function Com_passSingle:itemRenderer_List_adv(index, obj)
	obj:initData(self.data.advanceReward[index + 1].id, self.data.advanceReward[index + 1].count)
	obj:setStatus(activity_9001735_Ctrl:getSignLvStatus(self.data.rewardID, true))
end
return Com_passSingle
