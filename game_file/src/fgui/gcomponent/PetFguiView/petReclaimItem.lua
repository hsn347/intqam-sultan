local petCtrl = SoraDGetCtrl("petCtrl")
local petltCtrl = include("petltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local petReclaimItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://PetFguiView/petReclaimItem", petReclaimItem)
function petReclaimItem:onInit()
	self.fields.btn_reclaim:addClickListener(handler(self, self.onClick_btn_reclaim))
	self.fields.btn_reclaim:setString(i18n("common_text_3983"))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.icon_arrow:fix()
	end
end
function petReclaimItem:onShow()
end
function petReclaimItem:onClick_btn_reclaim()
	SoraDPlaySound()
	if self.itemsManagerHandle then
		self.itemsManagerHandle(self.itemData)
	end
end
function petReclaimItem:init(data)
	self.itemData = data
	self.fields.Com_item1:initData(data.id)
	_ENV = nil
	;(nil).count = data.count
	self.fields.text_name:setString(i18n("common_text_1377", nil))
	self.fields.Com_item2:initData(gIDDef.PET_POINT, data.petPoint)
	self:initIconLock()
end
function petReclaimItem:setItemDelegate(handle)
	self.itemsManagerHandle = handle
end
function petReclaimItem:initIconLock(...)
	local isPetDebrisid, petid = petltCtrl.getDebrisidIsExist(self.itemData.id)
	if not isPetDebrisid then
		self.controllers.c_lock:setSelectedIndex(0)
		return
	end
	if petCtrl:petIsAleadyUnlock(petid) then
		self.controllers.c_lock:setSelectedIndex(0)
	else
		self.controllers.c_lock:setSelectedIndex(1)
	end
end
return petReclaimItem
