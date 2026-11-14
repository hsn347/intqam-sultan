local gametop = gModuleMgr.getObject("gametop")
local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local buildLogic = include("buildLogic")
local HeroJailListView = class("heroJailListView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroJailListView")
	end
	return target
end)
_ENV = "heroJailListView"
;("heroJailListView").RUN_TIME = 1
local _ENV, ("heroJailListView").QUALITY, sortTypeDef = function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroJailListView")
	end
	return target
end, 3, "heroJailListView"
_ENV = nil
;(nil).name = "prison_title_03"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroJailListView")
	end
	return target
end)[sortTypeDef.RUN_TIME], (nil).eventType = nil, 1
_ENV = nil
;(nil).name = "prison_title_05"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroJailListView")
	end
	return target
end)[sortTypeDef.QUALITY], (nil).eventType = nil, 3
local function sortTypeList(target)
	if target == nil then
		return SoraDCreateBasePanel("heroJailListView")
	end
	return target
end
function HeroJailListView:ctor()
	self.tableSingle, sortTypeDef, self.tableSpare, sortTypeDef, self.isHideCurrentSceneView = nil, nil, nil, nil, true
	self.curSortType = sortTypeDef.RUN_TIME
	SoraDGetChildByName(self, "Size_Image_bg"):setFillType(1)
	self.txtImNum = SoraDGetChildByName(self, "Text_imprisonNum")
	self.txtSpeedWait = SoraDGetChildByName(self, "Text_speedExecuteWait")
	self.txtAttForce = SoraDGetChildByName(self, "Text_troopAttackForce")
	self.txtHighLevel = SoraDGetChildByName(self, "Text_highestLevel")
	self.imgImNum = SoraDGetChildByName(self, "Image_imprisonNum")
	self.imgSpeedWait = SoraDGetChildByName(self, "Image_speedExecuteWait")
	self.imgAttForce = SoraDGetChildByName(self, "Image_troopAttackForce")
	self.imgHighLevel = SoraDGetChildByName(self, "Image_highestLevel")
	self.scrollHeros = SoraDGetChildByName(self, "Top_Size_ScrollView_heros")
	self.txtNoRecord = SoraDGetChildByName(self, "Center_Text_noRecord")
	self.txtNoRecord:setString(i18n("hero_text_83"))
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_heroJail")
	self.windowTitle:setTitle(i18n("buildDes_name_125"))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			if IsArClient then
				userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.HERO_JAIL)
			else
				userSDKManager.showFAQSection(gSDKDef.FAQSectionType.HERO_JAIL)
			end
		end
	end)
	SoraDGetChildByName(self, "Image_25"):loadTexture("bg_mailinfo_kingwar.png", ccui.TextureResType.plistType)
	self.Node_chooseList = SoraDGetChildByName(self, "Node_chooseList")
	self.Image_border = SoraDGetChildByName(self.Node_chooseList, "Image_border")
	self.Text_choose = SoraDGetChildByName(self.Node_chooseList, "Text_choose")
	self.Button_choose = SoraDGetChildByName(self, "Button_choose")
	self.Button_choose:addTouchEventListener(handler(self, self.onChooseClick))
	self.Button_time = SoraDGetChildByName(self, "Button_time")
	self.Button_time:setTitleText(i18n("prison_title_03"))
	self.Button_choose:setTitleText(i18n("prison_title_03"))
	self.Button_time:addTouchEventListener(handlerEx(self, self.onSortClick, sortTypeDef.RUN_TIME))
	self.Button_quality = SoraDGetChildByName(self, "Button_quality")
	self.Button_quality:setTitleText(i18n("prison_title_05"))
	self.Button_quality:addTouchEventListener(handlerEx(self, self.onSortClick, sortTypeDef.QUALITY))
	self:initData()
end
function HeroJailListView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_RELEASESUCCESS", handler(self, self.releaseSuccessCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_EXECUTESUCCESS", handler(self, self.releaseSuccessCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_NOTICEOTHERHERO", handler(self, self.releaseSuccessCallBack))
end
function HeroJailListView:initData(...)
	self.heroInMyJail = heroJailCtrl:getHerosInMyPrison()
	dump(self.heroInMyJail, "self.heroInMyJail")
	self:initView()
end
function HeroJailListView:initView(...)
	self:initPrisonNum()
	self:initReduceSpeedTime()
	self:initAddAttack()
	self:setSwitcher()
end
function HeroJailListView:initPrisonNum(...)
	local totalNum = buildLogic.getHeroJailCapacity().total
	local curNum = table.nums(self.heroInMyJail)
	buildLogic = nil
	;(nil).num1 = curNum
	;(nil).num2 = totalNum
	self.txtImNum:setString(i18n("prison_text_02", nil))
end
function HeroJailListView:initReduceSpeedTime(...)
	local reduceTime = buildLogic.getHeroJailReduceSpeedTime().total
	buildLogic = nil
	;(nil).time = SoraDConvertSecondToString(reduceTime)
	self.txtSpeedWait:setString(i18n("prison_text_03", nil))
end
function HeroJailListView:initAddAttack(...)
	local canAddNum = buildLogic.getHeroJailAddAttack()
	if 0 < canAddNum then
		self.txtAttForce:setVisible(true)
		self.txtHighLevel:setVisible(true)
		self.imgAttForce:setVisible(true)
		if next(self.heroInMyJail) then
			local buildLogic, lvs = next(self.heroInMyJail), next(self.heroInMyJail)
			for k, v in pairs(self.heroInMyJail) do
				local tmp = heroJailCtrl:getHerosInMyPrisonByID(v)
				dump(tmp)
				table.insert(lvs, tmp.level)
			end
			table.sort(lvs, function(l, r)
				return r < l
			end)
			dump(lvs)
			local attackValue = 0
			for i = 1, canAddNum do
				if lvs[i] then
					attackValue = attackValue + heroltCtrl.getJailAttackBuffByLevel(lvs[i])
				end
			end
			buildLogic = heroltCtrl.getJailAttackBuffByLevel(lvs[i])
			heroltCtrl.getJailAttackBuffByLevel(lvs[i]).attack = attackValue / 10
			self.txtAttForce:setString(i18n("prison_text_04", (heroltCtrl.getJailAttackBuffByLevel(lvs[i]))))
			buildLogic = i18n("prison_text_04", (heroltCtrl.getJailAttackBuffByLevel(lvs[i])))
			i18n("prison_text_04", (heroltCtrl.getJailAttackBuffByLevel(lvs[i]))).lv = lvs[1]
			self.txtHighLevel:setString(i18n("prison_text_05", i18n("prison_text_04", (heroltCtrl.getJailAttackBuffByLevel(lvs[i])))))
			self.imgHighLevel:setVisible(true)
		else
			buildLogic = true
			;(true).attack = "0"
			self.txtAttForce:setString(i18n("prison_text_04", true))
			self.imgHighLevel:setVisible(false)
			self.txtHighLevel:setString("")
		end
	else
		self.txtAttForce:setVisible(false)
		self.txtHighLevel:setVisible(false)
		self.imgAttForce:setVisible(false)
		self.imgHighLevel:setVisible(false)
	end
end
function HeroJailListView:cleanOld(...)
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableSpare, v.point)
		end
	end
	self.tableSingle, _ENV = ipairs(self.tableSingle)
end
function HeroJailListView:prepareScrollData(...)
	self:cleanOld()
	local sSize = self.scrollHeros:getContentSize()
	local sH = math.max(sSize.height, math.ceil(#self.heroInMyJail / 3) * 188 + 20)
	for i, v in ipairs(self.heroInMyJail) do
		_ENV = nil
		;(nil).data = v
		;(nil).posY = sH - (math.ceil(i / 3) - 1) * 188 - 20
		self.tableSingle[i], (nil).posX = nil, (i - 1) % 3 * 213 + 106.5
	end
	if next(self.heroInMyJail) then
		self.txtNoRecord:setVisible(false)
	else
		self.txtNoRecord:setVisible(true)
	end
	self.scrollHeros:setInnerContainerSize(cc.size(sSize.width, sH))
	self:initScrollList()
	if not self.initScrollEvent then
		self.scrollHeros:addEventListener(handler(self, self.scrollEventCallBack))
		self.initScrollEvent = true
	end
end
function HeroJailListView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initScrollList()
	end
end
function HeroJailListView:initScrollList(...)
	local scrollInner = self.scrollHeros:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local sSize = self.scrollHeros:getContentSize()
	_ENV = self.scrollHeros
	self.scrollHeros.beginY = math.max(0, offsetY - 0.5 * sSize.height)
	local self.scrollHeros.endY, tableShowH = offsetY + 1.5 * sSize.height, self.scrollHeros
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			if v.posY < tableShowH.beginY or v.posY > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.posY and tableShowH.endY >= v.posY then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = SoraDCreatePanel("heroJailItem")
				single:addTo(self.scrollHeros)
			end
			single:initData(v.data)
			single:setPosition(v.posX, v.posY)
			v.point = single
		end
	end
end
function HeroJailListView:releaseSuccessCallBack(target, redata)
	self:initData()
end
function HeroJailListView:onChooseClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.switcher = not self.switcher
		self:setSwitcher()
	end
end
function HeroJailListView:sortByType(sortType)
	local funcRunTime = function(info)
		return info.captureTime + info.killTime + info.executeTime
	end
	local funcStateScore = function(state)
		if state == gHeroJailState.escape then
			return 0
		end
		return state + 1
	end
	local _ENV, sortFunc
	sortFunc[sortTypeDef.QUALITY] = function(l, r)
		local lInfo = heroJailCtrl:getHerosInMyPrisonByID(l)
		local rInfo = heroJailCtrl:getHerosInMyPrisonByID(r)
		if lInfo.isAwake == rInfo.isAwake then
			if lInfo.quality == rInfo.quality then
				return funcRunTime(lInfo.extraData) < funcRunTime(rInfo.extraData)
			else
				return lInfo.quality > rInfo.quality
			end
		else
			return lInfo.isAwake or false
		end
	end
	sortFunc[sortTypeDef.RUN_TIME] = function(l, r)
		local lInfo = heroJailCtrl:getHerosInMyPrisonByID(l)
		local rInfo = heroJailCtrl:getHerosInMyPrisonByID(r)
		return funcRunTime(lInfo.extraData) < funcRunTime(rInfo.extraData)
	end
	table.sort(self.heroInMyJail, sortFunc[sortType])
	self:prepareScrollData()
end
function HeroJailListView:onSortClick(sortType, button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.switcher = false
		self.curSortType = sortType
		print("onSortClick", sortType)
		self:setSwitcher()
	end
end
function HeroJailListView:setSwitcher()
	self:sortByType(self.curSortType)
	self.Button_choose:setTitleText(i18n(sortTypeList[self.curSortType].name))
	self.Button_time:setVisible(self.switcher)
	self.Button_quality:setVisible(self.switcher)
	self.Image_border:setContentSize(cc.size(440, self.switcher and 140 or 60))
end
return HeroJailListView
