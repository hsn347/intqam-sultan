local gametop = gModuleMgr.getObject("gametop")
local landOfSoulCtrl = gametop.playertop_:getModule("landOfSoulCtrl")
local armyltCtrl = include("armyltCtrl")
local landOfSoulRead = include("landOfSoulRead")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local armyDesRead = include("armyDesRead")
local summonSuccessfulBlessView = class("summonSuccessfulBlessView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("summonSuccessfulBlessView")
	end
	return target
end)
function summonSuccessfulBlessView:ctor()
	self:initControls()
	self:initBottomEffect()
	self:initUpEffect()
end
function summonSuccessfulBlessView:initBottomEffect()
	local effecBottom = SoraDCreatAnimation("Node_yhzd_04", nil, true)
	SoraDMixtureGLONEByParent(effecBottom)
	self.effecBottom = effecBottom
	effecBottom:setPosition(cc.p(320, 0))
	self.Node_1:addChild(effecBottom)
	local cell1 = SoraDGetChildByName(effecBottom, "et_chuanqijw_06")
	cell1:setAutoCull(true)
end
function summonSuccessfulBlessView:initUpEffect()
	local effecUp = SoraDCreatAnimation("Node_yhzd_05", nil, true)
	SoraDMixtureGLONEByParent(effecUp)
	self.effecUp = effecUp
	effecUp:setPosition(cc.p(320, -100))
	self.Node_2:addChild(effecUp)
	local cell2 = SoraDGetChildByName(effecUp, "et_ctloading_07")
	cell2:setAutoCull(false)
end
function summonSuccessfulBlessView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function summonSuccessfulBlessView:initControls()
	SoraDGetAllChildFromWidget(self, self)
	if not SoraDFIsRA() then
		self.Sprite_title_t:setSpriteFrame("frame_yhzr_YSZen.png")
	end
	self.Text_tips_t:setString(i18n("heroicSouls_text_9"))
	self.Text_tips_b:setString(i18n("heroicSouls_text_3"))
end
function summonSuccessfulBlessView:initData(activityID)
	self.activityID = activityID
	self.deadArmyList = landOfSoulCtrl:getCureArmyList()
	self.blessArmyList = landOfSoulCtrl:getBlessArmyList()
	self:initScroll()
end
function summonSuccessfulBlessView:initScroll()
	self.Top_Size_ScrollView_troops:removeAllChildren()
	local totalH = 0
	local scrollH = math.max(self.Top_Size_ScrollView_troops:getContentSize().height, 80 * table.nums(self.deadArmyList) + 80 * table.nums(self.blessArmyList) + 100)
	self.Top_Size_ScrollView_troops:setInnerContainerSize(cc.size(640, scrollH))
	local nodeTitleBless = self.Node_title:clone()
	nodeTitleBless:setPosition(320, scrollH - 25)
	nodeTitleBless:addTo(self.Top_Size_ScrollView_troops)
	if self.activityID == gActivityTimeActivityID.LEGEND_LORD or worldMapDefine.isKingStarActivityID(self.activityID) then
		SoraDGetChildByName(nodeTitleBless, "Text_title"):setString(i18n("heroicSouls_text_11"))
	else
		SoraDGetChildByName(nodeTitleBless, "Text_title"):setString(i18n("heroicSouls_text_15"))
	end
	totalH = nodeTitleBless:getPositionY() - 65
	local index = 1
	for k, v in pairs(self.blessArmyList) do
		local cell = SoraDFIsRA() and self.Node_item:clone() or self.Node_item_en:clone()
		local nodeArmy = include("commonArmySingle").new(cell)
		_ENV = i18n("heroicSouls_text_15")
		i18n("heroicSouls_text_15").id = k
		i18n("heroicSouls_text_15").num = v
		nodeArmy:initData(i18n("heroicSouls_text_15"))
		nodeArmy:setPosition(320, totalH - (index - 1) * 80)
		nodeArmy:addTo(self.Top_Size_ScrollView_troops)
		index = index + 1
	end
	totalH = totalH - table.nums(self.blessArmyList) * 80 + 40
	local nodeTitleHero = self.Node_title:clone()
	nodeTitleHero:setPosition(320, totalH - 25)
	nodeTitleHero:addTo(self.Top_Size_ScrollView_troops)
	if self.activityID == gActivityTimeActivityID.LEGEND_LORD or worldMapDefine.isKingStarActivityID(self.activityID) then
		SoraDGetChildByName(nodeTitleHero, "Text_title"):setString(i18n("heroicSouls_text_12"))
	else
		SoraDGetChildByName(nodeTitleHero, "Text_title"):setString(i18n("heroicSouls_text_9"))
	end
	SoraDGetChildByName(nodeTitleHero, "Sprite_title"):setSpriteFrame("frame_yhzr_bt02.png")
	totalH = nodeTitleHero:getPositionY() - 65
	local index2 = 1
	for k, v in pairs(self.deadArmyList) do
		local cell = SoraDFIsRA() and self.Node_item:clone() or self.Node_item_en:clone()
		local nodeArmy2 = include("commonArmySingle").new(cell)
		_ENV = i18n("heroicSouls_text_9")
		i18n("heroicSouls_text_9").id = k
		i18n("heroicSouls_text_9").num = v
		nodeArmy2:initData(i18n("heroicSouls_text_9"))
		nodeArmy2:setPosition(320, totalH - (index2 - 1) * 80)
		nodeArmy2:addTo(self.Top_Size_ScrollView_troops)
		index2 = index2 + 1
		SoraDGetChildByName(nodeArmy2, "Image_item"):loadTexture("frame_warrecord_block.png", ccui.TextureResType.plistType)
	end
end
function summonSuccessfulBlessView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return summonSuccessfulBlessView
