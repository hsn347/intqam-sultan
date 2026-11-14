local gametop = gModuleMgr.getObject("gametop")
local legendLordWarltCtrl = include("legendLordWarltCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local radianceWarRead = include("radianceWarRead")
local radianceWarDef = include("radianceWarDef")
local RADIANCE_WAR_STATE = radianceWarDef.RADIANCE_WAR_STATE
local legendaryKingAwardSingle = class("legendaryKingAwardSingle", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end)
_ENV, _ENV = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end, "legendaryKingAwardSingle"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).title = "legendaryking_text_39"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).tip = "legendaryking_text_42"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).icon = "icon_cqjw_jwjx_03.png"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).bg = "frame_cqjw_bg_08.png"
_ENV, ("legendaryKingAwardSingle")[4], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).posY = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end, 355
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).title = "legendaryking_text_40"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).tip = "legendaryking_text_43"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).icon = "icon_cqjw_jwjx_02.png"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).bg = "frame_cqjw_bg_07.png"
_ENV, ("legendaryKingAwardSingle")[5], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).posY = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end, 374
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).title = "legendaryking_text_41"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).tip = "legendaryking_text_44"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).icon = "icon_cqjw_jwjx_01.png"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).bg = "frame_cqjw_bg_06.png"
_ENV, ("legendaryKingAwardSingle")[6], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).posY = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end, 365
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).title = "brightWar_text_228"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).tip = "brightWar_text_230"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).icon = "icon_jingong_gmjx_01.png"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).bg = "frame_gmjx_bg_01.png"
_ENV, ("legendaryKingAwardSingle")[7], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).posY = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end, 374
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).title = "brightWar_text_229"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).tip = "brightWar_text_231"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).icon = "icon_fanshou_gmjx_01.png"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).bg = "frame_gmjx_bg_02.png"
_ENV, ("legendaryKingAwardSingle")[8], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).posY = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end, 365
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).title = "legendaryking_text_39"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).tip = "kingstarbattle_text_42"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).icon = "icon_cqjw_jwjx_03.png"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).bg = "frame_cqjw_bg_08.png"
_ENV, ("legendaryKingAwardSingle")[14], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).posY = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end, 355
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).title = "legendaryking_text_40"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).tip = "kingstarbattle_text_43"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).icon = "icon_cqjw_jwjx_02.png"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).bg = "frame_cqjw_bg_07.png"
_ENV, ("legendaryKingAwardSingle")[15], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).posY = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end, function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end, 374
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).title = "legendaryking_text_41"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).tip = "kingstarbattle_text_44"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).icon = "icon_cqjw_jwjx_01.png"
;(function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).bg = "frame_cqjw_bg_06.png"
;("legendaryKingAwardSingle")[16], (function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end).posY = function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("legendaryKingAwardSingle")
end, 365
local Config = "legendaryKingAwardSingle"
function legendaryKingAwardSingle:ctor(properties)
	self.warType = gKingdomClassType.legendLord
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.textTip = SoraDGetChildByName(self, "Text_Tip")
	self.nodeHead = SoraDGetChildByName(self, "Node_head")
	self.btnHead = SoraDGetChildByName(self, "Button_Head")
	self.btnHead:addTouchEventListener(handler(self, self.btnClickHead))
	self.spHead = SoraDGetChildByName(self, "icon_head")
	self.spJctz = SoraDGetChildByName(self, "icon_jctz_wh")
	self.textName = SoraDGetChildByName(self, "Text_name")
	self.textKillNum = SoraDGetChildByName(self, "Text_KillNum")
	self.textNoResult = SoraDGetChildByName(self, "Text_NoResult")
	self.textNoResult:setString(i18n("hero_text_84"))
	_UPVALUE4_ = self.textNoResult.setString
	_UPVALUE2_, self.visitUser, self.textNoResult.setString[1] = self.textNoResult.setString, self.textNoResult.setString, self.btnHead
	_UPVALUE2_, self.visitUser, self.textNoResult.setString[2] = self.textNoResult.setString, self.textNoResult.setString, self.spHead
	_UPVALUE2_, self.visitUser, self.textNoResult.setString[3] = self.textNoResult.setString, self.textNoResult.setString, self.textName
	_UPVALUE2_, self.visitUser, self.textNoResult.setString[4] = self.textNoResult.setString, self.textNoResult.setString, self.textKillNum
	self.visitNoUser, self.textNoResult.setString[1] = self.textNoResult.setString, self.textNoResult
	self.visitNoUser, self.textNoResult.setString[2] = self.textNoResult.setString, self.spJctz
	self.imgIcon = SoraDGetChildByName(self, "Image_Icon")
	self.btnRank = SoraDGetChildByName(self, "Button_Rank")
	self.btnRank:addTouchEventListener(handler(self, self.btnRankClick))
	self.scrollAward = SoraDGetChildByName(self, "ScrollView_Award")
	self.scrollAward = include("commonAutoScrollList").new(self.scrollAward)
	self.scrollAward:setSingleCreate(handler(self, self.createScrollSingle))
	self.scrollAward:setSingleRefresh(handler(self, self.refreshScrollSingle))
	self.effectNode = SoraDGetChildByName(self, "Node_Effect")
	self.spBg = SoraDGetChildByName(self, "frame_cqjw_bg")
end
function legendaryKingAwardSingle:initEffect()
	if self.warType == gKingdomClassType.radiance then
		self:initRadianceEffect()
		return
	end
	if not self.effect then
		self.effect = SoraDCreatAnimation("legendaryKingAwardEffect", nil, true)
		self.effect:addTo(self.effectNode)
		self.effect:setPosition(0, 0)
	end
	for k, v in pairs(self.effect:getChildren()) do
		if v:getName() == "Node_" .. self:getTag() then
			v:setVisible(true)
		else
			v:setVisible(false)
		end
	end
end
function legendaryKingAwardSingle:initRadianceEffect()
	_ENV = nil
	;(nil)[1] = "G_huizhang01.usm"
	local (nil)[2], config = "G_huizhang02.usm", nil
	local fileName = config[self:getTag()]
	if not fileName then
		return
	end
	self.effectNode:removeChildByName("criSprite")
	self.effect = nil
	if not self.effect then
		local criSprite = cc.criSprite.createCriSprite(fileName, false, true, nil)
		criSprite:addTo(self.effectNode)
		criSprite:setPosition(2, 14)
		criSprite:setName("criSprite")
		criSprite:setBlendFunc(gl.ONE, gl.ONE)
		self.effect = criSprite
	else
		self.effect:replaceVideoFile(fileName, true)
	end
end
function legendaryKingAwardSingle:updateActivityStatu()
	if self.warType == gKingdomClassType.radiance then
		local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
		self.legendLordState = radianceActivityCtrl:getWarStatus()
	else
		local activityID = gActivityTimeActivityID.LEGEND_LORD
		if worldMapDefine.isKingStarMapId(self.mapid) then
			activityID = worldMapDefine.getKingStarActivityID(self.mapid)
		end
		self.legendLordState = activityShowCtrl:getParamCurState(activityID)
	end
end
function legendaryKingAwardSingle:checkWarEndState(...)
	if self.warType == gKingdomClassType.radiance then
		return self.legendLordState == RADIANCE_WAR_STATE.FINISH
	else
		return self.legendLordState == ACTIVITY_STATE.SETTLE
	end
end
function legendaryKingAwardSingle:initData(userInfo, otherInfo)
	self.parenView = otherInfo.view
	if otherInfo.warType then
		self.warType = otherInfo.warType
	end
	self.mapid = otherInfo.mapid
	self.userInfo = userInfo
	self:updateActivityStatu()
	if self:checkWarEndState() and next(self.userInfo) then
		self:updateUIVisit(true)
		self:initUserInfo()
	else
		self:updateUIVisit(false)
	end
	local awardList
	if self.warType == gKingdomClassType.radiance then
		self.rewardType = self:getTag() + 6
		local rewardCfg = radianceWarRead.getRewardList(self.rewardType)
		awardList = rewardCfg[1].reward
	else
		self.rewardType = worldMapDefine.isKingStarMapId(self.mapid) and self:getTag() + 13 or self:getTag() + 3
		awardList = legendLordWarltCtrl.getLegendBestReward(self:getTag() + 3, self.mapid)
	end
	self:initEffect()
	local configInfo = Config[self.rewardType]
	_ENV = awardList
	awardList.scroll = self.scroll
	awardList.view = self
	self.scrollAward:updateScrollView(cc.size(100, 100), awardList, table.nums(awardList), awardList)
	self.textTitle:setString(i18n(configInfo.title))
	self.textTip:setString(i18n(configInfo.tip))
	self.imgIcon:loadTexture(configInfo.icon, ccui.TextureResType.plistType)
	self.spBg:setSpriteFrame(configInfo.bg)
	self.spBg:setPositionY(configInfo.posY)
end
function legendaryKingAwardSingle:initUserInfo()
	if self.userInfo.leagueAbbrName then
		_ENV = nil
		;(nil).abbr = self.userInfo.leagueAbbrName
		;(nil).name = self.userInfo.playerName
	end
	local strName = i18n("common_text_186", nil) or self.userInfo.playerName or i18n("common_text_480")
	if self.warType == gKingdomClassType.radiance then
		self.textName:setString(strName)
	else
		self.textName:setString(strName .. "#" .. self.userInfo.sourceKid)
	end
	self.textKillNum:setString(i18n("legendaryking_title_06") .. string.formatnumberthousands(self.userInfo.killFc))
	SoraDGetHeadFromManager(self.spHead, self.userInfo.headid, self.userInfo.avatar)
end
function legendaryKingAwardSingle:updateUIVisit(isVisible)
	for i, v in ipairs(self.visitUser) do
		v:setVisible(isVisible)
	end
	for i, v in ipairs(self.visitNoUser) do
		v:setVisible(not isVisible)
	end
end
function legendaryKingAwardSingle:btnRankClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if self.warType == gKingdomClassType.legendLord and self.legendLordState ~= ACTIVITY_STATE.SETTLE and (self.rewardType == 4 or self.rewardType == 14) then
			SoraDShowMsgTip(i18n("legendaryking_text_45"))
		else
			local panel = SoraDCreatePanel("legendaryKingBeastRank")
			panel:setWarType(self.warType, self.mapid)
			panel:setTabDefaultClick(self:getTag())
			panel:initTab()
			panel:show()
		end
	end
end
function legendaryKingAwardSingle:btnClickHead(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		;(nil).playerID = self.userInfo.uid
		;(nil).kid = self.userInfo.sourceKid
		SoraDSendMessage(nil)
	end
end
function legendaryKingAwardSingle:createScrollSingle()
	local single = display.newNode()
	single.itemAward = include("commonItemAward").new()
	single.itemAward:setScale(0.8)
	single.itemAward:setPosition(0, 0)
	single.itemAward:setOwnView(self.parenView)
	single.itemAward:addTo(single)
	single.itemAward:setPosition(45, 45)
	return single
end
function legendaryKingAwardSingle:refreshScrollSingle(parent, data)
	parent.itemAward:initData(data.id, data.count)
end
return legendaryKingAwardSingle
