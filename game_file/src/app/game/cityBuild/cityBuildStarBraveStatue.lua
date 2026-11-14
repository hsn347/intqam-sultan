local cityltCtrl = include("cityltCtrl")
local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildBaseEntity = include("cityBuildBaseEntity")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local cityBuildStarBraveStatue = class("cityBuildStarBraveStatue", function()
	return cityBuildBaseEntity.new()
end)
function cityBuildStarBraveStatue:ctor()
	print("create StarBraveStatue!!")
	self:setBuildIndex(cityBuildConstDef.buildIndexDef.index_StarBraveStatue)
	self.bid = BUILDID.STAR_BRAVE_STATUE
end
function cityBuildStarBraveStatue:onMessageListener()
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_STATUEBRAVE_QUEQUE_CALLBACK", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_BUILD_STAR_UPGRADE", handler(self, self.msgUpdateView))
end
function cityBuildStarBraveStatue:onAfterInitWithBuildCell()
	local queue = queueCtrl:queryQueue(gQueueTypeDef.glorious_upgrade)
	dump(queue, "onAfterInitWithBuildCell")
	if queue and tonumber(queue.data.bid) == self:getBuildBid() then
		queueCtrl = nil
		;(nil).queueType = gQueueTypeDef.glorious_upgrade
		self:updateStarLv(nil, nil)
	end
	if self.buildImg then
		self.buildImg:setLocalZOrder(-1)
	end
	self:updateView()
end
function cityBuildStarBraveStatue:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("Soldiers_armor_text_48"), i18n("Soldiers_armor_text_48")
	i18n("Soldiers_armor_text_48").x = 0
	;(nil).pos, i18n("Soldiers_armor_text_48").y = i18n("Soldiers_armor_text_48"), -120
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildStarBraveStatue:msgUpdateView(target, data)
	if data and data.index and data.index ~= self:getBuildIndex() then
		return
	end
	local buildCell = self:getBuildCell()
	if not buildCell then
		return
	end
	dump(data, "msgUpdateView")
	self:updateStarLv(target, data)
	self:updateView()
end
function cityBuildStarBraveStatue:updateView()
	local starLv = self:getBuildStarLv()
	local qualityInfo = cityltCtrl.getQualityByStarLv(starLv)
	if not next(qualityInfo) then
		return
	end
	self:showBuildLv()
	local state = tonumber(self:getBuildState())
	local starState = tonumber(self:getBuildStarState())
	if starState == BUILD_STAR_STATE.UPGRADEING and self:getState() == "idle" then
		self:showAnimWorking()
	elseif self:getState() ~= "working" then
		self:hideAnimWorking()
	end
	if self.buildImg then
		local qualityInfo = cityltCtrl.getQualityByStarLv(starLv)
		if qualityInfo and qualityInfo.quality then
			local imageName = cityltCtrl.getStatueBraveCityImage(qualityInfo.quality)
			self.buildImg:setSpriteFrame(imageName)
			self:updateEffect(qualityInfo)
		end
	end
end
function cityBuildStarBraveStatue:updateEffect(qualityInfo)
	local effect = cityltCtrl.getStatueBraveCityEffect(qualityInfo.quality)
	if effect then
		if not self.effectSp then
			self.effectSp = display.newSprite("#" .. string.format(effect.name, 1))
			self.effectSp:setScale(1.5)
			self.effectSp:setPosition(cc.p(81, 149))
			self.effectSp:addTo(self.buildImg)
		end
		local pos = effect.pos or cc.p(81, 149)
		self.effectSp:setPosition(pos)
		local scale = effect.scale or 1.5
		self.effectSp:setScale(scale)
		local framesNumber = effect.framesNumber or 20
		local frames = display.newFrames(effect.name, 1, framesNumber)
		self.effectSp:stopAllActions()
		local animation = display.newAnimation(frames, 1.0 / framesNumber)
		self.effectSp:playAnimationForever(animation)
		if not effect.isAdd then
			self.effectSp:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		else
			self.effectSp:setBlendFunc(gl.ONE, gl.ONE)
		end
		if effect.showDizuo then
			if not self.sprite_dz then
				local sprite_dz = display.newSpriteNoChild("#yongzhediaoxiang_dizuo.png")
				sprite_dz:setPosition(cc.p(-116, -74))
				sprite_dz:addTo(self, -2)
				self.sprite_dz = sprite_dz
			end
		elseif self.sprite_dz then
			self.sprite_dz:removeFromParent()
		end
	end
end
function cityBuildStarBraveStatue:updateTextLv(...)
	local buildLv = self:getBuildLv()
	if self:getBuildState() == BUILD_STATE.BUILDING and buildLv == 1 then
		self:setTextLv(0)
		return
	end
	local starLv = self:getBuildStarLv()
	local qualityInfo = cityltCtrl.getQualityByStarLv(starLv)
	if not next(qualityInfo) then
		return
	end
	self:setTextLv(qualityInfo.level)
end
function cityBuildStarBraveStatue:updateStarLvBgLight()
	local quality = SoraDGetBuildQuality()
	self.buildLvBg:setSpriteFrame(cityltCtrl.getStatueBraveBuildLvBg(quality))
	self:updateTextLv()
end
function cityBuildStarBraveStatue:refreshBuildStarState(data)
	if data and data.queueType == gQueueTypeDef.glorious_upgrade then
		_ENV = gQueueTypeDef.glorious_upgrade
		gQueueTypeDef.glorious_upgrade.msg = "MESSAGE_MAINCITYVIEW_UPDATE_STATUEBRAVE_COOLING_PANEL"
		gQueueTypeDef.glorious_upgrade.buildIndex = self.buildIndex
		gQueueTypeDef.glorious_upgrade.buildEntity = self
		SoraDSendMessage(gQueueTypeDef.glorious_upgrade)
	end
end
function cityBuildStarBraveStatue:updateStarLvPos(...)
	local starLv = self:getBuildStarLv()
	if 0 < starLv then
		local x, y = self.buildLvBg:getPosition()
		local scaleX = self.buildLvBg:getScaleX()
		local scaleY = self.buildLvBg:getScaleY()
		if self.textLv then
			self.textLv:setPosition(cc.p(x + 15 * scaleX, y))
		end
		if self.imgUpgrade then
			self.imgUpgrade:setPosition(cc.p(x + 50 * scaleX, y + 20 * scaleY))
		end
	end
end
return cityBuildStarBraveStatue
