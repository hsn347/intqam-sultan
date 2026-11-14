local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local allianceRelationCtrl = gametop.playertop_:getModule("allianceRelationCtrl")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
local instanceCacheMgr = include("instanceCacheMgr")
local worldMapMineBuild = class("worldMapMineBuild", function()
	local target = include("worldMapInstance").new("worldMapMineBuild")
	return target
end)
function worldMapMineBuild:ctor()
	self:_initData()
	self:_initUI()
end
function worldMapMineBuild:_initData()
	self.objId = nil
	self.buildID = nil
	self.leagueID = 0
	self.leagueAbbrName = ""
	self.size = 2
	self.radioation = 0
end
function worldMapMineBuild:_initUI()
	self.modelImage = display.newSpriteNoChild("#alliance_mineral_nongtian.png")
	self.modelImage:setPosition(cc.p(0, 30))
	self:addChild(self.modelImage, -1)
	self.image_name_bg = display.newSpriteNoChild("#frame_map_07.png")
	self.image_name_bg:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_name_bg:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 60))
	self.image_name_bg:addTo(self, 1)
	self.image_name_bg:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_name_bg
	self.image_name_bg.UILabelType = 2
	self.image_name_bg.text = "leagueName"
	self.image_name_bg.size = 20
	self.text_Name = SoraDCreateLabelNoChild(self.image_name_bg)
	self.text_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Name:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 62))
	self.text_Name:addTo(self, 1)
	self.text_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
end
function worldMapMineBuild:createStatusImg()
	self.spriteBg = display.newSpriteNoChild("#frame_main_receive.png")
	self.spriteBg:setAnchorPoint(cc.p(0.5, 0.5))
	self.spriteBg:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y + 100))
	self.spriteBg:addTo(self, 1)
	self.spriteBg:setOpacity(180)
	self.statusImg = display.newSpriteNoChild("#icon_saleRoom_symbol.png")
	self.statusImg:setAnchorPoint(cc.p(0.5, 0.5))
	self.statusImg:setScale(0.65)
	self.statusImg:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y + 100))
	self.statusImg:addTo(self, 2)
end
function worldMapMineBuild:setBatchNodeGroupID(groupID)
	self.modelImage:setGroupID(groupID)
end
function worldMapMineBuild:setBuildSize(size, radioation)
	self.size = size
	self.radioation = radioation
end
function worldMapMineBuild:initInstanceData(objId, buildData)
	self.objId = objId
	self:initMineEffect()
	self:updateData(buildData)
end
function worldMapMineBuild:addCacheBefore()
	if self.mineEffect then
		instanceCacheMgr.addNormalNodeByType(self.mineEffect, self.mineEffect:getName())
		self.mineEffect:removeFromParent()
		self.mineEffect = nil
	end
end
function worldMapMineBuild:initMineEffect()
	local resID = allianceStrongholdMineRead.getMineOutputId(self.objId)
	if self.mineEffect then
		if self.mineEffect.resID == resID then
			return
		end
		instanceCacheMgr.addNormalNodeByType(self.mineEffect, self.mineEffect:getName())
		self.mineEffect:removeFromParent()
		self.mineEffect = nil
	end
	allianceStrongholdMineRead = self.mineEffect.removeFromParent
	allianceStrongholdMineRead = self.mineEffect:getName()
	self.mineEffect:getName().csb = "Node_mine_fmc"
	self.mineEffect.removeFromParent[gIDDef.WOOD], self.mineEffect:getName().offset = self.mineEffect:getName()
	allianceStrongholdMineRead = self.mineEffect:getName()
	self.mineEffect:getName().csb = "Node_mine_tk"
	self.mineEffect.removeFromParent[gIDDef.IRON], self.mineEffect:getName().offset = self.mineEffect:getName()
	allianceStrongholdMineRead = self.mineEffect:getName()
	self.mineEffect:getName().csb = "Node_mine_my"
	self.mineEffect.removeFromParent[gIDDef.MITHRIL], self.mineEffect:getName().offset = self.mineEffect:getName()
	local etCfg = self.mineEffect.removeFromParent
	local data = etCfg[resID]
	if data then
		local effect = instanceCacheMgr.getInstance(data.csb)
		if effect then
			effect:addTo(self)
			effect:release()
		else
			effect = SoraDCreatAnimation(data.csb)
			effect:setName(data.csb)
			effect:addTo(self)
		end
		local pos = cc.p(data.offset.x + self.modelImage:getPositionX(), data.offset.y + self.modelImage:getPositionY())
		effect:setPosition(pos)
		effect.resID = resID
		self.mineEffect = effect
	end
end
function worldMapMineBuild:getBuildClassID()
	return self.objId
end
function worldMapMineBuild:updateData(data)
	if not data then
		return
	end
	if data then
		self.leagueID = data.leagueID
		self.leagueAbbrName = data.leagueAbbrName
	end
	self:updatePlayerInfo()
end
function worldMapMineBuild:onMessageListener()
end
function worldMapMineBuild:getRamdanWorldTaskIndex()
	return self.taskIndex
end
function worldMapMineBuild:updateStatusImg()
end
function worldMapMineBuild:updatePlayerInfo()
	self:setBuildSize(2, 0)
	self.modelImage:setSpriteFrame(allianceStrongholdMineRead.getMineImage(self.objId))
	self.text_Name:setString(allianceStrongholdMineRead.getMineName(self.objId))
	self.text_Name:setColor(cc.c3b(255, 255, 255))
	if self.leagueID and 0 < self.leagueID then
		if self.leagueID == allianceMgr:getOwnAid() then
			self.text_Name:setColor(worldMapDefine.getLeagueManorLineColor(true))
			self:showProduceAct()
		end
		allianceStrongholdMineRead = worldMapDefine.getLeagueManorLineColor(true)
		worldMapDefine.getLeagueManorLineColor(true).abbr = self.leagueAbbrName
		worldMapDefine.getLeagueManorLineColor(true).name = allianceStrongholdMineRead.getMineName(self.objId)
		self.text_Name:setString(i18n("common_text_186", worldMapDefine.getLeagueManorLineColor(true)))
		local allianceRelationType = allianceRelationCtrl:getRelationTypeWith(self.leagueID)
		local nameColor = worldMapDefine.getLeagueManorLineColor(self.leagueID == allianceMgr:getOwnAid(), allianceRelationType)
		self.text_Name:setColor(nameColor)
	else
		self.text_Name:setColor(cc.c3b(255, 255, 255))
		self:hideProduceAct()
	end
end
function worldMapMineBuild:showProduceAct()
	local resID = allianceStrongholdMineRead.getMineOutputId(self.objId)
	local resNum = allianceStrongholdMineRead.getMineOutputNum(self.objId)
	local publicRead = include("publicRead")
	if not self.nodeProduce then
		self.nodeProduce = display.newNode()
		self.nodeProduce:setPosition(self.centerPoint.x, self.centerPoint.y)
		self.nodeProduce:addTo(self, 9)
		local icon = display.newSprite("#" .. publicRead.getIcon(resID))
		icon:setName("icon")
		icon:setScale(0.5)
		icon:addTo(self.nodeProduce)
		icon:setPosition(-20, 0)
		local text_produce = ccui.Text:create("", "", 18)
		text_produce:setName("text_produce")
		text_produce:setAnchorPoint(cc.p(0.5, 0.5))
		text_produce:setPosition(cc.p(20, 0))
		text_produce:addTo(self.nodeProduce)
	end
	self.nodeProduce:getChildByName("icon"):setURL(publicRead.getIcon(resID))
	self.nodeProduce:getChildByName("text_produce"):setString("+" .. math.floor(resNum / 40))
	self.nodeProduce:setVisible(true)
	self.nodeProduce:stopAllActions()
	self.nodeProduce:setPositionY(0)
	_UPVALUE3_ = self.nodeProduce
	self.nodeProduce[1] = cca.moveTo(1.0, 0, 80)
	self.nodeProduce[2] = cca.callFunc(function()
		self.nodeProduce:setPositionY(0)
		self.nodeProduce:setVisible(false)
	end)
	self.nodeProduce[3] = cca.delay(90)
	self.nodeProduce[4] = cca.callFunc(function()
		self.nodeProduce:setVisible(true)
	end)
	self.nodeProduce[5] = cca.callFunc(function()
		self.nodeProduce:setVisible(true)
	end)
	local seqAct = cca.seq(self.nodeProduce)
	self.nodeProduce:runAction(cc.RepeatForever:create(seqAct))
end
function worldMapMineBuild:hideProduceAct()
	if self.nodeProduce then
		self.nodeProduce:stopAllActions()
		self.nodeProduce:setPositionY(0)
		self.nodeProduce:setVisible(false)
	end
end
function worldMapMineBuild:getFavoriteName()
	local favoriteName = ""
	if self.objId then
		favoriteName = allianceStrongholdMineRead.getMineName(self.objId)
	end
	return favoriteName
end
function worldMapMineBuild:playClickSound()
	SoraDPlaySound("innerbuildsound", 119)
end
function worldMapMineBuild:onClickInstance(onShowView)
	self:playClickSound()
	local selectShowPanel = self:onShowWorldMapTip(onShowView)
	return selectShowPanel, true
end
function worldMapMineBuild:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	_ENV = nil
	;(nil).buttonType = worldMapDefine.worldMapTipButtonType_xiangqing
	table.insert(buttonTypeArray, nil)
	return buttonTypeArray
end
return worldMapMineBuild
