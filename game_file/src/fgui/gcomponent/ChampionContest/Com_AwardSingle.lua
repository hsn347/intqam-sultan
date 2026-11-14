local baseComponent = require("fgui.base.baseComponent")
local Com_AwardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ChampionContest/Com_AwardSingle", Com_AwardSingle)
function Com_AwardSingle:onInit()
	self:fixChildrenPos()
	self.fields.List_Award:setItemRenderer(handler(self, self.onItemRederer))
end
function Com_AwardSingle:onShow()
end
function Com_AwardSingle:initData(award, label)
	self.fields.title:setString(label)
	_UPVALUE2_ = label
	label[1] = "id"
	label[2] = "count"
	self.awardList = serviceFunctions.tableFormat(award, label)
	self.fields.List_Award:setNumItems(#self.awardList)
end
function Com_AwardSingle:onItemRederer(index, target)
	target:initData(self.awardList[index + 1].id, self.awardList[index + 1].count)
end
return Com_AwardSingle
