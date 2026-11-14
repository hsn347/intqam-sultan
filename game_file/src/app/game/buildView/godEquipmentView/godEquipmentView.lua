local gametop = gModuleMgr.getObject("gametop")
local miraculousWeaponCtrl = gametop.playertop_:getModule("miraculousWeaponCtrl")
local queueCtrl = gametop.playertop_:getModule("queueCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local miraculousWeaponltCtrl = include("miraculousWeaponltCtrl")
local publicRead = include("publicRead")
_ENV = "publicRead"
;("publicRead").LOCK = 1
;("publicRead").BEAWAKE = 2
;("publicRead").AWAKED = 3
;("publicRead").MULTIVIEW = 4
local ("publicRead").MULTIPREVIEW, modelConfig = 5, "publicRead"
local godEquipmentView = class("godEquipmentView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("godEquipmentView")
	end
	return target
end)
function godEquipmentView:ctor()
	self.isHideCurrentSceneView = true
	self.showModel = modelConfig.LOCK
	self.equipIndex = 1
	self.seniorStoneID = 230001
	self.weaponList, modelConfig, self.tableChipsSingle, modelConfig, self.attrArray, modelConfig, self.weaponID = miraculousWeaponltCtrl.getWeaponIDByIndex(self.equipIndex), miraculousWeaponltCtrl.getWeaponIDByIndex(self.equipIndex), miraculousWeaponltCtrl.getWeaponIDByIndex(self.equipIndex), miraculousWeaponltCtrl.getWeaponIDByIndex(self.equipIndex), miraculousWeaponltCtrl.getWeaponIDByIndex(self.equipIndex), miraculousWeaponltCtrl.getWeaponIDByIndex(self.equipIndex), miraculousWeaponltCtrl.getWeaponIDByIndex(self.equipIndex)
	self.onceWakeCount = 0
	self.onceSeniorWakeCount = 0
	self.isMultiMsg = false
	self.isPreview = false
	self.isSeniorAwake = false
	self.isEnough_normal = false
	self.isEnough_senior = false
	self.isEnough_multi = false
	self.isEnough_smulti = false
	self.isEnough_again = false
	self.indexArray, modelConfig, self.isMulti = miraculousWeaponltCtrl.getWeaponIDByIndex(self.equipIndex), miraculousWeaponltCtrl.getWeaponIDByIndex(self.equipIndex), false
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_god")
	self.nodeTitle:setTitle(i18n("weapon_title_01"))
	self.Center_Size_img_background = SoraDGetChildByName(self, "Center_Size_img_background")
	self.Top_Node_particle = SoraDGetChildByName(self, "Top_Node_particle")
	self.Top_Particle_up = SoraDGetChildByName(self, "Top_Particle_up")
	SoraDMixtureGLONE(SoraDGetChildByName(self.Top_Node_particle, "Particle_glone_1"))
	SoraDMixtureGLONE(SoraDGetChildByName(self.Top_Node_particle, "Particle_glone_2"))
	SoraDMixtureGLONE(self.Top_Particle_up)
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.Node_god = SoraDGetChildByName(self, "Top_Node_god")
	self.Node_gad = SoraDGetChildByName(self, "Top_Node_gad")
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	self.PageView_chips = SoraDGetChildByName(self, "PageView_chips")
	self.PageView_chips:setCustomScrollThreshold(50)
	self.PageView_chips:addEventListener(handler(self, self.pageChange))
	self.Button_equip = SoraDGetChildByName(self, "Button_equip")
	self.Button_equip:setTitleText(i18n("weapon_name_10"))
	self.Button_gad = SoraDGetChildByName(self, "Button_gad")
	self.Button_gad:setTitleText(i18n("weapon_title_06"))
	self.Button_equip:addTouchEventListener(handler(self, self.btnEquipCallBack))
	self.Button_gad:addTouchEventListener(handler(self, self.btnGadCallBack))
	self.Button_left = SoraDGetChildByName(self, "Button_left")
	self.Button_right = SoraDGetChildByName(self, "Button_right")
	self.Button_left:addTouchEventListener(handler(self, self.btnLeftCallBack))
	self.Button_right:addTouchEventListener(handler(self, self.btnRightCallBack))
	self.Button_unlock = SoraDGetChildByName(self, "Button_unlock")
	self.Button_unlock:setTitleText(i18n("common_text_740"))
	self.Button_unlock:setVisible(false)
	self.Button_unlock:addTouchEventListener(handler(self, self.btnUnlockCallBack))
	self.Node_normalShow = SoraDGetChildByName(self, "Node_normalShow")
	self.Node_multiWake = SoraDGetChildByName(self, "Node_multiWake")
	self.Node_multiWake:setVisible(false)
	self.scroll_multi = SoraDGetChildByName(self.Node_multiWake, "ScrollView_multi")
	self.scroll_multi = include("commonAutoScrollList").new(self.scroll_multi)
	self.scroll_multi:setSingleCCS("godEquipmentAwakeSingle")
	self.Node_multiTitle = SoraDGetChildByName(self.Node_multiWake, "Node_multiTitle")
	self.Text_multiTitle = SoraDGetChildByName(self.Node_multiTitle, "Text_multiTitle")
	self.Text_multiTitle:setString(i18n("weapon_title_05"))
	SoraDToCenter(self.Node_multiTitle, 50)
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Node_myPower = SoraDGetChildByName(self, "Node_myPower")
	self.Text_power = SoraDGetChildByName(self.Node_myPower, "Text_power")
	self.Text_power_ex = SoraDGetChildByName(self.Node_myPower, "Text_power_ex")
	self.Text_free = SoraDGetChildByName(self, "Text_free")
	self.Node_attribute = SoraDGetChildByName(self, "Node_attribute")
	self.Text_attr = SoraDGetChildByName(self.Node_attribute, "Text_attr")
	self.Node_attr = SoraDGetChildByName(self, "Node_attr")
	local pointNode = cc.Node:create()
	pointNode:setPosition(0, -680)
	pointNode:addTo(self.Node_normalShow)
	local imageItemBg = ccui.ImageView:create("frame_lace_09_02.png", ccui.TextureResType.plistType)
	imageItemBg:setName("Image_bg")
	imageItemBg:setPosition(0, 0)
	imageItemBg:addTo(pointNode)
	local imageLight = ccui.ImageView:create("frame_lace_09_01.png", ccui.TextureResType.plistType)
	imageLight:setName("Image_light")
	imageLight:setPosition(0, 0)
	imageLight:addTo(pointNode)
	self.pagePoint = include("commonScrollIndicatorNumber").new(pointNode)
	modelConfig = pointNode
	pointNode.count = 9
	pointNode.intervalWidth = 40
	pointNode.begin = 1
	self.pagePoint:initData(pointNode)
	self.Button_left:setVisible(false)
	self.Text_powerTitle = SoraDGetChildByName(self, "Text_powerTitle")
	self.Text_powerTitle:setString(i18n("weapon_text_10"))
	self.Node_power = SoraDGetChildByName(self, "Node_power")
	self.Text_totalPower = SoraDGetChildByName(self.Node_power, "Text_totalPower")
	self.Node_tip = SoraDGetChildByName(self, "Node_tip")
	self.Text_tip = SoraDGetChildByName(self.Node_tip, "Text_tip")
	self.Text_tip:setString(i18n("weapon_text_11"))
	self.Button_tip = SoraDGetChildByName(self.Node_tip, "Button_tip")
	self.Button_tip:addTouchEventListener(handler(self, self.btnTipCallBack))
	SoraDToCenter(self.Node_tip)
	self.scroll = SoraDGetChildByName(self, "ScrollView_gad")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("godEquipmentGadSingle")
	self.Size_Panel_touch = SoraDGetChildByName(self, "Size_Panel_touch")
	self.Size_Panel_touch:setTouchEnabled(false)
	self.Size_Panel_touch:addTouchEventListener(handler(self, self.btnPanelCallBack))
	self.Button_speedup = SoraDGetChildByName(self, "Button_speedup")
	self.Button_speedup:setVisible(false)
	SoraDGetChildByName(self.Button_speedup, "Text_speed"):setString(i18n("common_text_018"))
	self.Text_time = SoraDGetChildByName(self.Button_speedup, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeEndListener(function(...)
		self.Button_speedup:setVisible(false)
	end)
	self.Button_speedup:addTouchEventListener(handler(self, self.btnSpeedUpCallBack))
	self.Bottom_Node_awake = SoraDGetChildByName(self, "Bottom_Node_awake")
	self.Bottom_Node_awake:setVisible(false)
	self.btn_highAwake = SoraDGetExtendChildFromCCSByName(self.Bottom_Node_awake, "CCS_commonGoldNormalBtn_highAwake")
	self.btn_highAwake:setVisible(false)
	self.btn_awake = SoraDGetExtendChildFromCCSByName(self.Bottom_Node_awake, "CCS_commonGoldNormalBtn_awake")
	self.btn_awakeFive = SoraDGetExtendChildFromCCSByName(self.Bottom_Node_awake, "CCS_commonGoldNormalBtn_awakeFive")
	self.btn_highAwakeFive = SoraDGetExtendChildFromCCSByName(self.Bottom_Node_awake, "CCS_commonGoldNormalBtn_highAwakeFive")
	self.btn_highAwakeFive:setVisible(false)
	self.btn_highAwake:addTouchEventListener(handler(self, self.btnHighAwakeCallBack))
	self.btn_awake:addTouchEventListener(handler(self, self.btnAwakeCallBack))
	self.btn_awakeFive:addTouchEventListener(handler(self, self.btnAwakeFiveCallBack))
	self.btn_highAwakeFive:addTouchEventListener(handler(self, self.btnHighAwakeFiveCallBack))
	self.Bottom_Node_awaked = SoraDGetChildByName(self, "Bottom_Node_awaked")
	self.Bottom_Node_awaked:setVisible(false)
	self.Button_save = SoraDGetChildByName(self.Bottom_Node_awaked, "Button_save")
	self.Button_save:setTitleText(i18n("common_text_195"))
	self.Button_cancel = SoraDGetChildByName(self.Bottom_Node_awaked, "Button_cancel")
	self.Button_cancel:setTitleText(i18n("common_text_185"))
	self.btn_awakeAgain = SoraDGetExtendChildFromCCSByName(self.Bottom_Node_awaked, "CCS_commonGoldNormalBtn_awakeAgain")
	self.btn_awakeAgain:setColor(gBtnColorDef.BLUE)
	self.Button_preview = SoraDGetChildByName(self.Bottom_Node_awaked, "Button_preview")
	self.Button_preview:setTitleText(i18n("weapon_title_05"))
	self.Button_preview:setVisible(false)
	self.Button_save:addTouchEventListener(handler(self, self.btnSaveCallBack))
	self.Button_cancel:addTouchEventListener(handler(self, self.btnCancelCallBack))
	self.btn_awakeAgain:addTouchEventListener(handler(self, self.btnAwakeAgainCallBack))
	self.Button_preview:addTouchEventListener(handler(self, self.btnPreviewCallBack))
	SoraDAddMessage(self, "MESSAGE_UI_GODEQUIP_NOTIFY_UNLOCK", handler(self, self.unlockEquip))
	self:suitView()
end
function godEquipmentView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_UI_GODEQUIP_PANELTOUCH_UPDATE", handler(self, self.setPanelTouchStatus))
	SoraDAddMessage(self, "MESSAGE_ITEM_SPEED_UP_BACK", handler(self, self.updateUnlockTime))
	SoraDAddMessage(self, "MESSAGE_UI_GODEQUIP_SHOWMODEL_UPDATE", handler(self, self.setShowModel))
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_WAKE_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_SAVE_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_CANCEL_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_GODEQUIP_SELECTATTR_UPDATE", handler(self, self.updateAttr))
	SoraDAddMessage(self, "MESSAGE_SERVER_GODEQUIP_MERGE_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_GODEQUIP_TO_BEUNLOCK_CHIP", handler(self, self.toBeUnlockChip))
	SoraDAddMessage(self, "MESSAGE_UI_GODEQUIP_NOTIFY_UNLOCK", handler(self, self.unlockEquip))
	SoraDAddMessage(self, "MESSAGE_FILE_DOWNLOAD_SUCCESS", handler(self, self.updateChipView))
end
function godEquipmentView:onEnterOther()
	self:initData()
	self:changeState(true)
	self:initJump()
	self:setShakeAction()
end
function godEquipmentView:suitView()
	self.PageView_chips:setPositionY(display.height < 960 and -350 or -390)
	self.Node_myPower:setPositionY(-15)
	self.pagePoint:setPositionY(-610 - math.min(0, display.height - 960))
	self.scroll:setContentSize(cc.size(640, display.height - 300))
	self.scroll_multi:setContentSize(cc.size(640, display.height - 520))
	self.Size_Panel_touch:setContentSize(cc.size(640, display.height - 145))
	self.Top_Node_particle:setPositionY(display.height - 700)
	self.Top_Particle_up:setPositionY(display.height + 150)
	self.Node_normalShow:setPositionY(display.height >= 960 and -0.5 * (display.height - 960) or 0)
	self.Text_name:setPositionY(display.height > 960 and math.max(-0.5 * (display.height - 960), -88) or -175)
end
function godEquipmentView:setShakeAction()
	if self.PageView_chips then
		self.pageOriPosX, self.pageOriPosY = self.PageView_chips:getPosition()
	end
	if self.Center_Size_img_background then
		self.bgOriPosX, self.bgOriPosY = self.Center_Size_img_background:getPosition()
	end
	SoraDAddShakeOffsetHandl(handler(self, self.shakeFun), "godEquipmentView")
end
function godEquipmentView:shakeFun(acc, x, y, z, timeStamp)
	local _var = 20
	if not self.mx then
		self.mx, self.my = x, y
	else
		if _var < math.abs(x - self.mx) then
			x = self.mx + (x - self.mx) / math.abs(x - self.mx) * _var
		end
		if _var < math.abs(y - self.my) then
			y = self.my + (y - self.my) / math.abs(y - self.my) * _var
		end
		self.mx, self.my = x, y
	end
	local _y = 0.0225 * y
	local _x = 0.0225 * x
	if self.PageView_chips and not tolua.isnull(self.PageView_chips) then
		self.PageView_chips:setPosition(self.pageOriPosX + 1.1 * _x, self.pageOriPosY + 1.1 * _y)
	end
	if self.Center_Size_img_background and not tolua.isnull(self.Center_Size_img_background) then
		self.Center_Size_img_background:setPosition(self.bgOriPosX - _x, self.bgOriPosY - _y)
	end
end
function godEquipmentView:initJump()
	_ENV = nil
	;(nil).byLTID = true
	self.equipIndex = SoraDConfigGet("Game:godEquipmentView:index~integer", nil)
	for i = 1, table.nums(self.weaponList) do
		if not miraculousWeaponCtrl:isWeaponMerged(miraculousWeaponltCtrl.getWeaponIDByIndex(i)) then
			self.equipIndex = i
			break
		end
	end
	self:loadChipsPage(self.equipIndex)
	self.PageView_chips:scrollToPage(self.equipIndex - 1, true)
end
function godEquipmentView:updateChipView(target, data)
	self.Center_Size_img_background:loadTexture("bg_godEquipment.png", ccui.TextureResType.plistType)
	for k, v in pairs(self.tableChipsSingle) do
		v:updateSource()
	end
end
function godEquipmentView:unlockEquip(target, data)
	local isMerged = miraculousWeaponCtrl:isWeaponMerged(self.weaponID)
	self.Button_unlock:setVisible(not isMerged and data.ret)
end
function godEquipmentView:toBeUnlockChip(target, data)
	local ret, chipInfo = miraculousWeaponltCtrl.hasAnyChipsBeUnlock(true)
	if ret and not self.finger then
		self:stopAllActions()
		local toIndex = miraculousWeaponltCtrl.getWeaponInfo(chipInfo.weaponID).type
		_UPVALUE4_ = nil
		;(nil)[1] = cca.callFunc(function()
			self.PageView_chips:scrollToPage(toIndex - 1)
			self.equipIndex = toIndex
		end)
		;(nil)[2] = cca.delay(0.5)
		;(nil)[3] = cca.callFunc(function()
			if not self.finger then
				local chip = self.tableChipsSingle[toIndex]:getChip(chipInfo.weaponID, chipInfo.chipIndex)
				self.finger = SoraDFingerAction(false, false, 2)
				self.finger:setPosition(chip:getPositionX(), chip:getPositionY())
				self.finger:addTo(self.tableChipsSingle[toIndex].Node_chips, 99)
			end
		end)
		;(nil)[4] = cca.delay(3)
		;(nil)[5] = cca.callFunc(function()
			if self.finger then
				self.finger:removeFromParent()
				self.finger = nil
			end
		end)
		;(nil)[6] = cca.callFunc(function()
			if self.finger then
				self.finger:removeFromParent()
				self.finger = nil
			end
		end)
		local action = cca.seq(nil)
		self:runAction(action)
	end
end
function godEquipmentView:initData()
	self.weaponList = miraculousWeaponltCtrl.getAllWeapon()
	self:updateTotalePower()
	self:updateUnlockTime()
end
function godEquipmentView:updateTotalePower()
	self.curWeaponFc = miraculousWeaponCtrl:getCurWeaponFc()
	self.oriMaxPower = miraculousWeaponCtrl:getOriMaxWeaponFc()
	self.Text_totalPower:setString(string.formatnumberthousands(self.curWeaponFc))
	SoraDToCenter(self.Node_power, 20)
end
function godEquipmentView:updateView(target, data)
	SoraDCloseLoading(self)
	self.isSeniorAwake = miraculousWeaponCtrl:isWeaponSeniorAwaked(data.weaponID)
	self.isMultiMsg = false
	self:setWeaponInfo(true, true)
	self:updateTotalePower()
	self:setFreeTimes()
end
function godEquipmentView:updateUnlockTime(target, data)
	if data and data.qtype == gQueueTypeDef.miraculous_weapon_unlock or not data then
		local unlockQueue = queueCtrl:queryQueue(gQueueTypeDef.miraculous_weapon_unlock)
		if unlockQueue then
			self.Text_time:beginTime(unlockQueue.timerNode.timer:getRemainTime())
		else
			self.Button_speedup:setVisible(false)
		end
	end
end
function godEquipmentView:setFreeTimes()
	local weaponInfo = miraculousWeaponCtrl:getWeaponInfo(self.weaponID)
	local maxFreeCount = miraculousWeaponltCtrl.getWeaponInfo(self.weaponID).wakeNum
	local freeCount = maxFreeCount - weaponInfo.daily_normal_remake
	self.Text_free:setVisible(maxFreeCount > weaponInfo.daily_normal_remake and miraculousWeaponCtrl:isWeaponMerged(self.weaponID))
	miraculousWeaponCtrl = nil
	;(nil).member = freeCount
	;(nil).total = maxFreeCount
	self.Text_free:setString(i18n("common_text_049") .. i18n("common_text_155", nil))
end
function godEquipmentView:setPower()
	local myWeaponInfo = miraculousWeaponCtrl:getWeaponInfo(self.weaponID)
	local basePower = myWeaponInfo.total_power
	local previewPower = 0
	local preBuffList = miraculousWeaponCtrl:getSortRemakeBuff(self.weaponID)
	if preBuffList and next(preBuffList) then
		local preEx = 0
		if table.nums(preBuffList) == 1 then
			previewPower = miraculousWeaponCtrl:calcWeaponPower(self.weaponID, preBuffList[1])
			preEx = previewPower - basePower
		else
			for k, v in ipairs(preBuffList) do
				if v.isSelected then
					previewPower = miraculousWeaponCtrl:calcWeaponPower(self.weaponID, v)
					preEx = preEx + previewPower - basePower
				end
			end
		end
		local preStr = preEx
		local preColor = cc.c3b(190, 40, 40)
		if 0 < preEx then
			preStr = SoraDFValueSuit(preEx)
			preColor = cc.c3b(0, 190, 30)
		elseif preEx == 0 then
			preStr = ""
			preColor = cc.c3b(255, 255, 255)
		else
			preStr = SoraDFValueSuit(math.abs(preEx), "-")
		end
		self.Text_power_ex:setString(preStr)
		self.Text_power_ex:setColor(preColor)
	else
		self.Text_power_ex:setString("")
	end
	if 0 < basePower then
		miraculousWeaponCtrl = self.Text_power_ex
		self.Text_power_ex.power = string.formatnumberthousands(math.floor(basePower))
		self.Text_power:setString(i18n("common_text_128", self.Text_power_ex))
	else
		basePower = miraculousWeaponltCtrl.getWeaponInfo(self.weaponID).extrePower
		miraculousWeaponCtrl = i18n("common_text_128", self.Text_power_ex)
		i18n("common_text_128", self.Text_power_ex).power = string.formatnumberthousands(math.floor(basePower))
		self.Text_power:setString(i18n("weapon_text_25", i18n("common_text_128", self.Text_power_ex)))
	end
	SoraDToCenter(self.Node_myPower)
end
function godEquipmentView:setWeaponInfo(isFromMsg, isPreview)
	local weaponInfo = miraculousWeaponltCtrl.getWeaponInfo(self.weaponID)
	self.Text_name:setString(i18n(weaponInfo.name))
	self:setPower()
	local buffList, preBuffList, isLimited = miraculousWeaponCtrl:getWeaponShowBuffList(self.weaponID)
	for i, v in ipairs(buffList) do
		if not self.attrArray[i] then
			self.attrArray[i] = SoraDCreatePanel("godEquipmentAttrSingle")
			self.attrArray[i]:setPosition(0, -40 * i + 50)
			self.attrArray[i]:addTo(self.Node_attr)
		end
		if isLimited then
			self.isMulti = false
			self.attrArray[i]:limitShow(v.buffType, v.value)
		else
			local maxValue = miraculousWeaponltCtrl.getWeaponMaxBuffValue(self.weaponID, v.buffType)
			if preBuffList and next(preBuffList) then
				if table.nums(preBuffList) > 1 then
					self.isMulti = true
				elseif table.nums(preBuffList) == 1 then
					self.isMulti = false
					local preValue = preBuffList[1][i] and preBuffList[1][i].value
					self.attrArray[i]:initData(v.buffType, v.value, preValue, maxValue)
				end
			else
				self.isMulti = false
				self.attrArray[i]:initData(v.buffType, v.value, v.value, maxValue)
			end
		end
	end
	self.isMultiMsg = self.isMulti and isFromMsg or false
	self.isPreview = isPreview or false
	if self.isMulti and isFromMsg then
		self:initAwakeScroll()
	end
	self.Node_normalShow:setVisible(not self.isMultiMsg)
	self.Node_multiWake:setVisible(self.isMultiMsg)
	self:setShowModel()
	self:setFreeTimes()
end
function godEquipmentView:updateAttr(target, data)
	self.indexArray = miraculousWeaponCtrl:getSelectedKeyTab(self.weaponID)
	local buffList = miraculousWeaponCtrl:getWeaponShowBuffList(self.weaponID)
	for i, v in ipairs(buffList) do
		local maxValue = miraculousWeaponltCtrl.getWeaponMaxBuffValue(self.weaponID, v.buffType)
		local preValue = miraculousWeaponCtrl:getRemakeValuePreShow(self.weaponID, v.buffType)
		self.attrArray[i]:initData(v.buffType, v.value, preValue, maxValue)
	end
	self:setPower()
	local canSave = not self.isMulti or type(self.indexArray) == "table" and next(self.indexArray) ~= nil
	self.Button_save:setTouchEnabled(canSave)
	self.Button_save:setBright(canSave)
end
function godEquipmentView:setShowModel()
	local isMerged = miraculousWeaponCtrl:isWeaponMerged(self.weaponID)
	if not isMerged then
		self.showModel = modelConfig.LOCK
	else
		local isAwaked = miraculousWeaponCtrl:isWeaponAwaked(self.weaponID)
		if isAwaked then
			self.showModel = self.isMulti and modelConfig.MULTIVIEW or modelConfig.AWAKED
			if self.isPreview then
				self.showModel = modelConfig.MULTIPREVIEW
			end
		else
			self.showModel = modelConfig.BEAWAKE
		end
	end
	print("self.showModel===", self.showModel)
	self.Bottom_Node_awake:setVisible(self.showModel == modelConfig.BEAWAKE)
	self.Bottom_Node_awaked:setVisible(self.showModel > modelConfig.BEAWAKE)
	self.Bottom_Node:setPositionY(self.showModel == modelConfig.LOCK and 215 or 280)
	self.Text_free:setPositionY(self.showModel == modelConfig.LOCK and -125 or -190)
	if self.Bottom_Node_awaked:isVisible() then
		self.Button_preview:setVisible(self.showModel == modelConfig.MULTIVIEW)
		self.Button_cancel:setVisible(self.showModel ~= modelConfig.MULTIVIEW)
		self.Button_save:setVisible(self.showModel ~= modelConfig.MULTIVIEW)
		self.btn_awakeAgain:setVisible(self.showModel ~= modelConfig.MULTIVIEW)
	end
	self.Text_attr:setString(self.showModel == modelConfig.LOCK and i18n("weapon_title_04") or i18n("weapon_title_03"))
	if self.showModel == modelConfig.MULTIVIEW then
		self:updateAttr()
	end
	if self.showModel == modelConfig.BEAWAKE or self.showModel == modelConfig.AWAKED or self.showModel == modelConfig.MULTIPREVIEW then
		self:updateWakeBtns()
	end
	SoraDToCenter(self.Node_attribute, 50)
end
function godEquipmentView:checkSeniorStone()
	local seniorCount = backpackCtrl:getItemCount(self.seniorStoneID)
	self.btn_highAwake:setVisible(0 < seniorCount)
	self.btn_highAwakeFive:setVisible(0 < seniorCount)
	self.onceSeniorWakeCount = MULTI_AWAKE_MIN
	if 0 < seniorCount then
		local advancedCount = miraculousWeaponCtrl:getWeaponInfo(self.weaponID).daily_advanced_remake
		local cost = miraculousWeaponltCtrl.getWeaponWakeCost(advancedCount + 1, gAwakeOpType.SENIOR)
		self.isEnough_senior = seniorCount >= cost.value
		self.btn_awake:setPositionX(SoraDFPosX(234, 0))
		self.btn_awake:changeToSmall()
		self.btn_awakeFive:setPositionX(SoraDFPosX(78, 0))
		self.btn_awakeFive:changeToSmall()
		self.btn_highAwake:setPositionX(SoraDFPosX(-78, 0))
		self.btn_highAwake:changeToSmall()
		self.btn_highAwakeFive:setPositionX(SoraDFPosX(-234, 0))
		self.btn_highAwakeFive:changeToSmall()
		backpackCtrl = SoraDFPosX(-234, 0)
		SoraDFPosX(-234, 0).title = i18n("weapon_btn_04")
		self.btn_highAwake:initData(SoraDFPosX(-234, 0))
		self.btn_highAwake:setIconTexture(publicRead.getIcon(self.seniorStoneID))
		backpackCtrl = publicRead.getIcon(self.seniorStoneID)
		publicRead.getIcon(self.seniorStoneID).member = seniorCount
		publicRead.getIcon(self.seniorStoneID).total = cost.value
		self.btn_highAwake:setGoldText(i18n("common_text_155", publicRead.getIcon(self.seniorStoneID)))
		self.btn_highAwake:setTextGoldColor(seniorCount >= cost.value and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40))
		self.onceSeniorWakeCount = math.min(MULTI_AWAKE_MAX, math.max(MULTI_AWAKE_MIN, math.floor(seniorCount / cost.value)))
		self.isEnough_smulti = seniorCount >= self.onceSeniorWakeCount * cost.value
		backpackCtrl = math.max(MULTI_AWAKE_MIN, math.floor(seniorCount / cost.value))
		backpackCtrl = math.max(MULTI_AWAKE_MIN, math.floor(seniorCount / cost.value))
		math.max(MULTI_AWAKE_MIN, math.floor(seniorCount / cost.value)).name = i18n("weapon_btn_04")
		math.max(MULTI_AWAKE_MIN, math.floor(seniorCount / cost.value)).count = self.onceSeniorWakeCount
		math.max(MULTI_AWAKE_MIN, math.floor(seniorCount / cost.value)).title = i18n("common_text_1460", math.max(MULTI_AWAKE_MIN, math.floor(seniorCount / cost.value)))
		self.btn_highAwakeFive:initData(math.max(MULTI_AWAKE_MIN, math.floor(seniorCount / cost.value)))
		self.btn_highAwakeFive:setIconTexture(publicRead.getIcon(self.seniorStoneID))
		backpackCtrl = publicRead.getIcon(self.seniorStoneID)
		publicRead.getIcon(self.seniorStoneID).member = seniorCount
		publicRead.getIcon(self.seniorStoneID).total = cost.value * self.onceSeniorWakeCount
		self.btn_highAwakeFive:setGoldText(i18n("common_text_155", publicRead.getIcon(self.seniorStoneID)))
		self.btn_highAwakeFive:setTextGoldColor(seniorCount >= cost.value * self.onceSeniorWakeCount and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40))
	else
		self.isEnough_smulti = false
		self.btn_awake:setPositionX(SoraDFPosX(140, 0))
		self.btn_awake:changeToNormal()
		self.btn_awakeFive:setPositionX(SoraDFPosX(-140, 0))
		self.btn_awakeFive:changeToNormal()
	end
end
function godEquipmentView:updateWakeBtns()
	local wakeCount = miraculousWeaponCtrl:getWakeCountAndCost(self.weaponID)
	local freeCount = miraculousWeaponltCtrl.getWeaponInfo(self.weaponID).wakeNum
	local seniorCount = backpackCtrl:getItemCount(self.seniorStoneID)
	local advancedCount = miraculousWeaponCtrl:getWeaponInfo(self.weaponID).daily_advanced_remake
	local scost = miraculousWeaponltCtrl.getWeaponWakeCost(advancedCount + 1, gAwakeOpType.SENIOR)
	local cost = miraculousWeaponltCtrl.getWeaponWakeCost(wakeCount - freeCount + 1)
	local stoneCount = backpackCtrl:getItemCount(cost.id)
	self.isSeniorAwake = miraculousWeaponCtrl:isWeaponSeniorAwaked(self.weaponID)
	self.onceWakeCount = MULTI_AWAKE_MIN
	local updateBtnAwakeAgain = function(isHaveFree)
		if self.isSeniorAwake then
			if self.isMulti then
				self = nil
				;(nil).name = i18n("weapon_btn_04")
				;(nil).count = self.onceSeniorWakeCount
				if i18n("common_text_1460", nil) then
					goto lbl_22
				end
			end
			local titleStr = i18n("weapon_btn_04")
			::lbl_22::
			self = self.onceSeniorWakeCount
			self.onceSeniorWakeCount.title = titleStr
			self.btn_awakeAgain:initData(self.onceSeniorWakeCount)
			self = nil
			;(nil).member = seniorCount
			;(nil).total = scost.value * self.onceSeniorWakeCount
			self.btn_awakeAgain:setGoldText(i18n("common_text_155", nil))
			self.btn_awakeAgain:setTextGoldColor(self.isEnough_again and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40))
			self.btn_awakeAgain:setIconTexture(publicRead.getIcon(scost.id))
		elseif isHaveFree then
			if self.isMulti then
				self = self.btn_awakeAgain
				self.btn_awakeAgain.name = i18n("weapon_btn_05")
				self.btn_awakeAgain.count = self.onceWakeCount
				if i18n("common_text_1460", self.btn_awakeAgain) then
					goto lbl_87
				end
			end
			local freeTitleStr = i18n("weapon_btn_05")
			::lbl_87::
			self = self.onceWakeCount
			self.onceWakeCount.text = freeTitleStr
			self.btn_awakeAgain:initData(self.onceWakeCount, 0)
		else
			local cost = miraculousWeaponltCtrl.getWeaponWakeCost(wakeCount - freeCount + 1)
			local stoneCount = backpackCtrl:getItemCount(cost.id)
			if self.isMulti then
				self = 0
				;(0).name = i18n("weapon_btn_02")
				;(0).count = self.onceWakeCount
				if i18n("common_text_1460", 0) then
					goto lbl_122
				end
			end
			local costTitleStr = i18n("weapon_btn_03")
			::lbl_122::
			self = self.onceWakeCount
			self.onceWakeCount.title = costTitleStr
			self.btn_awakeAgain:initData(self.onceWakeCount)
			self = publicRead.getIcon(scost.id)
			publicRead.getIcon(scost.id).member = stoneCount
			publicRead.getIcon(scost.id).total = self.isMulti and self.onceWakeCount * cost.value or cost.value
			self.btn_awakeAgain:setGoldText(i18n("common_text_155", publicRead.getIcon(scost.id)))
			self.btn_awakeAgain:setTextGoldColor(self.isEnough_again and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40))
			self.btn_awakeAgain:setIconTexture(publicRead.getIcon(cost.id))
		end
	end
	local updateBtnAwake = function(isHaveFree)
		if isHaveFree then
			self = nil
			;(nil).text = i18n("weapon_btn_05")
			self.btn_awake:initData(nil, 0)
			self = nil
			self = nil
			;(nil).num = self.onceWakeCount
			;(nil).text = i18n("weapon_text_24", nil)
			self.btn_awakeFive:initData(nil, 0)
		else
			local cost = miraculousWeaponltCtrl.getWeaponWakeCost(wakeCount - freeCount + 1)
			local stoneCount = backpackCtrl:getItemCount(cost.id)
			self = "weapon_text_24"
			;("weapon_text_24").title = i18n("weapon_btn_02")
			self.btn_awake:initData("weapon_text_24")
			self = "weapon_btn_02"
			;("weapon_btn_02").member = stoneCount
			;("weapon_btn_02").total = cost.value
			self.btn_awake:setGoldText(i18n("common_text_155", "weapon_btn_02"))
			self.btn_awake:setIconTexture(publicRead.getIcon(cost.id))
			self.btn_awake:setTextGoldColor(self.isEnough_normal and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40))
			self = self.isEnough_normal and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40)
			self = 40
			;(40).name = i18n("weapon_btn_02")
			;(40).count = self.onceWakeCount
			;(self.isEnough_normal and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40)).title = i18n("common_text_1460", 40)
			self.btn_awakeFive:initData(self.isEnough_normal and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40))
			self = "common_text_1460"
			;("common_text_1460").member = stoneCount
			;("common_text_1460").total = self.onceWakeCount * cost.value
			self.btn_awakeFive:setGoldText(i18n("common_text_155", "common_text_1460"))
			self.btn_awakeFive:setIconTexture(publicRead.getIcon(cost.id))
			self.btn_awakeFive:setTextGoldColor(self.isEnough_multi and cc.c3b(255, 255, 0) or cc.c3b(190, 40, 40))
		end
	end
	local isOwnFree = wakeCount < freeCount
	self.isEnough_normal = isOwnFree or stoneCount >= cost.value
	self.onceWakeCount = isOwnFree and math.min(MULTI_AWAKE_MAX, freeCount - wakeCount) or math.min(MULTI_AWAKE_MAX, math.max(MULTI_AWAKE_MIN, math.floor(stoneCount / cost.value)))
	self.isEnough_multi = isOwnFree or stoneCount >= self.onceWakeCount * cost.value
	self.isEnough_again = isOwnFree or self.isMulti and self.isEnough_multi or not self.isMulti and self.isEnough_normal
	if self.isSeniorAwake then
		self.onceSeniorWakeCount = self.isMulti and math.min(MULTI_AWAKE_MAX, math.max(MULTI_AWAKE_MIN, math.floor(seniorCount / scost.value))) or 1
		self.isEnough_again = seniorCount >= scost.value * self.onceSeniorWakeCount
	end
	updateBtnAwakeAgain(isOwnFree)
	updateBtnAwake(isOwnFree)
	self:checkSeniorStone()
end
function godEquipmentView:setBtnLeftRight()
	self.Button_left:setVisible(self.equipIndex > 1)
	self.Button_right:setVisible(self.equipIndex < 9)
end
function godEquipmentView:pageChange(button, event)
	print("event====", event)
	if event == 0 then
		local realIndex = self.PageView_chips:getCurPageIndex()
		self.pagePoint:setCurLight(realIndex + 1)
		self.equipIndex = realIndex + 1
		self.weaponID = miraculousWeaponltCtrl.getWeaponIDByIndex(self.equipIndex)
		self:setWeaponInfo()
		self:setBtnLeftRight()
		self:loadChipsPage(self.equipIndex)
	end
end
function godEquipmentView:loadChipsPage(index)
	if self.pageInit == nil then
		for i = 1, table.nums(self.weaponList) do
			local node = ccui.Widget:create()
			node:setPosition(0, 0)
			self.PageView_chips:addWidgetToPage(node, i - 1, true)
		end
		self.pageInit = true
	end
	if index and 1 <= index and index <= 9 and not self.tableChipsSingle[index] then
		local ccsFileName = "godEquipmentChips_" .. index
		local chipView = include("godEquipmentChipsView").new(ccsFileName)
		chipView:setPosition(320, 240)
		chipView:setIndex(index)
		chipView:initData(miraculousWeaponltCtrl.getWeaponIDByIndex(index))
		self.PageView_chips:getPage(index - 1):addChild(chipView, 1)
		self.tableChipsSingle[index] = chipView
		_ENV = 1
		;(1).byLTID = true
		SoraDConfigSet("Game:godEquipmentView:index~integer", index, 1)
	end
	print("检测是否可合成=======")
	self.tableChipsSingle[index]:checkAllChipsUnlock()
	self.PageView_chips:forceDoLayout()
end
function godEquipmentView:changeState(isEquip)
	local checkColor = cc.c3b(100, 80, 40)
	local uncheckColor = cc.c3b(255, 200, 100)
	self.Button_equip:setTouchEnabled(not isEquip)
	self.Button_equip:setBright(isEquip)
	self.Button_equip:setTitleColor(not isEquip and checkColor or uncheckColor)
	self.Button_gad:setTouchEnabled(isEquip)
	self.Button_gad:setBright(not isEquip)
	self.Button_gad:setTitleColor(not isEquip and uncheckColor or checkColor)
	self.Node_god:setVisible(isEquip)
	self.Bottom_Node:setVisible(isEquip)
	self.Node_gad:setVisible(not isEquip)
	if not isEquip then
		self:initScroll()
	else
		self:setWeaponInfo()
	end
end
function godEquipmentView:initScroll()
	local list = miraculousWeaponltCtrl.getGadPowerBuffList(self.oriMaxPower)
	self.scroll:updateScrollView(cc.size(640, 100), list)
end
function godEquipmentView:initAwakeScroll()
	local weapon_remake_buff = miraculousWeaponCtrl:getSortRemakeBuff(self.weaponID)
	miraculousWeaponCtrl = nil
	;(nil).scroll = self.scroll_multi
	self.scroll_multi:updateScrollView(cc.size(640, 150), weapon_remake_buff, 1, nil)
	self.scroll_multi:jumpToTop()
	self:updateAttr()
end
function godEquipmentView:setPanelTouchStatus(target, data)
	if data.enable ~= nil then
		self.Size_Panel_touch:setTouchEnabled(data.enable)
	end
	self.Button_speedup:setVisible(data.chipStatus and data.chipStatus == 2 or false)
end
function godEquipmentView:btnHighAwakeCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("高级唤醒=====")
		if self.isEnough_senior then
			local cost = miraculousWeaponltCtrl.getWeaponWakeCost(1, gAwakeOpType.SENIOR)
			_ENV = nil
			;(nil).num = cost.value
			SoraDShowMsgBox(i18n("weapon_text_08", nil), i18n("common_text_204"), i18n("common_text_185"), function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					miraculousWeaponCtrl:reqAwake(self.weaponID, 1, 2)
					SoraDShowLoading(self)
				end
			end)
		else
			SoraDShowMsgTip(i18n("weapon_text_17"))
		end
	end
end
function godEquipmentView:btnHighAwakeFiveCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("高级唤醒XN=====", self.onceSeniorWakeCount)
		if self.isEnough_smulti then
			local cost = miraculousWeaponltCtrl.getWeaponWakeCost(self.onceSeniorWakeCount, gAwakeOpType.SENIOR)
			_ENV = nil
			;(nil).num = cost.value * self.onceSeniorWakeCount
			SoraDShowMsgBox(i18n("weapon_text_08", nil), i18n("common_text_204"), i18n("common_text_185"), function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					miraculousWeaponCtrl:reqAwake(self.weaponID, self.onceSeniorWakeCount, 2)
					SoraDShowLoading(self)
				end
			end)
		else
			SoraDShowMsgTip(i18n("weapon_text_17"))
		end
	end
end
function godEquipmentView:btnAwakeCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("普通唤醒=====")
		if self.isEnough_normal then
			miraculousWeaponCtrl:reqAwake(self.weaponID, 1)
			SoraDShowLoading(self)
		else
			SoraDShowMsgTip(i18n("weapon_text_15"))
		end
	end
end
function godEquipmentView:btnAwakeFiveCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("普通唤醒Xn=====")
		if self.isEnough_multi then
			miraculousWeaponCtrl:reqAwake(self.weaponID, self.onceWakeCount)
			SoraDShowLoading(self)
		else
			SoraDShowMsgTip(i18n("weapon_text_15"))
		end
	end
end
function godEquipmentView:btnPreviewCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:setWeaponInfo(true, true)
	end
end
function godEquipmentView:btnSaveCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgBox(i18n("weapon_text_07"), i18n("common_text_204"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				self.indexArray = miraculousWeaponCtrl:getSelectedKeyTab(self.weaponID)
				if type(self.indexArray) == "table" and next(self.indexArray) then
					miraculousWeaponCtrl:reqSave(self.weaponID, self.indexArray)
				elseif self.isMulti then
					miraculousWeaponCtrl:reqCancel(self.weaponID)
				else
					miraculousWeaponCtrl:reqSave(self.weaponID)
				end
				SoraDShowLoading(self)
			end
		end)
	end
end
function godEquipmentView:btnCancelCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgBox(i18n("weapon_text_18"), i18n("common_text_204"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				miraculousWeaponCtrl:reqCancel(self.weaponID)
				SoraDShowLoading(self)
			end
		end)
	end
end
function godEquipmentView:btnAwakeAgainCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("再次唤醒=====")
		if self.isEnough_again then
			SoraDShowMsgBox(i18n("weapon_text_18"), i18n("common_text_204"), i18n("common_text_185"), function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					local count = self.isMulti and self.onceWakeCount or 1
					local opType = 1
					if self.isSeniorAwake then
						count = self.isMulti and self.onceSeniorWakeCount or 1
						opType = 2
					end
					miraculousWeaponCtrl:reqAwake(self.weaponID, count, opType)
					SoraDShowLoading(self)
				end
			end)
		elseif self.isSeniorAwake then
			SoraDShowMsgTip(i18n("weapon_text_17"))
		else
			SoraDShowMsgTip(i18n("weapon_text_15"))
		end
	end
end
function godEquipmentView:btnSpeedUpCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if next(backpackCtrl:getSpeedUpItemList(gQueueTypeDef.miraculous_weapon_unlock)) then
			SoraDShowSpeedUpByItemBox(gQueueTypeDef.miraculous_weapon_unlock)
		else
			local unlockQueue = queueCtrl:queryQueue(gQueueTypeDef.miraculous_weapon_unlock)
			_ENV = "weapon_text_03"
			;("weapon_text_03").speedUpName = i18n("weapon_btn_01")
			SoraDShowSpeedUpBox(unlockQueue, function(event)
				if event == MSGBOX_CALLBACK_SPEEDUP then
					queueCtrl:speedUpQueueReq(gQueueTypeDef.miraculous_weapon_unlock, SPEEDUP_TYPE.GOLD)
				end
			end, i18n("weapon_text_03"), "weapon_text_03")
		end
	end
end
function godEquipmentView:btnPanelCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_GODEQUIP_CHIPS_UPDATE"
		;(nil).index = self.equipIndex
		SoraDSendMessage(nil)
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_GODEQUIP_PANELTOUCH_UPDATE"
		;(nil).enable = false
		SoraDSendMessage(nil)
	end
end
function godEquipmentView:btnUnlockCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local weaponInfo = miraculousWeaponltCtrl.getWeaponInfo(self.weaponID)
		_ENV = nil
		;(nil).name = i18n(weaponInfo.name)
		SoraDShowMsgBox(i18n("weapon_text_26", nil), i18n("common_text_1352"), nil, function(callBack)
			if callBack == MSGBOX_CALLBACK_YES then
				miraculousWeaponCtrl:reqMerge(self.weaponID)
			end
		end)
	end
end
function godEquipmentView:btnLeftCallBack(button, event)
	if event == ccui.TouchEventType.ended and self.equipIndex > 1 then
		SoraDPlaySound()
		self.equipIndex = self.equipIndex - 1
		self.weaponID = miraculousWeaponltCtrl.getWeaponIDByIndex(self.equipIndex)
		self:setWeaponInfo()
		self:setBtnLeftRight()
		self.pagePoint:setCurLight(self.equipIndex)
		self.PageView_chips:scrollToPage(self.equipIndex - 1)
	end
end
function godEquipmentView:btnRightCallBack(button, event)
	if event == ccui.TouchEventType.ended and self.equipIndex < 9 then
		SoraDPlaySound()
		self.equipIndex = self.equipIndex + 1
		self.weaponID = miraculousWeaponltCtrl.getWeaponIDByIndex(self.equipIndex)
		self:setWeaponInfo()
		self:setBtnLeftRight()
		self.pagePoint:setCurLight(self.equipIndex)
		self.PageView_chips:scrollToPage(self.equipIndex - 1)
	end
end
function godEquipmentView:btnTipCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("weapon_text_12"))
	end
end
function godEquipmentView:btnEquipCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:changeState(true)
		self:setShowModel()
		self:setFreeTimes()
	end
end
function godEquipmentView:btnGadCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:changeState(false)
		self.Bottom_Node_awake:setVisible(false)
		self.Bottom_Node_awaked:setVisible(false)
	end
end
function godEquipmentView:closePanel(...)
	local superClosePanel = include("basePanel").closePanel
	if self.showModel == modelConfig.MULTIPREVIEW and self.Node_god:isVisible() then
		self:setWeaponInfo()
	else
		superClosePanel(self)
	end
end
return godEquipmentView
