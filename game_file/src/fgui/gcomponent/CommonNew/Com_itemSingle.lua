local publicRead = include("publicRead")
local armyDesRead = include("armyDesRead")
local wargemResRead = include("wargemResRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_itemSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_itemSingle", Com_itemSingle)
function Com_itemSingle:onInit()
	self:fixChildrenPos()
end
function Com_itemSingle:onShow()
end
function Com_itemSingle:initData(data, itemType)
	self.fields.item:initData(data.itemID)
	self.fields.Text_name:setString(publicRead.getName(data.itemID))
	self.fields.Text_num:setString("+" .. string.formatnumberthousands(data.itemCount))
	if itemType then
		if itemType == gItemType.RECRUIT_SOLDIERS then
			self.fields.item:setIcon(armyDesRead.getIcon(data.itemID))
			self.fields.Text_name:setString(armyDesRead.getName(data.itemID))
		elseif itemType == gItemType.WAR_GEM then
			self.fields.item:setQualityIcon(wargemResRead.getBg(data.itemID))
			self.fields.item:setIcon(wargemResRead.getIcon(data.itemID))
			local name = wargemResRead.getName(data.itemID)
			local level = wargemResRead.getLevel(data.itemID)
			publicRead = wargemResRead.getIcon(data.itemID)
			wargemResRead.getIcon(data.itemID).name = name
			wargemResRead.getIcon(data.itemID).lv = level
			self.fields.Text_name:setString(i18n("common_text_099", wargemResRead.getIcon(data.itemID)))
		end
	end
end
return Com_itemSingle
