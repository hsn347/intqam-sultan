local MAX_AWARD_NUM = 4
local baseComponent = require("fgui.base.baseComponent")
local allianceActiveLevelSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceActiveView/allianceActiveLevelSingle", allianceActiveLevelSingle)
function allianceActiveLevelSingle:onInit()
	self.awardArray, _ENV = nil, nil
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
end
function allianceActiveLevelSingle:onShow()
end
function allianceActiveLevelSingle:onItemRenderer(index, obj)
	obj:initData(self.awardArray[index + 1].id, self.awardArray[index + 1].count)
end
function allianceActiveLevelSingle:initData(data)
	self.data = data
	_ENV = nil
	;(nil).num = string.formatnumberthousands(self.data.activeNum[1])
	self.fields.Text_des:setString(i18n("alliance_text_26", nil))
	self.fields.Font_level:setString(self.data.index)
	_UPVALUE2_ = self.data.index
	self.data.index[1] = "id"
	self.data.index[2] = "count"
	self.awardArray = serviceFunctions.tableFormat(self.data.reward, self.data.index)
	self.fields.List_item:setNumItems(math.min(#self.awardArray, MAX_AWARD_NUM))
end
return allianceActiveLevelSingle
