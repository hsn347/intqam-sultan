local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local buildDescribeRead = include("buildDescribeRead")
local publicRead = include("publicRead")
local kipchaksBossInfoView = class("kipchaksBossInfoView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("kipchaksBossInfoView")
	end
	return target
end)
function kipchaksBossInfoView:ctor()
	self.bossData, _ENV, self.npcLv = nil, nil, 1
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	SoraDGetChildByName(self, "Panel_cut"):setTouchEnabled(false)
	self.Node_spine = SoraDGetChildByName(self, "Node_spine")
	self.text_Name = SoraDGetChildByName(self, "Text_bossName")
	self.text_talk = SoraDGetChildByName(self, "Text_desInfo")
	self.Node_awardShow = SoraDGetChildByName(self, "Node_awardShow")
	self.Text_random = SoraDGetChildByName(self, "Text_random")
	self.Text_random:setString(i18n("common_text_978"))
	self.warningLabel = SoraDGetChildByName(self, "Text_warning")
	self.warningLabel:setPositionY(-320)
	self.warningLabel:setColor(display.COLOR_RED)
	self.warningLabel = SoraDCreateTimerLabel(self, self.warningLabel)
	self.warningLabel:setVisible(true)
	self.warningLabel:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("common_text_3604", nil)
	end)
	self.warningLabel:setTimeEndListener(function()
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	self.Button_attack = SoraDGetChildByName(self, "Button_attack")
	self.Button_attack:setTitleText(i18n("Semruk_text_08"))
	self.Button_attack:addTouchEventListener(handler(self, self.onBtnAttackClick))
	local imgHeroHead = ccui.ImageView:create("qctj_bust.png", ccui.TextureResType.plistType)
	imgHeroHead:setAnchorPoint(cc.p(0, 0))
	imgHeroHead:setPosition(-187, -5)
	imgHeroHead:addTo(self.Node_spine)
end
function kipchaksBossInfoView:initData(buildIndex)
	self.buildIndex = buildIndex
	if cityCtrl.kipchaksData.refreshNpc then
		self.npcLv = cityCtrl.kipchaksData.refreshNpc[tostring(self.buildIndex)]
		self.warningLabel:beginTime(serviceFunctions.getTodayRemainTime())
	end
	self.bossData = buildDescribeRead.getkipchaks(self.npcLv)
	self.text_Name:setString(i18n("npc_name_025") .. " Lv." .. self.npcLv)
	self.text_talk:setString(i18n("Semruk_text_07"))
	local info
	if info then
		self.spine_hero = sp.SkeletonAnimation:create(info.skel, info.atlas, 0.5)
		self.spine_hero:setPosition(0, -100)
		self.spine_hero:setAnimation(0, "animation", true)
		self.spine_hero:addTo(self.Node_spine)
	else
	end
	for i = 1, 4 do
		local awardItem = SoraDGetChildByName(self, "Node_award_" .. i)
		local sprite_item = SoraDGetChildByName(awardItem, "sprite_item")
		local Text_ItemName = SoraDGetChildByName(awardItem, "Text_ItemName")
		SoraDGetChildByName(awardItem, "Image_itemBar"):setVisible(true)
		local Text_num = SoraDGetChildByName(awardItem, "Text_num")
		local itemID = self.bossData.reward[2 * i - 1]
		local itemNum = self.bossData.reward[2 * i]
		if itemID then
			sprite_item:setSpriteFrame(publicRead.getIcon(itemID))
			Text_ItemName:setString(publicRead.getName(itemID))
			Text_num:setString(string.formatnumberthousands(itemNum))
			Text_num:setVisible(true)
		else
			awardItem:setVisible(false)
		end
		sprite_item:setScale(95.03999999999999 / sprite_item:getContentSize().width)
	end
	SoraDToCenter(self.Node_awardShow, 140)
end
function kipchaksBossInfoView:onBtnAttackClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local dispatchPanel = uiManager:show("WorldDispatchArmyView")
		_ENV = nil
		;(nil).isKipchaks = true
		;(nil).kipchaksBuildIndex = self.buildIndex
		dispatchPanel:initData(nil)
		self:removeFromParent()
	end
end
return kipchaksBossInfoView
