local itemDesRead = include("itemDesRead")
local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local equipmentMgr = include("equipmentMgr")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_suitForgeNeed = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SmithyView/Btn_suitForgeNeed", Btn_suitForgeNeed)
function Btn_suitForgeNeed:onInit()
	self:addClickListener(handler(self, self.btnClick))
	self.fields.Text_num:fixPos()
end
function Btn_suitForgeNeed:onShow()
end
function Btn_suitForgeNeed:initData(data, index)
	self.data = data
	self.index = index
	self.controllers.c1:setSelectedIndex(self.data.mode)
	if self.data.mode == 0 then
		self.fields.icon:setSpriteFrame(itemDesRead.getIcon(self.data.mid))
		self.fields.icon_base:setSpriteFrame(itemDesRead.getBg(self.data.mid))
	else
		self.fields.icon_base:setSpriteFrame(equipDesRead.color[self.data.quality])
		self.fields.icon:setSpriteFrame(equipDesRead.getIcon(self.data.mid))
	end
	itemDesRead = equipDesRead.getIcon(self.data.mid)
	equipDesRead.getIcon(self.data.mid).var1 = fguiHelper.getColorString(self.data.ownCount >= self.data.needCount and "#FFFFFF" or "#FF0000", self.data.ownCount)
	equipDesRead.getIcon(self.data.mid).var2 = self.data.needCount
	self.fields.Text_num:setString(i18n("%{var1}/%{var2}", equipDesRead.getIcon(self.data.mid)))
end
function Btn_suitForgeNeed:btnClick()
	SoraDPlaySound()
	if self.data.mode == 0 then
		_ENV = nil
		_ENV, (nil).type = gEquipMaterialType.MATERIAL, gEquipMaterialType.MATERIAL
		gEquipMaterialType.MATERIAL.id = self.data.mid
		;(nil).singleData, gEquipMaterialType.MATERIAL.count = gEquipMaterialType.MATERIAL, self.data.ownCount
		;(nil).isForgeInto = true
		uiManager:show("storageBoxInfoView", nil)
	end
end
return Btn_suitForgeNeed
