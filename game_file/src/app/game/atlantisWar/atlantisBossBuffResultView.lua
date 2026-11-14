local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local allianceDesRead = include("allianceDesRead")
local atlantisWarUtil = include("atlantisWarUtil")
local qualityConfig = gAtlantisQualityConfig
local atlantisBossBuffResultView = class("atlantisBossBuffResultView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("atlantisBossBuffResultView")
	end
	return target
end)
function atlantisBossBuffResultView:ctor()
	self:initWidget()
end
function atlantisBossBuffResultView:initWidget(...)
	_UPVALUE1_ = nil
	;(nil)[1] = "Center_Node"
	self.Center_Node = SoraDGetChildByFullPath(self._ccsView, nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "ar"
	;(nil)[2] = "en"
	local icon = SoraDGetImageNameByLang("frame_shmc_congratulation_%s.png", nil)
	_UPVALUE1_ = "ar"
	;("ar")[1] = "Sprite_title"
	SoraDGetChildByFullPath(self.Center_Node, "ar"):setSpriteFrame(icon)
	_UPVALUE1_ = icon
	icon[1] = "Node_buff"
	self.Node_buff = SoraDGetChildByFullPath(self.Center_Node, icon)
	_UPVALUE1_ = icon
	icon[1] = "Text_buff"
	self.Text_buff = SoraDGetChildByFullPath(self.Node_buff, icon)
	self.Text_buff:setString(i18n("atlantiswar_text_0169"))
	_UPVALUE1_ = i18n("atlantiswar_text_0169")
	i18n("atlantiswar_text_0169")[1] = "Node_kSingle"
	self.Node_kSingle = SoraDGetChildByFullPath(self.Node_buff, i18n("atlantiswar_text_0169"))
	self.Node_kSingle:setVisible(false)
	_UPVALUE1_ = false
	;(false)[1] = "Node_skill"
	self.Node_skill = SoraDGetChildByFullPath(self.Center_Node, false)
	_UPVALUE1_ = false
	;(false)[1] = "Text_skill"
	self.Text_skill = SoraDGetChildByFullPath(self.Node_skill, false)
	self.Text_skill:setString(i18n("atlantiswar_text_0170"))
	self.Node_skills = SoraDGetChildsArrayByName(self.Node_skill, "Node_skill", 2, 1)
	self.Node_players = SoraDGetChildsArrayByName(self.Node_skill, "Node_player", 3, 1, false)
	_UPVALUE1_ = "Node_player"
	;("Node_player")[1] = "Text_close"
	self.Text_close = SoraDGetChildByFullPath(self._ccsView, "Node_player")
	self.Text_close:setString(i18n("birthday_text_04"))
	self.Image_skillList, _ENV = self.Text_close.setString, self.Text_close.setString
	for i, Node_skill in ipairs(self.Node_skills) do
		table.insert(self.Image_skillList, SoraDGetChildByName(Node_skill, "Image_skill"))
	end
	for i, Image_skill in ipairs(self.Image_skillList) do
		Image_skill:setTouchEnabled(true)
		Image_skill:addTouchEventListener(handler(self, self.onClickBuff))
	end
end
function atlantisBossBuffResultView:initData(campMap, bossClassID)
	local effectList = atlantisWarUtil.getBossEffectList(bossClassID)
	for i, Image_skill in ipairs(self.Image_skillList) do
		self:refreshBuffIcon(Image_skill, effectList[i + 2])
	end
	atlantisWarUtil = (for generator)
	ipairs(self.Image_skillList)[gBossType.atlantisWarWlyn] = "killBossWlynCount"
	local ipairs(self.Image_skillList)[gBossType.atlantisWarSd], config = "killBossSdCount", ipairs(self.Image_skillList)
	local countKey = config[bossClassID]
	local index = 0
	local kingdomCount = atlantisWarUtil.getKingdomCount()
	for camp = 1, kingdomCount do
		local single = self.Node_kSingle:clone()
		single:addTo(self.Node_buff)
		single:setVisible(true)
		local row = math.ceil(camp / 2)
		local col = (camp - 1) % 2 + 1
		local posy = 50 - (row - 1) * 100
		single:setPosition(SoraDFSign(220 - (col - 1) * 280), posy)
		if camp % 2 == 1 and camp <= 4 then
			local line = display.newSprite("#frame_shmc_bg_08.png")
			line:addTo(self.Node_buff)
			line:setPosition(0, posy - 50)
			line:setScale(0.915625, 0.5)
		end
		SoraDGetAllChildFromWidget(single, single)
		local campData = campMap[camp]
		single.Text_kingdom:setString(serviceFunctions.getKingdomFormatName(campData.kingdomName, campData.kid))
		single.Sprite_flag:setSpriteFrame(allianceDesRead.getFlagIcon(campData.flag))
		single.Sprite_flag:setScale(0.35)
		for j = 1, 2 do
			local Node_buff = single["Node_buff" .. j]
			local Image_buff = SoraDGetChildByName(Node_buff, "Image_buff")
			Image_buff:setTouchEnabled(true)
			Image_buff:addTouchEventListener(handler(self, self.onClickBuff))
			self:refreshBuffIcon(Image_buff, effectList[j])
			local Text_count = SoraDGetChildByName(Node_buff, "Text_count")
			Text_count:setString("x" .. campData[countKey])
		end
		local topPlayer = campData.topPlayer
		if topPlayer and next(topPlayer) then
			index = index + 1
			local Node_player = self.Node_players[index]
			Node_player:setVisible(true)
			local Text_player = SoraDGetChildByName(Node_player, "Text_player")
			Text_player:setString(serviceFunctions.getKingdomFormatName(topPlayer.name, campData.kid))
			local ccs_head = SoraDGetExtendChildFromCCSByName(Node_player, "CCS_commonHead_1")
			ccs_head:setTouchEnabled(false)
			ccs_head:setHeadSprite(topPlayer.headid, topPlayer.avatar)
			ccs_head:setScale(1.0)
		end
	end
end
function atlantisBossBuffResultView:refreshBuffIcon(Image_buff, effect)
	local config = atlantisActivityCtrl:getBuffConfig(effect.effect)
	local qConfig = qualityConfig[config.itemquality]
	SoraChangeSpriteImage(Image_buff, config.icon)
	Image_buff:setTag(effect.effect)
	local Image_quality = Image_buff:getChildByName("Image_quality")
	SoraChangeSpriteImage(Image_quality, qConfig.qImage)
end
function atlantisBossBuffResultView:onClickBuff(button, eventType)
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
function atlantisBossBuffResultView:onExitPanel(...)
	SoraDCloseCommonTips()
end
return atlantisBossBuffResultView
