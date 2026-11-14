local allianceScience = SoraDGetCtrl("allianceScience")
local allianceDesRead = include("allianceDesRead")
local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceAttributeViewPanel = class("allianceAttributeViewPanel", baseFguiPanel)
function allianceAttributeViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceAttributeViewPanel:ctor", self.viewName)
end
function allianceAttributeViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceAttributeViewPanel:onInit()
	print("=======allianceAttributeViewPanel:onInit")
	self.attributeList, _ENV, self.officialList, _ENV = print, print, print, print
	self.fields.Com_title:initData(i18n("alliance_office_title_05"), handler(self, self.onClickClose))
	self.fields.Title_official:setString(i18n("alliance_office_title_09"))
	self.fields.Title_science:setString(i18n("alliance_office_title_06"))
	self.fields.Button_goScience:setString(i18n("common_btn_08"))
	self.fields.Button_goScience:addClickListener(handler(self, self.btnGoScienceClick))
	self.fields.List_OfficialAttr:setItemRenderer(handler(self, self.onOfficialRenderer))
	self.fields.List_attribute:setItemRenderer(handler(self, self.onAttributeRenderer))
end
function allianceAttributeViewPanel:onOfficialRenderer(index, obj)
	obj:initData(self.officialList[index + 1])
end
function allianceAttributeViewPanel:onAttributeRenderer(index, obj)
	obj:initData(self.attributeList[index + 1])
end
function allianceAttributeViewPanel:onShow()
	print("=======allianceAttributeViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initOfficial()
	self:initScience()
end
function allianceAttributeViewPanel:initOfficial()
	_ENV, self.officialList, _ENV = nil, nil, nil
	;(nil)[gAllianceOfficial.LEADER] = "frame_alliance_message_04.png"
	;(nil)[gAllianceOfficial.COMMANDER] = "frame_alliance_message_06.png"
	;(nil)[gAllianceOfficial.DIPLOMATS] = "frame_alliance_message_03.png"
	;(nil)[gAllianceOfficial.PLANNERS] = "frame_alliance_message_07.png"
	local (nil)[gAllianceOfficial.RECRUITER], spPNG = "frame_alliance_message_08.png", nil
	for official = gAllianceOfficial.LEADER, gAllianceOfficial.RECRUITER do
		_ENV = nil
		;(nil).png = spPNG[official]
		;(nil).name = allianceDesRead.getOfficialName(official)
		;(nil).attribute = allianceDesRead.getOfficialAttribute(official)
		table.insert(self.officialList, nil)
	end
	self.fields.List_OfficialAttr:setNumItems(#self.officialList)
end
function allianceAttributeViewPanel:initScience()
	self.attributeList, _ENV = nil, nil
	for _, scitype in pairs(gAScienceType) do
		local des = allianceDesRead.getTitleBase(scitype)
		local addValue = allianceScience:getScienceAddValue(scitype)
		local showValue = allianceDesRead.getTitleWithValue(scitype, addValue)
		if des and 0 < addValue then
			_ENV = nil
			;(nil).des = des
			;(nil).addValue = showValue
			;(nil).scitype = scitype
			table.insert(self.attributeList, nil)
		end
	end
	table.sort(self.attributeList, function(a, b)
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
			table.insert(self.attributeList, nil)
		end
	end
	self.fields.List_attribute:setNumItems(#self.attributeList)
end
function allianceAttributeViewPanel:btnGoScienceClick()
	SoraDPlaySound()
	if SoraDGetCtrl("conquestWarCtrl"):isHelper() then
		SoraDShowMsgTip(i18n("common_text_3302"))
		return
	end
	if GLOBAL_GAME_ALLIANCE_MODE then
		uiManager:show("AllianceScience")
	else
		SoraDCreatePanel("allianceScienceView"):show()
	end
end
return allianceAttributeViewPanel
