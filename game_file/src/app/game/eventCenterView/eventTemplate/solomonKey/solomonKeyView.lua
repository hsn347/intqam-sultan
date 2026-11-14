local solomonKeyRead = include("solomonKeyRead")
local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local solomonKeyCtrl = gametop.playertop_:getModule("solomonKeyCtrl")
local publicRead = include("publicRead")
_ENV, _ENV = nil, "publicRead"
;(nil).x = -137
_ENV, ("publicRead")[1], (nil).y = nil, nil, 137
;(nil).x = 0
_ENV, ("publicRead")[2], (nil).y = nil, nil, 137
;(nil).x = 137
_ENV, ("publicRead")[3], (nil).y = nil, nil, 137
;(nil).x = 137
_ENV, ("publicRead")[4], (nil).y = nil, nil, 0
;(nil).x = 137
_ENV, ("publicRead")[5], (nil).y = nil, nil, -137
;(nil).x = 0
_ENV, ("publicRead")[6], (nil).y = nil, nil, -137
;(nil).x = -137
_ENV, ("publicRead")[7], (nil).y = nil, nil, -137
;(nil).x = -137
;("publicRead")[8], (nil).y = nil, 0
local tablePos = "publicRead"
local solomonKeyView = class("solomonKeyView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("solomonKeyView")
	end
	return target
end)
function solomonKeyView:ctor()
	self.node_bigBox = SoraDGetChildByName(self, "Node_BigBox")
	self.node_center = SoraDGetChildByName(self, "Center_Node")
	self.node_specialCenter = SoraDGetChildByName(self, "Node_specialCenter")
	self.node_singleBox = SoraDGetChildByName(self, "Node_singleBox")
	self.node_singleList = SoraDGetChildByName(self, "Node_singleList")
	self.node_whyPrt = SoraDGetChildByName(self, "Node_whyPrt")
	self.node_num = SoraDGetChildByName(self, "Node_5")
	self.img_item = SoraDGetChildByName(self, "Image_item")
	self.img_key = SoraDGetChildByName(self, "icon_key")
	self.img_why = SoraDGetChildByName(self, "Image_2")
	self.text_alter = SoraDGetChildByName(self, "Text_alter")
	self.text_open = SoraDGetChildByName(self, "text_open")
	self.text_haveKey = SoraDGetChildByName(self, "Text_haveKey")
	self.text_needKey = SoraDGetChildByName(self, "text_needKey")
	self.text_record = SoraDGetChildByName(self, "Text_record")
	self.btn_record = SoraDGetChildByName(self, "btn_record")
	self.btn_operate = SoraDGetChildByName(self, "btn_operate")
	self.dh_BigBox_01 = SoraDGetChildByName(self, "dh_suoluomen_04_4")
	self.dh_BigBox_02 = SoraDGetChildByName(self, "dh_suoluomen_03_5")
	self.dh_why = SoraDGetChildByName(self.node_whyPrt, "dh_xunzhangcx_05_1")
	self.dh_why_02 = SoraDGetChildByName(self.node_whyPrt, "dh_xunzhangcx_02_5")
	self.particle_why = SoraDGetChildByName(self.node_whyPrt, "Particle_3")
	self.particle_why_02 = SoraDGetChildByName(self.node_whyPrt, "Particle_18")
	self.sprite_right = SoraDGetChildByName(self, "Sprite_right")
	self.sprite_left = SoraDGetChildByName(self, "Sprite_left")
	self.sprite_top = SoraDGetChildByName(self, "Sprite_top")
	self.Sprite_icon = SoraDGetChildByName(self, "Sprite_icon")
	self.text_open:setString(i18n("solomon_btn_01"))
	self.text_alter:setString(i18n("solomon_text_03"))
	self.text_record:setString(i18n("solomon_title_01"))
	self.btn_operate:addTouchEventListener(handler(self, self.onClickOpen))
	self.btn_record:addTouchEventListener(handler(self, self.onClickRecord))
	self.node_whyPrt:setVisible(false)
	self.awardEntityList, _ENV, self.enableTouchCloseSelf = self.node_whyPrt.setVisible, self.node_whyPrt.setVisible, false
	self.haveData = 0
	self.finalIndex = 0
	self.beforeIdx = 1
	self.keyNum = nil
	self:fitDevice()
	self:initCommonDh()
end
function solomonKeyView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_SOLOMON_AWARD_DATA", handler(self, self.getRewardDataCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_SOLOMON_AWARD_LIST", function(target, data)
		SoraDCloseLoading(self)
		self.reqRecord = false
		local panel = SoraDCreatePanel("solomonAwardRecord")
		panel:initView(data.list, data.keyID)
		panel:show()
	end)
end
function solomonKeyView:fitDevice()
	local dis = display.height - 960
	if dis < 0 then
		self.btn_record:setPositionY(self.btn_operate:getPositionY() + 20)
	end
end
function solomonKeyView:initCommonDh()
	self.node_bigBox:setScale(0.2)
	self.node_bigBox:runAction(cc.EaseBackOut:create(cca.scaleTo(0.4, 1)))
	self.dh_BigBox_01:runAction(cca.repeatForever(cca.repeatForever(cca.rotateBy(7.2, 360))))
	_UPVALUE7_ = self.dh_BigBox_01
	self.dh_BigBox_01[1] = cca.fadeTo(0.68, 0.79)
	self.dh_BigBox_01[2] = cca.fadeTo(0.92, 0.68)
	self.dh_BigBox_01[3] = cca.fadeTo(0.82, 0.91)
	self.dh_BigBox_01[4] = cca.fadeTo(0.68, 0.48)
	self.dh_BigBox_01[5] = cca.fadeTo(0.92, 0.69)
	self.dh_BigBox_01[6] = cca.fadeTo(1.52, 0.48)
	self.dh_BigBox_01[7] = cca.fadeTo(0.88, 0.64)
	self.dh_BigBox_01[8] = cca.fadeTo(0.88, 0.44)
	self.dh_BigBox_01[9] = cca.fadeTo(0.88, 0.44)
	self.dh_BigBox_01[10] = cca.fadeTo(0.88, 0.44)
	local seq = cca.seq(self.dh_BigBox_01)
	self.dh_BigBox_02:runAction(cca.repeatForever(seq))
	local frames = display.newFrames("dh_jinzitanew2_%.2d.png", 1, 9)
	local animation = display.newAnimation(frames, 0.8 / #frames)
	self.sprite_right:playAnimationForever(animation)
	self.sprite_left:playAnimationForever(animation)
	self.sprite_top:playAnimationForever(animation)
end
function solomonKeyView:initData(keyID)
	self.keyID = keyID
	local isAbas = self.keyID == solomonKeyRead.silverKey or self.keyID == solomonKeyRead.goldKey
	self.text_alter:setString(isAbas and i18n("solomon_text_03") or i18n("solomon_text_10"))
	self.awardList = solomonKeyRead.getRewardsByKeyID(keyID)
	if not self.keyNum then
		solomonKeyRead, solomonKeyRead = isAbas and i18n("solomon_text_03") or i18n("solomon_text_10"), keyID
		;(isAbas and i18n("solomon_text_03") or i18n("solomon_text_10")).x = 0
		keyID.pos, (isAbas and i18n("solomon_text_03") or i18n("solomon_text_10")).y = isAbas and i18n("solomon_text_03") or i18n("solomon_text_10"), 0
		keyID.fontSize = 20
		self.keyNum = SoraDCreateHtmlRichText(keyID)
		self.keyNum:addTo(self.node_num, 5)
	end
	self.keyNum:setVisible(true)
	self.Sprite_icon:setVisible(false)
	self:refleshView()
	self:initBoxes()
end
function solomonKeyView:refleshView()
	local curCount = backpackCtrl:getItemCount(self.awardList[1].USERKEYID)
	local curNumColor = curCount < 1 and "#FF0000" or "#FFFFFF"
	local img = "#" .. publicRead.getIcon(self.keyID)
	local str = ""
	if not SoraDFIsRA() then
		backpackCtrl = nil
		;(nil).param = img
		;(nil).name = ""
		;(nil).width = 26
		;(nil).height = 26
		;(nil).custom = "Sprite"
		;(nil).offsety = 4
		;(nil).scale = 0.2
		str = SoraDWrapReplaceTag(nil)
		backpackCtrl = nil
		;(nil).member = curCount
		backpackCtrl, backpackCtrl, (nil).total = nil, nil, 1
		backpackCtrl, (nil).member, (nil).color = nil, nil, curNumColor
		;(nil).__default, (nil).color = nil, "#FFFFFF"
		str = str .. i18n_html("common_text_155", nil, nil)
	else
		backpackCtrl = "common_text_155"
		;("common_text_155").member = curCount
		backpackCtrl, backpackCtrl, ("common_text_155").total = nil, nil, 1
		backpackCtrl, (nil).member, (nil).color = nil, nil, curNumColor
		;(nil).__default, (nil).color = nil, "#FFFFFF"
		str = i18n_html("common_text_155", "common_text_155", nil)
		backpackCtrl = "common_text_155"
		;("common_text_155").param = img
		;("common_text_155").name = ""
		;("common_text_155").width = 26
		;("common_text_155").height = 26
		;("common_text_155").custom = "Sprite"
		;("common_text_155").offsety = 4
		;("common_text_155").scale = 0.2
		str = str .. SoraDWrapReplaceTag("common_text_155")
	end
	self.keyNum:setString(str)
end
function solomonKeyView:initBoxes()
	local boxCenter = self.node_singleList:getPosition()
	for i = 1, #self.awardList do
		local box = self:createSingle()
		box:setPosition(tablePos[i].x, tablePos[i].y)
		box:setVisible(true)
		box:addTo(self.node_singleList)
		box:setTag(self.awardList[i].ITEMID[1].count)
		box:setName(tostring(self.awardList[i].ITEMID[1].id))
		self:initSingleData(box, self.awardList[i].ITEMID[1], self.awardList[i].Type)
		table.insert(self.awardEntityList, box)
	end
end
function solomonKeyView:openItemInfo(target, itemID)
	if self.itemTips == nil then
		self.itemTips = SoraDCreatePanel("commonItemTips")
		self.itemTips:setPositionY(50)
		self.itemTips:addTo(self)
		self.itemTips:setLocalZOrder(10)
		self.itemTips:setVisible(false)
	end
	local worldPos = target:convertToWorldSpace(cc.p(0, 0))
	local nodePos = self:convertToNodeSpace(worldPos)
	local deltaTipX = 0
	if SoraDFIsRA() then
		deltaTipX = 0
	else
		deltaTipX = -280
	end
	if nodePos.x > 300 then
		self.itemTips:setPositionX(nodePos.x + 15 + deltaTipX)
	else
		self.itemTips:setPositionX(nodePos.x + 325 + deltaTipX)
	end
	self.itemTips:setPositionY(nodePos.y + 200)
	self.itemTips:setVisible(true)
	self.itemTips:initData(itemID)
end
function solomonKeyView:closeItemInfo()
	if self.itemTips then
		self.itemTips:setVisible(false)
	end
end
function solomonKeyView:createSingle()
	local single = self.node_singleBox:clone()
	single.quality = SoraDGetChildByName(single, "item_color")
	single.icon = SoraDGetChildByName(single, "item_icon")
	single.textNum = SoraDGetChildByName(single, "text_num")
	single.particle_01 = SoraDGetChildByName(single, "node_particle")
	single.particle_02 = SoraDGetChildByName(single, "Particle_shine")
	single.dh_01 = SoraDGetChildByName(single, "dh_gongmingbx_01_6")
	single.btn = SoraDGetChildByName(single, "Image_23")
	single.btn:setTouchEnabled(true)
	single.btn:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			self:closeItemInfo()
		elseif event == ccui.TouchEventType.began then
			local itemId = tonumber(target:getParent():getName())
			self:openItemInfo(target, itemId)
		elseif event == ccui.TouchEventType.canceled then
			self:closeItemInfo()
		end
	end)
	local imgSelect = display.newSprite()
	imgSelect:setSpriteFrame("dh_gongmingbx_02.png")
	SoraDMixtureGLONE(imgSelect)
	imgSelect:addTo(single, 3)
	imgSelect:setVisible(false)
	imgSelect:setScale(1.3)
	single.imgSelect = imgSelect
	return single
end
function solomonKeyView:initSingleData(_single, data, itemType)
	local itemSingle = _single
	itemSingle.quality:loadTexture(publicRead.getBg(data.id), ccui.TextureResType.plistType)
	itemSingle.icon:loadTexture(publicRead.getIcon(data.id), ccui.TextureResType.plistType)
	itemSingle.textNum:setString(string.formatnumberthousands(data.count))
	local boolSpec = itemType == 2
	itemSingle.dh_01:setVisible(boolSpec)
	itemSingle.particle_01:setVisible(boolSpec)
	itemSingle.particle_02:setVisible(boolSpec)
	if boolSpec then
		itemSingle.dh_01:setVisible(false)
		SoraDGetChildByName(itemSingle, "Particle_1"):setVisible(false)
		local sprite = display.newSprite("#dh_slmdj_00.png")
		sprite:addTo(itemSingle.particle_01)
		sprite:setPosition(cc.p(0, 0))
		sprite:setScale(1.1287)
		SoraDMixtureGLONE(sprite)
		local frames = display.newFrames("dh_slmdj_%02d.png", 0, 13)
		local animation = display.newAnimation(frames, 0.11666666666666667)
		sprite:playAnimationForever(animation)
	end
end
function solomonKeyView:createSingleAnimation(single)
	SoraDPlaySound("pyramid", 6)
	self.img_why:setVisible(false)
	self.img_item:loadTexture(publicRead.getIcon(single:getName()), ccui.TextureResType.plistType)
	self.img_item:setScale(0)
	_UPVALUE4_ = ccui.TextureResType.plistType
	ccui.TextureResType.plistType[1] = cca.scaleTo(0.1, 0.8)
	ccui.TextureResType.plistType[2] = cca.scaleTo(0.1, 1.2)
	ccui.TextureResType.plistType[3] = cca.scaleTo(0.1, 1.1)
	ccui.TextureResType.plistType[4] = cca.scaleTo(0.1, 0.9)
	ccui.TextureResType.plistType[5] = cca.scaleTo(0.1, 1)
	ccui.TextureResType.plistType[6] = cca.scaleTo(0.1, 1)
	ccui.TextureResType.plistType[7] = cca.scaleTo(0.1, 1)
	ccui.TextureResType.plistType[8] = cca.scaleTo(0.1, 1)
	ccui.TextureResType.plistType[9] = cca.scaleTo(0.1, 1)
	self.img_item:runAction(cca.seq(ccui.TextureResType.plistType))
	self.node_whyPrt:setVisible(true)
	self.particle_why:stopSystem()
	self.particle_why:resetSystem()
	self.particle_why_02:stopSystem()
	self.particle_why_02:resetSystem()
	_UPVALUE2_ = self.particle_why_02
	self.particle_why_02[1] = cca.fadeTo(0.05, 0.64)
	self.particle_why_02[2] = cca.fadeTo(0.1, 0.63)
	self.particle_why_02[3] = cca.fadeTo(0.27, 0)
	self.particle_why_02[4] = cca.fadeTo(0.27, 0)
	self.particle_why_02[5] = cca.fadeTo(0.27, 0)
	self.particle_why_02[6] = cca.fadeTo(0.27, 0)
	self.particle_why_02[7] = cca.fadeTo(0.27, 0)
	self.particle_why_02[8] = cca.fadeTo(0.27, 0)
	self.particle_why_02[9] = cca.fadeTo(0.27, 0)
	self.particle_why_02[10] = cca.fadeTo(0.27, 0)
	self.particle_why_02[11] = cca.fadeTo(0.27, 0)
	local seq = cca.seq(self.particle_why_02)
	SoraDMixtureGLONE(self.dh_why)
	self.dh_why:stopAllActions()
	self.dh_why:runAction(seq)
	publicRead = self.dh_why
	self.dh_why[1] = cca.fadeTo(0.08, 1)
	self.dh_why[2] = cca.fadeTo(0.5, 0)
	self.dh_why[3] = cca.fadeTo(0.5, 0)
	self.dh_why[4] = cca.fadeTo(0.5, 0)
	self.dh_why[5] = cca.fadeTo(0.5, 0)
	self.dh_why[6] = cca.fadeTo(0.5, 0)
	self.dh_why[7] = cca.fadeTo(0.5, 0)
	self.dh_why[8] = cca.fadeTo(0.5, 0)
	self.dh_why[9] = cca.fadeTo(0.5, 0)
	self.dh_why[10] = cca.fadeTo(0.5, 0)
	local seq = cca.seq(self.dh_why)
	SoraDMixtureGLONE(self.dh_why_02)
	self.dh_why_02:stopAllActions()
	publicRead = cca.fadeTo(0.5, 0)
	publicRead = cca.fadeTo(0.5, 0)
	cca.fadeTo(0.5, 0)[1] = cca.rotateBy(0.08, 1.43)
	cca.fadeTo(0.5, 0)[2] = cca.rotateBy(0.5, 10)
	cca.fadeTo(0.5, 0)[3] = cca.rotateBy(0.5, 10)
	cca.fadeTo(0.5, 0)[4] = cca.rotateBy(0.5, 10)
	cca.fadeTo(0.5, 0)[1] = seq
	cca.fadeTo(0.5, 0)[2] = cca.seq(cca.fadeTo(0.5, 0))
	cca.fadeTo(0.5, 0)[3] = cca.seq(cca.fadeTo(0.5, 0))
	cca.fadeTo(0.5, 0)[4] = cca.seq(cca.fadeTo(0.5, 0))
	cca.fadeTo(0.5, 0)[5] = cca.seq(cca.fadeTo(0.5, 0))
	cca.fadeTo(0.5, 0)[6] = cca.seq(cca.fadeTo(0.5, 0))
	cca.fadeTo(0.5, 0)[7] = cca.seq(cca.fadeTo(0.5, 0))
	self.dh_why_02:runAction(cca.spawn(cca.fadeTo(0.5, 0)))
end
function solomonKeyView:onExitPanel()
	if self.flyToBagState == false and self.returnRewardList then
		local _ENV, curId = self.returnRewardList, self.returnRewardList
		curId[tostring(self.returnRewardList.id)] = self.returnRewardList.count
		SoraDMailGainItems(curId)
	end
end
function solomonKeyView:onceAction(single, select)
	self:createSingleAnimation(self.awardEntityList[self.finalIndex])
	_UPVALUE1_ = self.finalIndex
	self.finalIndex[1] = cca.delay(0.3)
	self.finalIndex[2] = cca.callFunc(function()
		if self.returnRewardList then
			local self, curId = self.returnRewardList, self.returnRewardList
			curId[tostring(self.returnRewardList.id)] = self.returnRewardList.count
			SoraDMailGainItems(curId)
			self.flyToBagState = true
		end
	end)
	self.finalIndex[3] = cca.callFunc(function()
		if self.returnRewardList then
			local self, curId = self.returnRewardList, self.returnRewardList
			curId[tostring(self.returnRewardList.id)] = self.returnRewardList.count
			SoraDMailGainItems(curId)
			self.flyToBagState = true
		end
	end)
	self:runAction(cca.seq(self.finalIndex))
	self.enableTouchCloseSelf = false
end
function solomonKeyView:showCirclingAction(_speed)
	local stepCount = 0
	local offsetSpeed = 0.15
	self.unShowQuick = nil
	local nextIndex = self.beforeIdx == 0 and math.random(1, #self.awardList) or self.beforeIdx
	local totalIndex = #self.awardList
	local _ENV, curId = #self.awardList, #self.awardList
	local _ENV, tableSpare
	local posX = self.awardEntityList[nextIndex]:getPositionX()
	local posY = self.awardEntityList[nextIndex]:getPositionY()
	local fadeInSelect = function()
		local showIndex = nextIndex % totalIndex + 1
		local idx = showIndex - 1 > 0 and showIndex - 1 or #self.awardEntityList
		self.awardEntityList[idx].imgSelect:setVisible(true)
		self.awardEntityList[idx].imgSelect:setOpacity(100)
		table.insert(tableSpare, self.awardEntityList[idx])
		idx = idx - 1 > 0 and idx - 1 or #self.awardEntityList - idx + 1
		self.awardEntityList[idx].imgSelect:setVisible(true)
		self.awardEntityList[idx].imgSelect:setOpacity(40)
		table.insert(tableSpare, self.awardEntityList[idx])
	end
	local unSee = function(isShowCurSingle)
		if tableSpare then
			for k, v in ipairs(tableSpare) do
				v.imgSelect:setOpacity(255)
				v.imgSelect:setVisible(false)
			end
		end
		tableSpare = (for generator)
		if self.curSingle and isShowCurSingle then
			self.curSingle.imgSelect:setVisible(false)
		end
	end
	unSee(true)
	self.awardEntityList[nextIndex].imgSelect:setVisible(true)
	self.curSingle = self.awardEntityList[nextIndex]
	local speedTime = 0
	local curSpeed = _speed
	local circle = 1
	local circleMax = 5
	self.timer = SoradCreateTimer(self, function(dt)
		if speedTime >= curSpeed then
			local showIndex = nextIndex % totalIndex + 1
			local _posX = self.awardEntityList[showIndex]:getPositionX()
			local _posY = self.awardEntityList[showIndex]:getPositionY()
			if self.curSingle then
				self.curSingle.imgSelect:setVisible(false)
			end
			unSee(true)
			self.awardEntityList[showIndex].imgSelect:setVisible(true)
			self.curSingle = self.awardEntityList[showIndex]
			SoraDPlaySound("pyramid", 3)
			if 5 < stepCount then
				fadeInSelect()
			end
			if circle < circleMax then
				if circle >= circleMax - 1 then
				else
				end
				print("现在的curspeed", curSpeed)
				if stepCount % totalIndex == 0 then
				end
			elseif 0 < self.haveData then
				self.unShowQuick = false
				if self.haveData == 1 then
					print("现在的showIndex", showIndex, self.finalIndex)
					if showIndex ~= self.finalIndex then
						unSee()
						print("现在的curspeed", curSpeed)
					elseif showIndex == self.finalIndex then
						unSee()
						self.unShowQuick = true
						SoraDManagerRemoveTimer(self, self.timer)
						self.timer = nil
						self:onceAction()
					end
				end
			end
		end
	end, true)
end
function solomonKeyView:onClickOpen(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.unShowQuick == nil and self.returnRewardList then
			return
		end
		SoraDManagerRemoveTimer(self, self.timer)
		if backpackCtrl:getItemCount(self.keyID) == 0 then
			_ENV = backpackCtrl:getItemCount(self.keyID)
			backpackCtrl:getItemCount(self.keyID)[solomonKeyRead.silverKey] = solomonKeyRead.silverGift
			backpackCtrl:getItemCount(self.keyID)[solomonKeyRead.goldKey] = solomonKeyRead.goldGift
			backpackCtrl:getItemCount(self.keyID)[solomonKeyRead.wesSilverKey] = solomonKeyRead.wesSilverGift
			local backpackCtrl:getItemCount(self.keyID)[solomonKeyRead.wesGoldKey], giftCfg = solomonKeyRead.wesGoldGift, backpackCtrl:getItemCount(self.keyID)
			if GLOBAL_GAME_RECHARGE_MODE then
				_ENV = nil
				;(nil).rechargeID = giftCfg[self.keyID]
				uiManager:show("rechargeView", nil)
			else
				local panel = SoraDCreatePanel("rechargeView")
				if giftCfg[self.keyID] then
					panel:jumpToLimitNode(12, giftCfg[self.keyID])
				end
				panel:show()
			end
			self:close(button, type)
		else
			if self.unShowQuick == false and self.returnRewardList then
				local _ENV, curId = self.returnRewardList, self.returnRewardList
				curId[tostring(self.returnRewardList.id)] = self.returnRewardList.count
				SoraDMailGainItems(curId)
			end
			self.node_whyPrt:setVisible(false)
			self.enableTouchCloseSelf = true
			self.flyToBagState = false
			self.haveData = 0
			self.beforeIdx = self.finalIndex
			self.img_why:setVisible(true)
			self.img_item:loadTexture("bg_transparent.png", ccui.TextureResType.plistType)
			self.returnRewardList = nil
			_ENV = "bg_transparent.png"
			;("bg_transparent.png").itemID = self.keyID
			;("bg_transparent.png").itemNum = 1
			solomonKeyCtrl:sendReqUseKey("bg_transparent.png")
			self:showCirclingAction(0.7)
		end
	end
end
function solomonKeyView:onClickRecord(button, type)
	if type == ccui.TouchEventType.ended and not self.reqRecord then
		SoraDPlaySound()
		SoraDShowLoading(self)
		self.reqRecord = true
		_ENV = nil
		;(nil).keyID = self.keyID
		solomonKeyCtrl:sendReqGetList(nil)
	end
end
function solomonKeyView:getRewardPosition(rewardCount)
	for k, v in ipairs(self.awardEntityList) do
		if tostring(v:getTag()) == tostring(rewardCount) then
			return k
		end
	end
end
function solomonKeyView:getRewardDataCallBack(target, data)
	if not data.reward then
		SoraDManagerRemoveTimer(self, self.timer)
		self:stopAllActions()
		return
	end
	self.finalIndex = self:getRewardPosition(data.reward.count)
	self.returnRewardList = data.reward
	self.haveData = 1
	self:refleshView()
end
return solomonKeyView
