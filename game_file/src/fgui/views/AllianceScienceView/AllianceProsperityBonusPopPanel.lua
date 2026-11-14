local allianceScience = SoraDGetCtrl("allianceScience")
local buffDesRead = include("buffDesRead")
local allianceDesRead = include("allianceDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceProsperityBonusPopPanel = class("AllianceProsperityBonusPopPanel", baseFguiPanel)
function AllianceProsperityBonusPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceProsperityBonusPopPanel:ctor", self.viewName)
end
function AllianceProsperityBonusPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceProsperityBonusPopPanel:onInit()
	print("=======AllianceProsperityBonusPopPanel:onInit")
	self.fields.Panel_bg:setString(i18n("alliance_prosperity_text_09"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function AllianceProsperityBonusPopPanel:onItemRenderer(index, target)
	local data = self.showList[index + 1]
	target:fixChildrenPos()
	if data.ctype == "type_title" then
		target:getChildByName("Text_title"):setString(data.title)
		target:getController("c1"):setSelectedIndex(0)
	else
		local value = 0
		local name = ""
		if data.property.allianceEffect then
			name = buffDesRead.checkColon(allianceDesRead.getTitleBase(data.property.eid))
			value = allianceDesRead.getTitleWithValue(data.property.eid, data.property.value)
		else
			name = buffDesRead.checkColon(buffDesRead.getTitleBase(data.property.eid))
			value = buffDesRead.getTitleValueWithValue(data.property.eid, data.property.value)
		end
		target:getChildByName("Text_name"):setString(name)
		target:getChildByName("Text_value"):setString(value)
		target:getController("c1"):setSelectedIndex(1)
		target:getChildByName("bg"):setVisible(data.showBg)
	end
end
function AllianceProsperityBonusPopPanel:onShow()
	print("=======AllianceProsperityBonusPopPanel:onShow")
	self:initData()
end
function AllianceProsperityBonusPopPanel:refreshProsperity()
	if self:isPropertyListChange() then
		self.fields.List:jumpToTop()
		self:initData()
	end
end
function AllianceProsperityBonusPopPanel:initData()
	self.showList = self:getShowList()
	self.fields.List:setNumItems(#self.showList)
end
function AllianceProsperityBonusPopPanel:isPropertyListChange(...)
	local propertyList = allianceScience:getPropertyList()
	if #propertyList ~= #self.propertyList then
		return true
	end
	for i, property in ipairs(self.propertyList) do
		if property.eid ~= propertyList[i].eid or property.value ~= propertyList[i].value then
			return true
		end
	end
	return false
end
function AllianceProsperityBonusPopPanel:getShowList(...)
	local prosperity = allianceScience:getProsperity()
	local propertyList = allianceScience:getPropertyList()
	self.propertyList = propertyList
	local nextProsperity, nextProperty, nextAllianceProperty = allianceScience:getProsperityNextProperty(prosperity)
	local allianceScience, showList
	if nextProsperity then
		allianceScience = nil
		;(nil).ctype = "type_title"
		allianceScience = nil
		;(nil).num = string.formatnumberthousands(nextProsperity)
		;(nil).title = i18n("alliance_prosperity_text_11", nil)
		table.insert(showList, nil)
		if nextProperty then
			allianceScience = nil
			;(nil).ctype = "type_cell"
			;(nil).property = nextProperty
			table.insert(showList, nil)
		end
		if nextAllianceProperty then
			allianceScience = nil
			;(nil).ctype = "type_cell"
			;(nil).property = nextAllianceProperty
			table.insert(showList, nil)
		end
	end
	if table.nums(propertyList) > 0 then
		allianceScience = nil
		;(nil).ctype = "type_title"
		allianceScience = nil
		;(nil).num = nextProsperity
		;(nil).title = i18n("alliance_prosperity_text_10", nil)
		table.insert(showList, nil)
		for i, property in ipairs(propertyList) do
			allianceScience = nextProsperity
			nextProsperity.ctype = "type_cell"
			nextProsperity.property = property
			nextProsperity.showBg = i % 2 == 0
			table.insert(showList, nextProsperity)
		end
	end
	return showList
end
return AllianceProsperityBonusPopPanel
