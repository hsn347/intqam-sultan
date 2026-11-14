local heroSecretltCtrl = include("heroSecretltCtrl")
local heroStageRewardView = class("heroStageRewardView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("heroStageRewardView")
end)
function heroStageRewardView:ctor(properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("hero_title_02"))
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.btnSure = SoraDGetChildByName(self, "Button_Sure")
	self.btnSure:setTitleText(i18n("common_text_204"))
	self.btnSure:addTouchEventListener(handler(self, self.btnSureClick))
end
function heroStageRewardView:initData(index)
	local awardConfig = heroSecretltCtrl.getStageRewardByIndex(index)
	self:initViewWithItems(awardConfig)
end
function heroStageRewardView:initViewWithItems(awardConfig)
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
function heroStageRewardView:btnSureClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		self:removeFromParent()
	end
end
return heroStageRewardView
