local mailFunctions = include("mailFunctions")
local allianceDesRead = include("allianceDesRead")
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local chatFunctions = include("chatFunctions")
local allianceTaskRankOwn = class("allianceTaskRankOwn", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceTaskRankOwn")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
function allianceTaskRankOwn:ctor()
	self.Sprite_index = SoraDGetChildByName(self, "Sprite_index")
	self.node_flag = SoraDGetChildByName(self, "Node_flag")
	self.Sprite_war = SoraDGetChildByName(self, "Sprite_war")
	self.Image_head = SoraDGetChildByName(self, "Image_head")
	self.Text_index = SoraDGetChildByName(self, "Text_index")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_donate = SoraDGetChildByName(self, "Text_donate")
	self.Text_score = SoraDGetChildByName(self, "Text_score")
	self.node_user = SoraDGetChildByName(self, "node_user")
	self.node_alliance = SoraDGetChildByName(self, "node_alliance")
	self.Text_alliance_leader = SoraDGetChildByName(self, "Text_alliance_leader")
	self.Text_name_alliance = SoraDGetChildByName(self, "Text_name_alliance")
	self.Text_score_alliance = SoraDGetChildByName(self, "Text_score_alliance")
	self.Text_index_alliance = SoraDGetChildByName(self, "Text_index_alliance")
	self.icon_alliance = SoraDGetChildByName(self.Image_head, "icon_alliance")
	self.itemSize = cc.size(640, 120)
	self.itemWidth = self.itemSize.width
	self.itemHeight = self.itemSize.height
end
function allianceTaskRankOwn:updateNoRank(rankType)
end
function allianceTaskRankOwn:init(data, i, rankType)
	if not data then
		self:updateNoRank(rankType)
		return
	end
	self.rankType = rankType
	self.itemData = data
	self.Sprite_war:setVisible(false)
	self.Text_score_alliance:setFontSize(24)
	if rankType == gMobilizationRankType.ALLIANCE then
		self.node_user:setVisible(false)
		self.node_alliance:setVisible(true)
		mailFunctions = self.node_alliance.setVisible
		local mailFunctions, self.node_alliance.setVisible[1], tbHide = self.Image_head, self.Image_head, self.node_alliance.setVisible
		local self.Image_head[1], tbShow = self.node_flag, self.Image_head
		SoraDSetNodeArrayVisible(tbHide, false)
		SoraDSetNodeArrayVisible(tbShow, true)
		local allianceName = mailFunctions:getWrappedName(self.itemData.aInfo.allianceAbbr, data.aInfo.allianceName)
		allianceName = allianceName .. "#" .. self.itemData.aInfo.kid
		self.Text_name_alliance:setString(allianceName)
		_ENV = nil
		;(nil).name = data.leadername
		self.Text_alliance_leader:setString(i18n("common_text_170", nil))
		self.Text_score_alliance:setString(data.score)
		self.node_flag:removeAllChildren()
		allianceDesRead.getFlagWithParticle(self.itemData.aInfo.allianceFlag, self.node_flag)
		self.node_flag:setScale(0.5)
		self.Text_index_alliance:setVisible(self.itemData.rank > RANK_TOP_SPECIAL)
		if self.itemData.rank <= RANK_TOP_SPECIAL then
			if SoraDFIsRA() then
				self.node_flag:setPositionX(410)
			else
				self.node_flag:setPositionX(260)
			end
			self.node_alliance:setPositionX(SoraDFIsRA() and -100 or 100)
			self.Sprite_index:setPositionX(SoraDFIsRA() and 490 or 160)
		else
			if SoraDFIsRA() then
				self.node_flag:setPositionX(460)
			else
				self.node_flag:setPositionX(220)
			end
			self.node_alliance:setPositionX(SoraDFIsRA() and -80 or 80)
		end
		self.Sprite_index:setVisible(self.itemData.rank <= RANK_TOP_SPECIAL)
		local isOwn = false
		local ownAid = allianceMgr:getOwnAid()
		if ownAid ~= 0 and ownAid == self.itemData.aid then
			isOwn = true
		end
		self.Text_index_alliance:setString(tostring(self.itemData.rank))
		if data.score == 0 then
			self.Text_score_alliance:setString(i18n("common_text_3404"))
			self.Text_score_alliance:setFontSize(20)
			self.Text_index_alliance:setVisible(false)
		else
		end
		if self.itemData.rank <= RANK_TOP_SPECIAL then
			self.Sprite_index:setSpriteFrame("icon_ranking_" .. self.itemData.rank .. ".png")
		end
	elseif rankType == gMobilizationRankType.PLAYER then
		self.node_user:setVisible(true)
		self.node_alliance:setVisible(false)
		mailFunctions = self.node_alliance.setVisible
		local mailFunctions, self.node_alliance.setVisible[1], tbHide = self.node_flag, self.node_flag, self.node_alliance.setVisible
		local self.node_flag[1], tbShow = self.Image_head, self.node_flag
		SoraDSetNodeArrayVisible(tbHide, false)
		SoraDSetNodeArrayVisible(tbShow, true)
		SoraDGetHeadFromManager(self.Image_head, data.uInfo.headid, data.uInfo.avatar)
		local nickName = data.uInfo.nickName
		if data.castlelv then
			local isShowWarLv, textLv = SoraDGetBuildWarLv(data.castlelv)
			self.Sprite_war:setVisible(false)
		end
		self.Text_name:setString(nickName)
		SoraDGetAutoHeightLabel(self.Text_name, 204)
		if SoraDFIsRA() then
			self.Sprite_war:setPositionX(self.Text_name:getPositionX() - (self.Text_name:getContentSize().width + 25))
		else
			self.Sprite_war:setPositionX(self.Text_name:getPositionX() + (self.Text_name:getContentSize().width + 25))
		end
		self.Text_score:setString(data.score)
		self.Text_donate:setString(string.format("%d/%d", data.completenum, data.receivenum))
		self.Text_index:setVisible(self.itemData.rank > RANK_TOP_SPECIAL)
		self.Sprite_index:setVisible(self.itemData.rank <= RANK_TOP_SPECIAL)
		local isOwn = false
		local ownUid = chatFunctions:getSelfId()
		if ownUid ~= 0 and ownUid == self.itemData.uid then
			isOwn = true
		end
		self.Text_index:setString(tostring(self.itemData.rank))
		if self.itemData.rank <= RANK_TOP_SPECIAL then
			self.Sprite_index:setSpriteFrame("icon_ranking_" .. self.itemData.rank .. ".png")
		end
		print("self.itemData.alliancerank = ", self.itemData.alliancerank)
		self.icon_alliance:setSpriteFrame(allianceDesRead.getIcon(self.itemData.alliancerank))
	end
end
return allianceTaskRankOwn
