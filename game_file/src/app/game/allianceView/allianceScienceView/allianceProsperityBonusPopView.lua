local allianceScience = SoraDGetCtrl("allianceScience")
local buffDesRead = include("buffDesRead")
local allianceDesRead = include("allianceDesRead")
local allianceProsperityBonusPopView = class("allianceProsperityBonusPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceProsperityBonusPopView")
	end
	return target
end)
function allianceProsperityBonusPopView:ctor()
	self:initWidget()
	self:initData()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_PROSPERITY_CHANGE", handler(self, self.refreshProsperity))
end
function allianceProsperityBonusPopView:initWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("alliance_prosperity_text_09"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_items")
	self.Node_single = SoraDGetChildByName(self, "Node_single")
	self.Node_single:setVisible(false)
	self.Node_title = SoraDGetChildByName(self.Node_single, "Node_title")
	self.Node_cell = SoraDGetChildByName(self.Node_single, "Node_cell")
end
function allianceProsperityBonusPopView:getShowList(...)
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
function allianceProsperityBonusPopView:initData()
	local itemH = 40
	local showList = self:getShowList()
	local sSize = self.scroll:getContentSize()
	local sHeight = math.max(sSize.height, #showList * itemH)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sHeight))
	for i, v in ipairs(showList) do
		local item = self:createSingleItem(v)
		if item then
			item:addTo(self.scroll)
			item:setPosition(sSize.width / 2, sHeight - (i - 0.5) * itemH)
		end
	end
end
function allianceProsperityBonusPopView:createSingleItem(data)
	if data.ctype == "type_title" then
		local Node_title = self.Node_title:clone()
		SoraDGetChildByName(Node_title, "Text_title"):setString(data.title)
		return Node_title
	elseif data.ctype == "type_cell" then
		local Node_cell = self.Node_cell:clone()
		local name = ""
		local value = 0
		if data.property.allianceEffect then
			name = buffDesRead.checkColon(allianceDesRead.getTitleBase(data.property.eid))
			value = allianceDesRead.getTitleWithValue(data.property.eid, data.property.value)
		else
			dump(data, "allianceProsperityBonusPopView:createSingleItem")
			name = buffDesRead.checkColon(buffDesRead.getTitleBase(data.property.eid))
			value = buffDesRead.getTitleValueWithValue(data.property.eid, data.property.value)
		end
		SoraDGetChildByName(Node_cell, "Text_name"):setString(name)
		SoraDGetChildByName(Node_cell, "Text_value"):setString(value)
		if not data.showBg then
			SoraDGetChildByName(Node_cell, "Image_bg"):setVisible(false)
		end
		return Node_cell
	end
end
function allianceProsperityBonusPopView:refreshProsperity(target, data)
	if self:isPropertyListChange() then
		self.scroll:removeAllChildren()
		self.scroll:jumpToTop()
		self:initData()
	end
end
function allianceProsperityBonusPopView:isPropertyListChange(...)
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
return allianceProsperityBonusPopView
