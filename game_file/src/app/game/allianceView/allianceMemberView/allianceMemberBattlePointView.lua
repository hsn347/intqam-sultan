local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local warmHeartRead = include("warmHeartRead")
local allianceMemberBattlePointView = class("allianceMemberBattlePointView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceMemberBattlePointView")
	end
	return target
end)
local singleRankH = 100
function allianceMemberBattlePointView:ctor()
	self:initWidget()
	self:fitDevice()
	self:initData()
end
function allianceMemberBattlePointView:fitDevice()
end
function allianceMemberBattlePointView:getSortedList()
	local tableMemberList = allianceMgr:getMemberList(allianceMgr:getOwnAid())
	local allianceMgr, newMemberList = allianceMgr, allianceMgr
	local allianceMgr, threeMemberList = allianceMgr:getOwnAid()
	local allianceMgr, remainMemberList = allianceMgr:getOwnAid()
	local allianceMgr, myData = allianceMgr:getOwnAid()
	for i = 6, 1, -1 do
		for k, userInfo in ipairs(tableMemberList[tostring(i)]) do
			print("eowirpwoeiropweirwo", k)
			table.insert(newMemberList, userInfo)
		end
	end
	table.sort(newMemberList, function(a, b)
		return a.uinfo.totalFc > b.uinfo.totalFc
	end)
	dump(newMemberList, "wejflksdjfjsdlkfj" .. gametop.playertop_:getPlayerID(), 10)
	for i, v in ipairs(newMemberList) do
		if i <= 3 then
			table.insert(threeMemberList, v)
		else
			table.insert(remainMemberList, v)
		end
		if tonumber(gametop.playertop_:getPlayerID()) == tonumber(v.minfo.uid) then
			myData = v
			myData.rank = i
		end
	end
	return threeMemberList, remainMemberList, myData
end
function allianceMemberBattlePointView:onMessageListener()
end
function allianceMemberBattlePointView:initWidget()
	SoraDGetAllChildFromWidget(self, self)
	self.Text_name:setString(i18n("common_btn_21"))
	self.Text_rank:setString(i18n("common_text_2193"))
	self.Text_rank_name:setString(i18n("common_text_264"))
	self.Text_des:setString(i18n("common_text_090"))
	self.text_noData:setString(i18n("herobattle_text_05"))
end
function allianceMemberBattlePointView:initData()
	self.threeList, self.remainList, self.myData = self:getSortedList()
	self:initPersonalScroll(self.threeList, self.remainList, self.myData)
end
function allianceMemberBattlePointView:initPersonalScroll(topList, remainList, myData)
	dump(topList, "slkdjfskdljfsld1111", 10)
	dump(remainList, "slkdjfskdljfsld2222", 10)
	dump(myData, "slkdjfskdljfsld3333", 10)
	self.text_noData:setVisible(false)
	self.Image_head_1:setContentSize(cc.size(68, 86))
	self.Image_head_2:setContentSize(cc.size(68, 86))
	self.Image_head_3:setContentSize(cc.size(68, 86))
	self.Node_flag_1:setVisible(false)
	self.Node_flag_2:setVisible(false)
	self.Node_flag_3:setVisible(false)
	self.Image_head_1:loadTexture("frame_lshs_txd.png", ccui.TextureResType.plistType)
	self.Image_head_2:loadTexture("frame_lshs_txd.png", ccui.TextureResType.plistType)
	self.Image_head_3:loadTexture("frame_lshs_txd.png", ccui.TextureResType.plistType)
	self.Text_score_1:setString(i18n("herobattle_text_05"))
	self.Text_score_2:setString(i18n("herobattle_text_05"))
	self.Text_score_3:setString(i18n("herobattle_text_05"))
	self.Text_name_1:setString("")
	self.Text_name_2:setString("")
	self.Text_name_3:setString("")
	if topList[1] then
		self.Image_head_1:setContentSize(cc.size(120, 120))
		SoraDGetHeadFromManager(self.Image_head_1, topList[1].uinfo.iconID, topList[1].uinfo.avatar)
		local firstName = topList[1].uinfo.nickName
		if topList[1].allianceAbbr then
			_ENV = topList[1].uinfo.avatar
			topList[1].uinfo.avatar.abbr = _q(topList[1].allianceAbbr)
			topList[1].uinfo.avatar.name = topList[1].uinfo.nickName
			firstName = i18n("common_text_186", topList[1].uinfo.avatar)
		end
		self.Text_name_1:setString(firstName)
		self.Text_score_1:setString(string.formatnumberthousands(topList[1].uinfo.totalFc))
		self.Image_head_1:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				_ENV = nil
				;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
				;(nil).playerID = topList[1].minfo.uid
				;(nil).kid = gametop.playertop_:getMapID()
				SoraDSendMessage(nil)
			end
		end)
	end
	if topList[2] then
		self.Image_head_2:setContentSize(cc.size(95, 95))
		SoraDGetHeadFromManager(self.Image_head_2, topList[2].uinfo.iconID, topList[2].uinfo.avatar)
		local secondName = topList[2].uinfo.nickName
		if topList[2].allianceAbbr then
			_ENV = topList[2].uinfo.avatar
			topList[2].uinfo.avatar.abbr = _q(topList[2].uinfo.allianceAbbr)
			topList[2].uinfo.avatar.name = topList[2].uinfo.nickName
			secondName = i18n("common_text_186", topList[2].uinfo.avatar)
		end
		self.Text_name_2:setString(secondName)
		self.Text_score_2:setString(string.formatnumberthousands(topList[2].uinfo.totalFc))
		self.Image_head_2:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				_ENV = nil
				;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
				;(nil).playerID = topList[2].minfo.uid
				;(nil).kid = gametop.playertop_:getMapID()
				SoraDSendMessage(nil)
			end
		end)
	end
	if topList[3] then
		self.Image_head_3:setContentSize(cc.size(95, 95))
		SoraDGetHeadFromManager(self.Image_head_3, topList[3].uinfo.iconID, topList[3].uinfo.avatar)
		local thirdName = topList[3].uinfo.nickName
		if topList[3].allianceAbbr then
			_ENV = topList[3].uinfo.avatar
			topList[3].uinfo.avatar.abbr = _q(topList[3].uinfo.allianceAbbr)
			topList[3].uinfo.avatar.name = topList[3].uinfo.nickName
			thirdName = i18n("common_text_186", topList[3].uinfo.avatar)
		end
		self.Text_name_3:setString(thirdName)
		self.Text_score_3:setString(string.formatnumberthousands(topList[3].uinfo.totalFc))
		self.Image_head_3:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				_ENV = nil
				;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
				;(nil).playerID = topList[3].minfo.uid
				;(nil).kid = gametop.playertop_:getMapID()
				SoraDSendMessage(nil)
			end
		end)
	end
	if not next(topList) and not next(remainList) then
		self.text_noData:setVisible(true)
	end
	self.ScrollView_attack:removeAllChildren()
	local scrollH = math.max(self.ScrollView_attack:getContentSize().height, singleRankH * #remainList)
	self.ScrollView_attack:setInnerContainerSize(cc.size(640, scrollH))
	for i, v in ipairs(remainList) do
		local cellRank = self.Node_single:clone()
		cellRank:addTo(self.ScrollView_attack)
		cellRank:setPosition(cc.p(self.ScrollView_attack:getContentSize().width / 2, scrollH - (i - 1) * singleRankH))
		local txtScore = SoraDGetChildByName(cellRank, "Text_singleScore")
		txtScore:setString(string.formatnumberthousands(v.uinfo.totalFc))
		local imgHead = SoraDGetChildByName(cellRank, "Image_head")
		imgHead:addTouchEventListener(function(ref, type)
			if type == ccui.TouchEventType.ended then
				SoraDPlaySound()
				if not SoraDIsNodeVisibleOnScroll(ref, self.ScrollView_attack) then
					print("node is not on view")
					return
				end
				_ENV = "node is not on view"
				;("node is not on view").msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
				;("node is not on view").playerID = v.minfo.uid
				;("node is not on view").kid = gametop.playertop_:getMapID()
				SoraDSendMessage("node is not on view")
			end
		end)
		SoraDGetHeadFromManager(imgHead, v.uinfo.iconID, v.uinfo.avatar)
		local txtRanking = SoraDGetChildByName(cellRank, "Text_singleRank")
		txtRanking:setString(i + 3)
		local txtComName = SoraDGetChildByName(cellRank, "Text_singleName")
		txtComName:setString(v.uinfo.nickName)
	end
	if next(myData) then
		self.Image_head_my:setVisible(true)
		SoraDGetHeadFromManager(self.Image_head_my, myData.uinfo.iconID, myData.uinfo.avatar)
		if myData.rank == 0 then
			self.Sprite_myHead:setVisible(false)
			self.Text_myRank:setVisible(true)
			self.Text_myRank:setString(i18n("common_text_827"))
		elseif myData.rank <= RANK_TOP_SPECIAL then
			self.Sprite_myHead:setSpriteFrame("icon_ranking_" .. myData.rank .. ".png")
			self.Sprite_myHead:setVisible(true)
			self.Text_myRank:setVisible(false)
		else
			self.Sprite_myHead:setVisible(false)
			self.Text_myRank:setVisible(true)
			self.Text_myRank:setString(myData.rank)
		end
		local name = myData.uinfo.nickName
		if myData.uinfo.allianceAbbr then
			_ENV = myData.rank
			myData.rank.abbr = _q(myData.uinfo.allianceAbbr)
			myData.rank.name = myData.uinfo.allianceName
			name = i18n("common_text_186", myData.rank)
		end
		self.Text_myName:setString(name)
		self.Text_myNum:setString(string.formatnumberthousands(myData.uinfo.totalFc))
	end
end
return allianceMemberBattlePointView
