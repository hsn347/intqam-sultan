local publicRead = include("publicRead")
local equipmentltCtrl = include("equipmentltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_materialShow = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/Com_materialShow", Com_materialShow)
function Com_materialShow:onInit()
	self.fields.Text_num:fixPos()
	self.fields.mageTag:fixPos()
end
function Com_materialShow:onShow()
end
function Com_materialShow:initData(data, selectID)
	self.data = data
	self.selectID = selectID
	self.fields.select:setVisible(self.selectID and self.data.id == self.selectID or false)
	self.fields.icon_base:setSpriteFrame(publicRead.getBg(self.data.id))
	self.fields.icon:setSpriteFrame(publicRead.getIcon(self.data.id))
	if self.data.count then
		self.fields.Text_num:setVisible(true)
		self.fields.Text_num:setString(self.data.count > 0 and self.data.count or "")
		self.fields.mageTag:setVisible(self.data.count >= 4 and equipmentltCtrl.canMerge(self.data.id))
	else
		self.fields.Text_num:setVisible(false)
		self.fields.mageTag:setVisible(false)
	end
	local isLock = backpackCtrl:isItemLock(self.data.id)
	self.controllers.lock:setSelectedIndex(isLock and 1 or 0)
end
return Com_materialShow
