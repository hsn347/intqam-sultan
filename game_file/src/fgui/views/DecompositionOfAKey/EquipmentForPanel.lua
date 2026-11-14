local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local equipDesRead = include("equipDesRead")
local equipmentltCtrl = include("equipmentltCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EquipmentForPanel = class("EquipmentForPanel", baseFguiPanel)
function EquipmentForPanel:ctor(...)
	self.super.ctor(self, ...)
	print("EquipmentForPanel:ctor", self.viewName)
end
function EquipmentForPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function EquipmentForPanel:onInit()
	print("=======EquipmentForPanel:onInit")
	self.fields.Text_tip:setString(i18n("disassemble_fast_16"))
	self.fields.Button_cancel:setString(i18n("common_text_185"))
	self.fields.Button_cancel:addClickListener(handler(self, self.onBtnCancelClick))
	self.fields.Button_sure:setString(i18n("common_text_204"))
	self.fields.Button_sure:addClickListener(handler(self, self.onBtnSureClick))
	self.fields.Button_cancel:fixPos()
	self.fields.Button_sure:fixPos()
end
function EquipmentForPanel:onShow()
	print("=======EquipmentForPanel:onShow")
	_ENV = nil
	;(nil).num = fguiHelper.getColorString("#FF9600", self.param.num)
	self.fields.Text_title:setString(i18n("disassemble_fast_12", nil))
	local str = ""
	local equipStr = ""
	for k, v in ipairs(self.param.equipList) do
		if k == #self.param.equipList then
			_ENV = i18n("disassemble_fast_12", nil)
			i18n("disassemble_fast_12", nil).name = equipDesRead.getQualityName(v.quality)
			i18n("disassemble_fast_12", nil).num = v.count
			equipStr = equipStr .. fguiHelper.getColorString(SoraDRGB2HtmlColor(gQualityTextColorDef[v.quality]), i18n("disassemble_fast_9", i18n("disassemble_fast_12", nil))) .. "\n"
		else
			_ENV = i18n("disassemble_fast_9", i18n("disassemble_fast_12", nil))
			i18n("disassemble_fast_9", i18n("disassemble_fast_12", nil)).name = equipDesRead.getQualityName(v.quality)
			i18n("disassemble_fast_9", i18n("disassemble_fast_12", nil)).num = v.count
			equipStr = equipStr .. fguiHelper.getColorString(SoraDRGB2HtmlColor(gQualityTextColorDef[v.quality]), i18n("disassemble_fast_9", i18n("disassemble_fast_9", i18n("disassemble_fast_12", nil)))) .. ","
		end
	end
	_ENV = i18n("disassemble_fast_12", nil)
	i18n("disassemble_fast_12", nil).name = equipStr
	str = str .. i18n("disassemble_fast_13", i18n("disassemble_fast_12", nil)) .. "\n"
	local _ENV, bluePrintList = str, str
	local _ENV, materialList = i18n("disassemble_fast_13", i18n("disassemble_fast_12", nil)), i18n("disassemble_fast_13", i18n("disassemble_fast_12", nil))
	for k, v in ipairs(self.param.eList) do
		if v:getEquipmentQuality() == gQualityDef.ORANGE then
			local bluePrint, material = equipmentltCtrl.getDisThings(v:getEID())
			for ki, vi in ipairs(bluePrint) do
				bluePrintList[vi.id] = (bluePrintList[vi.id] or 0) + vi.count
			end
			for kj, vj in ipairs(material) do
				materialList[vj.id] = (materialList[vj.id] or 0) + vj.count
			end
		end
	end
	if next(bluePrintList) then
		local blueStr = ""
		local _ENV, bList = bluePrintList, bluePrintList
		for k, v in pairs(bluePrintList) do
			_ENV = ipairs(material)
			ipairs(material).id = k
			ipairs(material).count = v
			table.insert(bList, ipairs(material))
		end
		table.sort(bList, function(a, b)
			return a.id < b.id
		end)
		for k, v in ipairs(bList) do
			if k == #bList then
				_ENV = v:getEID()
				v:getEID().name = publicRead.getName(v.id)
				v:getEID().num = v.count
				blueStr = blueStr .. i18n("disassemble_fast_14", v:getEID()) .. "\n"
			else
				_ENV = v:getEID()
				v:getEID().name = publicRead.getName(v.id)
				v:getEID().num = v.count
				blueStr = blueStr .. i18n("disassemble_fast_14", v:getEID()) .. ","
			end
		end
		str = str .. blueStr
	end
	if next(materialList) then
		str = str .. "\n"
		local materialStr = ""
		local _ENV, mList = "\n", "\n"
		for k, v in pairs(materialList) do
			_ENV = ","
			;(",").id = k
			;(",").count = v
			table.insert(mList, ",")
		end
		table.sort(mList, function(a, b)
			return a.id < b.id
		end)
		for k, v in ipairs(mList) do
			if k == #mList then
				_ENV = v:getEID()
				v:getEID().name = publicRead.getName(v.id)
				v:getEID().num = v.count
				materialStr = materialStr .. i18n("disassemble_fast_14", v:getEID()) .. "\n"
			else
				_ENV = v:getEID()
				v:getEID().name = publicRead.getName(v.id)
				v:getEID().num = v.count
				materialStr = materialStr .. i18n("disassemble_fast_14", v:getEID()) .. ","
			end
		end
		str = str .. materialStr
	end
	local _ENV, otherList = materialStr, materialStr .. i18n("disassemble_fast_14", v:getEID()) .. ","
	for k, v in ipairs(self.param.eList) do
		local quality = v:getEquipmentQuality()
		if quality == gQualityDef.ORANGE then
			quality = quality - 1
		end
		local elv = v:getEquipmentLV()
		local mult = 1
		local isSuitEquip = equipmentltCtrl.judgeSuitEquipByEid(v:getEID())
		if isSuitEquip then
			elv = elv % 100
			mult = 0.75
		end
		local min, max = equipmentltCtrl.getMaterialNumRangeOfDisassmble(elv)
		min = math.floor(min * mult)
		max = math.floor(max * mult)
		local eQItem = otherList[quality]
		if eQItem then
			_ENV = max * mult
			;(max * mult).min = min + eQItem.min
			;(max * mult).max = max + eQItem.max
			otherList[quality], (max * mult).quality = max * mult, quality
		else
			_ENV = max * mult
			;(max * mult).min = min
			;(max * mult).max = max
			otherList[quality], (max * mult).quality = max * mult, quality
		end
	end
	if next(otherList) then
		str = str .. "\n"
		local _ENV, oList = str, str
		for k, v in pairs(otherList) do
			table.insert(oList, v)
		end
		table.sort(oList, function(a, b)
			return a.quality < b.quality
		end)
		local oStr = ""
		for k, v in ipairs(oList) do
			if k == #oList then
				_ENV = math.floor(max * mult)
				math.floor(max * mult).value1 = v.min
				math.floor(max * mult).value2 = v.max
				math.floor(max * mult).name = equipDesRead.getMQualityName(v.quality)
				oStr = oStr .. i18n("disassemble_fast_15", (math.floor(max * mult)))
			else
				_ENV = math.floor(max * mult)
				math.floor(max * mult).value1 = v.min
				math.floor(max * mult).value2 = v.max
				math.floor(max * mult).name = equipDesRead.getMQualityName(v.quality)
				oStr = oStr .. i18n("disassemble_fast_15", (math.floor(max * mult))) .. ","
			end
		end
		str = str .. oStr
	end
	self.fields.Text_msg:setString(str)
end
function EquipmentForPanel:onBtnCancelClick()
	SoraDPlaySound()
	self:close()
end
function EquipmentForPanel:onBtnSureClick()
	SoraDPlaySound()
	equipmentCtrl:oneKeyDisassembleInfo(self.param.minLv, self.param.maxLv, self.param.qualitys, self.param.isStrengthen, self.param.isSuit)
	self:close()
end
return EquipmentForPanel
