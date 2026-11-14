local resDesRead = include("resDesRead")
local CommonResourcesMenu = class("commonResourcesMenu", function(target)
	if target == nil then
		return SoraDCreateBasePanel("commonResourcesMenu")
	end
	return target
end)
function CommonResourcesMenu:ctor()
	self.tableLabel, _ENV, self.tableRescources, _ENV = nil, nil, nil, nil
	self.isMainUIHiddle = true
	self.isAnimation = false
	self.itemScale = 1
	self.needScale = false
	self.btnMithril = SoraDGetChildByName(self, "Button_mithril")
	self.labelMithril = SoraDGetChildByName(self, "Text_mithril")
	self.imgMithril = SoraDGetChildByName(self, "Sprite_mithril")
	self.imgMithril:setTag(gIDDef.MITHRIL)
	self.btnIron = SoraDGetChildByName(self, "Button_iron")
	self.labelIron = SoraDGetChildByName(self, "Text_iron")
	self.imgIron = SoraDGetChildByName(self, "Sprite_iron")
	self.imgIron:setTag(gIDDef.IRON)
	self.imgIron:setScale(0.85)
	self.btnFood = SoraDGetChildByName(self, "Button_food")
	self.labelFood = SoraDGetChildByName(self, "Text_food")
	self.imgFood = SoraDGetChildByName(self, "Sprite_food")
	self.imgFood:setTag(gIDDef.FOOD)
	self.btnWood = SoraDGetChildByName(self, "Button_wood")
	self.labelWood = SoraDGetChildByName(self, "Text_wood")
	self.imgWood = SoraDGetChildByName(self, "Sprite_wood")
	self.imgWood:setTag(gIDDef.WOOD)
	self.btnCrystal = SoraDGetChildByName(self, "Button_crystal")
	self.labelCrystal = SoraDGetChildByName(self, "Text_crystal")
	self.imgCrystal = SoraDGetChildByName(self, "Sprite_crystal")
	self.imgCrystal:setTag(gIDDef.CRYSTAL)
	self.btnMeteor = SoraDGetChildByName(self, "Button_meteor")
	self.labelMeteor = SoraDGetChildByName(self, "Text_meteor")
	self.imgMeteor = SoraDGetChildByName(self, "Sprite_meteor")
	self.imgMeteor:setTag(gIDDef.METEOR_CRYSTAL)
	self.Node_style_bg = SoraDGetChildByName(self, "Node_style_bg")
	self.Node_style_top = SoraDGetChildByName(self, "Node_style_top")
	self.tableLabel[gIDDef.FOOD] = self.btnFood
	self.tableLabel[gIDDef.WOOD] = self.btnWood
	self.tableLabel[gIDDef.IRON] = self.btnIron
	self.tableLabel[gIDDef.MITHRIL] = self.btnMithril
	self.tableLabel[gIDDef.CRYSTAL] = self.btnCrystal
	self.tableLabel[gIDDef.METEOR_CRYSTAL] = self.btnMeteor
	self.btnMithril:addTouchEventListener(handler(self, self.OnBtnClick))
	self.btnIron:addTouchEventListener(handler(self, self.OnBtnClick))
	self.btnFood:addTouchEventListener(handler(self, self.OnBtnClick))
	self.btnWood:addTouchEventListener(handler(self, self.OnBtnClick))
	self.btnCrystal:addTouchEventListener(handler(self, self.OnBtnClick))
	self.btnMeteor:addTouchEventListener(handler(self, self.OnBtnClick))
	self:updateResource()
	self:initStyle()
end
function CommonResourcesMenu:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.updateResourceAction))
	SoraDAddMessage(self, "MESSAGE_MAINCITY_UPDATE_MAINUITOP_HEADPOS", handler(self, self.updateResource))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILD_QUEQUE_CALLBACK", function(target, data)
		if data.bid == BUILDID.CASTLE then
			self:updateResource()
		end
	end)
end
function CommonResourcesMenu:initStyle()
	_ENV = nil
	_ENV = nil
	;(nil)[gMainUIStype.EASTER], (nil).bg = nil, "Node_resource_style_easter_bg"
	_ENV = nil
	;(nil)[gMainUIStype.HALLOWEEN], (nil).bg = nil, "Node_resource_style_halloween_bg"
	_ENV = nil
	;(nil)[gMainUIStype.CHRITMAS], (nil).top = nil, "Node_resource_style_chritmas_top"
	_ENV = nil
	;(nil)[gMainUIStype.QUICKSAND], (nil).bg = nil, "Node_resource_style_ztsz_bg"
	;(nil)[gMainUIStype.ROSNORMAL], _ENV = nil, nil
	local param
	local cfg = param[GLOBAL_MAINUI_STYLE] or param[gMainUIStype.QUICKSAND]
	if cfg.bg then
		local bgNode = SoraDCreatAnimation(cfg.bg, nil, cfg.isLoop or false)
		bgNode:addTo(self.Node_style_bg)
		if GLOBAL_MAINUI_STYLE == gMainUIStype.EASTER then
			local spine_dingkuang1 = sp.SkeletonAnimation:create("spine/dingkuang01.skel", "spine/dingkuang01.atlas", 1.0)
			spine_dingkuang1:setAnimation(0, "animation", true)
			spine_dingkuang1:setPosition(cc.p(SoraDFPosX(50), -38))
			spine_dingkuang1:addTo(bgNode)
			local spine_dingkuang2 = sp.SkeletonAnimation:create("spine/dingkuang02.skel", "spine/dingkuang02.atlas", 1.0)
			spine_dingkuang2:setAnimation(0, "animation", true)
			spine_dingkuang2:setPosition(cc.p(SoraDFPosX(130), -38))
			spine_dingkuang2:setScaleX(-1)
			spine_dingkuang2:addTo(bgNode)
		end
	end
	if cfg.top then
		local topNode = SoraDCreatAnimation(cfg.top, nil, cfg.isLoop or false)
		topNode:addTo(self.Node_style_top)
	end
end
function CommonResourcesMenu:getResTarget(resid)
	if resid == gIDDef.FOOD then
		return self.imgFood
	elseif resid == gIDDef.WOOD then
		return self.imgWood
	elseif resid == gIDDef.IRON then
		return self.imgIron
	elseif resid == gIDDef.MITHRIL then
		return self.imgMithril
	elseif resid == gIDDef.CRYSTAL then
		return self.imgCrystal
	elseif resid == gIDDef.METEOR_CRYSTAL then
		return self.imgMeteor
	end
end
function CommonResourcesMenu:updateResourceAction(target, data)
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local isAnimate = false
	for k, v in pairs(data.reslist) do
		local v = math.floor(v)
		if v ~= 0 then
			isAnimate = true
			break
		end
	end
	if not isAnimate then
		return
	end
	local animate = data.animate
	if animate then
		for k, v in pairs(data.reslist) do
			local resid = tonumber(k)
			local curcount = cityCtrl:getResCount(resid)
			if 0 < curcount then
				local single = self.tableLabel[resid]
				if single == nil then
					return
				end
				local v = math.floor(v)
				local text = 0 < v and "+" .. tostring(v) or tostring(v)
				local color = 0 < v and display.COLOR_GREEN or display.COLOR_RED
				local floatingLabel = ccui.Text:create("", "", 19)
				floatingLabel:setString(text)
				floatingLabel:setColor(color)
				floatingLabel:setOpacity(0)
				local offsetY = 0 < v and 30 or -30
				local posY = 0 < v and -30 or -15
				local mainUI = SoraDCurrentMainUI()
				if not mainUI:isVisible() then
					mainUI = self
				end
				local _offsetX = -10
				if not SoraDFIsRA() then
					_offsetX = 10
				end
				floatingLabel:setAnchorPoint(single:getAnchorPoint())
				local point = self:convertToWorldSpace(cc.p(single:getPositionX() + _offsetX, single:getPositionY() + posY))
				point = mainUI:convertToNodeSpace(point)
				floatingLabel:setPosition(point)
				floatingLabel:addTo(mainUI, 999)
				local moveBy = cca.moveBy(0.4, 0, offsetY)
				local callFunc = cca.callFunc(function()
					floatingLabel:removeFromParent()
				end)
				_UPVALUE3_ = offsetY
				offsetY[1] = cca.fadeIn(1.5)
				offsetY[2] = moveBy
				offsetY[3] = callFunc
				local seq = cca.seq(offsetY)
				if self.isAnimation then
					_UPVALUE4_ = cca.fadeIn(1.5)
					cca.fadeIn(1.5)[1] = cca.fadeIn(0.8)
					cca.fadeIn(1.5)[2] = cca.delay(0.2)
					cca.fadeIn(1.5)[3] = moveBy
					cca.fadeIn(1.5)[4] = callFunc
					seq = transition.sequence((cca.fadeIn(1.5)))
				end
				floatingLabel:runAction(seq)
				if self.isAnimation then
					self:activeResIcon(resid, 1.5, 5)
				end
			end
		end
	end
	self:updateResource()
end
function CommonResourcesMenu:OnBtnClick(button, type)
	if type == ccui.TouchEventType.ended then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
		SoraDSendMessage(nil)
		if button == self.btnMeteor then
			SoraDPlaySound("uicontrol", 23)
			if SoraDResIsLock(gIDDef.METEOR_CRYSTAL) then
				_ENV = nil
				;(nil).rid = gIDDef.METEOR_CRYSTAL
				uiManager:show("meteorBuyView", nil)
			end
		else
			local resID
			if button == self.btnMithril then
				SoraDPlaySound("uicontrol", 27)
				if SoraDResIsLock(gIDDef.MITHRIL) then
					resID = gIDDef.MITHRIL
				end
			elseif button == self.btnIron then
				SoraDPlaySound("uicontrol", 26)
				if SoraDResIsLock(gIDDef.IRON) then
					resID = gIDDef.IRON
				end
			elseif button == self.btnFood then
				SoraDPlaySound("uicontrol", 24)
				resID = gIDDef.FOOD
			elseif button == self.btnWood then
				SoraDPlaySound("uicontrol", 28)
				resID = gIDDef.WOOD
			elseif button == self.btnCrystal then
				SoraDPlaySound("uicontrol", 23)
				if SoraDResIsLock(gIDDef.CRYSTAL) then
					resID = gIDDef.CRYSTAL
				end
			end
			_ENV = gIDDef.METEOR_CRYSTAL
			gIDDef.METEOR_CRYSTAL.rid = resID
			uiManager:show("resourceBuyView", gIDDef.METEOR_CRYSTAL)
		end
	end
end
function CommonResourcesMenu:activeResIcon(rid, delayTime, blinkTime)
	_ENV, rid = tonumber(rid), tonumber(rid)
	tonumber(rid)[gIDDef.FOOD] = self.imgFood
	tonumber(rid)[gIDDef.WOOD] = self.imgWood
	tonumber(rid)[gIDDef.IRON] = self.imgIron
	tonumber(rid)[gIDDef.MITHRIL] = self.imgMithril
	tonumber(rid)[gIDDef.CRYSTAL] = self.imgCrystal
	local tonumber(rid)[gIDDef.METEOR_CRYSTAL], resOCXList = self.imgMeteor, tonumber(rid)
	local curRes = resOCXList[rid]
	local _ENV, acTable = self.imgMeteor, self.imgMeteor
	local delayAction1 = cca.delay(delayTime)
	local action0 = cca.scaleTo(0.1, 1.2)
	local action1 = cca.scaleTo(0.1, 0.8)
	local action2 = cca.scaleTo(0.1, 1)
	table.insert(acTable, delayAction1)
	for i = 1, blinkTime do
		table.insert(acTable, action0)
		table.insert(acTable, action1)
		table.insert(acTable, action2)
	end
	curRes:runAction(cca.seq(acTable))
end
function CommonResourcesMenu:getResWorldPos(rid)
	_ENV, rid = tonumber(rid), tonumber(rid)
	tonumber(rid)[gIDDef.FOOD] = self.btnFood
	tonumber(rid)[gIDDef.WOOD] = self.btnWood
	tonumber(rid)[gIDDef.IRON] = self.btnIron
	tonumber(rid)[gIDDef.MITHRIL] = self.btnMithril
	tonumber(rid)[gIDDef.CRYSTAL] = self.btnCrystal
	local tonumber(rid)[gIDDef.METEOR_CRYSTAL], resOCXList = self.btnMeteor, tonumber(rid)
	local curRes = resOCXList[rid]
	local offsetX = -33
	if SoraDFIsRA() then
		offsetX = 33
	end
	return self:convertToWorldSpace(cc.p(curRes:getPositionX() + offsetX, curRes:getPositionY()))
end
function CommonResourcesMenu:updateResource()
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	_UPVALUE6_ = gametop.playertop_
	gametop.playertop_[1] = gIDDef.WOOD
	gametop.playertop_[2] = gIDDef.FOOD
	gametop.playertop_[3] = gIDDef.IRON
	gametop.playertop_[4] = gIDDef.MITHRIL
	gametop.playertop_[5] = gIDDef.CRYSTAL
	local gametop.playertop_[6], tableKey = gIDDef.METEOR_CRYSTAL, gametop.playertop_
	self.tableRescources.wood = cityCtrl:getResCount(tableKey[1])
	self.tableRescources.food = cityCtrl:getResCount(tableKey[2])
	self.tableRescources.iron = cityCtrl:getResCount(tableKey[3])
	self.tableRescources.mithril = cityCtrl:getResCount(tableKey[4])
	self.tableRescources.crystal = cityCtrl:getResCount(tableKey[5])
	self.tableRescources.meteor = cityCtrl:getResCount(tableKey[6])
	self.enableWood = SoraDResIsLock(tableKey[1])
	self.enableFood = SoraDResIsLock(tableKey[2])
	self.enableIron = SoraDResIsLock(tableKey[3])
	self.enableMithril = SoraDResIsLock(tableKey[4])
	self.enableCrystal = SoraDResIsLock(tableKey[5])
	self.enableMeteor = SoraDResIsLock(tableKey[6])
	_UPVALUE3_ = tableKey[6]
	tableKey[6][1] = self.btnWood
	tableKey[6][2] = self.labelWood
	tableKey[6][3] = self.imgWood
	SoraDSetNodeArrayVisible(tableKey[6], self.enableWood)
	_UPVALUE3_ = tableKey[6]
	tableKey[6][1] = self.btnFood
	tableKey[6][2] = self.labelFood
	tableKey[6][3] = self.imgFood
	SoraDSetNodeArrayVisible(tableKey[6], self.enableFood)
	_UPVALUE3_ = tableKey[6]
	tableKey[6][1] = self.btnIron
	tableKey[6][2] = self.labelIron
	tableKey[6][3] = self.imgIron
	SoraDSetNodeArrayVisible(tableKey[6], self.enableIron)
	_UPVALUE3_ = tableKey[6]
	tableKey[6][1] = self.btnMithril
	tableKey[6][2] = self.labelMithril
	tableKey[6][3] = self.imgMithril
	SoraDSetNodeArrayVisible(tableKey[6], self.enableMithril)
	_UPVALUE3_ = tableKey[6]
	tableKey[6][1] = self.btnCrystal
	tableKey[6][2] = self.labelCrystal
	tableKey[6][3] = self.imgCrystal
	SoraDSetNodeArrayVisible(tableKey[6], self.enableCrystal)
	_UPVALUE3_ = tableKey[6]
	tableKey[6][1] = self.btnMeteor
	tableKey[6][2] = self.labelMeteor
	tableKey[6][3] = self.imgMeteor
	SoraDSetNodeArrayVisible(tableKey[6], self.enableMeteor)
	local _ENV, showList = SoraDSetNodeArrayVisible, SoraDSetNodeArrayVisible
	if self.enableFood then
		table.insert(showList, self.btnFood)
		self.labelFood:setString(SoraDConvertNumberWithUnit(self.tableRescources.food))
		self:updateResLabelColor(self.labelFood, self.tableRescources.food)
	end
	if self.enableWood then
		table.insert(showList, self.btnWood)
		self.labelWood:setString(SoraDConvertNumberWithUnit(self.tableRescources.wood))
		self:updateResLabelColor(self.labelWood, self.tableRescources.wood)
	end
	if self.enableIron then
		table.insert(showList, self.btnIron)
		self.labelIron:setString(SoraDConvertNumberWithUnit(self.tableRescources.iron))
		self:updateResLabelColor(self.labelIron, self.tableRescources.iron)
	end
	if self.enableMithril then
		table.insert(showList, self.btnMithril)
		self.labelMithril:setString(SoraDConvertNumberWithUnit(self.tableRescources.mithril))
		self:updateResLabelColor(self.labelMithril, self.tableRescources.mithril)
	end
	if self.enableCrystal then
		table.insert(showList, self.btnCrystal)
		self.labelCrystal:setString(SoraDConvertNumberWithUnit(self.tableRescources.crystal))
		self:updateResLabelColor(self.labelCrystal, self.tableRescources.crystal)
	end
	if self.enableMeteor then
		table.insert(showList, self.btnMeteor)
		self.labelMeteor:setString(SoraDConvertNumberWithUnit(self.tableRescources.meteor))
		self:updateResLabelColor(self.labelMeteor, self.tableRescources.meteor)
	end
	if 5 < #showList and self.needScale then
		self.itemScale = 0.9
		for k, v in pairs(showList) do
			v:setScale(self.itemScale)
		end
	end
	if not SoraDFIsRA() then
		showList = self:reverseTable(showList)
	end
	SoraDAlignNodeArrayOnBeginX(SoraDFPosX(640, 640), showList, true)
end
function CommonResourcesMenu:updateResLabelColor(label, value)
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	if value > cityCtrl:getResMaxTotal() then
		label:setColor(cc.c3b(190, 30, 0))
	else
		label:setColor(cc.c3b(255, 255, 255))
	end
end
function CommonResourcesMenu:reverseTable(tab)
	local _ENV, tmp
	local tabClone = clone(tab)
	for i = 1, #tabClone do
		tmp[i] = table.remove(tabClone)
	end
	return tmp
end
function CommonResourcesMenu:runAnimation()
	self.isAnimation = true
end
function CommonResourcesMenu:hiddleMainUI(isHiddle)
	self.isMainUIHiddle = isHiddle
end
function CommonResourcesMenu:onExitOther()
	if self.isMainUIHiddle then
		_ENV = nil
		;(nil).isHideMainUI = false
		SoraDHideCurrentSceneViewAndMainUI(nil)
	end
end
function CommonResourcesMenu:onEnterOther()
	if self.isMainUIHiddle then
		_ENV = nil
		;(nil).isHideMainUI = true
		SoraDHideCurrentSceneViewAndMainUI(nil)
	end
end
function CommonResourcesMenu:setNeedScale(needScale)
	self.needScale = needScale
	self:updateResource()
end
return CommonResourcesMenu
