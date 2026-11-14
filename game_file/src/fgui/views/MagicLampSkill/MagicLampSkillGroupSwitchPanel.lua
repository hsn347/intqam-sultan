local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampSkillGroupSwitchPanel = class("MagicLampSkillGroupSwitchPanel", baseFguiPanel)
function MagicLampSkillGroupSwitchPanel:ctor(...)
	self.isLRU = true
	MagicLampSkillGroupSwitchPanel.super.ctor(self, ...)
	print("MagicLampSkillGroupSwitchPanel:ctor", self.viewName)
	self.listGroupData, MagicLampSkillGroupSwitchPanel = print, print
end
function MagicLampSkillGroupSwitchPanel:onInit()
	print("=======MagicLampSkillGroupSwitchPanel:onInit")
	self.fields.listGroup:setItemRenderer(handler(self, self.itemRenderer_listGroup))
end
function MagicLampSkillGroupSwitchPanel:endShow()
	print("=======MagicLampSkillGroupSwitchPanel:endShow")
	self:updateView()
end
function MagicLampSkillGroupSwitchPanel:onMagicLampUpdate()
	self:updateView()
end
function MagicLampSkillGroupSwitchPanel:getGroupDisplayName(groupID)
	if self.param and self.param.getGroupDisplayName then
		return self.param.getGroupDisplayName(groupID)
	end
	if groupID == 0 then
		return i18n("common_text_4345")
	end
	_ENV = nil
	;(nil).name = groupID
	return i18n("lordskill_page_01", nil)
end
function MagicLampSkillGroupSwitchPanel:getSkillMap(groupID)
	if self.param and self.param.getSkillMap then
		if not self.param.getSkillMap(groupID) then
			_UPVALUE0_ = self.param.getSkillMap(groupID)
		end
		return (self.param.getSkillMap(groupID))
	end
	_UPVALUE0_ = self.param.getSkillMap(groupID)
	return (self.param.getSkillMap(groupID))
end
function MagicLampSkillGroupSwitchPanel:getPreviewSkillIds(skillMap)
	if type(skillMap) ~= "table" then
		_ENV = type(skillMap)
		return (type(skillMap))
	end
	local _ENV, slotOrderMap = type(skillMap), type(skillMap)
	if not self.param or not self.param.slotDefs then
		_ENV = self.param.slotDefs
	end
	for index, slotDef in ipairs(self.param.slotDefs) do
		slotOrderMap[tostring(slotDef.jinnType) .. "_" .. tostring(slotDef.blessID)] = index
	end
	local _ENV, previewSkillList = (for generator), ipairs(self.param.slotDefs)
	for jinnType, jinnMap in pairs(skillMap) do
		local previewJinnType = tonumber(jinnType) or jinnType
		if type(jinnMap) == "table" then
			for blessID, skillID in pairs(jinnMap) do
				local previewBlessID = tonumber(blessID) or blessID
				skillID = tonumber(skillID) or skillID
				if skillID ~= nil then
					_ENV = nil
					;(nil).jinnType = previewJinnType
					;(nil).blessID = previewBlessID
					;(nil).skillID = skillID
					;(nil).slotOrder = slotOrderMap[tostring(previewJinnType) .. "_" .. tostring(previewBlessID)] or math.huge
					table.insert(previewSkillList, nil)
				end
			end
		end
	end
	table.sort(previewSkillList, function(a, b)
		if a.slotOrder ~= b.slotOrder then
			return a.slotOrder > b.slotOrder
		end
		if a.jinnType ~= b.jinnType then
			return a.jinnType < b.jinnType
		end
		if a.blessID ~= b.blessID then
			return a.blessID < b.blessID
		end
		return a.skillID < b.skillID
	end)
	local _ENV, skillIdList = table.sort, table.sort
	for __, previewData in ipairs(previewSkillList) do
		table.insert(skillIdList, previewData.skillID)
	end
	return skillIdList
end
function MagicLampSkillGroupSwitchPanel:isSkillMapEmpty(skillMap)
