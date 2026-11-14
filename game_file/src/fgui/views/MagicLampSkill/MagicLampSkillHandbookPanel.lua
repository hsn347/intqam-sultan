local magicLampSkillRead = include("magicLampSkillRead")
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampSkillHandbookPanel = class("MagicLampSkillHandbookPanel", baseFguiPanel)
function MagicLampSkillHandbookPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampSkillHandbookPanel:ctor", self.viewName)
	local hasSkillTypeMap = magicLampSkillCtrl:updateHasSkillTypeMap()
	local skillTypeList = clone(magicLampSkillRead.getSkillTypeList())
	for k, v in pairs(skillTypeList) do
		magicLampSkillRead.sortHandbookSkillList(v, hasSkillTypeMap)
	end
	local _ENV, ret = (for generator), pairs(skillTypeList)
	self.is3SSwitchOpen = constantRead.getConstValue("MAGIC_SKILL_3S_SWITCH", 0) == 1
	local maxQuality = 5
	if not self.is3SSwitchOpen then
		maxQuality = 4
	end
	for quality = maxQuality, 1, -1 do
		local title = magicLampSkillRead.getQualityName(quality)
		local bg = magicLampSkillRead.getQualityFrameTitle(quality)
		_ENV = magicLampSkillRead.getSkillTypeList()
		magicLampSkillRead.getSkillTypeList().title = title
		magicLampSkillRead.getSkillTypeList().bg = bg
		table.insert(ret, magicLampSkillRead.getSkillTypeList())
		if not skillTypeList[quality] then
			_ENV = skillTypeList[quality]
		end
		for __, skillType in ipairs(skillTypeList[quality]) do
			if magicLampSkillCtrl:getIsSkillShowInArea(skillType) then
				_ENV = skillType
				skillType.skillType = skillType
				table.insert(ret, skillType)
			end
		end
	end
	self.showList = ret
end
function MagicLampSkillHandbookPanel:onInit()
	print("=======MagicLampSkillHandbookPanel:onInit")
	self.fields.Com_title:initData(i18n("jinn_skill_61"), handler(self, self.onClickClose))
	self.fields.List_skill:setItemRenderer(handler(self, self.onSkillItemRenderer))
	self.fields.List_skill:setNumItems(#self.showList)
end
function MagicLampSkillHandbookPanel:onShow()
	print("=======MagicLampSkillHandbookPanel:onShow")
end
function MagicLampSkillHandbookPanel:onSkillItemRenderer(index, obj)
	obj:initHandbookData(self.showList[index + 1])
end
function MagicLampSkillHandbookPanel:onMsgAfterMerge(target, event)
	local skillType = event.skillType
	local findIndex
	for i, v in ipairs(self.showList) do
		if v.skillType and v.skillType == skillType then
			findIndex = i
			break
		end
	end
	if findIndex then
		local obj = self.fields.List_skill:getChildAt(findIndex - 1)
		if obj then
			obj:afterMerge()
		end
	end
end
return MagicLampSkillHandbookPanel
