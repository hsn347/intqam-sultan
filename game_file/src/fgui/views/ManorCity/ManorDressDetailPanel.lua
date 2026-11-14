local manorCityRead = include("manorCityRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorDressDetailPanel = class("ManorDressDetailPanel", baseFguiPanel)
function ManorDressDetailPanel:ctor(...)
	self.isLRU = true
	ManorDressDetailPanel.super.ctor(self, ...)
	print("ManorDressDetailPanel:ctor", self.viewName)
end
function ManorDressDetailPanel:onInit()
	print("=======ManorDressDetailPanel:onInit")
	self.fields.Label_title:setString(i18n("decoration_text_09"))
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	if not SoraDFIsRA() then
		self.fields.Image_build:fixPos()
		self.fields.Text_build:fixPos()
		self.fields.Label_des:fixPos()
		self.fields.bg_build:fix()
	end
end
function ManorDressDetailPanel:endShow()
	print("=======ManorDressDetailPanel:endShow")
	local dressID = self.param.dressID
	self.dressID = dressID
	local quality = manorCityRead.getDressQuality(dressID)
	local bgName = manorCityRead.getDressQualityDetailBg(quality)
	self.fields.bg_build:setURL(bgName)
	local imageName = manorCityRead.getDressSmallImage(dressID)
	self.fields.Image_build:setURL(imageName)
	local buildName = manorCityRead.getDressName(dressID)
	self.fields.Text_build:setString(buildName)
	local buildDes = manorCityRead.getDressDes(dressID)
	self.fields.Label_des:setString(buildDes)
	self.curLv = manorCityCtrl:getDressLv(dressID)
	local maxLv = manorCityRead.getDressMaxLv(dressID)
	self.fields.List:setNumItems(maxLv)
	if self.curLv > 0 then
		self.fields.List:scrollToView(self.curLv - 1)
	end
end
function ManorDressDetailPanel:itemRenderer_List(index, obj)
	local _fields = fguiHelper.get_fields(obj)
	local lv = index + 1
	if lv == self.curLv then
		_fields.bg:setVisible(true)
		_ENV = nil
		;(nil).lv = lv
		_fields.Text_lv:setString(i18n("decoration_text_10", nil))
	else
		_fields.bg:setVisible(false)
		_ENV = i18n("decoration_text_10", nil)
		i18n("decoration_text_10", nil).lv = lv
		_fields.Text_lv:setString(i18n("common_text_2838", i18n("decoration_text_10", nil)))
	end
	local buff = manorCityRead.getDressBuff(self.dressID, lv)
	_fields.List:setItemRenderer(function(_index, _obj)
		local _fields2 = fguiHelper.get_fields(_obj)
		local id = buff[_index + 1].id
		local value = buff[_index + 1].value
		local buffTitle = buffDesRead.getTitleBase(id, false, true)
		local buffValue = buffDesRead.getTitleValueWithValue(id, value)
		_fields2.Text_title:setString(buffTitle)
		_fields2.Text_value:setString(buffValue)
		if not SoraDFIsRA() then
			_obj:fixChildrenPos()
		end
	end)
	_fields.List:setNumItems(#buff)
	_fields.List:resizeToFit(#buff)
	if not SoraDFIsRA() then
		_fields.Text_lv:fixPos()
	end
end
return ManorDressDetailPanel
