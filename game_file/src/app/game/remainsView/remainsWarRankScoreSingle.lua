local scrollNode = include("scrollNode")
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local remainsWarRead = include("remainsWarRead")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local remainsWarRankScoreSingle = class("remainsWarRankScoreSingle", function(target)
	return target
end)
function remainsWarRankScoreSingle:ctor()
	self.frame_rank = SoraDGetChildByName(self, "frame_rank")
	if self.frame_rank then
		self.frame_rank = scrollNode.new(self.frame_rank)
		self.frame_rank:setSwallowTouches(false)
		self.frame_rank:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	self.imgBarBg = SoraDGetChildByName(self, "frame_rank_bg")
	self.Node_head = SoraDGetChildByName(self, "Node_head")
	self.spriteIndex = SoraDGetChildByName(self, "Sprite_Rank")
	self.icon_head = SoraDGetChildByName(self, "icon_head")
	self.labelIndex = SoraDGetChildByName(self, "text_my_rank")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelNum = SoraDGetChildByName(self, "Text_score")
	self.spScore = SoraDGetChildByName(self, "Sprite_score")
	self.handle = nil
end
function remainsWarRankScoreSingle:initData(data)
	self.tableSingleData = data
	self:setPlayerInfo()
end
function remainsWarRankScoreSingle:initSelfData(data)
	self.tableSingleData = data
	self:setRank()
	self:setSelfInfo()
	local rankScore = remainsTeamCtrl:getPlayerRankScore()
	local segmentID = remainsTeamCtrl:getPlayerSegment()
	local star = remainsTeamCtrl:getPlayerStar()
	self:setScore(rankScore, segmentID, star)
end
function remainsWarRankScoreSingle:setSelfInfo(...)
	local player = lordInfoCtrl:getBaseInfo()
	SoraDGetHeadFromManager(self.icon_head, player.imageId, player.avatar)
	if player.nickName then
		local name = player.nickName
		local leagueAbbrName = player.allianceAbbr
		if leagueAbbrName then
			lordInfoCtrl = nil
			;(nil).abbr = leagueAbbrName
			;(nil).name = player.nickName
			name = i18n("common_text_186", nil)
		end
		local sourceKid = lordInfoCtrl:getSourceKid()
		if sourceKid and sourceKid <= 0 then
			sourceKid = gametop.playertop_:getKingdomID()
		end
		if sourceKid then
			name = name .. "#" .. tostring(sourceKid)
		end
		self.labelName:setString(name)
	end
end
function remainsWarRankScoreSingle:initTitleData(data)
	self.tableSingleData = data
	local name = self:getLabelName()
	self.labelName:setString(name)
	self:setDataInfo()
	self:setRank()
	self:setTitleData(data)
end
function remainsWarRankScoreSingle:initSelfTitleData(data)
	self.tableSingleData = data
	self:setRank()
	self:setSelfInfo()
	self:setTitleData(data)
end
function remainsWarRankScoreSingle:setTitleData(data)
	self.labelNum:setString(string.formatnumberthousands(data.score or 0))
	self.Text_times = SoraDGetChildByName(self, "Text_times")
	self.Text_times:setString(string.formatnumberthousands(data.times or 0))
end
function remainsWarRankScoreSingle:btnQuickClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
	end
end
function remainsWarRankScoreSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.handle then
			self.handle(self.tableSingleData)
		end
	end
end
function remainsWarRankScoreSingle:setScroll(scroll)
	self.frame_rank:setScroll(scroll)
end
function remainsWarRankScoreSingle:setHandle(handle)
	self.handle = handle
end
function remainsWarRankScoreSingle:getLabelName()
	local name = self.tableSingleData.nickName
	local allianceAbbr = self.tableSingleData.allianceAbbr
	if allianceAbbr ~= nil and string.len(allianceAbbr) > 0 then
		_ENV = nil
		;(nil).abbr = allianceAbbr
		;(nil).name = self.tableSingleData.nickName
		name = i18n("common_text_186", nil)
	end
	if self.tableSingleData.kid then
		name = name .. "#" .. tostring(self.tableSingleData.kid)
	end
	return name
end
function remainsWarRankScoreSingle:setPlayerInfo(data)
	local name = self:getLabelName()
	self.labelName:setString(name)
	self:setDataInfo()
	self:setRank()
	self:setScore(self.tableSingleData.rankScore, self.tableSingleData.segment, self.tableSingleData.star)
end
function remainsWarRankScoreSingle:setScore(rankScore, segment, star)
	if rankScore then
		local strScore = string.formatnumberthousands(rankScore)
		self.labelNum:setString(strScore)
		local imgScore = remainsWarRead.getDanIcon(segment)
		self.spScore:setVisible(true)
		self.spScore:setSpriteFrame(imgScore)
		local startNode = SoraDGetRemainsWarStartNode(star or 0)
		startNode:addTo(self.spScore:getParent())
		startNode:setPosition(self.spScore:getPositionX(), self.spScore:getPositionY() - 20)
		startNode:setScale(0.3)
	else
		local strRank = i18n("common_text_480")
		self.labelNum:setString(strRank)
		self.spScore:setVisible(false)
	end
end
function remainsWarRankScoreSingle:setRank()
	if self.tableSingleData.rank and self.tableSingleData.rank > 0 then
		self.labelIndex:setVisible(self.tableSingleData.rank > RANK_TOP_SPECIAL)
		self.spriteIndex:setVisible(self.tableSingleData.rank <= RANK_TOP_SPECIAL)
		self.labelIndex:setString(tostring(self.tableSingleData.rank))
		if self.tableSingleData.rank <= RANK_TOP_SPECIAL then
			self.spriteIndex:setSpriteFrame("icon_ranking_" .. self.tableSingleData.rank .. ".png")
		end
	else
		self.spriteIndex:setVisible(false)
		local strRank = i18n("common_text_827")
		self.labelIndex:setString(strRank)
		self.labelIndex:setVisible(true)
		SoraDSetTextWidthHeight(self.labelIndex, cc.size(70, 50))
		self.labelIndex:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	end
end
function remainsWarRankScoreSingle:setDataInfo()
	SoraDGetHeadFromManager(self.icon_head, self.tableSingleData.headid, self.tableSingleData.avatar)
	self.imgBarBg:setVisible(true)
	local selfID = lordInfoCtrl:getLordInfo().base.uid
	if selfID == self.tableSingleData.uid then
		self.imgBarBg:setSpriteFrame("frame_alliance_pank_05.png")
	elseif self.tableSingleData.rank <= RANK_TOP_SPECIAL then
		self.imgBarBg:setSpriteFrame("frame_alliance_pank_0" .. self.tableSingleData.rank .. ".png")
	else
		self.imgBarBg:setSpriteFrame("frame_alliance_pank_04.png")
	end
end
return remainsWarRankScoreSingle
