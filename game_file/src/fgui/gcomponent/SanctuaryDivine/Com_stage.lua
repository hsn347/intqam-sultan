local divineProtectionRead = include("divineProtectionRead")
local magicLampSkillShelterCtrl = SoraDGetCtrl("magicLampSkillShelterCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_stage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SanctuaryDivine/Com_stage", Com_stage)
function Com_stage:onInit()
	self.boxArray, divineProtectionRead = nil, nil
	self.cfgList = divineProtectionRead.getAccruedCfgList()
	self.minSpace = 126
	self.lrSpace = 10
	self.boxWidth = 80
	self.width = math.max(600, #self.cfgList * self.minSpace)
	self:setWidth(self.width + self.lrSpace * 2)
	self.fields.bar:setWidth(self.width)
	self.fields.bar:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.bar:setMax(100)
end
function Com_stage:onShow()
end
function Com_stage:initData()
	for k, v in ipairs(self.cfgList) do
		if not self.boxArray[k] then
			self.boxArray[k] = fgui.UIPackage:createObjectFromURL("ui://SanctuaryDivine/Com_fbkr_rewardSelect")
			local space = math.max(self.width / #self.cfgList, self.minSpace)
			self.boxArray[k]:setPosition(SoraDFPosX(self.width - k * space, self.width - self.boxWidth + self.lrSpace), 0)
			self:addChild(self.boxArray[k], 1)
		end
		self.boxArray[k]:initData(v, k)
	end
	local curVal = magicLampSkillShelterCtrl:getTotalTimes()
	local percent = SoraDGetStagePercentNew(curVal, divineProtectionRead.getAccruedStageList())
	self.fields.bar:setValue(percent)
end
return Com_stage
