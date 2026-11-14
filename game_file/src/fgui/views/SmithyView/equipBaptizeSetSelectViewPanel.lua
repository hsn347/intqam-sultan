local equipmentCtrl = SoraDGetCtrl("equipmentCtrl")
local equipDesRead = include("equipDesRead")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local equipBaptizeSetSelectViewPanel = class("equipBaptizeSetSelectViewPanel", baseFguiPanel)
function equipBaptizeSetSelectViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("equipBaptizeSetSelectViewPanel:ctor", self.viewName)
end
function equipBaptizeSetSelectViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function equipBaptizeSetSelectViewPanel:onInit()
	print("=======equipBaptizeSetSelectViewPanel:onInit")
	self.selectArray, _ENV, self.arrayCfg, _ENV = print, print, print, print
	self.fields.Panel_bg:setString(i18n("equipment_training_text_13"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.onBtnOK))
end
function equipBaptizeSetSelectViewPanel:onShow()
	print("=======equipBaptizeSetSelectViewPanel:onShow")
	self.data = self.param.data
	self.quality = self.param.quality
	if not self.data.info then
		_ENV = self.data.info
	end
	self.selectArray = self.data.info
	if self.quality == gQualityDef.GREEN then
		_ENV = nil
		;(nil).var = self:getMaxSelect()
		self.fields.Text_tip:setString(i18n("equipment_training_text_14", nil))
	else
		_ENV = i18n("equipment_training_text_14", nil)
		i18n("equipment_training_text_14", nil).var1 = 1
		i18n("equipment_training_text_14", nil).var2 = self:getMaxSelect()
		self.fields.Text_tip:setString(i18n("equipment_training_text_15", i18n("equipment_training_text_14", nil)))
	end
	local attCfgs = equipDesRead.getAttributeGroupCfg()
	self.arrayCfg, _ENV = self.fields.Text_tip, self.fields.Text_tip
	for i, v in ipairs(attCfgs) do
		local isShow = equipDesRead.getPropertyIsShow(v, self.quality)
		if isShow then
			table.insert(self.arrayCfg, v)
			v.idx = #self.arrayCfg
		end
	end
	self.fields.List:setNumItems(#self.arrayCfg)
end
function equipBaptizeSetSelectViewPanel:getMaxSelect()
	_ENV = nil
	;(nil)[gQualityDef.GREEN] = "EQUIPMENT_ATTRIBUTE_GROUP_LIMIT_1"
	;(nil)[gQualityDef.BLUE] = "EQUIPMENT_ATTRIBUTE_GROUP_LIMIT_2"
	;(nil)[gQualityDef.PURPLE] = "EQUIPMENT_ATTRIBUTE_GROUP_LIMIT_3"
	;(nil)[gQualityDef.ORANGE] = "EQUIPMENT_ATTRIBUTE_GROUP_LIMIT_4"
	;(nil)[gQualityDef.NEBULA] = "EQUIPMENT_ATTRIBUTE_GROUP_LIMIT_888"
	local (nil)[gQualityDef.LEGEND], qualityCountCfg = "EQUIPMENT_ATTRIBUTE_GROUP_LIMIT_999", nil
	return constantRead.getConstValue(qualityCountCfg[self.quality]) or 1
end
function equipBaptizeSetSelectViewPanel:onItemRenderer(index, obj)
	obj:initData(self.arrayCfg[index + 1], self.selectArray, handler(self, self.onSelect))
end
function equipBaptizeSetSelectViewPanel:onSelect(index)
	print("选择===", index)
	local maxSelect = self:getMaxSelect()
	if index < 0 then
		local _ENV, array = self, self
		for k, v in ipairs(self.selectArray) do
			if math.abs(index) ~= v then
				table.insert(array, v)
			end
		end
		self.selectArray = array
	elseif maxSelect > #self.selectArray then
		table.insert(self.selectArray, index)
	else
		self.selectArray[maxSelect] = index
	end
	self.fields.List:setNumItems(#self.arrayCfg)
end
function equipBaptizeSetSelectViewPanel:onBtnOK()
	SoraDPlaySound()
	local setCount = equipmentCtrl:getSettedAttributeGroupCount()
	local maxGroup = constantRead.getConstValue("EQUIPMENT_ATTRIBUTE_GROUP_MAX_COUNT")
	if setCount >= maxGroup then
		if self.data.position and equipmentCtrl:getAttributeGroupInfoByIndex(self.quality, self.data.position) then
			equipmentCtrl:setAttributeGroupInfo(1, self.quality, position, self.selectArray)
			self:close()
		else
			SoraDShowMsgTip(i18n("equipment_training_text_16"))
		end
	else
		local position = self.data.position or equipmentCtrl:getNexPosition(self.quality)
		equipmentCtrl:setAttributeGroupInfo(1, self.quality, position, self.selectArray)
		self:close()
	end
end
return equipBaptizeSetSelectViewPanel
