local baseComponent = require("fgui.base.baseComponent")
local Com_ML_HatchUp = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_HatchUp", Com_ML_HatchUp)
function Com_ML_HatchUp:onInit()
	self:fixChildrenPos()
	self.fields.items:setItemRenderer(handler(self, self.onItemsRender))
end
function Com_ML_HatchUp:onShow()
end
function Com_ML_HatchUp:initData(data, index)
	self.fields.bg:setVisible(index % 2 ~= 0)
	self.fields.desc:setString(data.desc)
	self.fields.items:setVisible(data.items ~= nil)
	self.fields.value:setVisible(data.items == nil)
	if data.items then
		self.items = data.items
		self.fields.items:setNumItems(#data.items)
	else
		self.fields.value:setString(data.value)
	end
	self.fields.icon:setVisible(data.icon ~= nil)
	self.fields.Com_ML_JinnSkill:setVisible(data.icon == nil)
	if data.icon ~= nil then
		self.fields.icon:setURL(data.icon)
	end
end
function Com_ML_HatchUp:onItemsRender(index, obj)
	local data = self.items[index + 1]
	obj:initData(data.id)
end
return Com_ML_HatchUp
