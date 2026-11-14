local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_decreeSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_decreeSingle", Com_decreeSingle)
function Com_decreeSingle:onInit()
	self.unlock_reward, _ENV, self.reward, _ENV = nil, nil, nil, nil
	self.fields.List_normal:setItemRenderer(handler(self, self.onItem1Renderer))
	self.fields.List_adv:setItemRenderer(handler(self, self.onItem2Renderer))
	self.fields.line1:fixPos()
	self.fields.line2:fixPos()
	self.fields.hw:fixPos()
	self.fields.Text_lv:fixPos()
	self.fields.List_normal:fixPos()
	self.fields.List_adv:fixPos()
	self.fields.nbg:fix()
end
function Com_decreeSingle:onItem1Renderer(index, obj)
	obj:initData(self.reward[index + 1], self.isAdd, self.lv)
end
function Com_decreeSingle:onItem2Renderer(index, obj)
	obj:initData(self.unlock_reward[index + 1], self.isAdd, self.lv, true)
end
function Com_decreeSingle:onShow()
end
function Com_decreeSingle:initData(data, isAdd)
	self.lv = data.lv
	self.isAdd = isAdd
	self.fields.Text_lv:setString(isAdd and string.format("%d+", data.lv) or data.lv)
	self.reward = data.reward
	self.unlock_reward = data.unlock_reward
	self.fields.List_normal:setNumItems(#self.reward)
	self.fields.List_adv:setNumItems(#self.unlock_reward)
	local curLv = roaringFlameWarCtrl:getDecreeLvExp()
	self.fields.Text_lv:setColor(curLv >= self.lv and cc.c3b(255, 203, 49) or cc.c3b(215, 195, 155))
end
return Com_decreeSingle
