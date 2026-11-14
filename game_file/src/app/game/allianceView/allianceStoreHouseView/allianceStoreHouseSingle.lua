local allianceTreasureltCtrl = include("allianceTreasureltCtrl")
local allianceStoreHouseSingle = class("allianceStoreHouseSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceStoreHouseSingle")
	end
	return target
end)
function allianceStoreHouseSingle:ctor()
	self.style = 1
	self.scroll = nil
	self.awardItem = nil
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Panel_touch:setTouchEnabled(false)
	self.Panel_color = SoraDGetChildByName(self, "Panel_color")
	self.Panel_color:setTouchEnabled(false)
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_helper = SoraDGetChildByName(self, "Text_helper")
	self.Text_helper:setVisible(false)
	self.Image_box = SoraDGetChildByName(self, "Image_box")
	self.Node_effect_box_b = SoraDGetChildByName(self, "Node_effect_box_b")
	self.Node_effect_box_t = SoraDGetChildByName(self, "Node_effect_box_t")
	self.Node_head = SoraDGetChildByName(self, "Node_head")
	self.ccs_head = SoraDGetExtendChildFromCCSByName(self.Node_head, "CCS_commonHead_head")
	self.ccs_head:setScale(1.0)
	self.Button_box = SoraDGetChildByName(self, "Button_box")
	SoraDAutoSizeButtonText(self.Button_box, cc.size(150, 60))
	self.Button_box:setSwallowTouches(false)
	self.Node_info = SoraDGetChildByName(self.Button_box, "Node_info")
	self.Node_info:setVisible(false)
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Node_awards = SoraDGetChildByName(self, "Node_awards")
	self.Button_box:addTouchEventListener(handler(self, self.onClickBtnBox))
	self.dh_lianmengbz_01 = SoraDGetChildByName(self, "dh_lianmengbz_01")
	self.dh_lianmengbz_02 = SoraDGetChildByName(self, "dh_lianmengbz_02")
	self.dh_lianmengbz_01:setVisible(false)
	self.dh_lianmengbz_02:setVisible(false)
	self.awardSpace, _ENV, self.effectSpace, _ENV = self.dh_lianmengbz_02.setVisible, self.dh_lianmengbz_02.setVisible, self.dh_lianmengbz_02.setVisible, self.dh_lianmengbz_02.setVisible
end
function allianceStoreHouseSingle:doShowAction()
	self.Panel_touch:setScaleY(0)
	local mutiple = 1
	_ENV = 0
	;(0)[1] = cca.scaleTo(20 * mutiple / 60, 1, 1)
	;(0)[2] = cca.scaleTo(20 * mutiple / 60, 1, 1)
	;(0)[3] = cca.scaleTo(20 * mutiple / 60, 1, 1)
	;(0)[4] = cca.scaleTo(20 * mutiple / 60, 1, 1)
	local seq = cca.seq(0)
	self.Panel_touch:runAction(seq)
end
function allianceStoreHouseSingle:doFilpAction()
	self.dh_lianmengbz_01:setVisible(true)
	self.dh_lianmengbz_02:setVisible(true)
	local mutiple = 1
	_UPVALUE2_ = true
	_UPVALUE1_ = nil
	;(nil)[1] = cca.scaleTo(11 * mutiple / 60, 3, 1.685)
	;(nil)[2] = cca.fadeTo(11 * mutiple / 60, 47)
	;(nil)[3] = cca.fadeTo(11 * mutiple / 60, 47)
	;(nil)[4] = cca.fadeTo(11 * mutiple / 60, 47)
	;(nil)[5] = cca.fadeTo(11 * mutiple / 60, 47)
	;(nil)[6] = cca.fadeTo(11 * mutiple / 60, 47)
	_UPVALUE1_ = cca.scaleTo(11 * mutiple / 60, 3, 1.685)
	cca.scaleTo(11 * mutiple / 60, 3, 1.685)[1] = cca.scaleTo(8 * mutiple / 60, 1.5, 0.3135)
	cca.scaleTo(11 * mutiple / 60, 3, 1.685)[2] = cca.fadeTo(8 * mutiple / 60, 0)
	cca.scaleTo(11 * mutiple / 60, 3, 1.685)[3] = cca.fadeTo(8 * mutiple / 60, 0)
	cca.scaleTo(11 * mutiple / 60, 3, 1.685)[4] = cca.fadeTo(8 * mutiple / 60, 0)
	cca.scaleTo(11 * mutiple / 60, 3, 1.685)[5] = cca.fadeTo(8 * mutiple / 60, 0)
	;(true)[1] = cca.delay(8 * mutiple / 60)
	;(true)[2] = cca.spawn(nil)
	;(true)[3] = cca.spawn((cca.scaleTo(11 * mutiple / 60, 3, 1.685)))
	;(true)[4] = cca.spawn((cca.scaleTo(11 * mutiple / 60, 3, 1.685)))
	;(true)[5] = cca.spawn((cca.scaleTo(11 * mutiple / 60, 3, 1.685)))
	;(true)[6] = cca.spawn((cca.scaleTo(11 * mutiple / 60, 3, 1.685)))
	;(true)[7] = cca.spawn((cca.scaleTo(11 * mutiple / 60, 3, 1.685)))
	;(true)[8] = cca.spawn((cca.scaleTo(11 * mutiple / 60, 3, 1.685)))
	;(true)[9] = cca.spawn((cca.scaleTo(11 * mutiple / 60, 3, 1.685)))
	local seq1 = cca.seq(true)
	self.dh_lianmengbz_01:runAction(seq1)
	_UPVALUE2_ = self.dh_lianmengbz_01
	_UPVALUE1_ = cca.spawn((cca.scaleTo(11 * mutiple / 60, 3, 1.685)))
	cca.spawn((cca.scaleTo(11 * mutiple / 60, 3, 1.685)))[1] = cca.scaleTo(10 * mutiple / 60, 8.5678, 0.4943)
	cca.spawn((cca.scaleTo(11 * mutiple / 60, 3, 1.685)))[2] = cca.fadeTo(10 * mutiple / 60, 100)
	cca.spawn((cca.scaleTo(11 * mutiple / 60, 3, 1.685)))[3] = cca.fadeTo(10 * mutiple / 60, 100)
	cca.spawn((cca.scaleTo(11 * mutiple / 60, 3, 1.685)))[4] = cca.fadeTo(10 * mutiple / 60, 100)
	cca.spawn((cca.scaleTo(11 * mutiple / 60, 3, 1.685)))[5] = cca.fadeTo(10 * mutiple / 60, 100)
	_UPVALUE1_ = cca.scaleTo(10 * mutiple / 60, 8.5678, 0.4943)
	cca.scaleTo(10 * mutiple / 60, 8.5678, 0.4943)[1] = cca.scaleTo(12 * mutiple / 60, 5, 0.2676)
	cca.scaleTo(10 * mutiple / 60, 8.5678, 0.4943)[2] = cca.fadeTo(12 * mutiple / 60, 0)
	cca.scaleTo(10 * mutiple / 60, 8.5678, 0.4943)[3] = cca.fadeTo(12 * mutiple / 60, 0)
	cca.scaleTo(10 * mutiple / 60, 8.5678, 0.4943)[4] = cca.fadeTo(12 * mutiple / 60, 0)
	self.dh_lianmengbz_01[1] = cca.delay(8 * mutiple / 60)
	self.dh_lianmengbz_01[2] = cca.spawn(cca.spawn((cca.scaleTo(11 * mutiple / 60, 3, 1.685))))
	self.dh_lianmengbz_01[3] = cca.spawn((cca.scaleTo(10 * mutiple / 60, 8.5678, 0.4943)))
	self.dh_lianmengbz_01[4] = cca.spawn((cca.scaleTo(10 * mutiple / 60, 8.5678, 0.4943)))
	self.dh_lianmengbz_01[5] = cca.spawn((cca.scaleTo(10 * mutiple / 60, 8.5678, 0.4943)))
	self.dh_lianmengbz_01[6] = cca.spawn((cca.scaleTo(10 * mutiple / 60, 8.5678, 0.4943)))
	self.dh_lianmengbz_01[7] = cca.spawn((cca.scaleTo(10 * mutiple / 60, 8.5678, 0.4943)))
	self.dh_lianmengbz_01[8] = cca.spawn((cca.scaleTo(10 * mutiple / 60, 8.5678, 0.4943)))
	local seq2 = cca.seq(self.dh_lianmengbz_01)
	self.dh_lianmengbz_02:runAction(seq2)
	_UPVALUE1_ = self.dh_lianmengbz_02
	self.dh_lianmengbz_02[1] = cca.scaleTo(20 * mutiple / 60, 1, 0)
	self.dh_lianmengbz_02[2] = cca.delay(30 * mutiple / 60)
	self.dh_lianmengbz_02[3] = cca.delay(30 * mutiple / 60)
	self.dh_lianmengbz_02[4] = cca.delay(30 * mutiple / 60)
	self.dh_lianmengbz_02[5] = cca.delay(30 * mutiple / 60)
	self.dh_lianmengbz_02[6] = cca.delay(30 * mutiple / 60)
	self.dh_lianmengbz_02[7] = cca.delay(30 * mutiple / 60)
	local seq = cca.seq(self.dh_lianmengbz_02)
	self.Panel_touch:runAction(seq)
end
function allianceStoreHouseSingle:setBtnHandle(handle)
	self.handle = handle
end
function allianceStoreHouseSingle:setScroll(scroll)
	self.scroll = scroll
end
function allianceStoreHouseSingle:setStyle()
	if self.style == 1 or self.style == 2 then
		self.Image_box:setVisible(true)
		self.Node_head:setVisible(false)
	elseif self.style == 3 then
		self.Image_box:setVisible(false)
		self.Node_head:setVisible(true)
	end
end
function allianceStoreHouseSingle:setHeadInfo(ownUid, avatar, headID, name)
	self.ccs_head:setPlayerID(ownUid)
	self.ccs_head:setHeadSprite(headID, avatar)
	local Text_memberName = SoraDGetChildByName(self.Node_head, "Text_memberName")
	Text_memberName:setString(name)
end
function allianceStoreHouseSingle:setBtnBoxInfo(btnStyle, text, gold, isReward, timeData)
	local Node_gold = SoraDGetChildByName(self.Node_info, "Node_gold")
	local Text_gold = SoraDGetChildByName(self.Node_info, "Text_gold")
	local Text_open = SoraDGetChildByName(self.Node_info, "Text_open")
	if isReward then
		self.Button_box:loadTextureNormal("btn_green_small_01.png", ccui.TextureResType.plistType)
	else
		self.Button_box:loadTextureNormal("btn_yellow_small_01.png", ccui.TextureResType.plistType)
	end
	if btnStyle == 1 then
		self.Node_info:setVisible(false)
		self.Button_box:setVisible(true)
		self.Button_box:setTitleText(text)
		self.Button_box:setBright(true)
		self.Button_box:setTouchEnabled(true)
	elseif btnStyle == 2 then
		self.Node_info:setVisible(true)
		self.Button_box:setTitleText("")
		self.Button_box:setVisible(true)
		self.Button_box:setBright(true)
		self.Button_box:setTouchEnabled(true)
		Text_gold:setString(gold)
		SoraDToCenter(Node_gold)
		Text_open:setString(text)
		if timeData and next(timeData) then
			local curTime = timeData.curTime
			local totalTime = timeData.totalTime
			local realGold = math.floor(gold * curTime / totalTime)
			if realGold <= 0 then
				realGold = 1
			end
			Text_gold:setString(realGold)
			SoraDToCenter(Node_gold)
			if not self.goldTimer then
				self.goldTimer = SoradCreateTimer(self, function(dt)
					if curTime <= 0 then
						SoraDManagerRemoveTimer(self, self.goldTimer)
						self.goldTimer = nil
						Text_gold:setString(0)
					else
						local realGold = math.floor(gold * curTime / totalTime)
						if realGold <= 0 then
							realGold = 1
						end
						Text_gold:setString(realGold)
						SoraDToCenter(Node_gold)
					end
				end)
			end
		end
	elseif btnStyle == 3 then
		self.Node_info:setVisible(false)
		self.Button_box:setTitleText(text)
		self.Button_box:setVisible(true)
		self.Button_box:setBright(false)
		self.Button_box:setTouchEnabled(false)
	elseif btnStyle == 4 then
		self.Button_box:setVisible(false)
	end
end
function allianceStoreHouseSingle:refreshData()
	local data = self.data.data
	self.Text_helper:setVisible(false)
	local name = allianceTreasureltCtrl.getTreasureName(data.teasureID, data.quality)
	self.Text_name:setString(name)
	self.Text_name:setColor(gQualityTextColorDef[data.quality])
	self.Image_box:loadTexture(allianceTreasureltCtrl.getTreasureBox(data.teasureID, data.quality), ccui.TextureResType.plistType)
	if self.style == 3 then
		for k, v in pairs(self.effectSpace) do
			for ki, vi in pairs(v) do
				if vi then
					SoraDStopEffectNode(vi)
					vi:setVisible(false)
				end
			end
		end
	else
		for k, v in pairs(self.effectSpace) do
			if k ~= data.quality then
				for ki, vi in pairs(v) do
					if vi then
						SoraDStopEffectNode(vi)
						vi:setVisible(false)
					end
				end
			end
		end
		if self.effectSpace[data.quality] then
			for k, v in pairs(self.effectSpace[data.quality]) do
				if v then
					SoraDResetEffectNode(v)
					v:setVisible(true)
				end
			end
		else
			self.effectSpace[data.quality], allianceTreasureltCtrl = pairs(self.effectSpace[data.quality])
			local top, bottom = self:getBoxEffect(data.quality)
			top:addTo(self.Node_effect_box_t)
			bottom:addTo(self.Node_effect_box_b)
			table.insert(self.effectSpace[data.quality], top)
			table.insert(self.effectSpace[data.quality], bottom)
		end
	end
	self:initAwards(data.award)
end
function allianceStoreHouseSingle:setTipText(time)
	_ENV = nil
	;(nil).num = math.ceil(time / 3600)
	self.Text_tip:setString(i18n("allitreas_text_20", nil))
	self.Text_tip:setColor(cc.c3b(215, 195, 155))
end
function allianceStoreHouseSingle:getBoxEffect(quality)
	_ENV = nil
	_ENV, _ENV, _ENV = nil, nil, nil
	;(nil).plist = "et_whitebx_01.plist"
	;(nil)[gQualityDef.WHITE], (nil).bottom, _ENV, (nil).top, (nil)[1], (nil).pos = nil, nil, nil, nil, nil, cc.p(-11, 7)
	_ENV, _ENV, _ENV = nil, nil, nil
	;(nil).plist = "et_greenbx_03.plist"
	;(nil).pos = cc.p(-8, 0)
	;(nil).rotate = 1.92
	_ENV, _ENV, (nil).top, (nil)[1], (nil).scale = nil, nil, nil, nil, 1.2
	;(nil).plist = "et_greenbx_01.plist"
	;(nil).pos = cc.p(-8, -2)
	_ENV, (nil)[1], (nil).scale = nil, nil, 2.354
	;(nil).plist = "et_greenbx_02.plist"
	;(nil).pos = cc.p(-13, 6)
	;(nil).rotate = 104.91
	;(nil)[gQualityDef.GREEN], (nil).bottom, (nil)[2], (nil).scale = nil, nil, nil, 2.05
	_ENV, _ENV, _ENV = nil, nil, nil
	;(nil).plist = "et_bluebx_01.plist"
	_ENV, (nil).pos = cc.p(-1, -2), cc.p(-1, -2)
	cc.p(-1, -2).x = 2.745
	_ENV, (nil)[1], (nil).scale, cc.p(-1, -2).y = nil, nil, cc.p(-1, -2), 2.7
	;(nil).plist = "et_bluebx_02.plist"
	;(nil).pos = cc.p(1, -7)
	_ENV, _ENV, (nil).bottom, (nil)[2], (nil).scale = nil, nil, nil, nil, 2.554
	;(nil).plist = "et_bluebx_03.plist"
	;(nil).pos = cc.p(-8, 8)
	;(nil).rotate = -179.81
	_ENV, (nil)[1], (nil).scale = nil, nil, 1.2
	;(nil).plist = "et_bluebx_04.plist"
	;(nil).pos = cc.p(-7, 10)
	;(nil)[gQualityDef.BLUE], (nil).top, (nil)[2], (nil).scale = nil, nil, nil, 1.2
	_ENV, _ENV, _ENV = nil, nil, nil
	;(nil).plist = "et_purpsebx_01.plist"
	;(nil).pos = cc.p(0, 4)
	_ENV, (nil)[1], (nil).scale = nil, nil, 2.154
	;(nil).plist = "et_purpsebx_02.plist"
	;(nil).pos = cc.p(0, -4)
	_ENV, _ENV, (nil).bottom, (nil)[2], (nil).scale = nil, nil, nil, nil, 3.09
	;(nil).plist = "et_purpsebx_03.plist"
	_ENV, (nil).pos = cc.p(-3, 3), cc.p(-3, 3)
	cc.p(-3, 3).x = 1.214
	_ENV, (nil)[1], (nil).scale, cc.p(-3, 3).y = nil, nil, cc.p(-3, 3), 1.266
	;(nil).plist = "et_purpsebx_04.plist"
	;(nil).pos = cc.p(-11, 2)
	;(nil)[gQualityDef.PURPLE], (nil).top, (nil)[2], (nil).scale = nil, nil, nil, 1.105
	_ENV, _ENV, _ENV = nil, nil, nil
	;(nil).plist = "et_orangebx_01.plist"
	;(nil).pos = cc.p(0, 2)
	_ENV, (nil)[1], (nil).scale = nil, nil, 2.3
	;(nil).plist = "et_orangebx_02.plist"
	_ENV, (nil).pos = cc.p(-10, 5), cc.p(-10, 5)
	cc.p(-10, 5).x = 1.91
	_ENV, (nil)[2], (nil).scale, cc.p(-10, 5).y = nil, nil, cc.p(-10, 5), 1.95
	;(nil).plist = "et_orangebx_03.plist"
	;(nil).pos = cc.p(-6, 2)
	_ENV, _ENV, (nil).bottom, (nil)[3], (nil).scale = nil, nil, nil, nil, 1.26
	;(nil).plist = "et_orangebx_04.plist"
	_ENV, (nil).pos = cc.p(-28, -1), cc.p(-28, -1)
	cc.p(-28, -1).x = 0.91
	;(nil).scale, cc.p(-28, -1).y = cc.p(-28, -1), 0.94
	_ENV, (nil)[1], (nil).rotate = nil, nil, 68.38
	;(nil).plist = "et_orangebx_05.plist"
	_ENV, (nil)[2], (nil).pos = nil, nil, cc.p(-3, 11)
	;(nil).plist = "et_orangebx_06.plist"
	_ENV, (nil).pos = cc.p(-26, -6), cc.p(-26, -6)
	cc.p(-26, -6).x = -0.613
	;(nil).scale, cc.p(-26, -6).y = cc.p(-26, -6), 0.869
	;(nil)[gQualityDef.ORANGE], (nil).top, (nil)[3], (nil).rotate = nil, nil, nil, 19.03
	_ENV, _ENV, _ENV = nil, nil, nil
	;(nil).plist = "et_yellowbx_01.plist"
	;(nil).pos = cc.p(-2, -11)
	_ENV, (nil)[1], (nil).scale = nil, nil, 2.6965
	;(nil).plist = "et_orangebx_02.plist"
	;(nil).pos = cc.p(-4, 0)
	_ENV, _ENV, (nil).bottom, (nil)[2], (nil).scale = nil, nil, nil, nil, 2.25
	;(nil).plist = "et_yellowbx_02.plist"
	_ENV, (nil).pos = cc.p(-31, 3), cc.p(-31, 3)
	cc.p(-31, 3).x = 2.48
	;(nil).scale, cc.p(-31, 3).y = cc.p(-31, 3), 0.706
	_ENV, (nil)[1], (nil).rotate = nil, nil, 27.11
	;(nil).plist = "et_jlbox_05.plist"
	;(nil).pos = cc.p(-26, 3)
	_ENV, (nil)[2], (nil).scale = nil, nil, 0.66
	;(nil).plist = "et_yellowbx_04.plist"
	;(nil)[gQualityDef.GOLD], (nil).top, (nil)[3], (nil).pos = nil, nil, nil, cc.p(1, -5)
	local effectConfig
	local topNode, bottomNode
	if effectConfig[quality] then
		if next(effectConfig[quality].top) then
			topNode = SoraDCreateEffectNode(effectConfig[quality].top)
		end
		if next(effectConfig[quality].bottom) then
			bottomNode = SoraDCreateEffectNode(effectConfig[quality].bottom)
		end
	end
	return topNode, bottomNode
end
function allianceStoreHouseSingle:setHelpTipStatus(status, time)
	if status == gTreasureHelpStatus.REWARD then
		self.Text_tip:setString(i18n("allitreas_text_16"))
		self.Text_tip:setColor(cc.c3b(215, 195, 155))
	elseif status == gTreasureHelpStatus.HELPED then
		_ENV = cc.c3b(215, 195, 155)
		cc.c3b(215, 195, 155).time = SoraDConvertSecondToString(time)
		self.Text_tip:setString(i18n("allitreas_text_15", cc.c3b(215, 195, 155)))
		self.Text_tip:setColor(cc.c3b(190, 40, 40))
		if not self.timer then
			self.timer = SoradCreateTimer(self, function(dt)
				if time <= 0 then
					SoraDManagerRemoveTimer(self, self.timer)
					self.timer = nil
					self.Text_tip:setString(i18n("allitreas_text_16"))
					self.Text_tip:setColor(cc.c3b(215, 195, 155))
				else
					time = cc.c3b(215, 195, 155)
					cc.c3b(215, 195, 155).time = SoraDConvertSecondToString(time)
					self.Text_tip:setString(i18n("allitreas_text_15", cc.c3b(215, 195, 155)))
				end
			end)
		end
	else
		_ENV = cc.c3b(190, 40, 40)
		cc.c3b(190, 40, 40).num = math.ceil(time / 3600)
		self.Text_tip:setString(i18n("allitreas_text_20", cc.c3b(190, 40, 40)))
		self.Text_tip:setColor(cc.c3b(215, 195, 155))
	end
end
function allianceStoreHouseSingle:setTipStatus(status, time, assistNickName)
	if status == gTreasureDigStatus.REWARD then
		self.Text_tip:setString(i18n("allitreas_text_16"))
		self.Text_tip:setColor(cc.c3b(215, 195, 155))
		self.Text_helper:setVisible(false)
	elseif status == gTreasureDigStatus.BE_HELPED then
		self.Text_helper:setVisible(true)
		_ENV = cc.c3b(215, 195, 155)
		cc.c3b(215, 195, 155).name = assistNickName
		self.Text_helper:setString(i18n("allitreas_columntext_01", cc.c3b(215, 195, 155)))
		self.Text_tip:setColor(cc.c3b(215, 195, 155))
		_ENV = cc.c3b(215, 195, 155)
		cc.c3b(215, 195, 155).time = SoraDConvertSecondToString(time)
		self.Text_tip:setString(i18n("allitreas_text_15", cc.c3b(215, 195, 155)))
		if not self.timer then
			self.timer = SoradCreateTimer(self, function(dt)
				if time <= 0 then
					SoraDManagerRemoveTimer(self, self.timer)
					self.timer = nil
					self.Text_tip:setString(i18n("allitreas_text_16"))
				else
					time = i18n("allitreas_text_16")
					i18n("allitreas_text_16").time = SoraDConvertSecondToString(time)
					self.Text_tip:setString(i18n("allitreas_text_15", i18n("allitreas_text_16")))
				end
			end)
		end
	else
		self.Text_helper:setVisible(false)
		self.Text_tip:setColor(cc.c3b(190, 40, 40))
		_ENV = cc.c3b(190, 40, 40)
		cc.c3b(190, 40, 40).time = SoraDConvertSecondToString(time)
		self.Text_tip:setString(i18n("allitreas_text_14", cc.c3b(190, 40, 40)))
		if not self.timer then
			self.timer = SoradCreateTimer(self, function(dt)
				if time <= 0 then
					SoraDManagerRemoveTimer(self, self.timer)
					self.timer = nil
					self.Text_tip:setVisible(false)
				else
					time = nil
					;(nil).time = SoraDConvertSecondToString(time)
					self.Text_tip:setString(i18n("allitreas_text_14", nil))
				end
			end)
		end
	end
end
function allianceStoreHouseSingle:initAwards(award)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local awardArray = serviceFunctions.tableFormat(award, nil)
	for i = 1, 5 do
		if awardArray[i] then
			if self.awardSpace[i] then
				self.awardSpace[i]:setVisible(true)
				self.awardSpace[i]:initData(awardArray[i].id, awardArray[i].count)
			else
				self.awardSpace[i] = include("commonItemAward").new()
				self.awardSpace[i]:setScale(0.8)
				self.awardSpace[i]:setBaseScale(1.0)
				self.awardSpace[i]:setOwnView(self.view)
				self.awardSpace[i]:setOwnScroll(self.scroll)
				self.awardSpace[i]:initData(awardArray[i].id, awardArray[i].count)
				self.awardSpace[i]:setPosition(0, 0)
				self.awardSpace[i]:addTo(self.Node_awards)
			end
		elseif self.awardSpace[i] then
			self.awardSpace[i]:setVisible(false)
		end
	end
	SoraDautoSortPos(self.Node_awards, 5, SoraDFIsRA() and 2 or 0, cc.size(90, 90))
end
function allianceStoreHouseSingle:onClickBtnBox(button, event)
	if event == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		if self.handle then
			self.handle(self.data)
		end
	end
end
function allianceStoreHouseSingle:clearTimer()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	if self.goldTimer then
		SoraDManagerRemoveTimer(self, self.goldTimer)
		self.goldTimer = nil
	end
end
function allianceStoreHouseSingle:initData(data, otherData)
	self.style = data.style or self.style
	self.data = data.data
	self.view = otherData.view
	self:clearTimer()
	self:setScroll(otherData.scroll)
	self:setStyle()
	self:refreshData()
	if self.style == 1 then
		self:setTipText(self.data.tipText)
	elseif self.style == 2 then
		self:setTipStatus(self.data.status, self.data.time, self.data.assistNickName)
	elseif self.style == 3 then
		self:setHeadInfo(self.data.ownUid, self.data.avatar, self.data.headID, self.data.name)
		self:setHelpTipStatus(self.data.status, self.data.time)
	end
	self:setBtnBoxInfo(self.data.btnStyle, self.data.text, self.data.gold, self.data.isReward, self.data.timeData)
	if self.data.handle then
		self:setBtnHandle(self.data.handle)
	end
end
return allianceStoreHouseSingle
