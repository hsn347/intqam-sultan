local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local buffDesRead = include("buffDesRead")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroSkinPanel = class("HeroSkinPanel", baseFguiPanel)
function HeroSkinPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroSkinPanel:ctor", self.viewName)
end
function HeroSkinPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroSkinPanel:onInit()
	print("=======HeroSkinPanel:onInit")
	self.heroID = self.proxy.param.heroID
	self.dressIndex = 3
	self.heroClass = self.proxy.param.heroClass
	print("self.heroID,self.heroClass=====", self.heroID, self.heroClass)
	self.activeItemBtns, _ENV, self.switchMode = print, print, 0
	for i = 1, 3 do
		self.activeItemBtns[SoraDFPosX(i, 4)] = self.fields[string.format("Button_Cost%d", i)]
	end
	for i, v in ipairs(self.activeItemBtns) do
		v:addClickListener(handlerEx(self, self.btnCostItem, i))
	end
	self.fields.Com_title:initData(i18n("heroDress_text_001"), handler(self, self.onClickClose), handler(self, self.btnHelpClick))
	self.fields.Button_buff:setString(i18n("skin_text_15"))
	self.fields.Button_buff:addTouchEventListener(handler(self, self.btnBuffClick))
	self.fields.Button_switch:addTouchEventListener(handler(self, self.btnSwitchClick))
	self.fields.Button_lieutenant:setString(i18n("lieutenant_text_01"))
	self.fields.Button_lieutenant:addTouchEventListener(handler(self, self.btnLieutenantClick))
	self.fields.Button_lieutenant:setVisible(false)
	self.fields.Button_lieutenant:setString(i18n("lieutenant_text_01"))
	self.fields.Button_use:setString(i18n("common_text_314"))
	self.fields.Button_use:addTouchEventListener(handler(self, self.btnUseClick))
	self.fields.List_buff:setItemRenderer(handler(self, self.onItemRederer))
	self.Text_limitTime = SoraDCreateTimerLabel(self, self.fields.Text_limitTime)
	self.fields.List:setItemRenderer(handler(self, self.onMenuItemRender))
	self.fields.List:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onScrollItem))
	self.fields.List:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.onScrollEndItem))
	self.fields.Button_click:addClickListener(handler(self, self.btnClick))
end
function HeroSkinPanel:btnClick()
	SoraDPlaySound()
	self.switchMode = 2
	self:updateSwitch()
end
function HeroSkinPanel:onShow()
	print("=======HeroSkinPanel:onShow")
	self:updateSwitch()
	self:initData()
end
function HeroSkinPanel:onMenuItemRender(index, target)
	target:setMyHandle(handler(self, self.btnDressChoose))
	target:initData(self.dressList[index + 1], index + 1)
end
function HeroSkinPanel:updateSwitch()
	self.controllers.c1:setSelectedIndex(self.switchMode)
	self.fields.Button_lieutenant:setVisible(self.switchMode == 0 and commonCheck.HERO_COMBOS_SKILL and not heroltCtrl:isDefaultDress(self.curDressID))
end
function HeroSkinPanel:initData()
	self.fields.Sprite_heroname:setURL(heroltCtrl.getHeroNamePng(self.heroID))
	local heroClassInfo = heroltCtrl.getHeroClassTypeInfo(self.heroID, self.heroClass)
	self.fields.Sprite_heroClass:setURL(heroClassInfo.icon)
	self.dressList = clone(heroltCtrl:getHeroDress(self.heroID))
	dump(self.dressList, "self.dressList")
	heroltCtrl = heroltCtrl:getHeroDress(self.heroID)
	table.insert(self.dressList, 1, heroltCtrl:getHeroDress(self.heroID))
	heroltCtrl = heroltCtrl:getHeroDress(self.heroID)
	table.insert(self.dressList, 1, heroltCtrl:getHeroDress(self.heroID))
	heroltCtrl = 1
	table.insert(self.dressList, 1)
	heroltCtrl = 1
	table.insert(self.dressList, 1)
	for k, v in ipairs(self.dressList) do
		if heroCtrl:isWearDressID(self.heroID, v) then
			self.dressIndex = k
			break
		end
	end
	self:updateInfo()
	self:updateSpine()
	self:loadSingleList()
	self:updateBtns(true)
end
function HeroSkinPanel:updateSpine()
	local dressID = self.curDressID or heroCtrl:getHeroDressSeting(self.heroID)
	if self.dressID and self.dressID == dressID then
		return
	end
	self.dressID = dressID
	local cfg, spineCfg = heroltCtrl:getHeroSpineCfg(dressID)
	local isUsm = cfg.isUsm or false
	self.fields.Com_hero:initData(self.heroID, self.dressID)
	self.fields.Com_hero:playOpacityAct()
	if not isUsm then
		self.fields.Com_hero:playOffsetXAct(0.3)
	end
	self.transitions.t0:play(1, 0, 0, -1)
end
function HeroSkinPanel:updateInfo()
	self.curDressID = self.dressList[self.dressIndex]
	self.lieutenantHero = heroltCtrl:getDressLieutenant(self.curDressID)
	if commonCheck.HERO_COMBOS_SKILL and self.switchMode == 0 and not heroltCtrl:isDefaultDress(self.curDressID) then
		self.fields.Button_lieutenant:setVisible(true)
	else
		self.fields.Button_lieutenant:setVisible(false)
	end
	self.fields.Sp_dressName:setURL(heroltCtrl:getDressNamePNG(self.curDressID))
	local bgName, isNew = heroltCtrl:getDressViewBg(self.curDressID)
	self.fields.Bg_King:setSpriteFrame(bgName)
	local ownBuff = heroltCtrl:getOwnBuff(self.curDressID)
	local dressBuff = heroltCtrl:getDressBuff(self.curDressID)
	local newH = 0
	if not next(ownBuff) and not next(dressBuff) then
		self.fields.List_buff:setVisible(false)
	else
		self.fields.List_buff:setVisible(true)
		local isOwn = heroCtrl:isOwnDressID(self.heroID, self.curDressID)
		local isWear = heroCtrl:isWearDressID(self.heroID, self.curDressID)
		heroltCtrl, heroCtrl = self.heroID, heroCtrl
		self.heroID.title = i18n("heroDress_text_002")
		self.heroID.isLight = isOwn
		heroltCtrl, self.heroID.buffInfo = i18n("heroDress_text_002"), ownBuff
		i18n("heroDress_text_002").title = i18n("heroDress_text_003")
		i18n("heroDress_text_002").isLight = isWear
		i18n("heroDress_text_002").buffInfo = dressBuff
		self.buffList, heroCtrl[1] = heroCtrl, self.heroID
		self.buffList, heroCtrl[2] = heroCtrl, i18n("heroDress_text_002")
		self.fields.List_buff:setNumItems(2)
	end
end
function HeroSkinPanel:loadSingleList()
	self.fields.List:setNumItems(#self.dressList)
	self.fields.List:scrollToCenter(self.fields.List:getChildAt(self.dressIndex - 1), true)
	self:onScrollItem()
end
function HeroSkinPanel:updateBtns(isInit)
	local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	local isOwn = heroCtrl:isOwnDressID(self.heroID, self.curDressID)
	self.fields.Node_jh:setVisible(not isOwn)
	self.fields.Node_xf:setVisible(isOwn)
	for k, v in ipairs(self.activeItemBtns) do
		v:setVisible(false)
	end
	local activeItems = heroltCtrl:getDressActiveItem(self.curDressID)
	for k, v in ipairs(activeItems) do
		local result = backpackltCtrl:getResult(v)
		local resultVal = result and result[2] or 0
		local des = i18n("heroDress_text_011")
		local ownCount = backpackCtrl:getItemCount(v)
		if 0 < resultVal then
			heroCtrl = nil
			;(nil).time = resultVal / 86400
			des = i18n("heroDress_text_012", nil)
			if isOwn then
				heroCtrl = nil
				;(nil).time = resultVal / 86400
				des = i18n("heroDress_text_009", nil)
			end
		end
		self.activeItemBtns[k]:setString(des)
		self.activeItemBtns[k]:setCost(v, 1)
		self.activeItemBtns[k]:setVisible(true)
		self.activeItemBtns[k]:setNumTotal(1, ownCount, 0 < ownCount and "#FFFFFF" or "#FF0000")
		self.activeItemBtns[k]:setReddot(heroInfo and 0 < ownCount or false, -1)
	end
	self.Text_limitTime:setVisible(false)
	if isOwn then
		local isLimited = heroCtrl:isLimitedDress(self.heroID, self.curDressID)
		if isLimited then
			self.Text_limitTime:setTimeLast(function(time)
				_ENV = nil
				;(nil).time = time
				return i18n("common_text_766", nil)
			end)
			self.Text_limitTime:beginTime(heroCtrl:getDressLimitedTime(self.heroID, self.curDressID))
			self.Text_limitTime:setVisible(true)
		end
		local isWear = heroCtrl:isWearDressID(self.heroID, self.curDressID)
		if isWear then
			self.fields.Button_use:setVisible(false)
			if isLimited then
				if self:isHaveActiveItem() then
					self.fields.Node_jh:setVisible(true)
				else
					self.fields.Node_jh:setVisible(false)
				end
			else
				self.fields.Node_jh:setVisible(false)
			end
		else
			self.fields.Button_use:setVisible(true)
			if self:isHaveActiveItem() then
				if isLimited then
					self.fields.Node_jh:setVisible(false)
					self.fields.Node_xf:setVisible(true)
				else
					self.fields.Node_jh:setVisible(false)
				end
			else
				self.fields.Node_jh:setVisible(false)
			end
		end
	end
end
function HeroSkinPanel:onItemRederer(index, target)
	target:initData(self.buffList[index + 1])
	target:fixChildrenPos()
end
function HeroSkinPanel:btnLieutenantClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).dressID = self.curDressID
	;(nil).heroID = self.heroID
	;(nil).lieutenantHeroID = self.lieutenantHero
	uiManager:show("heroLieutenant", nil)
end
function HeroSkinPanel:btnUseClick()
	SoraDPlaySound()
	local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	if heroInfo.state ~= gHeroState.HERO_STATE_NORMAL then
		if heroInfo.state == gHeroState.HERO_STATE_DEAD or heroInfo.state == gHeroState.HERO_STATE_CAPTURED then
			SoraDShowMsgTip(i18n("hero_text_39"))
		else
			SoraDShowMsgTip(i18n("heroDress_text_008"))
		end
		return
	end
	SoraDShowLoading(self)
	heroCtrl:dressWear(self.curDressID)
end
function HeroSkinPanel:btnBuffClick()
	SoraDPlaySound()
	uiManager:show("HeroSkinPop")
end
function HeroSkinPanel:btnHelpClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("heroDress_text_019")
	;(nil).title = i18n("common_text_001")
	uiManager:show("RuleView", nil)
end
function HeroSkinPanel:btnSwitchClick()
	SoraDPlaySound()
	self.switchMode = self.switchMode + 1
	if self.switchMode > 2 then
		self.switchMode = 0
	end
	self:updateSwitch()
end
function HeroSkinPanel:btnDressChoose(index)
	self.dressIndex = index
	self.fields.List:scrollToCenter(self.fields.List:getChildAt(self.dressIndex - 1), true)
	self:updateInfo()
	self:updateSpine()
	self:updateBtns()
end
function HeroSkinPanel:btnCostItem(index)
	SoraDPlaySound()
	local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	local activeItems = heroltCtrl:getDressActiveItem(self.curDressID)
	local v = activeItems[index]
	local ownCount = backpackCtrl:getItemCount(v)
	local result = backpackltCtrl:getResult(v)[2]
	local timeStr = ""
	if 0 < result then
		_ENV = nil
		;(nil).day = result / 86400
		timeStr = i18n("common_text_227", nil)
	end
	if 0 < ownCount then
		if not heroInfo then
			_ENV = result / 86400
			;(result / 86400).name = i18n(heroltCtrl.getHeroName(self.heroID))
			SoraDShowMsgTip(i18n("heroDress_text_020", result / 86400))
			return
		end
		_ENV = i18n("heroDress_text_020", result / 86400)
		_ENV = v
		v.color = "#00BE1E"
		i18n("heroDress_text_020", result / 86400).name1 = SoraDWrapHtmlTagByStyle(publicRead.getName(v), v)
		i18n("heroDress_text_020", result / 86400).name2 = i18n(heroltCtrl.getHeroName(self.heroID))
		i18n("heroDress_text_020", result / 86400).var = i18n(heroltCtrl:getDressName(self.curDressID))
		i18n("heroDress_text_020", result / 86400).time = timeStr
		local sureStr = i18n("heroDress_text_007", i18n("heroDress_text_020", result / 86400))
		if result == 0 then
			_ENV = i18n(heroltCtrl:getDressName(self.curDressID))
			_ENV = v
			v.color = "#00BE1E"
			i18n(heroltCtrl:getDressName(self.curDressID)).name1 = SoraDWrapHtmlTagByStyle(publicRead.getName(v), v)
			i18n(heroltCtrl:getDressName(self.curDressID)).name2 = i18n(heroltCtrl.getHeroName(self.heroID))
			i18n(heroltCtrl:getDressName(self.curDressID)).var = i18n(heroltCtrl:getDressName(self.curDressID))
			sureStr = i18n("heroDress_text_021", (i18n(heroltCtrl:getDressName(self.curDressID))))
		end
		_ENV = heroltCtrl:getDressName(self.curDressID)
		heroltCtrl:getDressName(self.curDressID).useHtml = true
		SoraDShowMsgBoxNew(sureStr, i18n("common_text_204"), i18n("common_text_185"), function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				SoraDShowLoading(self)
				heroCtrl:dressActive(v)
			end
		end, heroltCtrl:getDressName(self.curDressID))
	else
		local materials = backpackltCtrl:getMaterialOfMergeItem(v)
		local isEnough = true
		if materials then
			for index, value in ipairs(materials) do
				local itemCount = backpackCtrl:getItemCount(value.id)
				if itemCount < value.count then
					isEnough = false
					break
				end
			end
		else
			isEnough = false
		end
		if isEnough then
			function _ENV(callType)
				if callType == MSGBOX_CALLBACK_YES then
					SoraDShowLoading(self)
					heroCtrl:dressActive(v)
				end
			end
			;(function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					SoraDShowLoading(self)
					heroCtrl:dressActive(v)
				end
			end).itemID = materials[1].id
			uiManager:show("itemCompoundView", function(callType)
				if callType == MSGBOX_CALLBACK_YES then
					SoraDShowLoading(self)
					heroCtrl:dressActive(v)
				end
			end)
		else
			local output = heroltCtrl:getDressOutPutInfo(v)
			if output and next(output) then
				_ENV = materials[1].id
				materials[1].id.itemID = v
				materials[1].id.needCount = 1
				materials[1].id.isDress = true
				materials[1].id.output = output
				uiManager:show("newHeroGainChipMethodView", materials[1].id)
			else
				SoraDShowMsgTip(i18n("skin_text_19"))
			end
		end
	end
end
function HeroSkinPanel:onScrollItem()
	local offsetX = self.fields.List:getScrollPane():getPositionX()
	local listW = self.fields.List:getContentSize().width
	local scrollW = self.fields.List:getInnerContainerSize().width
	local centerX = offsetX + listW / 2
	for i = 1, self.fields.List:getNumItems() do
		local objW = self.fields.List:getChildAt(i - 1):getContentSize().width
		local objOffsetX = self.fields.List:getChildAt(i - 1):getX() + objW / 2 - offsetX - listW / 2
		self.fields.List:getChildAt(i - 1):setRatio((scrollW - math.abs(objOffsetX)) / scrollW)
	end
end
function HeroSkinPanel:onScrollEndItem()
	local midIndex = 0
	local ratio = 0
	for i = 1, self.fields.List:getNumItems() do
		if ratio <= self.fields.List:getChildAt(i - 1):getRatio() and not self.fields.List:getChildAt(i - 1):isEmptyCom() then
			ratio = self.fields.List:getChildAt(i - 1):getRatio()
			midIndex = i
		end
	end
	self:btnDressChoose(midIndex)
end
function HeroSkinPanel:isHaveActiveItem()
	local ret = false
	local activeItems = heroltCtrl:getDressActiveItem(self.curDressID)
	for k, v in ipairs(activeItems) do
		if backpackCtrl:getItemCount(v) > 0 then
			ret = true
			break
		end
	end
	return ret
end
return HeroSkinPanel
