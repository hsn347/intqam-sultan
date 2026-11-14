local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local kingdomGraceCtrl = SoraDGetCtrl("kingdomGraceCtrl")
local kingdomGraceRead = include("kingdomGraceRead")
local itemDesRead = include("itemDesRead")
local kingdomGraceView = class("kingdomGraceView", function(target)
	return target or SoraDCreateBasePanel("kingdomGraceView")
end)
function kingdomGraceView:ctor()
	self.activityTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_KG")
	self.activityTitle:setTitle(i18n("activity_name_31"))
	self.btnKillMonster = SoraDGetChildByName(self, "Button_Kill")
	self.btnKillMonster:addTouchEventListener(handler(self, self.btnClickKill))
	self.btnKillMonster:setTitleText(i18n("limitactivities_sectiontitle_02"))
	self.btnQuest = SoraDGetChildByName(self, "Button_Question")
	self.btnQuest:addTouchEventListener(handler(self, self.btnlClickQuest))
	self.btnExchange = SoraDGetChildByName(self, "Button_Change")
	self.btnExchange:addTouchEventListener(handler(self, self.btnClickExchange))
	self.btnExchange:setTitleText(i18n("alliance_hunt_btn_01"))
	self.redNode = SoraDGetChildByName(self.btnExchange, "Sprite_headRedPoint")
	self.redNode:setVisible(false)
	self.itemAward = SoraDGetChildByName(self, "ItemShow")
	SoraDGetChildByName(self.itemAward, "Image_quality"):setVisible(false)
	self.itemAward = include("commonItemAward").new(self.itemAward)
	self.itemAward:setRealScale(1.2)
	self.itemAward:setOwnView(self)
	self.activityTime = SoraDGetChildByName(self, "Text_Time")
	self.textSmallTitle = SoraDGetChildByName(self, "Text_Number")
	self.textSmallTitle:setString(i18n("kingdom_grace_text_02"))
	self.textAwardName = SoraDGetChildByName(self, "Text_ItemName")
	self.textLeftAward = SoraDGetChildByName(self, "Text_LeftNumber")
	self.textTotalAward = SoraDGetChildByName(self, "Text_TotalNumber")
	self.textAwardAllInfo = SoraDGetChildByName(self, "Text_LeftInfo")
	self.textAwardAllInfo = SoraDChangeTextToHtml(self.textAwardAllInfo)
	self.textIsBound = SoraDGetChildByName(self, "Text_IsUp")
	self.textIsBound:setString(i18n("kingdom_grace_text_10"))
	if SoraDGetDefaultLanguage() == "ko" or SoraDGetDefaultLanguage() == "vi" then
		self.textIsBound:setFontSize(16)
	end
	self.textLeftInfo = SoraDGetChildByName(self, "Text_Left")
	self.textLeftInfo = SoraDChangeTextToHtml(self.textLeftInfo)
	self.textConvertible = SoraDGetChildByName(self, "Text_Convertible")
	self.textExplain = SoraDGetChildByName(self, "Text_Explain")
	self.textExplain = SoraDChangeTextToHtml(self.textExplain)
	self.textPoints = SoraDGetChildByName(self, "Text_PointHave")
	self.purpleNode = SoraDGetChildByName(self, "purple_node")
	self.yellowNode = SoraDGetChildByName(self, "yellow_node")
	self.orangeNode = SoraDGetChildByName(self, "orange_node")
	self.purpleP = SoraDGetChildByName(self, "Particle_Purple")
	self.yellowP = SoraDGetChildByName(self, "Particle_Yellow")
	self.orangeP = SoraDGetChildByName(self, "Particle_Orange")
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.TopTextNode = SoraDGetChildByName(self.centerNode, "Top_Node_Flag", true)
	self.iconNode = SoraDGetChildByName(self.centerNode, "Node_Total")
	self.bottomBlcakBg = SoraDGetChildByName(self, "Top_Size_Image_Black")
	self.textLeftInfo:setString(i18n("kingdom_grace_text_03"))
	self:fitView()
	self:initTimer()
	self:initAnimation()
	kingdomGraceCtrl:sendInitMsg()
end
function kingdomGraceView:fitView()
	local height = (self:getPanelOffsetHeight() - 960) * 7 / 12
	local bili = height < 0 and 0.75 or 0.5
	self.TopTextNode:setPositionY(self.TopTextNode:getPositionY() - height * bili)
	local scale = self:getPanelOffsetHeight() / 1136
	scale = 1 < scale and 1 or scale
	self.iconNode:setScale(scale)
	if self:getPanelOffsetHeight() > 1300 then
		self.iconNode:setPositionY(self.iconNode:getPositionY() + 140)
		self.TopTextNode:setPositionY(self.TopTextNode:getPositionY() + 160)
	elseif self:getPanelOffsetHeight() < 860 then
		SoraDGetChildByName(self, "Top_Image_Sheer"):setPositionY(SoraDGetChildByName(self, "Top_Image_Sheer"):getPositionY() + 70)
		self.bottomBlcakBg:setPositionY(self.bottomBlcakBg:getPositionY() + 70)
		self.bottomBlcakBg:setContentSize(self.bottomBlcakBg:getContentSize().width, self.bottomBlcakBg:getContentSize().height + 40)
		SoraDGetChildByName(self.TopTextNode, "Scale_Node"):setScale(0.8)
	end
end
function kingdomGraceView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_KINGDOMGRACES_REFRESH", handler(self, self.updateData))
end
function kingdomGraceView:initAnimation()
	self.centerIcon = sp.SkeletonAnimation:create("spine/wangguoendian.skel", "spine/wangguoendian.atlas", 1)
	local nodeCS = SoraDGetChildByName(self, "Node_Total")
	nodeCS:addChild(self.centerIcon)
	self.centerIcon:setPosition(0, 90)
	self.centerIcon:setLocalZOrder(-1)
	self.centerIcon:setAnimation(0, "animation", true)
	local posX = nodeCS:getPositionX()
	local posY = nodeCS:getPositionY()
	_UPVALUE2_ = true
	;(true)[1] = cca.moveTo(1.5, posX, posY + 5)
	;(true)[2] = cca.moveTo(3, posX, posY - 5)
	;(true)[3] = cca.moveTo(1.5, posX, posY)
	;(true)[4] = cca.moveTo(1.5, posX, posY)
	;(true)[5] = cca.moveTo(1.5, posX, posY)
	;(true)[6] = cca.moveTo(1.5, posX, posY)
	local action = cca.repeatForever(cca.seq(true))
	nodeCS:runAction(action)
end
function kingdomGraceView:initTimer()
	self.activityTime = SoraDCreateTimerLabel(self, self.activityTime)
	self.activityTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_766", nil)
	end)
	self.activityTime:setTimeEndListener(function()
		SoraDRemoveAllAfterPanelFromManager(self)
	end)
	local activityTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.KINGDOM_FAVOR)
	if activityTime then
		self.activityTime:beginTime(activityTime.timerNode.timer:getRemainTime())
	end
	local posX = SoraDFIsRA() and -(self.activityTime:getContentSize().width / 2 + 37) or self.activityTime:getContentSize().width / 2 + 7
	SoraDGetChildByName(self, "Sprite_time"):setPositionX(posX)
end
function kingdomGraceView:updateData(target, data)
	if data.reward then
		SoraDMailGainItems(data.reward, true)
	end
	local group = kingdomGraceCtrl:getGroup()
	local awardId = kingdomGraceRead.getExchangeConfig(group, "awardItem")
	self.textTotalAward:setString(kingdomGraceRead.getExchangeConfig(group, "upperBound"))
	self.textTotalAward:setScale(0.6)
	self.itemAward:initData(awardId, 1)
	self.textAwardName:setString(i18n(itemDesRead.getName(awardId)))
	local itemQuality = itemDesRead.getQuality(awardId)
	self.purpleNode:setVisible(itemQuality == 3)
	self.yellowNode:setVisible(itemQuality == 5)
	self.orangeNode:setVisible(itemQuality == 4)
	self.purpleP:setVisible(itemQuality == 3)
	self.yellowP:setVisible(itemQuality == 5)
	self.orangeP:setVisible(itemQuality == 4)
	local exchangePoint = kingdomGraceRead.getExchangeConfig(group, "exchange")
	if gConstValue.IS_DEBUG_SERVER then
		exchangePoint = math.ceil(exchangePoint / 10)
	end
	print("group", group)
	if not kingdomGraceRead.getSunshineConfig(group, "consolationPrize") then
		local _ENV, iconName = kingdomGraceRead.getSunshineConfig(group, "consolationPrize"), kingdomGraceRead.getSunshineConfig(group, "consolationPrize")
	end
	_ENV = i18n(itemDesRead.getName(awardId))
	_ENV, _ENV, i18n(itemDesRead.getName(awardId)).num = group, kingdomGraceRead.getSunshineConfig(group, "consolationPrizeLine") or 0, kingdomGraceRead.getSunshineConfig(group, "consolationPrizeLine") or 0
	_ENV, (kingdomGraceRead.getSunshineConfig(group, "consolationPrizeLine") or 0).num, group.color = group, group, "#ffff00"
	;(kingdomGraceRead.getSunshineConfig(group, "consolationPrizeLine") or 0).__default, group.color = group, "#ffffff"
	local str = i18n_html("kingdom_grace_text_04", i18n(itemDesRead.getName(awardId)))
	kingdomGraceRead = "kingdom_grace_text_04"
	;("kingdom_grace_text_04")[1] = "#" .. itemDesRead.getBg(iconName[1])
	local ("kingdom_grace_text_04")[2], NodeData = "#" .. itemDesRead.getIcon(iconName[1]), "kingdom_grace_text_04"
	local NodeParam = json.encode(NodeData)
	local urlJsonStr = string.urlencode(NodeParam)
	_ENV = i18n(itemDesRead.getName(awardId))
	i18n(itemDesRead.getName(awardId)).param = urlJsonStr
	i18n(itemDesRead.getName(awardId)).name = "itemNode"
	i18n(itemDesRead.getName(awardId)).width = 40
	i18n(itemDesRead.getName(awardId)).height = 40
	i18n(itemDesRead.getName(awardId)).custom = "Node"
	i18n(itemDesRead.getName(awardId)).offsety = 16
	str = str .. SoraDWrapReplaceTag(i18n(itemDesRead.getName(awardId)))
	self.textAwardAllInfo:setString(str)
	SoraDGetAutoHeightLabel(self.textAwardAllInfo, 590)
	self.textLeftAward:setString(kingdomGraceCtrl:getKingdomExchangeLeftCount())
	_ENV = kingdomGraceCtrl:getKingdomExchangeLeftCount()
	kingdomGraceCtrl:getKingdomExchangeLeftCount().num = kingdomGraceCtrl:getExchangeCount()
	self.textConvertible:setString(i18n("kingdom_grace_text_05", kingdomGraceCtrl:getKingdomExchangeLeftCount()))
	_ENV = i18n("kingdom_grace_text_05", kingdomGraceCtrl:getKingdomExchangeLeftCount())
	i18n("kingdom_grace_text_05", kingdomGraceCtrl:getKingdomExchangeLeftCount()).num = kingdomGraceCtrl:getScore()
	self.textPoints:setString(i18n("kingdom_grace_text_06", i18n("kingdom_grace_text_05", kingdomGraceCtrl:getKingdomExchangeLeftCount())))
	self.btnQuest:setPositionX(self.textPoints:getContentSize().width / 2 + 20)
	_ENV = self.textPoints:getContentSize().width / 2 + 20
	;(self.textPoints:getContentSize().width / 2 + 20).num1 = exchangePoint
	;(self.textPoints:getContentSize().width / 2 + 20).num2 = 1
	local strExplain = i18n("kingdom_grace_text_07", self.textPoints:getContentSize().width / 2 + 20)
	_ENV = self.textPoints
	self.textPoints.param = urlJsonStr
	self.textPoints.width = 40
	self.textPoints.height = 40
	self.textPoints.custom = "Node"
	self.textPoints.offsety = 13
	strExplain = strExplain .. SoraDWrapReplaceTag(self.textPoints)
	strExplain = strExplain .. i18n("kingdom_grace_text_15")
	self.textExplain:setString(strExplain)
	SoraDGetAutoHeightLabel(self.textExplain, 500)
	self.textIsBound:setVisible(kingdomGraceCtrl:getTotalGetScore() >= kingdomGraceRead.getExchangeConfig(group, "personLimit"))
	if 0 < kingdomGraceCtrl:getCanExchangeCount() then
		self.redNode:setVisible(true)
	else
		self.redNode:setVisible(false)
		self.btnExchange:setBright(false)
	end
end
function kingdomGraceView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.KINGDOM_FAVOR) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function kingdomGraceView:btnClickKill(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllPanelFromManager()
		local panel = SoraDCreatePanel("worldMapMonsterSearch")
		panel:show()
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.QUICK_TO_WORLD, nil)
	end
end
function kingdomGraceView:btnClickExchange(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if kingdomGraceCtrl:getCanExchangeCount() > 0 then
			SoraDCreatePanel("kGraceExchangePopView"):show()
		elseif 0 < kingdomGraceCtrl:getKingdomExchangeLeftCount() then
			SoraDShowMsgTip(i18n("kingdom_grace_text_09"))
		else
			SoraDShowMsgTip(i18n("kingdom_grace_text_17"))
		end
	end
end
function kingdomGraceView:btnlClickQuest(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("kGraceExplainPopView"):show()
	end
end
return kingdomGraceView
