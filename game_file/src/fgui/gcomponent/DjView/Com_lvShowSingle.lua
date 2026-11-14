local djRead = include("djRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_lvShowSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/Com_lvShowSingle", Com_lvShowSingle)
function Com_lvShowSingle:onInit()
	self.fields.List_reward:setItemRenderer(handler(self, self.itemRenderer_List_reward))
	self:fixChildrenPos()
end
function Com_lvShowSingle:onShow()
end
function Com_lvShowSingle:initData(data, tag)
	self.controllers.c1:setSelectedIndex(tag - 1)
	self.fields.bg:setVisible(data.index % 2 == 1)
	if tag == 1 then
		self.fields.Lab_lv:initData(data.lvMonth)
		local cfg = djRead.getMonthLvCfg(data.lvMonth)
		self.fields.Text_val:setString(string.formatnumberthousands(cfg.valueMonth))
		self.List_rewardData = cfg.rewardMonth
		self.fields.List_reward:setNumItems(#self.List_rewardData)
		self.fields.List_reward:setScrollEnable(#self.List_rewardData > 3)
	else
		local cfg = djRead.getLifeLvCfg(data.lvLife)
		self.fields.Text_val:setString(string.formatnumberthousands(cfg.valueLife))
		self.fields.Text_lv:setString(i18n(cfg.nameLife))
		self.fields.Text_lv:setColor(djRead.getColorByLv(data.lvLife, 2))
		self.fields.Lab_honor:setTitle(i18n(cfg.nameLife))
		self.fields.Lab_honor:setIcon(cfg.picLife)
	end
end
function Com_lvShowSingle:itemRenderer_List_reward(index, obj)
	local data = self.List_rewardData[index + 1]
	obj:initData(data.id, data.count)
end
return Com_lvShowSingle
