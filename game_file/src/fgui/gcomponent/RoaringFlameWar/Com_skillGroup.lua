local baseComponent = require("fgui.base.baseComponent")
local Com_skillGroup = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlameWar/Com_skillGroup", Com_skillGroup)
function Com_skillGroup:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function Com_skillGroup:onItemRenderer(index, obj)
	obj:initData(self.data[index + 1])
end
function Com_skillGroup:onItemRenderer2(index, obj)
	obj:initData(self.data[index + 1], self.curSkillId, self.warType)
end
function Com_skillGroup:onShow()
end
function Com_skillGroup:initData(data, index, sortType)
	self.data = data
	local qConfig = gAtlantisQualityConfig[index]
	if sortType == 1 then
		self.fields.title:setString(i18n(qConfig.qName))
		self.fields.title:setColor(qConfig.color)
	else
		self.fields.title:setString(i18n(qConfig.tName))
		self.fields.title:setColor(cc.c3b(215, 195, 155))
	end
	self.fields.List:setNumItems(#self.data)
	self.fields.List:resizeToFit(#self.data)
end
function Com_skillGroup:initData2(data, index, sortType, curSkillId, warType)
	self.curSkillId = curSkillId
	self.warType = warType
	self.fields.List:setDefaultItem("ui://RoaringFlameWar/Node_skillSingle2")
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer2))
	self.fields.List:setLineGap(38)
	self:initData(data, index, sortType)
end
return Com_skillGroup
