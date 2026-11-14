local kingCityUpgradeCtrl = SoraDGetCtrl("kingCityUpgradeCtrl")
local kingCityUpgradeRead = include("kingCityUpgradeRead")
local kingCitySingleNode = class("kingCitySingleNode", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("kingCitySingleNode")
end)
function kingCitySingleNode:ctor(properties)
	self.status = gBtnTargetStatusDef.GO
	self.imgBox = SoraDGetChildByName(self, "Image_Box")
	self.textLv = SoraDGetChildByName(self, "Text_Lv")
	self.nodeHero = SoraDGetChildByName(self, "Node_Hero")
	self.nodeCommonItemAward = SoraDGetExtendChildFromCCSByName(self.nodeHero, "CCS_commonItemAward")
	self.btnBox = SoraDGetChildByName(self, "Button_Box")
	self.btnBox:addTouchEventListener(handler(self, self.btnBoxClick))
	self.nodeEffect = SoraDGetChildByName(self, "Node_Effect_wcsj01_002")
	self.nodeEffect_3 = SoraDGetChildByName(self, "Node_3")
	self.nodeEffect:setVisible(false)
	self.nodeEffect_3:setVisible(false)
	local cssFileName = "kingCitySingleNode"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0)
	self:runAction(action)
end
function kingCitySingleNode:initData(lv, index)
	self.lv = lv
	self.index = index
	self.textLv:setRotation3D(cc.vec3(0, index % 2 == 0 and -180 or 0, 0))
	_ENV = cc.vec3(0, index % 2 == 0 and -180 or 0, 0)
	cc.vec3(0, index % 2 == 0 and -180 or 0, 0).lv = lv
	self.textLv:setString(i18n("common_text_100", cc.vec3(0, index % 2 == 0 and -180 or 0, 0)))
	local item = kingCityUpgradeRead.getHasHeroItemByLv(lv)
	if item then
		self.nodeHero:setVisible(true)
		self.nodeCommonItemAward:setOwnView(self:getParent():getParent())
		self.nodeCommonItemAward:initData(item.id, item.count)
	else
		self.nodeHero:setVisible(false)
	end
	self:refreshSingle()
end
function kingCitySingleNode:refreshSingle()
	if self.lv > SoraDGetCastleLv() then
		self.status = gBtnTargetStatusDef.GO
		self.imgBox:loadTexture("icon_Daily_reward_treasure_L_close.png", ccui.TextureResType.plistType)
	elseif kingCityUpgradeCtrl:getRewardIsGet(self.index) then
		self.imgBox:loadTexture("icon_Daily_reward_treasure_L_open.png", ccui.TextureResType.plistType)
		self.status = gBtnTargetStatusDef.GOT
		self.nodeEffect:setVisible(false)
		self.nodeEffect_3:setVisible(false)
	else
		self.status = gBtnTargetStatusDef.GET
		self.nodeEffect_3:setVisible(true)
		self.nodeEffect:setVisible(true)
		self.imgBox:loadTexture("icon_Daily_reward_treasure_L_close.png", ccui.TextureResType.plistType)
	end
end
function kingCitySingleNode:btnBoxClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		local panel = SoraDCreatePanel("kingCityPopReward")
		panel:initData(self.lv, self.status, self.index)
		panel:show()
	end
end
return kingCitySingleNode
