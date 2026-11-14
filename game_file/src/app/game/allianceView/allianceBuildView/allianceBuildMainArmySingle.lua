local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local lordLocalData = include("lordLocalData")
local AllianceBuildMainArmySingle = class("allianceBuildMainArmySingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceBuildMainArmySingle")
	end
	return target
end)
function AllianceBuildMainArmySingle:ctor()
	self.tableArmy, _ENV, self.tableMemberData, _ENV = nil, nil, nil, nil
	self.isLaunched = false
	self.isOwn = false
	self.handle = nil
	self.scroll = nil
	self.singleIsMoved = false
	self.imgBg1 = SoraDGetChildByName(self, "Image_bgD")
	self.spriteIcon = SoraDGetChildByName(self, "Sprite_icon")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelCount = SoraDGetChildByName(self, "Text_count")
	self.spriteArr = SoraDGetChildByName(self, "Sprite_arr")
	self.btnInfo = SoraDGetChildByName(self, "Button_info")
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.layerTouch:setSwallowTouches(false)
	self.layerMember = SoraDGetChildByName(self, "Panel_member")
	self.layerMember:setSwallowTouches(false)
	self.layerTouch:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnInfo:addTouchEventListener(handler(self, self.btnLordClickCallBack))
end
function AllianceBuildMainArmySingle:initData(data, type)
	self.tableMemberData = data
	dump(self.tableMemberData, "AllianceBuildMainArmySingle:initData")
	self:showMemberSingle()
end
function AllianceBuildMainArmySingle:showMemberSingle()
	self.isOwn = lordInfoCtrl:getLordInfo().base.uid == self.tableMemberData.playerID
	self.btnInfo:setTitleText(self.isOwn and i18n("common_text_017") or i18n("common_text_501"))
	self:showMember()
	self:setState(self.isLaunched)
end
function AllianceBuildMainArmySingle:showMember()
	SoraDGetHeadFromManager(self.spriteIcon, self.tableMemberData.headid, self.tableMemberData.avatar)
	self.labelName:setString(self.tableMemberData.playerName)
	_ENV = nil
	;(nil).count = string.formatnumberthousands(self.tableMemberData.armyNum)
	self.labelCount:setString(i18n("common_text_556", nil))
end
function AllianceBuildMainArmySingle:getState()
	return self.isLaunched
end
function AllianceBuildMainArmySingle:setState(state)
	if self.isLaunched == state then
		return
	end
	if not state then
		self:removeArmy()
		self.spriteArr:setRotation(SoraDFPosX(90, 0))
	else
		self:initArmy()
		self.spriteArr:setRotation(0)
	end
	self.isLaunched = state
end
function AllianceBuildMainArmySingle:initArmy()
	local heroData = self.tableMemberData.heroInfo
	local armsData = self.tableMemberData.armsInfo
	local divineBeastData = self.tableMemberData.divineBeastInfo
	local hArmy = 100
	local hHero = 0
	local hArms = 0
	local posX = SoraDFPosX(320)
	local panelH = 100 * math.ceil(#self.tableMemberData.army) + hArmy
	if heroData and next(heroData) then
		local heroShowBanner = include("heroShowBanner").new()
		heroShowBanner:addTo(self.layerMember)
		heroShowBanner:initData(heroData)
		hHero = 140 + heroShowBanner:getExtendHeight()
		self.heroShowBanner = heroShowBanner
		panelH = panelH + hHero
	end
	if armsData and next(armsData) then
		local armsShowBanner = include("artifactShowBanner").new()
		armsShowBanner:addTo(self.layerMember)
		armsShowBanner:initData(armsData)
		self.armsShowBanner = armsShowBanner
	end
	if divineBeastData and next(divineBeastData) then
		self.divineBeastBanner = SoraDCreatePanel("commonDivinebeast")
		self.divineBeastBanner:setScale(0.85)
		self.divineBeastBanner:addTo(self.layerMember)
		self.divineBeastBanner:initData(divineBeastData[1], 2)
	end
	if self.armsShowBanner or self.divineBeastBanner then
		hArms = 140
		panelH = panelH + hArms
	end
	if self.heroShowBanner then
		self.heroShowBanner:setPosition(cc.p(posX, panelH + 70 - hArmy))
	end
	if self.armsShowBanner then
		self.armsShowBanner:setPosition(cc.p(posX, panelH + 70 - hArmy - hHero))
	end
	if self.divineBeastBanner then
		if self.armsShowBanner == nil then
			self.divineBeastBanner:setPositionX(SoraDFIsRA() and 550 or 90)
		else
			self.divineBeastBanner:setPositionX(SoraDFIsRA() and 200 or 450)
		end
		self.divineBeastBanner:setPositionY(panelH + 10 - hArmy - hHero)
	end
	self.layerMember:setContentSize(cc.size(640, panelH))
	self.imgBg1:setContentSize(cc.size(630, 30 + panelH))
	self.imgBg1:setPositionY(panelH + 30)
	for i, v in ipairs(self.tableMemberData.army) do
		local posY = panelH - i * 100 - hHero - hArms
		local single = self.tableArmy[i]
		if single == nil then
			single = include("commonArmySingle").new()
			single:addTo(self.layerMember)
			table.insert(self.tableArmy, single)
		end
		single:initData(v)
		single:setPosition(cc.p(posX, posY))
	end
end
function AllianceBuildMainArmySingle:removeArmy()
	for _, v in ipairs(self.tableArmy) do
		v:removeFromParent()
	end
	self.tableArmy, _ENV = ipairs(self.tableArmy)
	self.layerMember:setContentSize(cc.size(640, 0))
	self.imgBg1:setContentSize(cc.size(630, 30))
	self.imgBg1:setPositionY(30)
	if self.heroShowBanner then
		self.heroShowBanner:removeFromParent()
		self.heroShowBanner = nil
	end
	if self.armsShowBanner then
		self.armsShowBanner:removeFromParent()
		self.armsShowBanner = nil
	end
	if self.divineBeastBanner then
		self.divineBeastBanner:removeFromParent()
		self.divineBeastBanner = nil
	end
end
function AllianceBuildMainArmySingle:btnLordClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		if self.isOwn then
			local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
			kingdomMapCtrl:reqBackQueueById(self.tableMemberData.queueId)
		else
			SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
			_ENV = gametop.playertop_
			gametop.playertop_.targetName = self.__cname
			lordInfoCtrl:getLordInfoByUid(self.tableMemberData.playerID, gametop.playertop_:getKingdomID(), gametop.playertop_)
		end
	end
end
function AllianceBuildMainArmySingle:serverMessageGetLordInfo(target, data)
	if data.clientData then
		local targetName = data.clientData.targetName
		if targetName == self.__cname and data.lord then
			SoraDOpenLordView(data.lord)
			SoraDRemoveMessageFromTargetByName(self, "MESSAGE_LORDINFO_BY_UID")
		end
	end
end
function AllianceBuildMainArmySingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local state = not self.isLaunched
		self:setState(state)
		if self.handle then
			self.handle(state, self.tableMemberData.queueId)
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function AllianceBuildMainArmySingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceBuildMainArmySingle:getSingleH()
	return self.layerTouch:getContentSize().height + (self.layerMember:getContentSize().height > 0 and self.layerMember:getContentSize().height or 0)
end
function AllianceBuildMainArmySingle:setClickCallBack(handle)
	self.handle = handle
end
return AllianceBuildMainArmySingle
