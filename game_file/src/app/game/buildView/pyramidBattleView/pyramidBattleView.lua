local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local allianceltCtrl = include("allianceltCtrl")
local pyramidwarShopCtrl = SoraDGetCtrl("pyramidwarShopCtrl")
local PyramidBattleView = class("pyramidBattleView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("pyramidBattleView")
	end
	return target
end)
function PyramidBattleView:ctor()
	self.isHideCurrentSceneView = true
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_pyramid")
	self.nodeTitle:setTitle(i18n("common_text_2517"))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.bottomNodeButtons = SoraDGetChildByName(self, "Bottom_Node_buttons")
	self.spriteBottomLine = SoraDGetChildByName(self, "Sprite_bottom_line")
	self.imgRBottomBg = SoraDGetChildByName(self, "Image_rBottomBg")
	self.imgLBottomBg = SoraDGetChildByName(self, "Image_lBottomBg")
	self.nodeSpine = SoraDGetChildByName(self, "Node_spine")
	self.nodeSpine1 = SoraDGetChildByName(self, "Node_spine_1")
	self.nodeSpine2 = SoraDGetChildByName(self, "Node_spine_2")
	self.nodeEffect1 = SoraDGetChildByName(self, "Node_effect_1")
	self.nodeEffect2 = SoraDGetChildByName(self, "Node_effect_2")
	self.btnHistory = SoraDGetChildByName(self, "Button_history")
	self.btnPrice = SoraDGetChildByName(self, "Button_price")
	self.btnRank = SoraDGetChildByName(self, "Button_rank")
	self.btnGroup = SoraDGetChildByName(self, "Button_group")
	self.btnShop = SoraDGetChildByName(self, "Button_shop")
	self.btnShop:setPositionY(45)
	self.bottomNode = SoraDGetChildByName(self, "Bottom_Node")
	self.groupRed = SoraDGetChildByName(self, "Sprite_redPoint")
	self.groupRed:setVisible(false)
	self.shopRed = SoraDGetChildByName(self.btnShop, "Sprite_redPoint")
	self.shopRed:setVisible(false)
	self.nodeOut = SoraDGetChildByName(self, "Node_out")
	self.btnOut = SoraDGetChildByName(self, "Button_out")
	self.labelOut = SoraDGetChildByName(self, "Text_out")
	self.labelOut:setString(i18n("common_text_3333"))
	self.nodeOut:setVisible(false)
	self.imageOutIcon = SoraDGetChildByName(self, "Image_out_icon")
	self.btnHistory:getChildByName("Text_btnTitle"):setString(i18n("common_text_3032"))
	self.btnPrice:getChildByName("Text_btnTitle"):setString(i18n("common_text_2078"))
	self.btnRank:getChildByName("Text_btnTitle"):setString(i18n("common_text_851"))
	self.btnGroup:getChildByName("Text_btnTitle"):setString(i18n("pyramid_btn_03"))
	self.btnShop:getChildByName("Text_btnTitle"):setString(i18n("allianceWar_shop_title02"))
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.btnHistory:addTouchEventListener(handler(self, self.btnHistoryClick))
	self.btnPrice:addTouchEventListener(handler(self, self.btnPriceClick))
	self.btnRank:addTouchEventListener(handler(self, self.btnRankClick))
	self.btnGroup:addTouchEventListener(handler(self, self.btnGroupClick))
	self.btnShop:addTouchEventListener(handler(self, self.btnShopClick))
	self.btnOut:addTouchEventListener(handler(self, self.btnOutClick))
	if pyramidWarCtrl.curSeasonType == gSeasonType.PINNACLE_SEASON then
		self.noramlNode = SoraDCreatePanel("alliancePBLMainNode")
		self.noramlNode:addTo(self.bottomNode)
		self.noramlNode:setPosition(320, 0)
		if display.height < 1330 then
			local scale = (display.height - 130 - 110) / 1090
			print("scale", scale)
			self.noramlNode:setScale(scale)
		end
	else
		self.noramlNode = SoraDCreatePanel("allianceGroupMainNode")
		self.noramlNode:setPosition(320, 0)
		self.noramlNode:addTo(self.bottomNode)
		if display.height < 990 then
			local scale = (display.height - 130 - 110) / 750
			print("scale", scale)
			self.noramlNode:setScale(scale)
		end
	end
	self.nodePBLBg = SoraDGetChildByName(self, "Node_PBLBg")
	self.imgBig = SoraDGetChildByName(self, "Image_big")
	self.imgPBL = SoraDGetChildByName(self, "Size_Image_pbl")
	local size = self.imgBig:getContentSize()
	local sizePBL = self.imgPBL:getContentSize()
	self.imgBig:setContentSize(cc.size(size.width, math.max(size.height, display.height - 80)))
	self.imgPBL:setScale(math.max(1, (display.height - 210) / sizePBL.height))
	self.nodePBLBg:setVisible(pyramidWarCtrl.curSeasonType == gSeasonType.PINNACLE_SEASON)
	self.nodeSpine:setVisible(pyramidWarCtrl.curSeasonType ~= gSeasonType.PINNACLE_SEASON)
	self.imgBig:setVisible(pyramidWarCtrl.curSeasonType ~= gSeasonType.PINNACLE_SEASON)
	SoraDTestButton(self, function(...)
		SoraDCreatePanel("alliancePBLScheduleView"):show()
	end)
	self.oldSeasonType = pyramidWarCtrl.curSeasonType
	self:initSpine()
	self:updateButton()
	SoraDPlaySound("pyramidBattle", 2)
end
function PyramidBattleView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", function(target, data)
		local redShow = pyramidwarShopCtrl:getReceiveStatusAndNum(gActivityCenterUIEnum.PYRAMID_BATTLE)
		self.shopRed:setVisible(redShow)
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_MAINSTATECHANGE", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_GROUP_UPDATE", handler(self, self.updateButton))
	SoraDAddMessage(self, "MESSAGE_FILE_DOWNLOAD_SUCCESS_BY_KEY", handler(self, self.msgKeyDownLoadSuccess))
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_IMPRINT_BACK", handler(self, self.updatePBLMark))
end
function PyramidBattleView:updateView()
	if pyramidWarCtrl.curSeasonType ~= self.oldSeasonType then
		self.noramlNode:removeFromParent()
		if pyramidWarCtrl.curSeasonType == gSeasonType.PINNACLE_SEASON then
			self.noramlNode = SoraDCreatePanel("alliancePBLMainNode")
			self.noramlNode:setPosition(320, 0)
			self.noramlNode:addTo(self.bottomNode)
			if display.height < 1330 then
				local scale = (display.height - 130 - 110) / 1090
				self.noramlNode:setScale(scale)
			end
		else
			self.noramlNode = SoraDCreatePanel("allianceGroupMainNode")
			self.noramlNode:setPosition(320, 0)
			self.noramlNode:addTo(self.bottomNode)
			if display.height < 990 then
				local scale = (display.height - 130 - 110) / 750
				self.noramlNode:setScale(scale)
			end
		end
		self.oldSeasonType = pyramidWarCtrl.curSeasonType
	end
end
function PyramidBattleView:msgKeyDownLoadSuccess(target, data)
	local key = data.key
	if key == "pyramidWar" then
		self:initSpine()
	end
end
function PyramidBattleView:updatePBLMark()
	local ownMarkData = pyramidWarCtrl:getOwnMark()
	if not ownMarkData then
		self.nodeOut:setVisible(false)
		return
	end
	local isShowRegular = ownMarkData.battleSeasonType == gSeasonType.REGULAR_SEASON and (ownMarkData.regularSeasonAllianceState == gRegularSeasonAllianceState.PREPARE or ownMarkData.regularSeasonAllianceState == gRegularSeasonAllianceState.RUNNING)
	local isShowPinnacle = ownMarkData.battleSeasonType == gSeasonType.PINNACLE_SEASON and ownMarkData.pinnacleSeasonAllianceState ~= gPinnacleSeasonAllianceState.PINNACLE_SIGN_UP
	_UPVALUE2_ = nil
	;(nil)[1] = isShowRegular
	;(nil)[2] = isShowPinnacle
	dump(nil, "isShowPinnacle")
	self.nodeOut:setVisible(isShowRegular or isShowPinnacle)
	if ownMarkData ~= nil then
		local imageName = "bg_jztzc_01.png"
		if ownMarkData.battleSeasonType == gSeasonType.PINNACLE_SEASON then
			imageName = "PBL_gotowar_small.png"
		end
		self.imageOutIcon:setSpriteFrame(imageName)
	end
end
function PyramidBattleView:initSpine()
	_ENV, _ENV = nil, nil
	;(nil).json = "spine/pyramidWarV4/pyramid_bg_03.skel"
	;(nil).atlas = "spine/pyramidWarV4/pyramid_bg_03.atlas"
	;(nil).scale = 1
	_ENV, (nil)[1], (nil).pos = nil, nil, cc.p(-180, -190)
	;(nil).json = "spine/pyramidWarV4/pyramid_bg_04.skel"
	;(nil).atlas = "spine/pyramidWarV4/pyramid_bg_04.atlas"
	;(nil).scale = 1
	_ENV, (nil)[2], (nil).pos = nil, nil, cc.p(210, 275)
	;(nil).json = "spine/pyramidWarV4/pyramid_bg_02.skel"
	;(nil).atlas = "spine/pyramidWarV4/pyramid_bg_02.atlas"
	;(nil).scale = 1
	_ENV, (nil)[3], (nil).pos = nil, nil, cc.p(-20, -500)
	;(nil).json = "spine/pyramidWarV4/pyramid_bg_01.skel"
	;(nil).atlas = "spine/pyramidWarV4/pyramid_bg_01.atlas"
	;(nil).scale = 1
	;(nil)[4], (nil).pos = nil, cc.p(-100, -570)
	local data
	for i, v in ipairs(data) do
		local spine = sp.SkeletonAnimation:create(v.json, v.atlas, 1)
		spine:setAnimation(0, "animation", true)
		spine:setPosition(v.pos)
		spine:setScale(v.scale)
		if i <= 2 then
			spine:addTo(self.nodeSpine1)
		elseif i == 3 then
			spine:addTo(self.nodeSpine2)
		else
			spine:addTo(self.nodeSpine)
		end
	end
	self.nodeSpine:setPositionY(display.cy)
	SoraDMixtureGLONEByParent(self.nodeEffect1)
	SoraDMixtureGLONEByParent(self.nodeEffect2)
	SoraDCreatAnimationEx(self.__cname, self, true)
end
function PyramidBattleView:onEnterPanel()
	self.soundId = SoraDPlaySound("uicontrol", 57)
end
function PyramidBattleView:onExitPanel()
	if self.soundId then
		AudioEngine.stopEffect(self.soundId)
	end
end
function PyramidBattleView:updateButton()
	self.legionList = pyramidWarCtrl:getLegionInfoList()
	self.groupRed:setVisible(false)
	local pyramidWarCtrl, tableBtnTotal = self.groupRed.setVisible, self.groupRed.setVisible
	if not allianceMgr:hasJoinAlliance() or self.legionList == nil or #self.legionList == 0 then
		self.btnGroup:setVisible(false)
	else
		self.btnGroup:setVisible(true)
		table.insert(tableBtnTotal, self.btnGroup)
	end
	table.insert(tableBtnTotal, self.btnHistory)
	table.insert(tableBtnTotal, self.btnShop)
	table.insert(tableBtnTotal, self.btnRank)
	table.insert(tableBtnTotal, self.btnPrice)
	local widthJG = #tableBtnTotal == 4 and 160 or 130
	local initX = #tableBtnTotal == 4 and 80 or 60
	for i, v in ipairs(tableBtnTotal) do
		v:setPositionX(SoraDFPosX(initX + widthJG * (i - 1), 0))
	end
	if self.legionList and pyramidWarCtrl:getGroupManagerRank() >= 2 then
		local corpsCount = allianceltCtrl:getCorpsCount()
		for i = 1, corpsCount do
			if self.legionList[i] == nil then
				local unlock, ssdata = allianceltCtrl:getLegionUnlock(i)
				if unlock then
					self.groupRed:setVisible(true)
				end
			end
		end
	end
	local redShow = pyramidwarShopCtrl:getReceiveStatusAndNum(gActivityCenterUIEnum.PYRAMID_BATTLE)
	self.shopRed:setVisible(redShow)
	pyramidWarCtrl:sendGetImprint()
	self:updateView()
end
function PyramidBattleView:btnHelpClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.PYRAMID_BATTLE)
	end
end
function PyramidBattleView:testDump()
	self.groupType = gPinnacleSeasonAllianceState.NOT_APPLY
	self.seasonState = pyramidWarCtrl.pinnacleSeasonState
	self.curMatchType = pyramidWarCtrl.curMatchType
	self.legionList = pyramidWarCtrl:getLegionInfoList()
	self.ownlegion = pyramidWarCtrl:getOwnLegion()
	if self.ownlegion then
		self.groupType = self.ownlegion.pinnacleSeasonAllianceState
	end
	local groupTypeR = self.ownlegion.regularSeasonAllianceState
	local seasonStateR = pyramidWarCtrl.regularSeasonState
	local str = ""
	dump(self.ownlegion, "self.ownlegion", 10)
	for k, v in pairs(gPinnacleSeasonAllianceState) do
		if v == self.groupType then
			str = "groupType " .. k .. " " .. self.groupType .. "\n"
			break
		end
	end
	for k, v in pairs(gPinnacleSeasonState) do
		if v == self.seasonState then
			str = str .. "seasonState " .. k .. " " .. self.seasonState .. "\n"
			break
		end
	end
	for k, v in pairs(gPinnacleMatchType) do
		if v == self.curMatchType then
			str = str .. "curMatchType " .. k .. " " .. self.curMatchType .. "\n"
			break
		end
	end
	for k, v in pairs(gRegularSeasonAllianceState) do
		if v == groupTypeR then
			str = "gRegulargroupType " .. k .. " " .. groupTypeR .. "\n"
			break
		end
	end
	for k, v in pairs(gRegularSeasonState) do
		if v == seasonStateR then
			str = str .. "gRegularseasonState " .. k .. " " .. seasonStateR .. "\n"
			break
		end
	end
	SoraDShowMsgBox(str, "yesBtnTitle")
end
function PyramidBattleView:btnHistoryClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not allianceMgr:hasJoinAlliance() or self.legionList == nil or #self.legionList == 0 then
			SoraDShowMsgTip(i18n("god_beast_text_16"))
		else
			SoraDCreatePanel("allianceGroupHistoryView"):show()
		end
	end
end
function PyramidBattleView:btnPriceClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if pyramidWarCtrl.curSeasonType == gSeasonType.PINNACLE_SEASON then
			SoraDCreatePanel("alliancePBLPrizeView"):show()
		else
			SoraDCreatePanel("allianceGroupPrizeView"):show()
		end
	end
end
function PyramidBattleView:btnRankClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("allianceGroupRankView"):show()
	end
end
function PyramidBattleView:btnGroupClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound("pyramidBattle", 5)
		SoraDCreatePanel("allianceGroupManagerView"):show()
	end
end
function PyramidBattleView:btnShopClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound("pyramidBattle", 6)
		uiManager:show("pyramidBattleStoreView")
	end
end
function PyramidBattleView:btnOutClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("alliancePBLMarkView"):show()
	end
end
return PyramidBattleView
