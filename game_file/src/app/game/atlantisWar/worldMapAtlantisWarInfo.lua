local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local atlantisWarUtil = include("atlantisWarUtil")
local worldMapAtlantisWarInfo = class("worldMapAtlantisWarInfo", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapAtlantisWarInfo")
	end
	return target
end)
local isShowInfo = true
function worldMapAtlantisWarInfo:ctor()
	self.isShow = isShowInfo
	self.isDirty = false
	self:initWidget()
end
function worldMapAtlantisWarInfo:initWidget(...)
	SoraDGetAllChildFromWidget(self, self)
	self.Panel_touch:addTouchEventListener(handler(self, self.btnPanelClick))
	self.Text_remain:setString(i18n("atlantiswar_text_0099"))
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_stageTime = SoraDCreateTimerLabel(self, self.Text_stageTime)
	self.Text_stageTime:setTimeEndListener(function()
		self:refreshWarStage()
		if self.handle then
			self.handle()
		end
	end)
	local textW = self.Text_remain:getContentSize().width
	if 230 < textW then
		textW = 230
		SoraDSetTextWidthHeight(self.Text_remain, cc.size(textW, 30))
	end
	self.icon_hourglass:setPositionX(self.Text_remain:getPositionX() - SoraDFSign(textW + 16))
	self.Text_time:setPositionX(self.icon_hourglass:getPositionX() - SoraDFSign(20))
	_UPVALUE2_ = 20
	;(20)[1] = cca.scaleTo(0.5, 0.8)
	;(20)[2] = cca.scaleTo(1.0, 1.2)
	;(20)[3] = cca.scaleTo(0.5, 1.0)
	;(20)[4] = cca.scaleTo(0.5, 1.0)
	;(20)[5] = cca.scaleTo(0.5, 1.0)
	self.Sprite_go:runAction(cca.repeatForever(cca.seq(20)))
	self.Button_go:addTouchEventListener(handler(self, self.btnGoClick))
	self.ccs_scroe = SoraDGetExtendChildFromCCSByName(self, "CCS_atlantisKingdomScroe_1")
	local constantRead = include("constantRead")
	local score_max = constantRead.getConstValue("ATLANTISWAR_SCORE_BAR_UP", 0)
	self.ccs_scroe:setScoreMax(score_max)
	self.Button_arrow:addTouchEventListener(handler(self, self.btnArrowClick))
	local kingdomCount = atlantisWarUtil.getKingdomCount()
	if kingdomCount == 4 then
		self.Image_bg:setHeight(188)
	end
	self:refreshShowWarInfo()
end
function worldMapAtlantisWarInfo:initData(...)
	self:refreshWarStage()
	self:refreshCampMap()
end
function worldMapAtlantisWarInfo:refreshWarStage(...)
	local warData = atlantisWarCtrl:getWarData()
	if not next(warData) then
		return
	end
	local curtime = serviceFunctions.systemTime()
	local lefttime = warData.warEndTime - curtime
	if 0 < lefttime then
		self.Text_time:beginTime(lefttime)
	end
	local stage, lefttime = atlantisWarCtrl:getWarStage()
	_UPVALUE6_ = lefttime
	lefttime[1] = i18n("atlantiswar_text_0100")
	lefttime[2] = i18n("atlantiswar_text_0101")
	lefttime[3] = i18n("atlantiswar_text_0102")
	lefttime[4] = i18n("atlantiswar_text_0103")
	lefttime[5] = i18n("atlantiswar_text_0104")
	lefttime[6] = i18n("atlantiswar_text_0105")
	lefttime[7] = i18n("atlantiswar_text_0106")
	local lefttime[8], stageConfig = i18n("atlantiswar_text_0106")
	self.Text_stage:setString(stageConfig[stage] or "")
	if stage == gAtlantisWarStageType.battleEnd then
		self.Node_stageTime:setVisible(false)
		self.Button_go:setVisible(false)
	elseif 0 < lefttime then
		self.Node_stageTime:setVisible(true)
		self.Text_stageTime:beginTime(lefttime)
		self.Button_go:setVisible(true)
	end
	if stage <= gAtlantisWarStageType.wlynIng then
		self.Sprite_stageBg:setSpriteFrame("frame_shmc_img_01.png")
	elseif stage <= gAtlantisWarStageType.sdIng then
		self.Sprite_stageBg:setSpriteFrame("frame_shmc_img_02.png")
	else
		self.Sprite_stageBg:setSpriteFrame("frame_shmc_img_03.png")
	end
end
function worldMapAtlantisWarInfo:refreshCampMap(...)
	if not self.isShow then
		self.isDirty = true
		return
	end
	local campMap = atlantisWarCtrl:getCampMap()
	local atlantisWarCtrl, data = atlantisWarCtrl, atlantisWarCtrl
	for camp, campData in ipairs(campMap) do
		local totalScore = (campData.killBossWlynScore or 0) + (campData.killBossSdScore or 0) + (campData.killPlayerScore or 0) + (campData.occupyScore or 0)
		local lastScoreTime = math.max(campData.killBossWlynFcTime or 0, campData.killBossSdFcTime or 0, campData.killPlayerScoreTime or 0, campData.occupyScoreTime or 0)
		atlantisWarCtrl = campData.killPlayerScoreTime or 0
		;(campData.killPlayerScoreTime or 0).camp = camp
		;(campData.killPlayerScoreTime or 0).kid = campData.kid
		;(campData.killPlayerScoreTime or 0).score = totalScore
		;(campData.killPlayerScoreTime or 0).t = lastScoreTime
		table.insert(data, campData.killPlayerScoreTime or 0)
	end
	self.ccs_scroe:initData(data)
end
function worldMapAtlantisWarInfo:btnGoClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local stage = atlantisWarCtrl:getWarStage()
		if stage <= gAtlantisWarStageType.wlynIng then
			atlantisWarUtil.jumpToBoss(gBossType.atlantisWarWlyn)
		elseif stage <= gAtlantisWarStageType.sdIng then
			atlantisWarUtil.jumpToBoss(gBossType.atlantisWarSd)
		elseif stage <= gAtlantisWarStageType.warAreaIng then
			atlantisWarUtil.jumpToBuild(901)
		end
	end
end
function worldMapAtlantisWarInfo:btnArrowClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isShow = not self.isShow
		self:refreshShowWarInfo()
	end
end
function worldMapAtlantisWarInfo:btnPanelClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("atlantisBattlePointRank"):show()
	end
end
function worldMapAtlantisWarInfo:setStageChangeHandle(handle)
	self.handle = handle
end
function worldMapAtlantisWarInfo:refreshShowWarInfo(...)
	self.Node_show:setVisible(self.isShow)
	local nodeShowH = self.Image_bg:getContentSize().height
	local offsetY = 40 + (self.isShow and nodeShowH or 0)
	self.Button_arrow:setPositionY(-offsetY)
	self.Sprite_arrow:setFlippedY(self.isShow)
	self.Panel_touch:setContentSize(cc.size(self.Panel_touch:getContentSize().width, offsetY))
	if self.isShow and self.isDirty then
		self:refreshCampMap()
		self.isDirty = false
	end
end
return worldMapAtlantisWarInfo
