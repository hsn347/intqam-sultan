local equipDesRead = include("equipDesRead")
local equipmentMgr = include("equipmentMgr")
local equipmentltCtrl = include("equipmentltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_equipTopOrange = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/Com_equipTopOrange", Com_equipTopOrange)
function Com_equipTopOrange:onInit()
	self.fields.Btn_add:addClickListener(handler(self, self.btnAddClick))
end
function Com_equipTopOrange:onShow()
end
function Com_equipTopOrange:initData(tableEquipData, data, str)
	self.tableEquipData = tableEquipData
	if data then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Com_equip:initData(data)
		_ENV = nil
		;(nil).lv = data:getEquipmentLV()
		;(nil).name = equipDesRead.getName(data:getEID())
		self.fields.title:setString(i18n("common_text_134", nil))
		self.fields.title:setColor(equipDesRead.getAttrColor(data:getEquipmentQuality()))
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.title:setString(str)
		self.fields.title:setColor(cc.c3b(224, 43, 43))
	end
end
function Com_equipTopOrange:btnAddClick()
	SoraDPlaySound()
	local tabelBaseList = equipmentMgr:getEquipmentArray()
	local _ENV, tabelList = equipmentMgr, equipmentMgr
	local maxlv = self.tableEquipData.level
	local minlv = self.tableEquipData.level - 5
	local mainMaterialList = equipmentltCtrl.getOrangeMainMaterial(self.tableEquipData.equipmentID)
	for i, v in ipairs(tabelBaseList) do
		if mainMaterialList then
			if v:getEID() == mainMaterialList[1] and v:getEquipmentQuality() == mainMaterialList[2] then
				table.insert(tabelList, v)
			end
			if v:getEID() == mainMaterialList[3] and v:getEquipmentQuality() == mainMaterialList[4] then
				table.insert(tabelList, v)
			end
		end
	end
	local _ENV, items = (for generator), ipairs(tabelBaseList)
	for k, v in ipairs(tabelList) do
		table.insert(items, v)
	end
	_ENV = nil
	;(nil).items = items
	;(nil).mode = 1
	;(nil).title = self.fields.title:getText()
	uiManager:show("equipMaterialSelectView", nil)
end
return Com_equipTopOrange
