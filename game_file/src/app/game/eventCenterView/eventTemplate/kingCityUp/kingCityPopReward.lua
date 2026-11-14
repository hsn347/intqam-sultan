local kingCityUpgradeRead = include("kingCityUpgradeRead")
local kingCityUpgradeCtrl = SoraDGetCtrl("kingCityUpgradeCtrl")
local kingCityPopReward = class("kingCityPopReward", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("kingCityPopReward")
end)
function kingCityPopReward:ctor(properties)
	self.textName = SoraDGetChildByName(self, "Text_name")
	self.textName:setString(i18n("god_beast_text_04"))
	self.textTitleInfo = SoraDGetChildByName(self, "Text_TitleInfo")
	self.imgIcon = SoraDGetChildByName(self, "Image_icon")
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.btnGet = SoraDGetChildByName(self, "Button_Get")
	self.btnGet:setTouchEnabled(true)
	self.btnGet:addTouchEventListener(handler(self, self.btnGetClick))
end
function kingCityPopReward:initData(lv, status, index)
	_ENV = nil
	;(nil).LV = lv
	self.textTitleInfo:setString(i18n("cityUp_text_02", nil))
	self.status = status
	self.index = index
	if self.status == gBtnTargetStatusDef.GO then
		self.btnGet:setTitleText(i18n("common_text_477"))
	elseif self.status == gBtnTargetStatusDef.GET then
		self.btnGet:setTitleText(i18n("common_text_1146"))
	else
		self.btnGet:setTitleText(i18n("common_text_204"))
	end
	local award = kingCityUpgradeRead.getRewardByLv(lv)
	for i, v in ipairs(award) do
		local single = include("commonItemAward").new()
		single:setScale(0.9)
		single:setOwnView(self)
		single:setPosition(0, 0)
		single:addTo(self.nodeAward)
		single:initData(v.id, v.count)
	end
	if table.nums(award) > 4 then
		SoraDautoSortPos(self.nodeAward, 4, SoraDFIsRA() and 2 or 0, cc.size(110, 100, SoraDFIsRA()))
	else
		SoraDToCenter(self.nodeAward, 110, SoraDFIsRA())
	end
	self:setCityImage(lv)
end
function kingCityPopReward:setCityImage(lv)
	if SoraDGetFactionType() == 1 then
		print("  lth", string.format("icon_wcsj_cb_%02d.png", lv))
		self.imgIcon:setSpriteFrame(string.format("icon_wcsj_cb_%02d.png", lv))
	else
		self.imgIcon:setSpriteFrame(string.format("Castle_byzantine_Lv%d.png", lv))
		self.imgIcon:setScale(0.75)
		self.imgIcon:setPositionY(self.imgIcon:getPositionY() - 35)
		if lv == 30 then
			self.imgIcon:setPosition(-40, -70)
		end
	end
end
function kingCityPopReward:btnGetClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if self.status == gBtnTargetStatusDef.GO then
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			_ENV = nil
			;(nil).bid = BUILDID.CASTLE
			;(nil).lv = SoraDGetCastleLv()
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.BUILD_UPGRADE, nil)
			SoraDRemoveAllPanelFromManager()
		elseif self.status == gBtnTargetStatusDef.GET then
			kingCityUpgradeCtrl:reqUpgradeCaslteLvReward(self.index)
			self:removeFromParent()
		else
			self:removeFromParent()
		end
	end
end
return kingCityPopReward
