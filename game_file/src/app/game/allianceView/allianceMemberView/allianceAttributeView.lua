local gametop = gModuleMgr.getObject("gametop")
local allianceScience = gametop.playertop_:getModule("allianceScience")
local allianceDesRead = include("allianceDesRead")
local buffDesRead = include("buffDesRead")
local allianceAttributeView = class("allianceAttributeView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceAttributeView")
	end
	return target
end)
function allianceAttributeView:ctor()
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("alliance_office_title_05"))
	self.Text_title_official = SoraDGetChildByName(self, "Text_title_official")
	self.Text_title_official:setString(i18n("alliance_office_title_09"))
	self.Text_title_science = SoraDGetChildByName(self, "Text_title_science")
	self.Text_title_science:setString(i18n("alliance_office_title_06"))
	self.Image_bg = SoraDGetChildByName(self, "Image_bg")
	self.Image_bg:setContentSize(cc.size(640, display.height - 548))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_attribute")
	self.Node_detail = SoraDGetChildByName(self, "Node_detail")
	self.Node_detail:setVisible(false)
	self.Button_goScience = SoraDGetChildByName(self, "Button_goScience")
	self.Button_goScience:setTitleText(i18n("common_btn_08"))
	self.Button_goScience:addTouchEventListener(handler(self, self.btnGoScienceClick))
	self:initOfficial()
	self:initScience()
end
function allianceAttributeView:initOfficial()
	for official = gAllianceOfficial.LEADER, gAllianceOfficial.RECRUITER do
		local node = SoraDGetChildByName(self, "Node_" .. official)
		local Text_officialName = SoraDGetChildByName(node, "Text_officialName")
		Text_officialName:setString(allianceDesRead.getOfficialName(official))
		local Text_attribute = SoraDGetChildByName(node, "Text_attribute")
		local attribute = allianceDesRead.getOfficialAttribute(official)
		Text_attribute:setString(attribute)
	end
end
function allianceAttributeView:initScience()
	local _ENV, showData
	for _, scitype in pairs(gAScienceType) do
		local des = allianceDesRead.getTitleBase(scitype)
		local addValue = allianceScience:getScienceAddValue(scitype)
		local showValue = allianceDesRead.getTitleWithValue(scitype, addValue)
		if des and 0 < addValue then
			_ENV = nil
			;(nil).des = des
			;(nil).addValue = showValue
			;(nil).scitype = scitype
			table.insert(showData, nil)
		end
	end
	table.sort(showData, function(a, b)
		return a.scitype < b.scitype
	end)
	local propertyList = allianceScience:getPropertyList()
	for i, property in ipairs(propertyList) do
		if not property.allianceEffect then
			local name = buffDesRead.getTitleBase(property.eid)
			local value = buffDesRead.getTitleValueWithValue(property.eid, property.value)
			_ENV = nil
			;(nil).des = name
			;(nil).addValue = value
			table.insert(showData, nil)
		end
	end
	local scrollInnerNewH = math.max(self.scroll:getContentSize().height, table.nums(showData) * 50)
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollInnerNewH))
	for k, v in ipairs(showData) do
		local single = self:getDetailSingle()
		single.setData(v)
		single:setPosition(self.scroll:getContentSize().width / 2, scrollInnerNewH - k * 50 + 10)
		single:addTo(self.scroll)
	end
end
function allianceAttributeView:btnGoScienceClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if SoraDGetCtrl("conquestWarCtrl"):isHelper() then
			SoraDShowMsgTip(i18n("common_text_3302"))
			return
		end
		SoraDCreatePanel("allianceScienceView"):show()
	end
end
function allianceAttributeView:getDetailSingle()
	local single = self.Node_detail:clone()
	single:setVisible(true)
	function single.setData(data)
		local Text_des = SoraDGetChildByName(single, "Text_des")
		local Text_des_value = SoraDGetChildByName(single, "Text_des_value")
		Text_des:setString(data.des)
		Text_des_value:setString(data.addValue)
	end
	return single
end
return allianceAttributeView
