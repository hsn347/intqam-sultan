local gametop = gModuleMgr.getObject("gametop")
local activity_9001597_Read = include("activity_9001597_Read")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local activity_9001597_Ctrl = SoraDGetCtrl("activity_9001597_Ctrl")
local constantRead = include("constantRead")
local worldMapRamadanSylyut = class("worldMapRamadanSylyut", function()
	local target = include("worldMapInstance").new("worldMapRamadanSylyut")
	return target
end)
function worldMapRamadanSylyut:ctor()
	self.ignoreRequest = true
	self:_initUI()
	self:_initData()
end
function worldMapRamadanSylyut:_initData()
end
function worldMapRamadanSylyut:_initUI()
	self.modelImage = display.newSprite("#zylp_gj_w_01.png")
	self.modelImage:setPositionY(35)
	self:addChild(self.modelImage, -1)
	self.modelImage:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	self.image_name_bg = display.newSprite("#frame_SJDT_mingpai.png")
	self.image_name_bg:setContentSize(cc.size(231, 25))
	self.image_name_bg:setOpacity(178.5)
	self.image_name_bg:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_name_bg:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 30 - 60))
	self.image_name_bg:addTo(self, 1)
	self.image_name_bg:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_name_bg
	self.image_name_bg.UILabelType = 2
	self.image_name_bg.text = ""
	self.image_name_bg.size = 18
	self.text_Name = SoraDCreateLabel(self.image_name_bg)
	self.text_Name:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_Name:setColor(cc.c3b(255, 235, 185))
	self.text_Name:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 30 - 61))
	self.text_Name:addTo(self, 1)
	self.text_Name:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.image_time_bg = display.newSprite("#frame_SJDT_mingpai.png")
	self.image_time_bg:setContentSize(cc.size(173, 25))
	self.image_time_bg:setOpacity(178.5)
	self.image_time_bg:setAnchorPoint(cc.p(0.5, 0.5))
	self.image_time_bg:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 30 - 90))
	self.image_time_bg:addTo(self, 1)
	self.image_time_bg:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	_ENV = self.image_time_bg
	self.image_time_bg.UILabelType = 2
	self.image_time_bg.text = "00:00:00"
	self.image_time_bg.size = 18
	self.text_time = cc.ui.UILabel.new(self.image_time_bg)
	self.text_time:setColor(cc.c3b(255, 235, 185))
	self.text_time:setAnchorPoint(cc.p(0.5, 0.5))
	self.text_time:setPosition(cc.p(self.centerPoint.x, self.centerPoint.y + 30 - 91))
	self.text_time:addTo(self, 1)
	self.text_time:setGroupID(worldMapDefine.GROU_ID.group_text)
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.icon_hourglass = display.newSprite("#icon_hourglass.png")
	self.icon_hourglass:setAnchorPoint(cc.p(0.5, 0.5))
	self.icon_hourglass:setPosition(cc.p(SoraDFIsRA() and self.centerPoint.x + 50 or self.centerPoint.x - 50, self.text_time:getPositionY()))
	self.icon_hourglass:setScale(0.5)
	self.icon_hourglass:addTo(self, 1)
	self.icon_hourglass:setGroupID(worldMapDefine.GROU_ID.group_level_build)
end
function worldMapRamadanSylyut:updateTipFrame(isMy)
	if self.imgTips then
		self.imgTips:setVisible(isMy)
		self.spriteArr:setVisible(isMy)
		self.labelTips:setVisible(isMy)
		return
	elseif not isMy then
		return
	end
	local imgTips = ccui.ImageView:create("frame_newbie_task_dialog_box_01.png", ccui.TextureResType.plistType)
	imgTips:setAnchorPoint(cc.p(0.5, 0.5))
	imgTips:setScale9Enabled(true)
	imgTips:setCapInsets(cc.rect(25, 25, 26, 28))
	imgTips:setPosition(0, 140)
	imgTips:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	imgTips:addTo(self, 1)
	local labelTips = ccui.Text:create("", "", 20)
	labelTips:setColor(cc.c4b(255, 235, 185, 255))
	labelTips:setAnchorPoint(cc.p(0.5, 0.5))
	labelTips:addTo(self, 1)
	labelTips:setPosition(0, 140)
	labelTips:setGroupID(worldMapDefine.GROU_ID.group_text)
	labelTips:setString(i18n("salvo_guide_text1"))
	local size = labelTips:getContentSize()
	imgTips:setContentSize(cc.size(size.width + 30, size.height + 30))
	labelTips:setAnchorPoint(cc.p(0.5, 0.5))
	local spriteArr = display.newSprite("#frame_newbie_task_dialog_box_02.png")
	spriteArr:setAnchorPoint(cc.p(0.5, 0))
	spriteArr:addTo(self, 1)
	spriteArr:setRotation(180)
	spriteArr:setGroupID(worldMapDefine.GROU_ID.group_level_build)
	spriteArr:setPosition(0, 140)
	self.imgTips = imgTips
	self.spriteArr = spriteArr
	self.labelTips = labelTips
end
function worldMapRamadanSylyut:initInstanceData(resourceClassID, data)
	self:updateData(data)
end
function worldMapRamadanSylyut:updateData(data)
	dump(data, "worldMapRamadanSylyut:updateData")
	self.data = data
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	local isSelf = self.data.placeUid == selfPlayerID
	self.isMyBuilding = isSelf
	self:updateTipFrame(isSelf)
	if isSelf then
		self.text_Name:setString(i18n("Ramadan_2024_text45"))
	else
		self.text_Name:setString(self.data.playerName)
	end
	self:updateDisapearTime()
	self:showEffect()
end
function worldMapRamadanSylyut:updateDisapearTime()
	self.text_time:setVisible(true)
	self.lastTime = self.data.disappearTime - serviceFunctions.systemTime()
	self.text_time:beginTime(self.lastTime)
end
function worldMapRamadanSylyut:showEffect()
	self:removeChildByName("effect", true)
	if self.data.playTime == nil then
		return
	end
	local passTime = serviceFunctions.systemTime() - self.data.playTime
	local playTimes, effectType = activity_9001597_Read.getPlayTimes(self.data.playID, self.data.playCount)
	local totalPlayTime = 3 * playTimes
	if totalPlayTime - passTime <= 0 then
		return
	end
	local lastPlayTimes = math.ceil(totalPlayTime - passTime)
	self:stopActionByTag(996)
	local _ENV, seqActions = self.stopActionByTag, self.stopActionByTag
	for i = 1, lastPlayTimes do
		table.insert(seqActions, cca.delay(1))
		table.insert(seqActions, cca.callFunc(function()
			self:createEffect(effectType)
		end))
	end
	local seq = cca.seq(seqActions)
	seq:setTag(996)
	self:runAction(seq)
end
function worldMapRamadanSylyut:createEffect(effectType)
	local imgName = effectType == 1 and "dh_9001597_firelv1_%02d.png" or "dh_9001597_firelv2_%02d.png"
	local sp = display.newSprite(string.format("#%s", string.format(imgName, 1)))
	sp:setName("effect")
	sp:setOpacity(0)
	_UPVALUE2_ = string.format("#%s", string.format(imgName, 1))
	string.format("#%s", string.format(imgName, 1))[1] = cca.delay(0.05)
	string.format("#%s", string.format(imgName, 1))[2] = cca.fadeIn(0)
	string.format("#%s", string.format(imgName, 1))[3] = cca.callFunc(function()
		local frames = display.newFrames(imgName, 1, 29)
		local animation = display.newAnimation(frames, 0.06666666666666667)
		sp:playAnimationOnce(animation, true)
	end)
	string.format("#%s", string.format(imgName, 1))[4] = cca.callFunc(function()
		local frames = display.newFrames(imgName, 1, 29)
		local animation = display.newAnimation(frames, 0.06666666666666667)
		sp:playAnimationOnce(animation, true)
	end)
	sp:runAction(cca.seq(string.format("#%s", string.format(imgName, 1))))
	self:addChild(sp, 5)
	if effectType == 1 then
		sp:setPosition(cc.p(-160, 115))
	else
		sp:setPosition(cc.p(-180, 123))
	end
	local frames2 = display.newFrames("zylp_gj_w_%02d.png", 1, 12)
	local animation2 = display.newAnimation(frames2, 0.03333333333333333)
	self.modelImage:playAnimationOnce(animation2, false)
	return sp
end
function worldMapRamadanSylyut:getInstanceOp(isSelfKindom)
	local _ENV, buttonTypeArray
	_ENV = nil
	;(nil).buttonType = worldMapDefine.worldMapTipButtonType_shuoMing
	table.insert(buttonTypeArray, nil)
	if self.isMyBuilding then
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_activity_9001597_fire
		table.insert(buttonTypeArray, nil)
		_ENV = nil
		;(nil).buttonType = worldMapDefine.worldMapTipButtonType_activity_9001597_remove
		table.insert(buttonTypeArray, nil)
	end
	dump(buttonTypeArray, "worldMapRamadanSylyut:getInstanceOp")
	return buttonTypeArray
end
function worldMapRamadanSylyut:onClickTipButton(tipButtonType, tipButtonData, tipButtonExtra)
	dump(tipButtonType, "tipButtonType")
	if tipButtonType == worldMapDefine.worldMapTipButtonType_shuoMing then
		SoraDShowHelpMsgTip(i18n("Ramadan_2024_text27"))
		return true
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_activity_9001597_fire then
		_ENV = i18n("Ramadan_2024_text27")
		i18n("Ramadan_2024_text27").tipButtonData = tipButtonData
		uiManager:show("Activity_9001597_Pop", i18n("Ramadan_2024_text27"))
		return true
	elseif tipButtonType == worldMapDefine.worldMapTipButtonType_activity_9001597_remove then
		activity_9001597_Ctrl:reqDelete()
		return true
	end
	return false
end
function worldMapRamadanSylyut:getFavoriteName()
	return i18n("Ramadan_2024_text8")
end
return worldMapRamadanSylyut
