local magicLampSkillShelterCtrl = SoraDGetCtrl("magicLampSkillShelterCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_fbkr_rewardSelect = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SanctuaryDivine/Com_fbkr_rewardSelect", Com_fbkr_rewardSelect)
function Com_fbkr_rewardSelect:onInit()
	self:addClickListener(handler(self, self.onClick))
end
function Com_fbkr_rewardSelect:onShow()
end
function Com_fbkr_rewardSelect:initData(data, index)
	self.index = index
	self.fields.title:setString(data.Integral)
	self.fields.box:initStyle(math.min(index, 8))
	local boxStatus = gBtnTargetStatusDef.GO
	local cIndex = 0
	local curVal = magicLampSkillShelterCtrl:getTotalTimes()
	local isClaimed = magicLampSkillShelterCtrl:isReward(index)
	if isClaimed then
		boxStatus = gBtnTargetStatusDef.GOT
		cIndex = 2
	end
	if not isClaimed and curVal >= data.Integral then
		boxStatus = gBtnTargetStatusDef.GET
		cIndex = 1
	end
	self.status = boxStatus
	self.fields.box:setStatus(boxStatus)
	self.controllers.c1:setSelectedIndex(cIndex)
	_UPVALUE2_ = cIndex
	cIndex[1] = "id"
	cIndex[2] = "count"
	self.rewards = serviceFunctions.tableFormat(data.Cumulativerewards, cIndex)
end
function Com_fbkr_rewardSelect:cliamReward()
	magicLampSkillShelterCtrl:sendReward(self.index)
end
function Com_fbkr_rewardSelect:onClick()
	SoraDPlaySound()
	local okStr = i18n("common_text_2139")
	if self.status == gBtnTargetStatusDef.GOT then
		okStr = i18n("common_text_1892")
	elseif self.status == gBtnTargetStatusDef.GET then
		okStr = i18n("common_text_1146")
	end
	_ENV = nil
	;(nil).title = i18n("warmHeart_text_13")
	;(nil).awardList = self.rewards
	;(nil).okStr = okStr
	;(nil).btnStatus = self.status
	;(nil).handle = handler(self, self.cliamReward)
	uiManager:show("Panel_gainView", nil)
end
return Com_fbkr_rewardSelect
