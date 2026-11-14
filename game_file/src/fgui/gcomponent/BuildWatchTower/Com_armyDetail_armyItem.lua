local baseComponent = require("fgui.base.baseComponent")
local Com_armyDetail_armyItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWatchTower/Com_armyDetail_armyItem", Com_armyDetail_armyItem)
function Com_armyDetail_armyItem:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(true)
	end
	self.fields.txtCount:setString(i18n("common_text_601"))
end
function Com_armyDetail_armyItem:onShow()
end
function Com_armyDetail_armyItem:initData(armyData)
	local armyDes = include("armyDesRead")
	local armyLogic = include("armyLogic")
	if -1 == armyData.num then
		self.fields.txtName:setString(armyDes.getName(armyData.id))
		self.fields.imgHead:setSpriteFrame(armyDes.getIcon(armyData.id))
		self.fields.imgLevel:setSpriteFrame(armyDes.getLvImg(armyData.id))
		self.fields.txtCount:setString("???")
	else
		self.fields.txtName:setString(armyDes.getName(armyData.id))
		self.fields.imgHead:setSpriteFrame(armyDes.getIcon(armyData.id))
		self.fields.txtCount:setString(string.formatnumberthousands(armyData.num))
		self.fields.imgLevel:setSpriteFrame(armyDes.getLvImg(armyData.id))
	end
	if self.fields.spriteWarLv then
		self.fields.spriteWarLv:setVisible(armyDes.getWarLv(armyData.id) > 0)
	end
	if self.fields.labelWarLv then
		self.fields.labelWarLv:setVisible(armyDes.getWarLv(armyData.id) > 0)
		self.fields.labelWarLv:setString(armyDes.getWarLv(armyData.id))
	end
end
return Com_armyDetail_armyItem
