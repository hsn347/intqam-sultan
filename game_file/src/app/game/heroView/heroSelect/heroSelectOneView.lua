local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local HeroSelectOneView = class("heroSelectOneView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroSelectOneView")
	end
	return target
end)
function HeroSelectOneView:ctor()
	_ENV = nil
	;(nil)[gHeroState.HERO_STATE_NORMAL] = true
	;(nil)[gHeroState.HERO_STATE_DEAD] = false
	;(nil)[gHeroState.HERO_STATE_CAPTURED] = false
	;(nil)[gHeroState.HERO_STATE_BATTLE] = true
	;(nil)[gHeroState.HERO_STATE_DEFEND] = true
	self.tableSingle, _ENV, self.tableSpare, _ENV, self.stateList, (nil)[gHeroState.HERO_STATE_ESCAPE] = nil, nil, nil, nil, nil, true
	self.Size_Image_bg = SoraDGetChildByName(self, "Size_Image_bg")
	self.Size_Image_bg:setFillType(1)
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_heroSelect")
	self.windowTitle:setTitle(i18n("herotrain_title_01"))
	self.scrollHeros = SoraDGetChildByName(self, "Top_Size_ScrollView_heros")
	self.txtTip = SoraDGetChildByName(self, "Text_tip")
	self.txtTip:setColor(cc.c3b(215, 195, 155))
	self.btnOk = SoraDGetChildByName(self, "Button_ok")
	self.btnOk:setTitleText(i18n("common_text_054"))
	self.btnOk:addTouchEventListener(handler(self, self.btnOkClick))
	self.txtNoHero = SoraDGetChildByName(self, "Center_Text_noHerosTip")
	self.txtNoHero:setString(i18n("hero_text_71"))
end
function HeroSelectOneView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_NOTICEMYHERO", handler(self, self.sMsgHeroStateChanged))
	SoraDAddMessage(self, "MESSAGE_SERVER_HERO_NOTICEHERO", handler(self, self.sMsgHeroStateChanged))
end
function HeroSelectOneView:initData(handl, filterList, times)
	self.resultCB = handl
	self.times = times
	self.canSelectHeros = heroCtrl:getHaveHerosIDNumList()
	dump(self.canSelectHeros, "self.canSelectHeros", 10)
	dump(filterList, "filterList")
	local heroCtrl, newCanSelectHeros = dump, dump
	for _, v in ipairs(self.canSelectHeros) do
		if filterList[v] or filterList[tostring(v)] then
		else
			table.insert(newCanSelectHeros, v)
		end
	end
	self.canSelectHeros = newCanSelectHeros
	self:initView()
	local selectHeroID = self.canSelectHeros[1]
	if self:judgeCanBeSelected(selectHeroID) then
		self:selectHeroClick(selectHeroID)
		self.selectHeroID = selectHeroID
	end
end
function HeroSelectOneView:sMsgHeroStateChanged(target, data)
	dump(data, "HeroSelectOneView:sMsgHeroStateChanged(target, data)", 10)
	local heroID = data.heroID
	local isCancel = false
	if self.selectHeroID and self.selectHeroID == heroID and not self:judgeCanBeSelected(heroID) then
		self.selectHeroID = nil
		self:cancelHeroClick()
		isCancel = true
	end
	self:prepareScrollData()
	if not isCancel and self.selectHeroID then
		self:selectHeroClick(self.selectHeroID)
	end
end
function HeroSelectOneView:judgeCanBeSelected(heroID)
	if heroCtrl:judgeHeroInStates(heroID, self.stateList) then
		local heroInfo = heroCtrl:getHeroInfoByID(heroID)
		return heroInfo.state
	end
end
function HeroSelectOneView:getCanSelectHeros()
	return self.canSelectHeros
end
function HeroSelectOneView:getCanReallySelectHeros()
	local _ENV, ret
	for i, v in ipairs(self.canSelectHeros) do
		if self:judgeCanBeSelected(v) then
			table.insert(ret, v)
		end
	end
	return ret
end
function HeroSelectOneView:initView(...)
	self.txtNoHero:setVisible(not next(self.canSelectHeros))
	self:prepareScrollData()
end
function HeroSelectOneView:setBannerTitle(str)
	self.windowTitle:setTitle(str)
end
function HeroSelectOneView:setBottomTip(str)
	self.txtTip:setString(str)
end
function HeroSelectOneView:setFilteHeroState(states)
	self.stateList = states
end
function HeroSelectOneView:btnOkClick(button, eventType)
	if eventType == ccui.TouchEventType.ended and self.resultCB then
		self.resultCB(self.selectHeroID, self.times)
	end
end
function HeroSelectOneView:cancelHeroClick(heroID)
	print("heroID=", heroID)
	for i, v in ipairs(self.tableSingle) do
		v.check = false
		if v.point then
			print("取消选中----")
			v.point:setMeCheck(false)
		end
		self.selectHeroID = nil
	end
end
function HeroSelectOneView:selectHeroClick(heroID)
	print("heroID=", heroID)
	for i, v in ipairs(self.tableSingle) do
		if v.data == heroID then
			v.check = true
			if v.point then
				print("选择了")
				v.point:setMeCheck(true)
			end
			self.selectHeroID = heroID
		else
			v.check = false
			if v.point then
				v.point:setMeCheck(false)
			end
		end
	end
end
function HeroSelectOneView:cleanOld(...)
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			v.point:setMeCheck(false)
			v.point:setVisible(false)
			table.insert(self.tableSpare, v.point)
		end
	end
	self.tableSingle, _ENV = ipairs(self.tableSingle)
end
function HeroSelectOneView:prepareScrollData(...)
	self:cleanOld()
	local sSize = self.scrollHeros:getContentSize()
	local sH = math.max(sSize.height, math.ceil(#self.canSelectHeros / 4) * 230)
	heroCtrl:sortHuntHerosID(self.canSelectHeros, self.stateList)
	for i, v in ipairs(self.canSelectHeros) do
		_ENV = nil
		;(nil).data = v
		;(nil).posY = sH - (math.ceil(i / 4) - 1) * 230
		self.tableSingle[i], (nil).posX = nil, SoraDFIsRA() and sSize.width - ((i - 1) % 4 * 160 + 80) or (i - 1) % 4 * 160 + 80
	end
	self.scrollHeros:setInnerContainerSize(cc.size(sSize.width, sH))
	self:initScrollList()
	if not self.initScrollEvent then
		self.scrollHeros:addEventListener(handler(self, self.scrollEventCallBack))
		self.initScrollEvent = true
	end
end
function HeroSelectOneView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initScrollList()
	end
end
function HeroSelectOneView:initScrollList(...)
	local scrollInner = self.scrollHeros:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local sSize = self.scrollHeros:getContentSize()
	_ENV = self.scrollHeros
	self.scrollHeros.beginY = math.max(0, offsetY - 0.25 * sSize.height)
	local self.scrollHeros.endY, tableShowH = offsetY + 1.25 * sSize.height, self.scrollHeros
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
				single = SoraDCreatePanel("heroHuntingSelectItem")
				single:addTo(self.scrollHeros)
				single:setClickCallBack(handler(self, self.selectHeroClick))
				single:setCancelLightBack(handler(self, self.cancelHeroClick))
				single:setScroll(self.scrollHeros)
			end
			single:setFilteHeroState(self.stateList)
			single:initData(v.data)
			single:setMeCheck(not not v.check)
			single:setPosition(v.posX, v.posY)
			v.point = single
		end
	end
end
return HeroSelectOneView
