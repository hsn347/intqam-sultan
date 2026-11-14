local epicWarltCtrl = include("epicWarltCtrl")
local epicWarBuffSingle = class("epicWarBuffSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicWarBuffSingle")
	end
	return target
end)
function epicWarBuffSingle:ctor()
	self.Image_quality = SoraDGetChildByName(self, "Image_quality")
	self.Image_icon = SoraDGetChildByName(self, "Image_icon")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Node_lv = SoraDGetChildByName(self, "Node_lv")
	self.Text_lv = SoraDGetChildByName(self, "Text_lv")
end
function epicWarBuffSingle:initData(data, otherData)
	self.Node_lv:setVisible(data.lv > 0)
	_ENV = nil
	;(nil).lv = data.lv
	self.Text_lv:setString(i18n("common_text_100", nil))
	local tacticsId = data.tacticsId
	local base = epicWarltCtrl.getBlessTacticsBase(tacticsId)
	self.Image_quality:loadTexture(base, ccui.TextureResType.plistType)
	local icon = epicWarltCtrl.getBlessTacticsIcon(tacticsId)
	self.Image_icon:loadTexture(icon, ccui.TextureResType.plistType)
	local name = epicWarltCtrl.getBlessTacticsName(tacticsId)
	self.Text_name:setString(i18n(name))
	local des = epicWarltCtrl.getBlessTacticsDes(tacticsId)
	self.Text_des:setString(des)
end
return epicWarBuffSingle
