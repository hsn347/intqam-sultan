local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local allianceDesRead = include("allianceDesRead")
local alliancePBLHonorPersonalRankView = class("alliancePBLHonorPersonalRankView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("alliancePBLHonorPersonalRankView")
	end
	return target
end)
function alliancePBLHonorPersonalRankView:ctor()
	self.getdata = false
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramid")
	self.nodeTitle:setTitle(i18n("pyramid_title_08"))
	self.imgBg = SoraDGetChildByName(self, "Image_bigBg")
	self.imgBg:setScale(math.max(1, display.height / self.imgBg:getContentSize().height))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_scroll")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.labelEmpty = SoraDGetChildByName(self, "Center_Text_empty")
	SoraDGetChildByName(self, "Button_help"):setVisible(false)
	self.nodeClone = SoraDGetChildByName(self, "Node_clone")
	self.labelTitle:setString(i18n("pyramid_text_85"))
	self.labelEmpty:setString(i18n("herobattle_text_05"))
	self.nodeTip = SoraDGetChildByName(self, "Top_Node_tip")
	self.spriteArr = SoraDGetChildByName(self, "Sprite_arr")
	self.labelInfo = SoraDGetChildByName(self, "Text_info")
	self.nodeTip:setVisible(false)
end
function alliancePBLHonorPersonalRankView:createSingle()
	local single = self.nodeClone:clone()
	single.spriteGood = SoraDGetChildByName(single, "Sprite_good")
	single.btnGood = SoraDGetChildByName(single, "Button_good")
	single.btnGood:setSwallowTouches(false)
	single.labelGood = SoraDGetChildByName(single, "Text_good")
	single.btnInfo = SoraDGetChildByName(single, "Button_info")
	single.btnInfo:setTitleText(i18n("common_text_059"))
	single.btnInfo:setSwallowTouches(false)
	single.labelName = SoraDGetChildByName(single, "Text_name")
	single.nodeHead = SoraDGetExtendChildFromCCSByName(single, "CCS_commonHead_head")
	single.btnGood:addTouchEventListener(handler(self, self.btnGoodClickCallBack))
	single.btnInfo:addTouchEventListener(handler(self, self.btnInfoClickCallBack))
	return single
end
function alliancePBLHonorPersonalRankView:refreshSingle(single, data, otherData)
	single.btnGood:setTag(single:getTag())
	single.btnInfo:setTag(single:getTag())
	single.labelGood:setString(string.formatnumberthousands(data.praiseNum))
	_ENV = string.formatnumberthousands(data.praiseNum)
	string.formatnumberthousands(data.praiseNum).abbr = data.legionName
	string.formatnumberthousands(data.praiseNum).name = data.nickName
	single.labelName:setString(i18n("common_text_186", string.formatnumberthousands(data.praiseNum)) .. "#" .. data.kid)
	single.nodeHead:setHeadSprite(data.iconID, data.avatar)
	local canPadised = pyramidWarCtrl:checkPadise(data) == nil
	single.btnGood:setTouchEnabled(canPadised)
	single.btnGood:setBright(canPadised)
	single.labelGood:setColor(canPadised and cc.c3b(200, 155, 100) or cc.c3b(146, 146, 146))
	single.spriteGood:getVirtualRenderer():setState(canPadised and 0 or 1)
end
function alliancePBLHonorPersonalRankView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_PBL_GET_RANK_BACK", handler(self, self.updateView))
end
function alliancePBLHonorPersonalRankView:initData(season)
	self.curSeason = season
	pyramidWarCtrl:newGloryRankReq(gGloryRankTypeDef.ALSTAR_PLAYER, self.curSeason)
	self:updateView()
end
function alliancePBLHonorPersonalRankView:updateView()
	self.curData = pyramidWarCtrl:getPBLHistoryRank(gGloryRankTypeDef.ALSTAR_PLAYER, self.curSeason)
	if self.curData and next(self.curData) then
		self:updateTips()
		self.labelEmpty:setVisible(false)
		pyramidWarCtrl = nil
		;(nil).isAR = SoraDFIsRA()
		self.scroll:updateScrollView(cc.size(213.33333333333334, 260), self.curData, 3, nil)
		SoraDCloseLoading(self)
	else
		SoraDCloseLoading(self)
		self.labelEmpty:setVisible(true)
		pyramidWarCtrl = 213.33333333333334
		self.scroll:updateScrollView(cc.size(213.33333333333334, 260), 213.33333333333334)
	end
end
function alliancePBLHonorPersonalRankView:updateTips()
	local pyramidWarCtrl, showdata
	for i = 1, 3 do
		do
			local data = self.curData[i]
			if data then
				local info = pyramidWarCtrl:checkContent(data, data.seasonNum, true)
				if info then
					table.insert(showdata, cca.callFunc(function(...)
						self.nodeTip:setVisible(true)
						self.labelInfo:setString(info)
						self.spriteArr:setPositionX(SoraDFSign(215 - (i - 1) * 215))
					end))
					table.insert(showdata, cca.delay(3))
					table.insert(showdata, cca.callFunc(function(...)
						self.nodeTip:setVisible(false)
					end))
					if i == 3 then
						table.insert(showdata, cca.delay(3))
					end
				end
			end
		end
	end
	if next(showdata) then
		self.nodeTip:stopAllActions()
		self.nodeTip:runAction(cca.repeatForever(cca.seq(showdata)))
	end
end
function alliancePBLHonorPersonalRankView:btnGoodClickCallBack(button, type)
	if SoraDIsButtonOnScrollBack(button, type, self, self.scroll) then
		SoraDPlaySound()
		local data = self.curData[button:getTag()]
		pyramidWarCtrl:pinnaclePraisePraisedReq(data.uid, data.seasonNum)
	end
end
function alliancePBLHonorPersonalRankView:btnInfoClickCallBack(button, type)
	if SoraDIsButtonOnScrollBack(button, type, self, self.scroll) then
		SoraDPlaySound()
		local data = self.curData[button:getTag()]
		local panel = SoraDCreatePanel("alliancePBLHonorPersonalInfoView")
		panel:initData(data)
		panel:show()
	end
end
return alliancePBLHonorPersonalRankView
