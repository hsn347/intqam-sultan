local allianceMgr = SoraDGetCtrl("allianceMgr")
local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local atlantisWarUtil = include("atlantisWarUtil")
local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local AMB = require_data("atlantiswar_map_build", true).data
local qualityConfig = gAtlantisQualityConfig
local worldMapAtlantisBossView = class("worldMapAtlantisBossView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldMapAtlantisBossView")
	end
	return target
end)
function worldMapAtlantisBossView:ctor(...)
	self:initWidget()
end
function worldMapAtlantisBossView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLD_MAP_REQUEST_OBJECT_INFO", handler(self, self.serverMessage_RequestMapInstaceInfo))
end
function worldMapAtlantisBossView:initWidget(...)
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.Text_left:setString(i18n("atlantiswar_text_0334"))
	self.Image_skillList, _ENV = self.Text_left.setString, self.Text_left.setString
	_UPVALUE3_ = i18n("atlantiswar_text_0334")
	i18n("atlantiswar_text_0334")[1] = "Node_rewards"
	i18n("atlantiswar_text_0334")[2] = "Node_buff1"
	i18n("atlantiswar_text_0334")[3] = "Image_skill"
	table.insert(self.Image_skillList, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334")))
	_UPVALUE3_ = SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334"))
	SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334"))[1] = "Node_rewards"
	SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334"))[2] = "Node_buff2"
	SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334"))[3] = "Image_skill"
	table.insert(self.Image_skillList, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334"))))
	_UPVALUE3_ = SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334")))
	SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334")))[1] = "Node_rewards"
	SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334")))[2] = "Node_buff1"
	SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334")))[3] = "Image_skill"
	table.insert(self.Image_skillList, SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334")))))
	_UPVALUE3_ = SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334"))))
	SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334"))))[1] = "Node_rewards"
	SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334"))))[2] = "Node_buff2"
	SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334"))))[3] = "Image_skill"
	table.insert(self.Image_skillList, SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334"))))))
	self.Text_countList, _ENV = table.insert, table.insert
	_UPVALUE4_ = SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334")))))
	SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334")))))[1] = "Node_rewards"
	SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334")))))[2] = "Node_buff1"
	SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334")))))[3] = "Node_count"
	SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334")))))[4] = "Text_count"
	self.Text_countList[3] = SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334"))))))
	_UPVALUE4_ = SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334")))))
	SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334")))))[1] = "Node_rewards"
	SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334")))))[2] = "Node_buff2"
	SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334")))))[3] = "Node_count"
	SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334")))))[4] = "Text_count"
	self.Text_countList[4] = SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_right, SoraDGetChildByFullPath(self.Node_left, SoraDGetChildByFullPath(self.Node_left, i18n("atlantiswar_text_0334"))))))
	for i, Image_skill in ipairs(self.Image_skillList) do
		Image_skill:setTouchEnabled(true)
		Image_skill:addTouchEventListener(handler(self, self.onClickBuff))
	end
	SoraDChangeTextToHtml(self.Text_time)
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeEndListener(function()
		self:close(nil, ccui.TouchEventType.ended)
	end)
	self.Button_mass:setTitleText(i18n("common_text_2079"))
	SoraDAutoSizeButtonTextByContent(self.Button_mass)
	self.Button_mass:addTouchEventListener(handler(self, self.massButtonCallFun))
	self.Button_help:addTouchEventListener(handler(self, self.btnHelpClick))
end
function worldMapAtlantisBossView:initData(mapInstance)
	self.boss = mapInstance
	local bossClassID = self.boss:getBossClassID()
	local objId = self.boss:getObjId()
	local image = worldMapDefine.getWorldBossShow(bossClassID).image
	self.Sprite_boss:setSpriteFrame(image)
	self.Text_bossName:setString(self.boss.bossName)
	self.Text_desInfo:setString(i18n("atlantiswar_text_0219"))
	local campList = clone(AMB[objId].camp)
	table.sort(campList)
	local killBossFcKey = ""
	local killBossCountKey = ""
	if bossClassID == gBossType.atlantisWarWlyn then
		killBossFcKey = "killBossWlynFc"
		killBossCountKey = "killBossWlynCount"
	elseif bossClassID == gBossType.atlantisWarSd then
		killBossFcKey = "killBossSdFc"
		killBossCountKey = "killBossSdCount"
	end
	local _ENV, config = gBossType.atlantisWarSd, gBossType.atlantisWarSd
	for __, camp in ipairs(campList) do
		local campData = atlantisWarCtrl:getCampData(camp)
		local killFc = campData[killBossFcKey] or 0
		local killCount = campData[killBossCountKey] or 0
		_ENV = i18n("atlantiswar_text_0219")
		i18n("atlantiswar_text_0219").camp = camp
		i18n("atlantiswar_text_0219").killFc = killFc
		i18n("atlantiswar_text_0219").killCount = killCount
		i18n("atlantiswar_text_0219").percent = 50
		table.insert(config, i18n("atlantiswar_text_0219"))
	end
	local totalKillFc = config[1].killFc + config[2].killFc
	if 0 < totalKillFc then
		for i, v in ipairs(config) do
			v.percent = v.killFc / totalKillFc * 100
		end
	end
	dump(config, "==worldMapAtlantisBossView config==")
	for i, v in ipairs(config) do
		_ENV = i18n("atlantiswar_text_0219")
		_ENV, _ENV, i18n("atlantiswar_text_0219").var = v.killCount, string.formatnumberthousands(v.killCount), string.formatnumberthousands(v.killCount)
		string.formatnumberthousands(v.killCount).var, v.killCount.color = v.killCount, "#E6B46E"
		SoraDChangeTextToHtml(self["Text_kill" .. i]):setString(i18n_html("atlantiswar_text_0332", i18n("atlantiswar_text_0219")))
		_ENV = i18n_html("atlantiswar_text_0332", i18n("atlantiswar_text_0219"))
		_ENV, _ENV, i18n_html("atlantiswar_text_0332", i18n("atlantiswar_text_0219")).var = v.killFc, string.formatnumberthousands(v.killFc), string.formatnumberthousands(v.killFc)
		string.formatnumberthousands(v.killFc).var, v.killFc.color = v.killFc, "#E6B46E"
		SoraDChangeTextToHtml(self["Text_score" .. i]):setString(i18n_html("atlantiswar_text_0333", i18n_html("atlantiswar_text_0332", i18n("atlantiswar_text_0219"))))
		local Image_bar = self["Image_bar" .. i]
		local imageName = atlantisWarUtil.getCampLoadingBarImage(v.camp)
		SoraChangeSpriteImage(Image_bar, imageName)
		local imageSize = Image_bar:getContentSize()
		Image_bar:setContentSize(cc.size(540 * v.percent / 100, imageSize.height))
	end
	if self.boss.warStatus == gKingdomWarStatusType.inWar then
		local leftTime = 0
		if bossClassID == gBossType.atlantisWarWlyn then
			leftTime = atlantisWarCtrl:getWarStageRemainTime(gAtlantisWarStageType.wlynIng)
		elseif bossClassID == gBossType.atlantisWarSd then
			leftTime = atlantisWarCtrl:getWarStageRemainTime(gAtlantisWarStageType.sdIng)
		end
		if 0 < leftTime then
			self.Text_time:setTimeLast(function(time)
				_ENV = nil
				_ENV, _ENV, (nil).var = nil, nil, time
				_ENV, (nil).var, (nil).color = nil, nil, "#FFF9CD"
				;(nil).__default, (nil).color = nil, "#E6B46E"
				return i18n_html("atlantiswar_text_0074", nil, nil)
			end)
			self.Text_time:beginTime(leftTime)
		end
		self:setStateBegin()
		local selfCamp = atlantisWarCtrl:getSelfCamp()
		if not table.indexof(campList, selfCamp) then
			self.Button_mass:setVisible(false)
		end
	else
		local leftTime = 0
		if bossClassID == gBossType.atlantisWarWlyn then
			leftTime = atlantisWarCtrl:getWarStageRemainTime(gAtlantisWarStageType.wlynReady)
		elseif bossClassID == gBossType.atlantisWarSd then
			leftTime = atlantisWarCtrl:getWarStageRemainTime(gAtlantisWarStageType.sdReady)
		end
		if 0 < leftTime then
			self.Text_time:setTimeLast(function(time)
				_ENV = nil
				_ENV, _ENV, (nil).time = nil, nil, time
				_ENV, (nil).time, (nil).color = nil, nil, "#FFF9CD"
				;(nil).__default, (nil).color = nil, "#E6B46E"
				return i18n_html("atlantiswar_text_0263", nil, nil)
			end)
			self.Text_time:beginTime(leftTime)
			self:setStateReady()
		else
			self:setStateEnd()
		end
	end
	local effectList = atlantisWarUtil.getBossEffectList(bossClassID)
	for i, Image_skill in ipairs(self.Image_skillList) do
		local effect = effectList[i]
		local config = atlantisActivityCtrl:getBuffConfig(effect.effect)
		local qConfig = qualityConfig[config.itemquality]
		SoraChangeSpriteImage(Image_skill, config.icon)
		Image_skill:setTag(effect.effect)
		local Image_quality = Image_skill:getChildByName("Image_quality")
		SoraChangeSpriteImage(Image_quality, qConfig.qImage)
	end
	for i = 3, 4 do
		local effect = effectList[i]
		self.Text_countList[i]:setString(effect.value)
	end
	self:requestInstanceInfo()
end
function worldMapAtlantisBossView:requestInstanceInfo()
	if self.boss and self.boss.__cname then
		local tilePoint = self.boss:getTilePoint()
		local instanceID = self.boss:getInstanceID()
		local kingdomID = self.boss:getWorldMapCell().kingdomID
		kingdomMapCtrl:reqMapObjInfo(tilePoint.x, tilePoint.y, instanceID, kingdomID)
		SoraDShowLoading(self)
	end
end
function worldMapAtlantisBossView:serverMessage_RequestMapInstaceInfo(target, data)
	if not data.data then
		return
	end
	if tolua.isnull(self.boss) then
		self:close(nil, ccui.TouchEventType.ended)
	end
	SoraDCloseLoading(self)
	if not data.data.boss then
		local _ENV, bossData = data.data.boss, data.data.boss
	end
	local camps = bossData.camps
	_UPVALUE2_, atlantisWarUtil = nil, nil
	;(nil)[1] = "camp"
	;(nil)[2] = "<"
	;(nil)[1] = nil
	serviceFunctions.sort(camps, nil)
	local winCamp = bossData.winCamp
	local winPlayer = bossData.winPlayer
	local allianceDesRead = include("allianceDesRead")
	for i = 1, 2 do
		local camp = camps[i].camp
		local Text_kingdom = self["Text_kingdom" .. i]
		local textColor = atlantisWarUtil.getCampTextColor(camp)
		Text_kingdom:setColor(textColor)
		local kingdomName = serviceFunctions.getKingdomFormatName(camps[i].kingdomName, camps[i].kid)
		Text_kingdom:setString(kingdomName)
		local flag = camps[i].flag
		if flag then
			local Sprite_flag = self["Sprite_flag" .. i]
			Sprite_flag:setSpriteFrame(allianceDesRead.getFlagIcon(flag))
			Sprite_flag:setScale(0.35)
		end
	end
	if self.isStateEnd then
		if winPlayer and next(winPlayer) then
			local name = winPlayer.name
			_ENV = self["Text_kingdom" .. i]
			self["Text_kingdom" .. i].var = name
			self.Text_right:setString(i18n("atlantiswar_text_0078", self["Text_kingdom" .. i]))
		else
			self.Text_right:setString(i18n("hero_text_84"))
		end
	end
end
function worldMapAtlantisBossView:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function worldMapAtlantisBossView:getTilePoint()
	return self.tilePoint
end
function worldMapAtlantisBossView:massButtonCallFun(ref, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local buildLogic = include("buildLogic")
		local isOwn = buildLogic.isOwnBuild(BUILDID.HALL_OF_WAR)
		if not isOwn then
			SoraDShowMsgBox(i18n("common_text_2125"), i18n("common_text_204"))
			return
		end
		if not allianceMgr:hasJoinAlliance(true) then
			SoraDShowMsgBox(i18n("common_text_583"), i18n("common_text_204"))
			return
		end
		if not atlantisWarUtil.checkCanMass() then
			SoraDShowMsgTip(i18n("atlantiswar_text_0260"))
			return
		end
		if SoraDEnoughTroops() then
			local panel = uiManager:show("WorldMapMass")
			_ENV = i18n("atlantiswar_text_0260")
			i18n("atlantiswar_text_0260").uPos = self.tilePoint
			i18n("atlantiswar_text_0260").dispatchType = worldMapDefine.worldMapTipButtonType_xuanZhan
			i18n("atlantiswar_text_0260").instanceID = self.boss:getInstanceID()
			i18n("atlantiswar_text_0260").instanceType = self.boss:getInstanceType()
			i18n("atlantiswar_text_0260").classID = self.boss:getBossClassID()
			panel.view:bindData(i18n("atlantiswar_text_0260"))
		end
		self:close(ref, type)
	end
end
function worldMapAtlantisBossView:close(ref, type)
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(nil)
end
function worldMapAtlantisBossView:setStateReady(...)
	self.Sprite_finish:setVisible(false)
	self.Button_mass:setVisible(false)
	self.Text_right:setString(i18n("atlantiswar_text_0073"))
end
function worldMapAtlantisBossView:setStateBegin(...)
	self.Sprite_finish:setVisible(false)
	self.Button_mass:setVisible(true)
	self.Text_right:setString(i18n("atlantiswar_text_0073"))
end
function worldMapAtlantisBossView:setStateEnd(...)
	self.isStateEnd = true
	_ENV, _ENV, _ENV = nil, nil, nil
	;(nil).__default, (nil).color = nil, "#FFF9CD"
	self.Text_time:setString(i18n_html("atlantiswar_text_0079", nil, nil))
	self.Sprite_finish:setVisible(true)
	SoraDSetGray(self.Sprite_boss, true)
	self.Button_mass:setVisible(false)
end
function worldMapAtlantisBossView:onClickBuff(button, eventType)
	if eventType == ccui.TouchEventType.began then
		SoraDPlaySound()
		_ENV = button
		function button.initFunc(tips, buffId)
			local config = atlantisActivityCtrl:getBuffConfig(buffId)
			tips:customName(i18n(config.name))
			tips:customDes(i18n(config.describe))
			return true
		end
		SoraDShowCommonTips(button, button:getTag(), button)
	elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
		SoraDCloseCommonTips()
	end
end
function worldMapAtlantisBossView:onExitPanel(...)
	SoraDCloseCommonTips()
end
function worldMapAtlantisBossView:btnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local bossClassID = self.boss:getBossClassID()
		local bossName = self.boss.bossName
		if bossClassID == gBossType.atlantisWarWlyn then
			_ENV = nil
			;(nil)[1] = i18n("atlantiswar_text_0157")
			;(nil)[2] = i18n("atlantiswar_text_0157")
			SoraDShowFixWindow(bossName, nil)
		elseif bossClassID == gBossType.atlantisWarSd then
			_ENV = nil
			;(nil)[1] = i18n("atlantiswar_text_0159")
			;(nil)[2] = i18n("atlantiswar_text_0159")
			SoraDShowFixWindow(bossName, nil)
		end
	end
end
return worldMapAtlantisBossView
