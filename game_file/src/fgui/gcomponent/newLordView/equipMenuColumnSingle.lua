local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local equipMenuColumnSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/equipMenuColumnSingle", equipMenuColumnSingle)
function equipMenuColumnSingle:onInit()
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
	self.fields.Btn_suit:addClickListener(handler(self, self.clickSuitDetail))
	self.fields.Button_info:setString(i18n("common_text_1328"))
	self.fields.Button_info:addClickListener(handler(self, self.btnClickCallBack))
	self:fixChildrenPos()
end
function equipMenuColumnSingle:onShow()
end
function equipMenuColumnSingle:initData(data, part, setID)
	self.data = data
	self.part = part
	self.setID = setID
	if self.data.isJump then
		self.controllers.c1:setSelectedIndex(1)
		self:setJumpInfo()
		self.fields.Com_attr:setHeight(130)
		self:setHeight(158)
	else
		self.controllers.c1:setSelectedIndex(0)
		self:setEquipInfo()
	end
end
function equipMenuColumnSingle:setJumpInfo()
	_ENV = nil
	;(nil).equip = equipDesRead.getPartName(self.part)
	self.fields.Text_tip:setString(i18n("common_text_1399", nil))
end
function equipMenuColumnSingle:setEquipInfo()
