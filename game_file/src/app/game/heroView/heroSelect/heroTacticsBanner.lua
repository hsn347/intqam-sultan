local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroTacticsBanner = class("heroTacticsBanner", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroTacticsBanner")
	end
	return target
end)
function heroTacticsBanner:ctor()
	self.title = SoraDGetChildByName(self, "Text_tactics")
	self.title:setString(i18n("herotactics_text_01"))
	self.tacticComs, _ENV = self.title.setString, self.title.setString
	for i = 1, 5 do
		local tacticCom = SoraDGetChildByName(self, "Node_tactics_icon_" .. i)
		local button = SoraDGetChildByName(tacticCom, "Button_icon")
		button:setTag(i)
		button:addTouchEventListener(handler(self, self.onTacticClick))
		table.insert(self.tacticComs, tacticCom)
	end
	self.heroHead = SoraDGetChildByName(self, "Node_hero")
	self.baseNode = SoraDGetChildByName(self, "Node_hero_base")
	self.tacticDetails = SoraDGetChildByName(self, "Node_tactics_details")
	self.tacticDetails:setVisible(false)
	self.desc = SoraDGetChildByName(self, "Text_30")
end
function heroTacticsBanner:onMessageListener()
end
function heroTacticsBanner:initData(heroList)
	if not self:isVisible() then
		return
	end
	self.heroList = heroList
	local _ENV, allHeroTacticsDatas = self:isVisible(), self:isVisible()
	for k, v in pairs(heroList) do
		local tactics = heroltCtrl:getTacticsByHeroID(v)
		if tactics and 0 < #tactics then
			local isAdded = false
			for k, v in pairs(allHeroTacticsDatas) do
				if v[1].tacticsID == tactics[1].tacticsID then
					isAdded = true
					break
				end
			end
			if not isAdded then
				table.insert(allHeroTacticsDatas, tactics)
			end
		end
	end
	self.allHeroTacticsDatas = allHeroTacticsDatas
	local index = 1
	for k, v in pairs(allHeroTacticsDatas) do
		local tacticCom = self.tacticComs[index]
		self:reloadTacticCom(tacticCom, v)
		index = index + 1
	end
	for i = index, 5 do
		local tacticCom = self.tacticComs[i]
		self:reloadTacticCom(tacticCom, nil)
	end
end
function heroTacticsBanner:reloadTacticCom(tacticCom, tacticData)
	local spIcon = SoraDGetChildByName(tacticCom, "Sprite_icon")
	spIcon:setVisible(tacticData ~= nil and 0 < #tacticData)
	local button = SoraDGetChildByName(tacticCom, "Button_icon")
	button:setTouchEnabled(tacticData ~= nil and 0 < #tacticData)
	if tacticData == nil or not next(tacticData) then
		return
	end
	local tactic = tacticData[1]
	spIcon:setSpriteFrame(tactic.tacticsIcon)
	local isActive = self:getIsTacticsActive(tactic)
	SoraDSetNodeGray(spIcon, not isActive)
end
function heroTacticsBanner:getIsTacticsActive(tactic)
	if not tactic then
		return nil
	end
	local isActive = true
	for k, v in pairs(tactic.heroGroupID) do
		local isInHeroList, tmpIsActive = self:getHeroStatus(v, self.heroList)
		if not isInHeroList or not tmpIsActive then
			isActive = false
			break
		end
	end
	return isActive
end
function heroTacticsBanner:getHeroStatus(heroID, heroList)
	local isInHeroList = false
	local isActive = false
	for k, v in pairs(heroList) do
		if v == heroID then
			isInHeroList = true
			break
		end
	end
	local heroInfo = heroCtrl:getHeroInfoByID(heroID)
	if heroInfo == nil then
		isInHeroList = false
	else
		isActive = heroInfo.isAwake
	end
	return isInHeroList, isActive
end
function heroTacticsBanner:onTacticClick(button, eventType)
	if eventType == ccui.TouchEventType.began then
		local tag = button:getTag()
		if not self.allHeroTacticsDatas[tag] then
			return
		end
		self:updateDetails(self.allHeroTacticsDatas[tag])
	elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
		self.tacticDetails:setVisible(false)
	end
end
function heroTacticsBanner:updateDetails(tacticData)
	if tacticData == nil or not next(tacticData) then
		self.tacticDetails:setVisible(false)
		return
	end
	self.tacticDetails:setVisible(true)
	local tacticCfg = tacticData[1]
	self.desc:setString(heroltCtrl:getTacticsDesc(tacticCfg.tacticsDes))
	for i = 1, 5 do
		local heroID = tacticCfg.heroGroupID[i]
		local node = self.baseNode:getChildByTag(i)
		if not heroID then
			if node then
				node:setVisible(false)
			end
		else
			local hero
			if node == nil then
				node = self.heroHead:clone()
				node:addTo(self.baseNode)
				node:setTag(i)
				local heroNode = SoraDGetChildByName(node, "CCS_heroShowItem")
				hero = include("heroShowItem").new(heroNode)
			else
				hero = SoraDGetChildByName(node, "CCS_heroShowItem")
			end
			node:setVisible(true)
			local isInHeroList, isActive = self:getHeroStatus(heroID, self.heroList)
			if i == 3 and #tacticCfg.heroGroupID == 5 then
				node:setScale(1)
			else
				node:setScale(0.9)
			end
			hero:initData(heroID)
			local heroDesInfo = heroCtrl:getHeroInfoByID(heroID)
			if heroDesInfo then
				hero:setHeadBg(heroDesInfo.quality)
			end
			local wakeLight = SoraDGetChildByName(node, "image_light")
			local darkColor = SoraDGetChildByName(node, "Panel_1")
			SoraDSetNodeGray(hero.spHeroHead, not isInHeroList)
			SoraDSetNodeGray(hero.spHeadBg, not isInHeroList)
			wakeLight:setVisible(isInHeroList and isActive)
			darkColor:setVisible(isInHeroList and not isActive)
		end
	end
	SoraDautoSortPos(self.baseNode, 5, 1, cc.size(95, 95), not SoraDFIsRA())
end
return heroTacticsBanner
