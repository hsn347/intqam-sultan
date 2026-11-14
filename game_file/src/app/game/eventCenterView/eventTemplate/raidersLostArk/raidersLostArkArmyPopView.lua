local raidersLostArkArmyPopView = class("raidersLostArkArmyPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("raidersLostArkArmyPopView")
	end
	return target
end)
local raidersLostArkRead = include("raidersLostArkRead")
local publicRead = include("publicRead")
local raidersLostArkCtrl = SoraDGetCtrl("raidersLostArkCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local armyDesRead = include("armyDesRead")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local godArmsCtrl = SoraDGetCtrl("godArmsCtrl")
local equipDesRead = include("equipDesRead")
function raidersLostArkArmyPopView:ctor()
	self:initControls()
end
function raidersLostArkArmyPopView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	self.Text_titleName:setString(i18n("common_text_019"))
	self.Panel_cut:setPositionY(display.height / 2)
	self.activityID = gActivityTimeActivityID.RAIDERS_LOST_ARK
end
function raidersLostArkArmyPopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function raidersLostArkArmyPopView:initData(prob, armyInfo)
	if not prob then
		return
	end
	if not armyInfo then
		return
	end
	self.prob = prob
	self.armyInfo = armyInfo
	local color = cc.c3b(177, 77, 255)
	local str = i18n("Martial_arts_text_19")
	if self.prob == gRaidersLostArkKeyDropProbability.NORMAL then
		color = cc.c3b(161, 225, 255)
		str = i18n("Martial_arts_text_20")
	elseif self.prob == gRaidersLostArkKeyDropProbability.LOW then
		color = cc.c3b(118, 230, 137)
		str = i18n("Martial_arts_text_21")
	end
	local armyTotalNums = raidersLostArkCtrl:getArmyTotalNums(self.prob)
	self.text_prob:setColor(color)
	self.text_prob:setString(str)
	_ENV = nil
	;(nil).power = self.armyInfo.fightCapacity
	self.text_defence:setString(i18n("Martial_arts_text_22", nil))
	_ENV = i18n("Martial_arts_text_22", nil)
	i18n("Martial_arts_text_22", nil).count = armyTotalNums
	self.text_total:setString(i18n("common_text_466", i18n("Martial_arts_text_22", nil)))
	if not next(self.armyInfo.armsInfo) and not next(self.armyInfo.heroInfo) then
		self.Node_none:setPositionY(85)
		self.scroll_troop:setPositionY(350)
		self.scroll_troop:setContentSize(cc.size(515, 330))
	end
	self:initScroll()
	self:initHeroScroll()
end
function raidersLostArkArmyPopView:initScroll()
	self.scroll_troop:removeAllChildren()
	dump(self.armyInfo, "sdjhfsdjfhsdk")
	local scrollH = math.max(self.scroll_troop:getContentSize().height, 100 * #self.armyInfo.armyInfo)
	self.scroll_troop:setInnerContainerSize(cc.size(self.scroll_troop:getContentSize().width, scrollH))
	for i, v in ipairs(self.armyInfo.armyInfo) do
		local cell = self.node_single:clone()
		cell:setPosition(257, scrollH - (i - 1) * 100)
		cell:addTo(self.scroll_troop)
		local cellName = SoraDGetChildByName(cell, "Text_armyName")
		cellName:setString(armyDesRead.getName(v.id))
		local cellNum = SoraDGetChildByName(cell, "Text_armyCount")
		cellNum:setString(string.formatnumberthousands(v.num))
		local cellHead = SoraDGetChildByName(cell, "Sprite_armyHead")
		cellHead:setSpriteFrame(armyDesRead.getIcon(v.id))
		local cellLevel = SoraDGetChildByName(cell, "Sprite_armyLevel")
		cellLevel:setSpriteFrame(armyDesRead.getLvImg(v.id))
		local cellWarLv = SoraDGetChildByName(cell, "Sprite_warLv")
		cellWarLv:setVisible(armyDesRead.getWarLv(v.id) > 0)
		local cellTxtWarLv = SoraDGetChildByName(cell, "Text_warLv")
		cellTxtWarLv:setVisible(armyDesRead.getWarLv(v.id) > 0)
		cellTxtWarLv:setString(armyDesRead.getWarLv(v.id))
	end
end
function raidersLostArkArmyPopView:initHeroScroll()
	self.scroll_hero:removeAllChildren()
	self.tableHeroAndArm, _ENV = self.scroll_hero.removeAllChildren, self.scroll_hero.removeAllChildren
	local isHaveArm = false
	if next(self.armyInfo.armsInfo) then
		table.insert(self.tableHeroAndArm, self.armyInfo.armsInfo[1])
		isHaveArm = true
	end
	if next(self.armyInfo.heroInfo) then
		for i, v in ipairs(self.armyInfo.heroInfo) do
			table.insert(self.tableHeroAndArm, v)
		end
	end
	local scrollW = math.max(self.scroll_hero:getContentSize().width, 100 * #self.tableHeroAndArm)
	self.scroll_hero:setInnerContainerSize(cc.size(scrollW, self.scroll_hero:getContentSize().height))
	local index = 1
	for i, v in ipairs(self.tableHeroAndArm) do
		if i == 1 and isHaveArm then
			local armCell = self.Node_arm:clone()
			armCell:setScale(0.6)
			armCell:setPosition(50 + (index - 1) * 90, 42.5)
			armCell:addTo(self.scroll_hero)
			local cellImage = SoraDGetChildByName(armCell, "Image_icon")
			local cellLvTxt = SoraDGetChildByName(armCell, "Text_lv")
			cellImage:loadTexture(equipDesRead.getArtifactIcon(v.armsID), ccui.TextureResType.plistType)
			_ENV = cc.size(scrollW, self.scroll_hero:getContentSize().height)
			cc.size(scrollW, self.scroll_hero:getContentSize().height).lv = v.level
			cellLvTxt:setString(i18n("common_text_100", cc.size(scrollW, self.scroll_hero:getContentSize().height)))
		else
			local heroCell = self.node_hero:clone()
			heroCell:setScale(0.6)
			heroCell:setPosition(50 + (index - 1) * 90, 42.5)
			heroCell:addTo(self.scroll_hero)
			local heroInfo = heroltCtrl.getHeroInfo(v.heroID)
			local cellImage = SoraDGetChildByName(heroCell, "Sprite_head")
			local cellLvTxt = SoraDGetChildByName(heroCell, "Text_lv")
			local cellBg = SoraDGetChildByName(heroCell, "Sprite_headBg")
			cellImage:setSpriteFrame(heroInfo.herIcon)
			cellLvTxt:setString(v.level)
			cellBg:setSpriteFrame(heroltCtrl.getBg(v.quality))
		end
		index = index + 1
	end
end
function raidersLostArkArmyPopView:judgeClose(target, redata)
	if not activityShowCtrl:isActivityOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return raidersLostArkArmyPopView
