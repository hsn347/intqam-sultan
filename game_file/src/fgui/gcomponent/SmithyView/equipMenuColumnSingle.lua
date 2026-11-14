local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local baseComponent = require("fgui.base.baseComponent")
local equipMenuColumnSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/equipMenuColumnSingle", equipMenuColumnSingle)
function equipMenuColumnSingle:onInit()
	self.fields.Btn_suit:addClickListener(handler(self, self.clickSuitDetail))
	self.fields.Button_info:setString(i18n("common_text_1328"))
	self.fields.Button_info:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.Text_notice:setVisible(false)
	self.fields.bar:setVisible(false)
	self.fields.Text_time:setVisible(false)
	self.fields.Text_time:setTimeUpdateListener(handler(self, self.timeUpdate))
	self:fixChildrenPos()
	self.fields.bar:setScaleX(SoraDFIsRA() and -1 or 1)
end
function equipMenuColumnSingle:onShow()
end
function equipMenuColumnSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_FINISH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_INTENSIFY_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_BAPTIZE_SURE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_WEAR_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_DISASSEMBLE_BACK", handler(self, self.updateView))
end
function equipMenuColumnSingle:initData(data, operateType)
	self.data = data
	self.operateType = operateType
	self:updateView()
end
function equipMenuColumnSingle:timeUpdate(time)
	self.fields.bar:setValue(time)
end
function equipMenuColumnSingle:updateView()
