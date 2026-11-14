local lightGuardianRead = include("lightGuardianRead")
local lightGuardianRewardView = class("lightGuardianRewardView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("lightGuardianRewardView")
end)
function lightGuardianRewardView:ctor(properties)
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self.node, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("common_text_1235"))
	self.textTip = SoraDGetChildByName(self.node, "Text_Tip")
	self.textTip:setString(i18n("guardLight_text_12"))
	self.nodeAward = SoraDGetChildByName(self.node, "Node_Award")
end
function lightGuardianRewardView:initData(index)
	local awardConfig = lightGuardianRead.getStageRewardByIndex(index)
	if next(awardConfig) then
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		awardConfig = serviceFunctions.tableFormat(awardConfig, nil)
		for i, v in ipairs(awardConfig) do
			local single = include("commonItemAward").new()
			single:setScale(0.9)
			single:setOwnView(self)
			single:setPosition(0, 0)
			single:addTo(self.nodeAward)
			single:initData(v.id, v.count)
		end
	end
	SoraDToCenter(self.nodeAward, 100, SoraDFIsRA())
end
return lightGuardianRewardView
