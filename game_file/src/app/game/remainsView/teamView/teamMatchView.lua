local remainsWarUtil = include("remainsWarUtil")
local teamMatchView = class("teamMatchView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("teamMatchView")
	end
	return target
end)
function teamMatchView:ctor()
	self.single = SoraDGetChildByName(self, "Node_head")
	self.single:setVisible(false)
	self.txtNameSouth = SoraDGetChildByName(self, "Text_name_south")
	self.txtScoreSouth = SoraDGetChildByName(self, "Text_score_south")
	self.spFlagSouth = SoraDGetChildByName(self, "Sprite_team_south_flag")
	self.txtNameNorth = SoraDGetChildByName(self, "Text_name_north")
	self.txtScoreNorth = SoraDGetChildByName(self, "Text_score_north")
	self.spFlagNorth = SoraDGetChildByName(self, "Sprite_team_north_flag")
	self.txtScoreTitleSouth = SoraDGetChildByName(self, "Text_score_title_south")
	self.txtScoreTitleSouth:setString(i18n("common_text_4407"))
	self.txtScoreTitleNorth = SoraDGetChildByName(self, "Text_score_title_north")
	self.txtScoreTitleNorth:setString(i18n("common_text_4407"))
	self.nodeMemberSouth = SoraDGetChildByName(self, "Node_member_south")
	self.nodeMemberNorth = SoraDGetChildByName(self, "Node_member_north")
	self.frame_rank = SoraDGetChildByName(self, "Size_Panel_touch")
	self.frame_rank:setTouchEnabled(true)
	self.frame_rank:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.imgBg = SoraDGetChildByName(self, "Top_Image_bg")
	local imageDanFullPath = "bg_mailinfo_RomanKnight"
	if not _G.SoraDHasActivieyBg(imageDanFullPath) then
		self.imgBg:setVisible(false)
	else
		self.imgBg:setVisible(true)
		local scale = self.frame_rank:getContentSize().height / 210
		self.imgBg:setScale(scale * 1.1)
	end
	self:initEffect()
end
function teamMatchView:initView(data)
	dump(data, "data", 10)
	if not data.matchInfo then
		_ENV = data.matchInfo
	end
	self.tableSingleData = data.matchInfo
	if not self.tableSingleData.south then
		local _ENV, southData = self.tableSingleData.south, self.tableSingleData.south
	end
	if not self.tableSingleData.north then
		local _ENV, northData = self.tableSingleData.north, self.tableSingleData.north
	end
	self.southData = southData
	self.northData = northData
	self:updateBaseInfo()
	self:updateTeamMemberInfo()
end
function teamMatchView:initEffect()
	local loop = false
	local cssFileName = "teamMatchView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:stopAllActions()
	self:runAction(action)
end
local setTeamName = function(isSelfIn, txt)
	if isSelfIn then
		txt:setString(IsArClient and i18n("common_text_3033") or i18n("complement_text_01"))
	else
		txt:setString(IsArClient and i18n("common_text_3034") or i18n("complement_text_02"))
	end
end
function teamMatchView:updateBaseInfo()
	do
		local isSelfIn = remainsWarUtil.isSelfIn(self.southData.memberList)
		setTeamName(isSelfIn, self.txtNameSouth)
	end
	local southNameWidth = self.txtNameSouth:getContentSize().width / 2 + 25
	self.spFlagSouth:setPositionX(SoraDFIsRA() and southNameWidth or -southNameWidth)
	local rankSouthScore = self.southData.rankScore or 0
	self.txtScoreSouth:setString(string.formatnumberthousands(rankSouthScore))
	do
		local isSelfIn = remainsWarUtil.isSelfIn(self.northData.memberList)
		setTeamName(isSelfIn, self.txtNameNorth)
	end
	self.txtScoreNorth:setString(string.formatnumberthousands(self.northData.rankScore or 0))
	local northNameWidth = self.txtNameNorth:getContentSize().width / 2 + 25
	self.spFlagNorth:setPositionX(SoraDFIsRA() and northNameWidth or -northNameWidth)
end
function teamMatchView:updateTeamMemberInfo()
	if not self.southData.memberList then
		_UPVALUE0_ = self.southData.memberList
	end
	self:updateTeamMemberInfo_imp(self.nodeMemberSouth, self.southData.memberList)
	if not self.northData.memberList then
		_UPVALUE0_ = self.northData.memberList
	end
	self:updateTeamMemberInfo_imp(self.nodeMemberNorth, self.northData.memberList)
end
function teamMatchView:updateTeamMemberInfo_imp(member, memberList)
	local _ENV, scrollItems
	for _, v in ipairs(memberList) do
		local single = self.single:clone()
		single:setVisible(true)
		single:addTo(member)
		self:setSingleView(single, v)
		table.insert(scrollItems, single)
	end
	local INTER_WIDTH = 115
	local INTER_HEIGHT = 100
	local scrollW = INTER_WIDTH * 4
	for i, v in ipairs(scrollItems) do
		local posX = SoraDFPosX(scrollW - (i - 1) % 4 * INTER_WIDTH, scrollW)
		local posY = -math.floor((i - 1) / 4) * INTER_HEIGHT
		v:setPosition(cc.p(posX, posY))
	end
end
function teamMatchView:setSingleView(single, headData)
	local iconHead = SoraDGetChildByName(single, "icon_head")
	if headData then
		iconHead:setVisible(true)
		SoraDGetHeadFromManager(iconHead, headData.headid, headData.avatar)
	else
		iconHead:setVisible(false)
	end
end
function teamMatchView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
return teamMatchView
