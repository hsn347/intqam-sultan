local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local heroTacticsPopView = class("heroTacticsPopView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("heroTacticsPopView")
end)
function heroTacticsPopView:ctor()
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.tip = SoraDGetChildByName(self, "Text_1")
	self.tip:setString(i18n("herotactics_text_02"))
	self.desc = SoraDGetChildByName(self, "Text_2")
	self.icon = SoraDGetChildByName(self, "Image_icon")
	self.baseNode = SoraDGetChildByName(self, "Node_hero_base")
	self.heroHead = SoraDGetChildByName(self, "Node_hero")
end
function heroTacticsPopView:onMessageListener()
end
function heroTacticsPopView:initData(heroID)
	local tacticsHeroDatas, heroTactics = heroCtrl:getHeroTacticsStatus(heroID)
	local tacticsHeroData = tacticsHeroDatas[1]
	local tacticCfg = heroTactics[1]
	self.desc:setString(heroltCtrl:getTacticsDesc(tacticCfg.tacticsDes))
	self.windowTitle:setTitleName(i18n(tacticCfg.tacticsName))
	self.icon:setSpriteFrame(tacticCfg.tacticsIcon)
	for k, v in pairs(tacticsHeroData) do
		local node = self.heroHead:clone()
		node:addTo(self.baseNode)
		local heroNode = SoraDGetChildByName(node, "CCS_heroShowItem")
		local hero = include("heroShowItem").new(heroNode)
		if k == 3 and #tacticsHeroData == 5 then
			node:setScale(node:getScale())
		else
			node:setScale(node:getScale() * 0.9)
		end
		hero:initData(v.heroID)
		local heroDesInfo = heroCtrl:getHeroInfoByID(v.heroID)
		if heroDesInfo then
			hero:setHeadBg(heroDesInfo.quality)
		end
		local wakeLight = SoraDGetChildByName(node, "image_light")
		local darkColor = SoraDGetChildByName(node, "Panel_1")
		if not v.isUnlock then
			hero:setClickCallback(handler(self, self.onHeroClick))
		end
		SoraDSetNodeGray(hero.spHeroHead, not v.isUnlock)
		SoraDSetNodeGray(hero.spHeadBg, not v.isUnlock)
		wakeLight:setVisible(v.isActive)
		darkColor:setVisible(v.isUnlock and not v.isActive)
	end
	SoraDautoSortPos(self.baseNode, 5, 1, cc.size(95, 95), not SoraDFIsRA())
end
function heroTacticsPopView:onHeroClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local _, needNum, itemID = heroltCtrl:judgeUpgradeItem(button.heroID)
		_ENV = nil
		;(nil).itemID = itemID
		;(nil).needCount = needNum
		uiManager:show("newHeroGainChipMethodView", nil)
	end
end
return heroTacticsPopView
