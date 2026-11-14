local gametop = gModuleMgr.getObject("gametop")
local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local nationalFlagRead = include("nationalFlagRead")
local legendKingRead = include("legendKingRead")
local kingdomNode = class("kingdomNode", function()
	local baseView = include("baseView")
	local view = baseView.new(cc.size(215, 230), false)
	return view
end)
function kingdomNode:ctor(param)
	self.relyView = nil
	self.isMoved = false
	self:setSwallowTouches(false)
	self:addTouchEventListener(handler(self, self.mainScenceOnShow))
	self.isNebulaTower = param.isNebulaTower
	self.kid = param.kid or 1
	self.flag = nil
	self.isHaveKing = false
	self.isOwnKingdom = self.kid == gametop.playertop_:getMapID()
	if not self.isNebulaTower and self.isOwnKingdom then
		local imgOwn = display.newSprite("#icon_map_res_me.png")
		imgOwn:setScale(0.5)
		imgOwn:setPosition(cc.p(self:getContentSize().width / 2, self:getContentSize().height - 50))
		gametop = imgOwn
		imgOwn[1] = cca.moveBy(1, 0, -10)
		imgOwn[2] = cca.moveBy(1, 0, 10)
		imgOwn[3] = cca.moveBy(1, 0, 10)
		imgOwn[4] = cca.moveBy(1, 0, 10)
		imgOwn[5] = cca.moveBy(1, 0, 10)
		imgOwn[6] = cca.moveBy(1, 0, 10)
		imgOwn[7] = cca.moveBy(1, 0, 10)
		imgOwn[8] = cca.moveBy(1, 0, 10)
		imgOwn[9] = cca.moveBy(1, 0, 10)
		imgOwn[10] = cca.moveBy(1, 0, 10)
		imgOwn[11] = cca.moveBy(1, 0, 10)
		imgOwn[12] = cca.moveBy(1, 0, 10)
		local seq = cca.seq(imgOwn)
		imgOwn:runAction(cc.RepeatForever:create(seq))
		self:addChild(imgOwn, 5)
	end
	local kbg = display.newSprite("#frame_SJDT_mingpai.png")
	kbg:setPosition(cc.p(self:getContentSize().width / 2, 58))
	kbg:setOpacity(102.0)
	self:addChild(kbg, 1)
	self.kbg = kbg
	self.labKName = ccui.Text:create("", "", 22)
	self.labKName:setTextColor(cc.c4b(255, 200, 100, 255))
	self.labKName:setPosition(cc.p(self:getContentSize().width / 2, 58))
	self:addChild(self.labKName, 2)
	local ubg = display.newSprite("#frame_SJDT_mingpai.png")
	ubg:setPosition(cc.p(self:getContentSize().width / 2, 20))
	ubg:setOpacity(63.75)
	self.ubg = ubg
	self:addChild(ubg, 1)
	self.labUName = ccui.Text:create("", "", 22)
	self.labUName:setTextColor(cc.c4b(255, 245, 230, 255))
	self.labUName:setPosition(cc.p(self:getContentSize().width / 2, 20))
	self:addChild(self.labUName, 2)
	local bgImgWidth = 40
	local bgImgHeight = 40
	local kingdomLvImg = ccui.ImageView:create()
	self.kingdomLvImg = kingdomLvImg
	kingdomLvImg:loadTexture("icon_map_kingdomlv.png", ccui.TextureResType.plistType)
	kingdomLvImg:ignoreContentAdaptWithSize(false)
	self:addChild(kingdomLvImg)
	self.labKNameLv = ccui.Text:create("", "", 18)
	self.labKNameLv:setTextColor(cc.c4b(255, 255, 255, 255))
	self.labKNameLv:setAnchorPoint(cc.p(0.5, 0.5))
	self.labKNameLv:setSkewY(25)
	self.labKNameLv:setPosition(cc.p(bgImgWidth / 2 + 15, bgImgHeight / 2))
	kingdomLvImg:addChild(self.labKNameLv, 2)
	local lkbg = display.newSprite("#frame_SJDT_mingpai.png")
	lkbg:setPosition(cc.p(self:getContentSize().width / 2, 96))
	lkbg:setOpacity(102.0)
	self:addChild(lkbg, 1)
	self.lkbg = lkbg
	self.labLKName = ccui.Text:create("", "", 22)
	self.labLKName:setTextColor(cc.c4b(255, 200, 100, 255))
	self.labLKName:setPosition(cc.p(self:getContentSize().width / 2, 96))
	self:addChild(self.labLKName, 2)
	local lkIcon = ccui.ImageView:create()
	lkIcon:loadTexture("icon_legendary_14.png", ccui.TextureResType.plistType)
	lkIcon:setPosition(cc.p(self:getContentSize().width / 2, 96))
	self:addChild(lkIcon)
	self.lkIcon = lkIcon
	if SoraDFIsRA() then
		self.lkIcon:setPositionX(self:getContentSize().width / 2 - 55)
	else
		self.lkIcon:setPositionX(self:getContentSize().width / 2 + 55)
	end
	_UPVALUE3_ = self.lkIcon.setPositionX
	self.tbNodesLK, self.lkIcon.setPositionX[1] = self.lkIcon.setPositionX, self.lkbg
	self.tbNodesLK, self.lkIcon.setPositionX[2] = self.lkIcon.setPositionX, self.labLKName
	self.tbNodesLK, self.lkIcon.setPositionX[3] = self.lkIcon.setPositionX, self.lkIcon
	local ksbg = display.newSprite("#frame_SJDT_mingpai.png")
	ksbg:setPosition(cc.p(self:getContentSize().width / 2, 96))
	ksbg:setOpacity(102.0)
	self:addChild(ksbg, 1)
	self.ksbg = ksbg
	self.labKSName = ccui.Text:create("", "", 22)
	self.labKSName:setTextColor(cc.c4b(255, 200, 100, 255))
	self.labKSName:setPosition(cc.p(self:getContentSize().width / 2, 96))
	self:addChild(self.labKSName, 2)
	local ksIcon = ccui.ImageView:create()
	ksIcon:loadTexture("icon_legendary_14.png", ccui.TextureResType.plistType)
	ksIcon:setPosition(cc.p(self:getContentSize().width / 2, 96))
	self:addChild(ksIcon)
	self.ksIcon = ksIcon
	if SoraDFIsRA() then
		self.ksIcon:setPositionX(self:getContentSize().width / 2 - 55)
	else
		self.ksIcon:setPositionX(self:getContentSize().width / 2 + 55)
	end
	_UPVALUE3_ = self.ksIcon.setPositionX
	self.tbNodesKS, self.ksIcon.setPositionX[1] = self.ksIcon.setPositionX, self.ksbg
	self.tbNodesKS, self.ksIcon.setPositionX[2] = self.ksIcon.setPositionX, self.labKSName
	self.tbNodesKS, self.ksIcon.setPositionX[3] = self.ksIcon.setPositionX, self.ksIcon
	self:refreshData(param)
end
function kingdomNode:refreshData(param)
	if self.isNebulaTower then
		nationalFlagRead = nil
		;(nil)[1] = self.ubg
		;(nil)[2] = self.labUName
		for i, v in ipairs(nil) do
			v:setVisible(false)
		end
		SoraDSetNodeArrayVisible(self.tbNodesLK, false)
		SoraDSetNodeArrayVisible(self.tbNodesKS, false)
		self.labKName:setString(i18n("nebula_war_text_0152"))
		self:updateKingdomLv(param)
		self:reAlignNodes()
		return
	end
	local kingdomName = i18n("common_text_480")
	local kingName, flagId
	if param then
		if param.kname then
			kingdomName = string.gsub(param.kname, "\n", "")
		end
		if param.uname then
			kingName = string.gsub(param.uname, "\n", "")
		end
		flagId = param.flagid
	else
		local isK, kInfo = kingdomCtrl:isFoundKingdomID(self.kid)
		if isK then
			kingdomName = string.gsub(kInfo.kname, "\n", "")
			kingName = kInfo.uname
			flagId = kInfo.flagid
		end
	end
	if kingName and string.len(kingName) > 0 then
		self.isHaveKing = true
	end
	if kingName == nil then
		kingName = i18n("common_text_480")
	end
	if worldMapDefine.isLegendLordKingdomID(self.kid) then
		self.labKName:setString(i18n("common_text_4244"))
		local name = kingName
		if param then
			if param.aabbr then
				_ENV = i18n("common_text_4244")
				i18n("common_text_4244").abbr = param.aabbr
				i18n("common_text_4244").name = name
				name = i18n("common_text_186", i18n("common_text_4244"))
			end
			if param.ukid then
				name = name .. "#" .. tostring(param.ukid)
			end
		end
		_ENV = i18n("common_text_4244")
		i18n("common_text_4244").name = name
		self.labUName:setString(i18n("legendaryking_text_07", i18n("common_text_4244")))
	else
		self.labKName:setString(kingdomName)
		local isOccupy = kingdomCtrl:isOccupy(self.kid)
		if isOccupy then
			self.labUName:setString(i18n("common_text_2083"))
			self.labUName:setTextColor(cc.c4b(255, 0, 0, 255))
		else
			_ENV = cc.c4b(255, 0, 0, 255)
			cc.c4b(255, 0, 0, 255).kingName = kingName
			self.labUName:setString(i18n("common_text_529", cc.c4b(255, 0, 0, 255)))
			self.labUName:setTextColor(cc.c4b(255, 245, 230, 255))
		end
	end
	if self.flag then
		self.flag:removeFromParent()
		self.flag = nil
	end
	if self.isHaveKing and flagId then
		local flagImg = nationalFlagRead.getImgByID(flagId)
		if flagImg then
			self.flag = SoraDCreateWaveNode(flagImg)
			self.flag:setScale(0.5)
			self:addChild(self.flag, 2)
			self.flag:SetPivot(0, 0.5, false)
			self.flag:setPosition(cc.p(200, 90))
		end
	end
	if param.bestKingdom and param.bestKingdom.valid then
		self:setBestKingdom(param)
	else
		self:removeBestKingdom()
	end
	self:updateKingdomLv(param)
	local titleID = param.kingdomTitle
	self.titleID = titleID
	if titleID and titleID ~= 0 then
		SoraDSetNodeArrayVisible(self.tbNodesLK, true)
		local officialName = legendKingRead.getOfficialName(gLegendBuffType.KINGDOM, titleID)
		self.labLKName:setString(officialName)
		local iconName = legendKingRead.getOfficialIcon(gLegendBuffType.KINGDOM, titleID)
		self.lkIcon:setContentSize(cc.size(40, 40))
		self.lkIcon:ignoreContentAdaptWithSize(false)
		self.lkIcon:loadTexture(iconName, ccui.TextureResType.plistType)
	else
		SoraDSetNodeArrayVisible(self.tbNodesLK, false)
	end
	local kingStarTitleID = param.legendForSepKingdomTitle
	self.kingStarTitleID = kingStarTitleID
	if kingStarTitleID and kingStarTitleID ~= 0 then
		SoraDSetNodeArrayVisible(self.tbNodesKS, true)
		local officialName = legendKingRead.getOfficialName(gLegendBuffType.KINGDOM, kingStarTitleID, self.kid)
		self.labKSName:setString(officialName)
		local iconName = legendKingRead.getOfficialIcon(gLegendBuffType.KINGDOM, kingStarTitleID, self.kid)
		self.ksIcon:setContentSize(cc.size(40, 40))
		self.ksIcon:ignoreContentAdaptWithSize(false)
		self.ksIcon:loadTexture(iconName, ccui.TextureResType.plistType)
	else
		SoraDSetNodeArrayVisible(self.tbNodesKS, false)
	end
	self:refreshAtlantisTitle(param.atlantisTitle)
	self:reAlignNodes()
	if commonCheck.MOVE_CITY_ACTIVIYT then
		self:setMoveInOutState()
	end
end
function kingdomNode:updateKingdomLv(param)
	local curKingdomLv = param.kingdomLevel or 0
	if self.isNebulaTower or 1 <= curKingdomLv then
		self.kingdomLvImg:setVisible(true)
		self.labKNameLv:setString(curKingdomLv)
		local posX = self.labKName:getPositionX() + self.labKName:getContentSize().width / 2 + self.kingdomLvImg:getContentSize().width / 2
		local posY = 63
		self.kingdomLvImg:setPosition(cc.p(posX, posY))
	else
		self.kingdomLvImg:setVisible(false)
	end
end
function kingdomNode:reAlignNodes()
	local _ENV, tbNodesArray
	if self.titleID and self.titleID ~= 0 then
		_UPVALUE2_ = nil
		;(nil)[1] = self.labLKName
		;(nil)[2] = self.lkIcon
		_UPVALUE1_ = self.lkIcon
		self.lkIcon[1] = 5
		SoraDAlignNodeArray(nil, SoraDFIsRA(), self.lkIcon)
		_UPVALUE3_ = SoraDFIsRA()
		SoraDFIsRA()[1] = self.lkbg
		SoraDFIsRA()[2] = self.labLKName
		SoraDFIsRA()[3] = self.lkIcon
		table.insert(tbNodesArray, (SoraDFIsRA()))
	end
	if self.kingStarTitleID and self.kingStarTitleID ~= 0 then
		_UPVALUE2_ = tbNodesArray
		tbNodesArray[1] = self.labKSName
		tbNodesArray[2] = self.ksIcon
		_UPVALUE1_ = self.ksIcon
		self.ksIcon[1] = 5
		SoraDAlignNodeArray(tbNodesArray, SoraDFIsRA(), self.ksIcon)
		_UPVALUE3_ = SoraDFIsRA()
		SoraDFIsRA()[1] = self.ksbg
		SoraDFIsRA()[2] = self.labKSName
		SoraDFIsRA()[3] = self.ksIcon
		table.insert(tbNodesArray, (SoraDFIsRA()))
	end
	_UPVALUE2_ = table.insert
	table.insert[1] = self.kbg
	local table.insert[2], groupK = self.labKName, table.insert
	if self.flag then
		table.insert(groupK, self.flag)
		_UPVALUE2_ = groupK
		groupK[1] = self.labKName
		groupK[2] = self.flag
		_UPVALUE1_ = self.flag
		self.flag[1] = 5
		SoraDAlignNodeArray(groupK, SoraDFIsRA(), self.flag)
	end
	table.insert(tbNodesArray, groupK)
	_UPVALUE2_ = groupK
	groupK[1] = self.ubg
	groupK[2] = self.labUName
	table.insert(tbNodesArray, groupK)
	if self.atlantisTitle then
		_UPVALUE1_ = groupK
		groupK[1] = self.Node_atlantisTitle
		table.insert(tbNodesArray, groupK)
	end
	for i, group in ipairs(tbNodesArray) do
		for _, v in ipairs(group) do
			v:setPositionY(20 - 42 * (i - 1))
		end
	end
end
function kingdomNode:setBestKingdom(kingdomData)
	if not self.bestNode then
		local worldMapEffect = include("worldMapEffect")
		local leftTime = kingdomData.bestKingdom.endtime - serviceFunctions.systemTime()
		self.bestNode = worldMapEffect.createRamadanKingdomEffect(leftTime)
		self.bestNode:setPosition(cc.p(108, 250))
		self.bestNode:addTo(self, 9)
	end
end
function kingdomNode:removeBestKingdom()
	if self.bestNode then
		self.bestNode:removeFromParent()
		self.bestNode = nil
	end
end
function kingdomNode:setWarStatus(isInWar)
	if isInWar then
		if not self.fight then
			self.fight = SoraDGetFightingEffect(false)
			self.fight:setPosition(cc.p(108, 80))
			self.fight:addTo(self, 10)
		end
	elseif self.fight then
		self.fight:removeFromParent()
		self.fight = nil
	end
end
function kingdomNode:mainScenceOnShow(button, event)
	if event == ccui.TouchEventType.ended then
		if self.isMoved then
			return
		end
		if not self.isNebulaTower and commonCheck.MOVE_CITY_ACTIVIYT and not self.isOwnKingdom and kingdomCtrl:getCanMoveOut(self.kid) then
			return
		end
		_ENV = kingdomCtrl
		kingdomCtrl.msg = "MESSAGE_WORLD_MAP_KINGDOM_CHANGE"
		kingdomCtrl.kid = self.kid
		kingdomCtrl.isNebulaTower = self.isNebulaTower
		SoraDSendMessage(kingdomCtrl)
		self.isMoved = false
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = self:getTouchBeganPosition()
		local touchmovePoint = self:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.isMoved = true
		end
	elseif event == ccui.TouchEventType.began then
		self.isMoved = false
	end
end
function kingdomNode:setMoveInOutState(...)
	if not self.isOwnKingdom and kingdomCtrl:getCanMoveOut(self.kid) then
		if not self.effectOut then
			local effect = SoraDCreatAnimation("baiyun")
			effect:setPosition(cc.p(self:getContentSize().width / 2, self:getContentSize().height / 2))
			self:addChild(effect, 2)
			self.effectOut = effect
		end
	elseif self.effectOut then
		self.effectOut:removeFromParent()
		self.effectOut = nil
	end
	if activityShowCtrl:getCanMoveIn(self.kid) then
		if not self.effectIn then
			local effect = SoraDCreatAnimation("csm")
			effect:setPosition(cc.p(self:getContentSize().width / 2, self:getContentSize().height / 2))
			effect:setScale(0.9)
			self:addChild(effect, 2)
			self.effectIn = effect
		end
	elseif self.effectIn then
		self.effectIn:removeFromParent()
		self.effectIn = nil
	end
end
function kingdomNode:refreshAtlantisTitle(atlantisTitle)
	self.atlantisTitle = atlantisTitle
	if atlantisTitle then
		if not self.Node_atlantisTitle then
			local node = display.newNode()
			node:addTo(self)
			node:setName("Node_atlantisTitle")
			node:setPosition(cc.p(self:getContentSize().width / 2, 96))
			self.Node_atlantisTitle = node
			local atlantisBg = ccui.ImageView:create("frame_shmc_kingdom_nameplate.png", ccui.TextureResType.plistType)
			atlantisBg:addTo(node)
			atlantisBg:setScale9Enabled(true)
			atlantisBg:setCapInsets(cc.rect(120, 10, 10, 10))
			atlantisBg:setContentSize(cc.size(350, 92))
			local atlantisName = ccui.Text:create("", "", 22)
			atlantisName:setTextColor(cc.c4b(255, 200, 100, 255))
			atlantisName:addTo(node)
			SoraDSetTextWidthHeight(atlantisName, cc.size(350, 40))
			atlantisName:setPosition(0, -12)
			atlantisName:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
			atlantisName:setTextVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)
			self.atlantisName = atlantisName
		else
			self.Node_atlantisTitle:setVisible(true)
		end
		_ENV = true
		;(true).season = atlantisTitle
		local seasonStr = i18n("atlantiswar_text_0399", true)
		self.atlantisName:setString(seasonStr)
	elseif self.Node_atlantisTitle then
		self.Node_atlantisTitle:setVisible(false)
	end
end
return kingdomNode
