local mailFunctions = include("mailFunctions")
local allianceDesRead = include("allianceDesRead")
local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local chatFunctions = include("chatFunctions")
local allianceTaskRankingsSingle = class("allianceTaskRankingsSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceTaskRankingsSingle")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
function allianceTaskRankingsSingle:ctor()
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Image_barBg = SoraDGetChildByName(self, "Image_1")
	self.Image_frame = SoraDGetChildByName(self, "Image_frame")
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
	self:setSwallowTouches(false)
	self:setTouchEnabled(false)
	self.Panel_touch:setSwallowTouches(false)
	self.itemSize = cc.size(640, 120)
	self.itemWidth = self.itemSize.width
	self.itemHeight = self.itemSize.height
	if self.Panel_touch then
		self.Panel_touch:setTouchEnabled(true)
		self.Panel_touch:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function allianceTaskRankingsSingle:init(data, i, rankType)
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
		self.node_flag:setScale(0.4)
		self.Text_index_alliance:setVisible(self.itemData.rank > RANK_TOP_SPECIAL)
		self.Sprite_index:setVisible(self.itemData.rank <= RANK_TOP_SPECIAL)
		local isOwn = false
		local ownAid = allianceMgr:getOwnAid()
		if ownAid ~= 0 and ownAid == self.itemData.aid then
			isOwn = true
		end
		self.Image_barBg:loadTexture("frame_alliance_pank_04.png", ccui.TextureResType.plistType)
		self.Text_index_alliance:setString(tostring(self.itemData.rank))
		if data.score == 0 then
			self.Text_score_alliance:setString(i18n("common_text_3404"))
			self.Text_score_alliance:setFontSize(20)
			self.Text_index_alliance:setVisible(false)
		else
		end
		if self.itemData.rank <= RANK_TOP_SPECIAL then
			self.Sprite_index:setSpriteFrame("icon_ranking_" .. self.itemData.rank .. ".png")
			self.Image_barBg:loadTexture("frame_alliance_pank_0" .. self.itemData.rank .. ".png", ccui.TextureResType.plistType)
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
			if isShowWarLv then
			else
			end
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
		self.Image_barBg:setVisible(self.itemData.rank <= RANK_TOP_SPECIAL or isOwn)
		self.Text_index:setString(tostring(self.itemData.rank))
		if self.itemData.rank <= RANK_TOP_SPECIAL then
			self.Sprite_index:setSpriteFrame("icon_ranking_" .. self.itemData.rank .. ".png")
			self.Image_barBg:loadTexture("frame_alliance_pank_0" .. self.itemData.rank .. ".png", ccui.TextureResType.plistType)
		end
		self.icon_alliance:setSpriteFrame(allianceDesRead.getIcon(self.itemData.alliancerank))
	end
end
function allianceTaskRankingsSingle:onMessageListener()
end
function allianceTaskRankingsSingle:getItemWidth()
	return self.itemSize.width
end
function allianceTaskRankingsSingle:getItemHeight()
	return self.itemSize.height
end
function allianceTaskRankingsSingle:setScroll(scroll)
	self.scroll = scroll
end
function allianceTaskRankingsSingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		dump(self.itemData, "单条数据")
		SoraDPlaySound()
		print("allianceTaskRankingsSingle:btnClickCallBack(button,type)---------")
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.rankType == gMobilizationRankType.ALLIANCE then
			print("请求联盟数据------, ", self.itemData.aid)
			local gametop = gModuleMgr.getObject("gametop")
			local allianceQuery = gametop.playertop_:getModule("allianceQuery")
			_ENV = nil
			;(nil).from = "allianceTaskRankingsView"
			allianceQuery:reqAllianceInfo(self.itemData.aInfo.kid, self.itemData.aid, nil)
		else
			local ownUid = chatFunctions:getSelfId()
			if ownUid ~= 0 and ownUid == self.itemData.uid then
				print("这是自己----------")
			elseif self.itemData.uid ~= 0 then
				local playerID = self.itemData.uid
				_ENV = allianceQuery
				allianceQuery.msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
				allianceQuery.playerID = playerID
				SoraDSendMessage(allianceQuery)
			end
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif event == ccui.TouchEventType.began then
		self.singleIsMoved = false
	end
end
return allianceTaskRankingsSingle
