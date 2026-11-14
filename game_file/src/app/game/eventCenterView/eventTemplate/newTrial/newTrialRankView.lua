local gametop = gModuleMgr.getObject("gametop")
local GridScrollView = include("GridScrollView")
local devilValleyCtrl = gametop.playertop_:getModule("devilValleyCtrl")
local newTrialRead = include("newTrialRead")
local newTrialRankView = class("newTrialRankView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("newTrialRankView")
	end
	return target
end)
function newTrialRankView:ctor()
	self.rankData, _UPVALUE0_ = nil, nil
	self:initWidget()
	self:initData()
end
function newTrialRankView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_NEWTRIAL_RANK_REFRESH", function(target, data)
		SoraDCloseLoading(self)
		local rankType = self.mtype
		if not devilValleyCtrl:getRankInfo(rankType) then
			local _ENV, rankInfo = devilValleyCtrl:getRankInfo(rankType), devilValleyCtrl:getRankInfo(rankType)
		end
		self.rankData, _ENV = devilValleyCtrl, devilValleyCtrl
		local playerID = gametop.playertop_:getPlayerID()
		for i, v in ipairs(rankInfo) do
			_ENV, _ENV = nil, nil
			;(nil).allianceAbbr = v.allianceAbbr
			;(nil).allianceName = v.allianceName
			;(nil).avatar = v.avatar
			;(nil).imageId = v.iconID
			;(nil).nickName = v.nickName
			;(nil).ranking = v.score
			;(nil).data, (nil).uid = nil, v.uid
			;(nil).isOwn = false
			;(nil).rank = v.rank
			;(nil).type = 4
			local (nil).info, single = v.info, nil
			single.isOwn = v.uid == playerID
			if v.info then
				for i, u in ipairs(v.info) do
					u.isOwn = u.uid == playerID
				end
			end
			single.type = self.isleft and lordRankingsDef.lordKill or lordRankingsDef.newTrialTimeRank
			table.insert(self.rankData, single)
		end
		if display.height < 1136 then
			self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, 745 + self.offset))
			self.scroll:setPositionY(855 + self.offset)
			self.scroll:updateNum(#self.rankData)
			self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, display.height - 391 + self.offset))
			self.scroll:setPositionY(display.height - 281 + self.offset)
		else
			self.scroll:updateNum(#self.rankData)
		end
		self.scroll:jumpToTop()
		if not devilValleyCtrl:getSelfRankInfo(rankType) then
			local _ENV, rankInfo = devilValleyCtrl:getSelfRankInfo(rankType), devilValleyCtrl:getSelfRankInfo(rankType)
		end
		self:initMyData(rankInfo)
	end)
end
function newTrialRankView:initWidget(...)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_rank")
	self.nodeTitle:setTitle(i18n("common_text_851"))
	newTrialRead = i18n("common_text_851")
	i18n("common_text_851")[1] = "Button_help"
	self.Button_help = SoraDGetChildByFullPath(self.nodeTitle, i18n("common_text_851"))
	newTrialRead = i18n("common_text_851")
	i18n("common_text_851")[1] = "Image_2"
	self.Image_2 = SoraDGetChildByFullPath(self.Top_Node, i18n("common_text_851"))
	newTrialRead = i18n("common_text_851")
	i18n("common_text_851")[1] = "Text_name"
	self.Text_name = SoraDGetChildByFullPath(self.Image_2, i18n("common_text_851"))
	newTrialRead = i18n("common_text_851")
	i18n("common_text_851")[1] = "Text_des"
	self.Text_des = SoraDGetChildByFullPath(self.Image_2, i18n("common_text_851"))
	self.Top_Node_0 = SoraDGetChildByName(self, "Top_Node_0")
	newTrialRead = "Top_Node_0"
	;("Top_Node_0")[1] = "Button_lord"
	self.Button_left = SoraDGetChildByFullPath(self.Top_Node_0, "Top_Node_0")
	self.Button_left:setTitleText(i18n("devilvalley_text_34"))
	self.Button_left:addTouchEventListener(handler(self, self.btnClickCallback))
	newTrialRead = handler(self, self.btnClickCallback)
	handler(self, self.btnClickCallback)[1] = "Button_alliance"
	self.Button_right = SoraDGetChildByFullPath(self.Top_Node_0, handler(self, self.btnClickCallback))
	self.Button_right:setTitleText(i18n("common_text_1722"))
	self.Button_right:addTouchEventListener(handler(self, self.btnClickCallback))
	SoraDAutoSizeButtonText(self.Button_left)
	SoraDAutoSizeButtonText(self.Button_right)
	newTrialRead = handler(self, self.btnClickCallback)
	handler(self, self.btnClickCallback)[1] = "Node_Type"
	self.Node_Type = SoraDGetChildByFullPath(self.Top_Node_0, handler(self, self.btnClickCallback))
	newTrialRead = handler(self, self.btnClickCallback)
	handler(self, self.btnClickCallback)[1] = "ScrollView_type"
	self.scrollType = SoraDGetChildByFullPath(self.Node_Type, handler(self, self.btnClickCallback))
	newTrialRead = handler(self, self.btnClickCallback)
	handler(self, self.btnClickCallback)[1] = "Panel_1"
	self.Panel_1 = SoraDGetChildByFullPath(self.scrollType, handler(self, self.btnClickCallback))
	self.Panel_1:setVisible(false)
	local itemSize = self.Panel_1:getContentSize()
	self.textList, _ENV, self.imageList, _ENV = self.Panel_1, self.Panel_1, self.Panel_1, self.Panel_1
	local showCount = newTrialRead.showCount
	self.scrollType:setInnerContainerSize(cc.size(showCount * itemSize.width, self.scrollType:getContentSize().height))
	if SoraDFIsRA() then
		self.scrollType:jumpToPercentHorizontal(100)
	end
	for i = 1, showCount do
		local item = self.Panel_1:clone()
		item:addTo(self.scrollType)
		item:setVisible(true)
		local posx = SoraDFIsRA() and itemSize.width * (showCount - i) or itemSize.width * (i - 1)
		item:setPosition(posx, 0)
		local Text_type = item:getChildByName("Text_type")
		Text_type:setString(newTrialRead.getName(i))
		table.insert(self.textList, Text_type)
		table.insert(self.imageList, item:getChildByName("Image_black"))
		local image = newTrialRead.getProperty(i, "rankbtnbg")
		local Image_type = item:getChildByName("Image_type")
		Image_type:loadTexture(image, ccui.TextureResType.plistType)
		Image_type:setTag(i)
		Image_type:setTouchEnabled(true)
		Image_type:addTouchEventListener(function(button, type)
			if type ~= ccui.TouchEventType.ended then
				return
			end
			SoraDPlaySound()
			local mtype = button:getTag()
			self:switchButton2(mtype)
		end)
	end
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_rankings")
	self.scroll = GridScrollView.new(self.scroll)
	_ENV = "Top_Size_ScrollView_rankings"
	;("Top_Size_ScrollView_rankings").col = 1
	;("Top_Size_ScrollView_rankings").top = 10
	;("Top_Size_ScrollView_rankings").left = 10
	;("Top_Size_ScrollView_rankings").h = 15
	self.scroll:init("Top_Size_ScrollView_rankings", 0, handler(self, self.createCell), handler(self, self.updateCell))
	self.textMyRank = SoraDGetChildByName(self, "Text_myRank")
	self.textMyNum = SoraDGetChildByName(self, "Text_myNum")
	self.textMyName = SoraDGetChildByName(self, "Text_myName")
	self.imageMyHead = SoraDGetChildByName(self, "Image_head")
	self.imageBottomBg = SoraDGetChildByName(self, "bottomBg")
	self.imageBottomBg_1 = SoraDGetChildByName(self, "bottomBg_1")
	self.imageBottomBg:addTouchEventListener(handler(self, self.btnJumpClickCallBack))
	self.imageBottomBg_1:addTouchEventListener(handler(self, self.btnJumpClickCallBack))
	self.Button_help:addTouchEventListener(handler(self, self.btnClickCallback))
	self.Button_help:setVisible(IsArClient)
end
function newTrialRankView:initData(...)
	self:switchButton1(false)
end
function newTrialRankView:btnClickCallback(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if button == self.Button_help then
		self:btnHelpCallback()
	elseif button == self.Button_left then
		self:switchButton1(true)
	elseif button == self.Button_right then
		self:switchButton1(false)
	end
end
function newTrialRankView:btnHelpCallback()
	if IsArClient then
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.NEW_TRIAL)
	else
		userSDKManager.showFAQSection(gSDKDef.FAQSingleType.NEW_TRIAL_EN)
	end
end
function newTrialRankView:createCell()
	local cell = self:createItem()
	cell:setScroll(self.scroll)
	return cell
end
function newTrialRankView:updateCell(panel, i)
	local index = i
	local data = self.rankData[index]
	panel:initData(data)
end
function newTrialRankView:createItem(...)
	return SoraDCreatePanel("newTrialRankingsScrollSingle")
end
function newTrialRankView:switchButton1(isleft)
	if self.isleft == isleft then
		return
	end
	self.isleft = isleft
	self.Button_left:setBright(not isleft)
	self.Button_left:setTitleColor(isleft and cc.c3b(255, 200, 100) or cc.c3b(100, 80, 40))
	self.Button_right:setBright(isleft)
	self.Button_right:setTitleColor(isleft and cc.c3b(100, 80, 40) or cc.c3b(255, 200, 100))
	self.Node_Type:setVisible(not isleft)
	local offset = isleft and 76 or 0
	self.offset = offset
	self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, display.height - 391 + offset))
	self.scroll:setPositionY(display.height - 281 + offset)
	self.Image_2:setPositionY(-223 + offset)
	if isleft then
		self.Text_name:setString(i18n("common_text_264"))
		self.Text_des:setString(i18n("common_text_2416"))
		devilValleyCtrl:sendReqRankList(gDV_RANK_TYPE.PERSON_FINISH_POINT)
		self.mtype = 0
		SoraDShowLoading(self)
	else
		self:switchButton2(1)
		self.Text_name:setString(i18n("devilvalley_text_42"))
		self.Text_des:setString(i18n("devilvalley_text_35"))
	end
end
function newTrialRankView:switchButton2(mtype)
	if SoraDFIsRA() and mtype == 1 or not SoraDFIsRA() and mtype == 6 then
		self.scrollType:jumpToRight()
	elseif SoraDFIsRA() and mtype == 6 or not SoraDFIsRA() and mtype == 1 then
		self.scrollType:jumpToLeft()
	end
	if self.mtype == mtype then
		return
	end
	devilValleyCtrl:sendReqRankList(mtype)
	self.mtype = mtype
	SoraDShowLoading(self)
	for i, v in ipairs(self.imageList) do
		if i == mtype then
			v:setVisible(false)
		else
			v:setVisible(true)
		end
	end
	for i, v in ipairs(self.textList) do
		if i == mtype then
			v:setColor(display.COLOR_WHITE)
		else
			v:setColor(newTrialRead.getProperty(i, "darkcolor"))
		end
	end
end
function newTrialRankView:initMyData(selfInfo)
	self.selfInfo = selfInfo
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local ownInfo = lordInfoCtrl:getLordInfo()
	self.textMyName:setString(ownInfo.base.nickName)
	self.imageMyHead:setVisible(true)
	self.textMyName:setPositionY(50)
	SoraDGetHeadFromManager(self.imageMyHead, ownInfo.base.imageId, ownInfo.base.avatar)
	if self.mtype == 0 then
		self.textMyNum:setString(string.formatnumberthousands(selfInfo.score))
		self.imageMyHead:setScale(1.0)
		self.textMyName:setVisible(true)
		for i = 2, 4 do
			local imgsingle = self.imageBottomBg:getChildByName("Image_head_" .. i)
			if imgsingle then
				imgsingle:setVisible(false)
			end
		end
	else
		self.textMyNum:setString(SoraDConvertSecondToString(selfInfo.score))
		self.imageMyHead:setScale(0.8)
		self.textMyName:setVisible(false)
		if not selfInfo.info then
			local _ENV, info = selfInfo.info, selfInfo.info
		end
		local data = info[1]
		if data then
			SoraDGetHeadFromManager(self.imageMyHead, data.iconID, data.avatar)
		end
		local posX = self.imageMyHead:getPositionX()
		for i = 2, #info do
			local imgsingle = self.imageBottomBg:getChildByName("Image_head_" .. i)
			if not imgsingle then
				imgsingle = self.imageMyHead:clone()
				imgsingle:addTo(self.imageBottomBg)
				imgsingle:setName("Image_head_" .. i)
				if SoraDFIsRA() then
					imgsingle:setPositionX(posX - (i - 1) * 100 * 0.8)
				else
					imgsingle:setPositionX(posX + (i - 1) * 100 * 0.8)
				end
				imgsingle:setSwallowTouches(false)
				imgsingle:setTag(i)
			end
			imgsingle:setVisible(true)
			local data = info[i]
			SoraDGetHeadFromManager(imgsingle, data.iconID, data.avatar)
		end
		for i = #info + 1, 4 do
			local imgsingle = self.imageBottomBg:getChildByName("Image_head_" .. i)
			if imgsingle then
				imgsingle:setVisible(false)
			end
		end
	end
	local msg = selfInfo.rank
	if not msg or msg <= 0 then
		msg = i18n("common_text_827")
	end
	self.textMyRank:setString(msg)
end
function newTrialRankView:btnJumpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.selfInfo and self.selfInfo.rank then
			self.scroll:scrollToIndex(self.selfInfo.rank)
		end
	end
end
return newTrialRankView
