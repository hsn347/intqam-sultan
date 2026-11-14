local princeGiftTaskRewardSingle = class("princeGiftTaskRewardSingle", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("princeGiftTaskRewardSingle")
end)
function princeGiftTaskRewardSingle:ctor(properties)
	self.nodeCommonItemAward = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward")
	self.nodeCommonItemAward:setBaseScale(1.0)
	self.panelGot = SoraDGetChildByName(self, "Panel_got")
	self.spDh2 = SoraDGetChildByName(self, "G_dh_Tex_XL_dfwz02_03")
	self.spDh3 = SoraDGetChildByName(self, "G_dh_Texture_bbsyzy_001_01")
	self:initEffect()
end
function princeGiftTaskRewardSingle:initEffect()
	local loop = true
	local cssFileName = "princeGiftTaskRewardSingle"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:runAction(action)
end
function princeGiftTaskRewardSingle:initData(award, isGot, canGet, showCanGetEffect)
	self.spDh3:setVisible(false)
	self.nodeCommonItemAward:initData(award.id, award.count)
	self.panelGot:setVisible(isGot)
	self.spDh2:setVisible(canGet and showCanGetEffect)
end
function princeGiftTaskRewardSingle:updateFirstEffect(isVisible)
	self.spDh3:setVisible(isVisible)
end
function princeGiftTaskRewardSingle:setOwnView(parent)
	self.nodeCommonItemAward:setOwnView(parent)
end
return princeGiftTaskRewardSingle
