local militaryFortressCtrl = SoraDGetCtrl("militaryFortressCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local militaryFortressRead = include("militaryFortressRead")
local militaryFortressHeroSelectView = class("militaryFortressHeroSelectView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("militaryFortressHeroSelectView")
end)
function militaryFortressHeroSelectView:ctor(properties)
	local armyCtrl = SoraDGetCtrl("armyCtrl")
	dump(heroCtrl:getHeroInDefend(), "armyCtrl", 10)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("fortress_text_06"))
	self.nodeNowHero = SoraDGetChildByName(self, "Node_NowHero")
	self.textNow = SoraDGetChildByName(self.nodeNowHero, "Text_Now")
	self.textNow:setString(i18n("common_text_4345"))
	self.nowHeroLockItem = SoraDGetExtendChildFromCCSByName(self.nodeNowHero, "CCS_militaryHeroItem")
	self.nowHeroLockItem:setNoneHero(false)
	self.scrollNowBuff = SoraDGetChildByName(self.nodeNowHero, "ScrollView_Buff")
	self.scrollNowBuff = include("buffScrollView").new(self.scrollNowBuff)
	self.scrollNowBuff:setProportion(0.7)
	self.scrollNowBuff:setBuffFontSize(16)
	self.nodeNewHero = SoraDGetChildByName(self, "Node_SelectedHero")
	self.newHeroLockItem = SoraDGetExtendChildFromCCSByName(self.nodeNewHero, "CCS_militaryHeroItem")
	self.newHeroLockItem:setNoneHero(false)
	self.scrollNewBuff = SoraDGetChildByName(self.nodeNewHero, "ScrollView_Buff")
	self.scrollNewBuff = include("buffScrollView").new(self.scrollNewBuff)
	self.scrollNewBuff:setProportion(0.7)
	self.scrollNewBuff:setBuffFontSize(16)
	SoraDGetChildByName(self, "Text_AttrTitle"):setString(i18n("common_btn_07"))
	SoraDGetChildByName(self, "Text_ScrollTitle"):setString(i18n("hero_title_07"))
	self.scrollHero = SoraDGetChildByName(self, "ScrollView_Hero")
	self.scrollHero = include("commonAutoScrollList").new(self.scrollHero)
	self.scrollHero:setSingleCCS("militaryHeroItem")
	self.btnSure = SoraDGetChildByName(self, "Button_Sure")
	self.btnSure:setTitleText(i18n("common_text_204"))
	self.btnSure:addTouchEventListener(handler(self, self.btnSureClick))
	self.singleProportion = SoraDGetChildByName(self, "Node_Single")
	self.arrIcon = SoraDGetChildByName(self, "frame_tdcq_xjt")
	self.textTip = SoraDGetChildByName(self, "Text_Tips")
	self.textTip:setString(i18n("fortress_text_34"))
end
function militaryFortressHeroSelectView:initData(campType, fortessType, pos)
	self.fortessType = fortessType
	self.campType = campType
	self.pos = pos
	self.orignHeroID = militaryFortressCtrl:getHeroID(fortessType, campType, pos)
	self.heroIDList = militaryFortressCtrl:getChooseHeroList(fortessType, campType, pos)
	militaryFortressCtrl = nil
	;(nil).scale = 0.75
	;(nil).addHandler = handler(self, self.changeHeroChoose)
	;(nil).canShowStatus = true
	;(nil).isAR = SoraDFIsRA()
	self.scrollHero:updateScrollView(cc.size(90, 100), self.heroIDList, 5, nil)
	self.selectHeroID = tonumber(self.heroIDList[1])
	local heroInfo = heroCtrl:getHeroInfoByID(self.selectHeroID)
	if 1 < heroInfo.state then
		self.selectHeroID = nil
	end
	self:initNowNode()
	if self.orignHeroID then
		self:initNewNode()
		self.arrIcon:setVisible(true)
		self.nodeNewHero:setVisible(true)
		self.nodeNowHero:setPositionX(SoraDFPosX(130.0, 0))
	else
		self.arrIcon:setVisible(false)
		self.nodeNewHero:setVisible(false)
		self.nodeNowHero:setPositionX(0)
	end
end
function militaryFortressHeroSelectView:initNowNode()
	if self.selectHeroID then
		self.scrollHero:getchildByIndex(1).point:setChoosed(true)
	end
	self:updateNowScroll(self.orignHeroID or self.selectHeroID)
end
function militaryFortressHeroSelectView:initNewNode()
	if not self.selectHeroID then
		return
	end
	if self.selectHeroID then
		self.scrollHero:getchildByIndex(1).point:setChoosed(true)
	end
	self:updateNewScroll()
end
function militaryFortressHeroSelectView:updateChooseHeroInfo()
	if self.orignHeroID then
		self:updateNewScroll()
	else
		self:updateNowScroll(self.selectHeroID)
	end
end
function militaryFortressHeroSelectView:updateNewScroll()
	self.newHeroLockItem:initData(self.selectHeroID)
	_ENV = nil
	;(nil).fortessType = self.fortessType
	;(nil).campType = self.campType
	;(nil).pos = self.pos
	;(nil).heroID = self.selectHeroID
	;(nil).oldHeroID = self.orignHeroID
	self.scrollNewBuff:updateScrollView(cc.size(224, 35), militaryFortressCtrl:getBuffByHeroPos(nil), 1)
	self:initProporTionNode(SoraDGetChildByName(self.nodeNewHero, "Node_Proportion"), self.selectHeroID)
end
function militaryFortressHeroSelectView:updateNowScroll(heroID)
	self.nowHeroLockItem:initData(heroID)
	_ENV = nil
	;(nil).fortessType = self.fortessType
	;(nil).campType = self.campType
	;(nil).pos = self.pos
	;(nil).heroID = heroID
	self.scrollNowBuff:updateScrollView(cc.size(224, 35), militaryFortressCtrl:getBuffByHeroPos(nil), 1)
	self:initProporTionNode(SoraDGetChildByName(self.nodeNowHero, "Node_Proportion"), heroID)
end
function militaryFortressHeroSelectView:initProporTionNode(parent, heroID)
	_ENV, _ENV = nil, nil
	;(nil).title = "fortress_text_07"
	_ENV, (nil)[1], (nil).propertyName = nil, nil, "rarity"
	;(nil).title = "fortress_text_08"
	_ENV, (nil)[2], (nil).propertyName = nil, nil, "level"
	;(nil).title = "fortress_text_09"
	;(nil)[3], (nil).propertyName = nil, "power"
	local titleConfig
	local nodeList = parent:getChildren()
	for i = 1, 3 do
		local single
		if nodeList[i] then
			single = nodeList[i]
		else
			single = self.singleProportion:clone()
			single:addTo(parent)
			single:setPosition(0, 0)
		end
		SoraDGetChildByName(single, "Image_Sheer"):setVisible(i % 2 == 0)
		single:getChildByName("Text_Title"):setString(i18n(titleConfig[i].title))
		local textValue = single:getChildByName("Text_Value")
		if heroID then
			local heroInfo = heroCtrl:getHeroInfoByID(heroID)
			local rarity = heroltCtrl:getRarity(heroID)
			if titleConfig[i].propertyName == "power" then
				local poweModulus = militaryFortressRead.getPowerModulus(self.campType, rarity, heroCtrl:getHeroPower(heroID))
				textValue:setString(tostring(poweModulus / 10) .. "%")
			elseif titleConfig[i].propertyName == "rarity" then
				local qualityModulus = militaryFortressRead.getRarityModulus(self.campType, rarity)
				textValue:setString(tostring(qualityModulus / 10) .. "%")
			else
				local lvModulus = militaryFortressRead.getLvModulus(self.campType, rarity, heroInfo.level)
				textValue:setString(tostring(lvModulus / 10) .. "%")
			end
		else
			textValue:setString("?")
		end
	end
	SoraDautoSortPos(parent, 1, 2, cc.size(100, 30))
end
function militaryFortressHeroSelectView:btnSureClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.selectHeroID then
			if militaryFortressCtrl:isHeroInGarrison(self.selectHeroID) then
				local info = militaryFortressCtrl:getChoosedHeroInfo(self.selectHeroID)
				_ENV = nil
				;(nil).name = i18n(militaryFortressRead.getCampTitle(info.campType))
				;(nil).num = i18n(militaryFortressRead.getFortessTitle(info.fortessType))
				SoraDShowMsgBox(i18n("fortress_text_11", nil), i18n("common_text_204"), i18n("common_text_185"), function(Type)
					if MSGBOX_CALLBACK_YES == Type then
						_ENV = nil
						;(nil).fortessType = self.fortessType
						;(nil).campType = self.campType
						;(nil).pos = self.pos
						;(nil).heroID = self.selectHeroID
						militaryFortressCtrl:reqMilitaryFortessSetHero(nil)
						self:close(self, eventType)
					end
				end)
			else
				_ENV = i18n("fortress_text_11", nil)
				i18n("fortress_text_11", nil).fortessType = self.fortessType
				i18n("fortress_text_11", nil).campType = self.campType
				i18n("fortress_text_11", nil).pos = self.pos
				i18n("fortress_text_11", nil).heroID = self.selectHeroID
				militaryFortressCtrl:reqMilitaryFortessSetHero((i18n("fortress_text_11", nil)))
				self:close(self, eventType)
			end
		else
			self:close(self, eventType)
		end
	end
end
function militaryFortressHeroSelectView:changeHeroChoose(heroID)
	self.scrollHero:getchildByIndex(self:getIndexByHero(self.selectHeroID)).point:setChoosed(false)
	self.selectHeroID = heroID
	self:updateChooseHeroInfo()
end
function militaryFortressHeroSelectView:getIndexByHero(heroID)
	for i, v in ipairs(self.heroIDList) do
		if v == heroID then
			return i
		end
	end
end
return militaryFortressHeroSelectView
