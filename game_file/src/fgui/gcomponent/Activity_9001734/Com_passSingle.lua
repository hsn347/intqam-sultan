local activity_9001734_Ctrl = SoraDGetCtrl("activity_9001734_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_passSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001734/Com_passSingle", Com_passSingle)
function Com_passSingle:onInit()
	self.fields.List_normal:setItemRenderer(handler(self, self.itemRenderer_List_normal))
	self.fields.List_adv:setItemRenderer(handler(self, self.itemRenderer_List_adv))
	self.fields.List_senior:setItemRenderer(handler(self, self.itemRenderer_List_senior))
	self:fixChildrenPos()
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
	self.fields.List_senior:setNumItems(#self.data.premiumReward)
end
function Com_passSingle:itemRenderer_List_normal(index, obj)
	obj:initData(self.data.normalReward[index + 1].id, self.data.normalReward[index + 1].count)
	obj:setStatus(activity_9001734_Ctrl:getSignLvStatus(self.data.rewardID))
end
function Com_passSingle:itemRenderer_List_adv(index, obj)
	obj:initData(self.data.advanceReward[index + 1].id, self.data.advanceReward[index + 1].count)
	obj:setStatus(activity_9001734_Ctrl:getSignLvStatus(self.data.rewardID, true))
end
function Com_passSingle:itemRenderer_List_senior(index, obj)
	obj:initData(self.data.premiumReward[index + 1].id, self.data.premiumReward[index + 1].count)
	obj:setStatus(activity_9001734_Ctrl:getSignSeniorLvStatus(self.data.rewardID))
end
return Com_passSingle
