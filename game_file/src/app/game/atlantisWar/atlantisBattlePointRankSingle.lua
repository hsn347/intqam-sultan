local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local atlantisBattlePointRankSingle = class("atlantisBattlePointRankSingle", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("atlantisBattlePointRankSingle")
end)
function atlantisBattlePointRankSingle:ctor(properties)
	self.panelColor = SoraDGetChildByName(self, "Panel_Color")
	self.panelColor.__background_color__ = self.panelColor:getChild("graph")
	self.spIndex = SoraDGetChildByName(self.panelColor, "Sprite_index")
	self.textIndex = SoraDGetChildByName(self.panelColor, "Text_index")
	self.nodeFlag = SoraDGetChildByName(self.panelColor, "Node_flag")
	self.spRank = SoraDGetChildByName(self.panelColor, "Sprite_rank")
	self.btnHead = SoraDGetChildByName(self.panelColor, "Button_Head")
	self.btnHead:addTouchEventListener(handler(self, self.btnHeadClick))
	self.spHead = SoraDGetChildByName(self.panelColor, "Sprite_head")
	self.textName = SoraDGetChildByName(self.panelColor, "Text_name")
	self.nodePeople = SoraDGetChildByName(self.panelColor, "Node_People")
	self.textMemberNum = SoraDGetChildByName(self.nodePeople, "Text_memberNum")
	self.nodeNum = SoraDGetChildByName(self.panelColor, "Node_num")
	self.textNum = SoraDGetChildByName(self.nodeNum, "Text_num")
	self.nodePoint = SoraDGetChildByName(self.panelColor, "Node_Point")
	self.textKillUser = SoraDGetChildByName(self.nodePoint, "Text_KillUser")
	self.textKillMonster = SoraDGetChildByName(self.nodePoint, "Text_KillMonster")
	self.textOccupied = SoraDGetChildByName(self.nodePoint, "Text_Occupied")
	self.textTotal = SoraDGetChildByName(self.panelColor, "Text_Total")
end
function atlantisBattlePointRankSingle:initData(data, otherData)
	self.parentView = otherData.view
	self.singleData = data
	local index = self:getTag()
	self.rank = data.rank or index
	self.selfRank = data.selfRank
	self.panelColor:setBackGroundColorType(index % 2 == 0 and ccui.LayoutBackGroundColorType.solid or ccui.LayoutBackGroundColorType.none)
	if data.headid then
		self.nodeFlag:setVisible(false)
		self.spHead:setVisible(true)
		SoraDGetHeadFromManager(self.spHead, data.headid, data.avatar or "")
	end
	if data.flag then
		self.nodeFlag:removeAllChildren()
		allianceDesRead.getFlagWithParticle(data.flag, self.nodeFlag)
		self.spHead:setVisible(false)
	end
	if data.nameStr then
		self.textName:setString(data.nameStr)
	elseif data.nickName then
		self.textName:setString(textParser.formatPlayerName(data.abbr, data.nickName, data.kid))
	elseif data.kid then
		self.textName:setString(serviceFunctions.getKingdomFormatName(data.kingdomName, data.kid))
	end
	if self.textIndex then
		self.textIndex:setVisible(self.rank > RANK_TOP_SPECIAL or self.rank == 0)
	end
	if self.spIndex then
		self.spIndex:setVisible(self.rank > 0 and self.rank <= RANK_TOP_SPECIAL)
	end
	if self.rank > 0 and self.rank <= RANK_TOP_SPECIAL then
		if self.spIndex then
			self.spIndex:setSpriteFrame("icon_ranking_" .. self.rank .. ".png")
		end
	elseif self.textIndex then
		if self.rank == 0 or self.rank > 150 then
			self.textIndex:setString(i18n("common_text_827"))
		else
			self.textIndex:setString(self.rank)
		end
	end
	if data.totalScore then
		self.textTotal:setString(string.formatnumberthousands(data.totalScore))
	else
		local totalScore = (data.killPlayerScore or 0) + (data.killBossScore or 0) + (data.occupyScore or 0)
		if otherData.scoreWeight then
			totalScore = math.floor(totalScore * otherData.scoreWeight)
		end
		self.textTotal:setString(string.formatnumberthousands(totalScore))
	end
	if data.killPlayerScore then
		self.textKillUser:setString(string.formatnumberthousands(data.killPlayerScore))
	end
	if data.killBossScore then
		self.textKillMonster:setString(string.formatnumberthousands(data.killBossScore))
	end
	if data.occupyScore then
		self.textOccupied:setString(string.formatnumberthousands(data.occupyScore))
	end
	if data.score then
		if tolua.type(data.score) == "string" then
			self.textNum:setString(data.score)
		else
			self.textNum:setString(string.formatnumberthousands(data.score))
		end
		self.nodePoint:setVisible(false)
		self.nodePeople:setVisible(false)
		self.textName:setPositionY(50)
	elseif data.peopleNum then
		self.nodePeople:setVisible(true)
		self.textName:setPositionY(80.0)
		self.textMemberNum:setString(string.formatnumberthousands(data.peopleNum))
	else
		self.nodePeople:setVisible(false)
	end
end
function atlantisBattlePointRankSingle:btnHeadClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if self.rank == self.selfRank then
			SoraDOpenLordView(lordInfoCtrl:getLordInfo())
		else
			local kid = gametop.playertop_:getKingdomID()
			_ENV = lordInfoCtrl:getLordInfo()
			lordInfoCtrl:getLordInfo().targetName = self.parentView.__cname
			lordInfoCtrl:getLordInfoByUid(self.singleData.uid, self.singleData.kid or kid, lordInfoCtrl:getLordInfo())
			SoraDShowLoading(self.parentView)
		end
	end
end
return atlantisBattlePointRankSingle
