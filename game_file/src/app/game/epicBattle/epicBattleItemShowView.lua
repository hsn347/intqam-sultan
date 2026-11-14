local publicRead = include("publicRead")
local epicBattleItemShowView = class("epicBattleItemShowView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicBattleItemShowView")
	end
	return target
end)
function epicBattleItemShowView:ctor()
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("epicbattle_text_38"))
	SoraDSetTextWidthHeight(self.Text_tip, cc.size(500, 50))
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_detail = SoraDGetChildByName(self, "Text_detail")
	self.Image_quality = SoraDGetChildByName(self, "Image_quality")
	self.Image_item = SoraDGetChildByName(self, "Image_item")
end
function epicBattleItemShowView:initData(itemID)
	self.Text_name:setString(publicRead.getName(itemID))
	self.Text_detail:setString(publicRead.getDes(itemID))
	self.Image_quality:loadTexture(publicRead.getBg(itemID), ccui.TextureResType.plistType)
	self.Image_item:loadTexture(publicRead.getIcon(itemID), ccui.TextureResType.plistType)
end
return epicBattleItemShowView
