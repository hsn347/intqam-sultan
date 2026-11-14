local baseFguiPanel = require("fgui.base.baseFguiPanel")
local buffDesRead = include("buffDesRead")
local collegeDesRead = include("collegeDesRead")
local MailManorRecountPanel = class("MailManorRecountPanel", baseFguiPanel)
function MailManorRecountPanel:ctor(...)
	self.isLRU = true
	MailManorRecountPanel.super.ctor(self, ...)
	print("MailManorRecountPanel:ctor", self.viewName)
end
function MailManorRecountPanel:onInit()
	print("=======MailManorRecountPanel:onInit")
	self.fields.list_att:setVirtual()
	self.fields.list_att:setItemRenderer(handler(self, self.itemRenderer_list_att))
	self.fields.Panel_bg:setString(i18n("mail_2_text_98"))
	self.fields.txt_notip:setString(i18n("mail_2_text_102"))
end
function MailManorRecountPanel:endShow()
	print("=======MailManorRecountPanel:endShow")
	self:initData(self.param.gardenData)
end
function MailManorRecountPanel:initData(data)
	dump(data, "MailManorRecountPanel:initData data==========")
	self.showList, _ENV = dump, dump
	if data.garden and next(data.garden) then
		local _ENV, attList = next(data.garden), next(data.garden)
		for k, v in pairs(data.garden) do
			if buffDesRead.getIfBattleBuff(tonumber(k)) then
				local name = buffDesRead.getTitleBase(tonumber(k), true, true)
				local value = buffDesRead.getTitleValueWithValue(tonumber(k), SoraDPreciseDecimal(v, 2), false)
				_ENV = false
				;(false).name = name
				;(false).value = value
				;(false).showType = "NameAndValue"
				;(false).sort = tonumber(k)
				table.insert(attList, false)
			end
		end
		table.sort(attList, function(a, b)
			return a.sort < b.sort
		end)
		if 0 < #attList then
			function _ENV(a, b)
				return a.sort < b.sort
			end
			;(function(a, b)
				return a.sort < b.sort
			end).title = i18n("mail_2_text_99")
			;(function(a, b)
				return a.sort < b.sort
			end).showType = "Title"
			table.insert(self.showList, function(a, b)
				return a.sort < b.sort
			end)
		end
		for k, v in ipairs(attList) do
			table.insert(self.showList, v)
		end
	end
	if data.tech then
		local _ENV, attList = data.tech, data.tech
		for k, v in pairs(data.tech) do
			local name = collegeDesRead.getTechBuffDes(tonumber(k))
			local value = "+" .. collegeDesRead.getTechBuffValue(tonumber(k), v)
			_ENV = v
			v.name = name
			v.value = SoraDPreciseDecimal(value, 2)
			v.showType = "NameAndValue"
			v.sort = tonumber(k)
			table.insert(attList, v)
		end
		table.sort(attList, function(a, b)
			return a.sort < b.sort
		end)
		if 0 < #attList then
			function _ENV(a, b)
				return a.sort < b.sort
			end
			;(function(a, b)
				return a.sort < b.sort
			end).title = i18n("mail_2_text_100")
			;(function(a, b)
				return a.sort < b.sort
			end).showType = "Title"
			table.insert(self.showList, function(a, b)
				return a.sort < b.sort
			end)
		end
		for k, v in ipairs(attList) do
			table.insert(self.showList, v)
		end
	end
	if data.dress then
		local _ENV, attList = data.dress, data.dress
		for k, v in pairs(data.dress) do
			if buffDesRead.getIfBattleBuff(tonumber(k)) then
				local name = buffDesRead.getTitleBase(tonumber(k), true, true)
				local value = buffDesRead.getTitleValueWithValue(tonumber(k), SoraDPreciseDecimal(v, 2), false)
				_ENV = false
				;(false).name = name
				;(false).value = value
				;(false).showType = "NameAndValue"
				;(false).sort = tonumber(k)
				table.insert(attList, false)
			end
		end
		table.sort(attList, function(a, b)
			return a.sort < b.sort
		end)
		if 0 < #attList then
			function _ENV(a, b)
				return a.sort < b.sort
			end
			;(function(a, b)
				return a.sort < b.sort
			end).title = i18n("mail_2_text_101")
			;(function(a, b)
				return a.sort < b.sort
			end).showType = "Title"
			table.insert(self.showList, function(a, b)
				return a.sort < b.sort
			end)
		end
		for k, v in ipairs(attList) do
			table.insert(self.showList, v)
		end
	end
	self.fields.txt_notip:setVisible(#self.showList == 0)
	self.fields.list_att:setNumItems(#self.showList)
end
function MailManorRecountPanel:itemRenderer_list_att(index, obj)
	local data = self.showList[index + 1]
	if data.showType == nil then
		obj:initData(data, index)
	elseif data.showType == "Desc" then
		obj:setDesc(data.desc, index)
	elseif data.showType == "Title" then
		obj:setSubTitle(data.title)
	elseif data.showType == "NameAndValue" then
		obj:setNameAndValue(data.name, data.value, index)
	end
end
return MailManorRecountPanel
