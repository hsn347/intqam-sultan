local worldMapBossView = include("worldMapBossView")
local endlessTrialsCtrl = SoraDGetCtrl("endlessTrialsCtrl")
local mailFunctions = include("mailFunctions")
local worldMapEndlessTrialBossInfo = class("worldMapEndlessTrialBossInfo", worldMapBossView)
function worldMapEndlessTrialBossInfo:ctor(...)
	worldMapEndlessTrialBossInfo.super.ctor(self, ...)
	local Center_Node = SoraDGetChildByName(self, "Center_Node")
	local node = SoraDCreateCSBNode("endlessTrialsBossInfo")
	node:addTo(Center_Node, 1)
	node:setPosition(-320, -500)
	self.Node_class = SoraDGetChildByName(node, "Node_class")
	self.Sprite_class = SoraDGetChildByName(node, "Sprite_class")
	local Node_ice = SoraDGetChildByName(node, "Node_ice")
	Node_ice:removeFromParent()
	local Node_kk = SoraDGetChildByName(self, "Node_kk")
	Node_ice:addTo(Node_kk)
	Node_ice:setPosition(0, 0)
	local effect = SoraDCreatAnimation("Node_Effect_wjtzjf03")
	SoraDMixtureGLONEByParent(effect)
	effect:addTo(Node_kk)
	effect:setPosition(0, 86)
	local Panel_cut = SoraDGetChildByName(node, "Panel_cut")
	self.Panel_cut = Panel_cut
	local effect = SoraDCreatAnimation("Node_Effect_wjtzjf04")
	effect:setRotation(180)
	SoraDMixtureGLONEByParent(effect)
	effect:addTo(Panel_cut)
	local size = Panel_cut:getContentSize()
	self.oldSize = size
	effect:setPosition(size.width / 2, size.height / 2)
	self.expPoint = SoraDGetChildByName(effect, "G_dh_Tex_lcks_006")
	self.expPoint:setVisible(true)
	if SoraDFIsRA() then
		Panel_cut:setRotation(180)
		Panel_cut:setPositionX(Panel_cut:getPositionX() + size.width)
		self.expPoint:setAnchorPoint(cc.p(1, 0.5))
	else
		self.expPoint:setAnchorPoint(cc.p(0, 0.5))
		self.expPoint:setFlippedX(true)
	end
	self.progress_blood:loadTexture("progressbar_01_blue1.png", ccui.TextureResType.plistType)
	for i = 1, 4 do
		SoraDGetChildByName(self, "Text_item_name_" .. i):setColor(display.COLOR_WHITE)
	end
	if G_IS_UNITY then
		local ice_btn = node:getChild("ice_btn")
		if ice_btn then
			ice_btn:setVisible(false)
		end
	end
end
function worldMapEndlessTrialBossInfo:initData(...)
	worldMapEndlessTrialBossInfo.super.initData(self, ...)
	self.Node_class:setPositionX(display.cx + self.text_Name:getPositionX() - self.text_Name:getContentSize().width - 35)
	local info = endlessTrialsCtrl:getBossTypeInfo(self.boss:getBossClassID())
	self.Sprite_class:setSpriteFrame(mailFunctions:getSoldierClassIcon(info.arms[1]))
	local config = endlessTrialsCtrl:getScoreConfig(info.type, self.boss.bossLevel)
	worldMapEndlessTrialBossInfo = mailFunctions:getSoldierClassIcon(info.arms[1])
	mailFunctions:getSoldierClassIcon(info.arms[1]).num1 = config.perScore
	mailFunctions:getSoldierClassIcon(info.arms[1]).num2 = config.allienceScore
	self.textHeroBossTip:setString(i18n("Endless_trial_text_17", mailFunctions:getSoldierClassIcon(info.arms[1])))
	self.textHeroBossTip:setVisible(true)
	local percent = self.progress_blood:getPercent()
	local width = self.oldSize.width * percent / 100
	self.Panel_cut:setContentSize(cc.size(width, self.oldSize.height))
	self.expPoint:setPositionX(-width + self.oldSize.width / 2)
end
return worldMapEndlessTrialBossInfo
