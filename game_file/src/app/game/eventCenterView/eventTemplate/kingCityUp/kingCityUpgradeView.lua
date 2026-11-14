local kingCityUpgradeCtrl = SoraDGetCtrl("kingCityUpgradeCtrl")
local kingCityUpgradeRead = include("kingCityUpgradeRead")
local kingCityUpgradeView = class("kingCityUpgradeView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("kingCityUpgradeView")
end)
function kingCityUpgradeView:ctor(properties)
	self.singleList, _ENV, self.activityID = gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY, gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY, gActivityTimeActivityID.CASTLE_UP_LEVEL_ACTIVITY
	SoraDGetChildByName(self, "Top_Image_Bg"):setScale(math.max(1, display.height / 1136))
	self.node = SoraDGetChildByName(self, "Top_Node")
	self.textTips = SoraDGetChildByName(self.node, "Text_Tips")
	self.textTips:setString(i18n("cityUp_text_01"))
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeCommonFramTitle:setTitle(i18n("activity_name_9001265"))
	self.nodeBar = SoraDGetChildByName(self, "Node_Bar")
	self.imageCastleTop = SoraDGetChildByName(self.nodeBar, "castal_Top")
	self.imageCastleBottom = SoraDGetChildByName(self.nodeBar, "castle_bottom")
	self.spBg = SoraDGetChildByName(self.nodeBar, "bar_Bg")
	self.panelCutEffect = SoraDGetChildByName(self, "Panel_Effect_Cut")
	self.nodeCommonProgressBar = SoraDGetChildByName(self.spBg, "CCS_commonProgressBar_preview")
	self.m_progressBar = SoraDGetChildByName(self.nodeCommonProgressBar, "LoadingBar_progress")
	local cssFileName = "kingCityUpgradeView"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0)
	self:runAction(action)
	self:fitView()
	self:initData()
end
function kingCityUpgradeView:onEnterOther()
	kingCityUpgradeCtrl:reqUpgradeCaslteLvInit()
end
function kingCityUpgradeView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP", handler(self, self.refreshProgress))
	SoraDAddMessage(self, "MESSAGE_KINGCITY_UPGRADE_REFRESH", handler(self, self.refreshProgress))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
end
function kingCityUpgradeView:fitView()
	local offsetHeight = math.max(-110, display.height - 1136)
	self.newHeight = 640 + offsetHeight
	self.nodeBar:setScale((display.height - 1136 + 640 + 210) / (self.newHeight + 210))
	self.spBg:setContentSize(cc.size(15, self.newHeight))
	self.panelCutEffect:setContentSize(cc.size(100, self.newHeight))
	self.m_progressBar:setContentSize(cc.size(self.newHeight + 18, 30))
	self.offset = (self.newHeight + 18) / kingCityUpgradeRead.getConfigNum()
	self.imageCastleTop:setPositionY(self.newHeight + 220)
	local effectScale = self.newHeight / 290
	SoraDGetChildByName(self, "G_dh_Tex_wjtzjf_003_01"):setScaleX(effectScale)
	SoraDGetChildByName(self, "G_dh_Tex_wjtzjf_003_02"):setScaleX(effectScale)
	if SoraDGetFactionType() == 2 then
		self.imageCastleTop:setScale(0.8)
		self.imageCastleBottom:setScale(0.8)
		self.imageCastleBottom:setPositionY(self.imageCastleBottom:getPositionY() - 40)
		self.imageCastleTop:setSpriteFrame("Castle_byzantine_Lv30.png")
		self.imageCastleTop:setPositionX(-40)
		self.imageCastleBottom:setSpriteFrame("Castle_byzantine_Lv5.png")
	end
end
function kingCityUpgradeView:initData(target, data)
	self:initProgressBar()
	self:refreshProgress()
end
function kingCityUpgradeView:initProgressBar()
	self.awardConfig = kingCityUpgradeRead.getAwardConfig()
	for i, v in ipairs(self.awardConfig) do
		local single = include("kingCitySingleNode").new()
		single:addTo(self.nodeBar)
		single:setPosition(0, 120 + i * self.offset)
		single:setRotation3D(cc.vec3(0, i % 2 == 0 and 180 or 0, 0))
		single:initData(v.castlelv, v.Index)
		self.singleList[i] = single
	end
end
function kingCityUpgradeView:refreshProgress()
	local curValue = SoraDGetCastleLv()
	local max = #self.awardConfig
	local belongNum = max
	for i, v in ipairs(self.awardConfig) do
		self.singleList[i]:refreshSingle()
		if curValue < v.castlelv then
			belongNum = i - 1
			break
		elseif curValue == v.castlelv then
			belongNum = i
			break
		end
	end
	local totalDis = 0
	local baseDis = math.max(0, belongNum) / max * 100
	local preTaskNum = belongNum == 0 and 0 or self.awardConfig[belongNum].castlelv
	local afterTaskNum = self.awardConfig[math.min(belongNum + 1, max)].castlelv
	local curDis = 100 * (curValue - preTaskNum) / (afterTaskNum - preTaskNum) / max
	totalDis = baseDis + curDis
	print("totalDis", belongNum, totalDis, curValue)
	local panelHeight = (self.newHeight + 18) * (totalDis / 100)
	self.m_progressBar:setPercent(totalDis)
	self.panelCutEffect:setContentSize(cc.size(100, panelHeight))
end
function kingCityUpgradeView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDShowHelpMsgTip(i18n("key"))
	end
end
function kingCityUpgradeView:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return kingCityUpgradeView
