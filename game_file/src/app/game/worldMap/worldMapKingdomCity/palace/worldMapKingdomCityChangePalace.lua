local palaceInfoRead = include("palaceInfoRead")
local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local WorldMapKingdomCityChangePalace = class("worldMapKingdomCityChangePalace", function(target)
	if target == nil then
		return SoraDCreateBasePanel("worldMapKingdomCityChangePalace")
	end
	return target
end)
function WorldMapKingdomCityChangePalace:ctor()
	self:setBackGround(216.75)
	self.isHidePrePanel = false
	if SoraDCurrentSceneShowView("worldMapView") then
		self.freeImagesOnExit = false
	else
		self.freeImagesOnExit = true
	end
	self.palaceArray, _ENV, self.palaceList, _ENV = SoraDCurrentSceneShowView("worldMapView"), SoraDCurrentSceneShowView("worldMapView"), SoraDCurrentSceneShowView("worldMapView"), SoraDCurrentSceneShowView("worldMapView")
	self.defaultCity = 1
	self.realCurPage = 1
	SoraDGetAllChildFromWidget(self, self)
	self.pageView = self.PageView_palace
	self.pageView:setCustomScrollThreshold(50)
	self.pageView:addEventListener(handler(self, self.pageChange))
	self.scroll = self.ScrollView_palace
	self.btnOk = self.Button_ok
	self.btnOk:setTouchEnabled(false)
	self.btnOk:setBright(false)
	self.btnOk:setTitleText(i18n("common_text_1417"))
	self.btnOk:addTouchEventListener(handler(self, self.btnChangeClick))
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_changePalace"):setTitle(i18n("common_text_1187"))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_KINGDOMPALACE_CHANGED", function()
		SoraDCloseLoading(self)
		self:removeFromParent()
	end)
	if display.height <= 960 then
		local scale = 0.65 + (display.height - 853) / 107 * 0.15
		self.pageView:setScale(scale)
		local offsetY = self.pageView:getContentSize().height * (1 - scale) / 2 + 50
		self.pageView:setPositionY(self.pageView:getPositionY() - offsetY)
		self.arrow_L:setPositionY(self.pageView:getPositionY())
		self.arrow_R:setPositionY(self.pageView:getPositionY())
	elseif display.height > 1200 then
		local offsetY = (display.height - 1136) / 2
		self.pageView:setPositionY(self.pageView:getPositionY() + offsetY)
		self.arrow_L:setPositionY(self.pageView:getPositionY())
		self.arrow_R:setPositionY(self.pageView:getPositionY())
	end
	self:initData()
end
function WorldMapKingdomCityChangePalace:initData()
	local gametop = gModuleMgr.getObject("gametop")
	local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
	self.defaultCity = KWKingdomCtrl:getKingdomPlace()
	self:initView()
end
function WorldMapKingdomCityChangePalace:initView()
	self.palaceList = palaceInfoRead.getTbl()
	self.palaceKey = table.keys(self.palaceList)
	self.realCurPage = 1
	for i, v in ipairs(self.palaceKey) do
		local newLayout = ccui.Layout:create()
		local spPalace = display.newSprite("#" .. self.palaceList[v].big)
		local pSize = self.pageView:getContentSize()
		newLayout:setContentSize(pSize)
		newLayout:setTag(v)
		newLayout:setName("realPage")
		spPalace:setPosition(pSize.width / 2, pSize.height / 2)
		spPalace:setScale(0.75)
		spPalace:addTo(newLayout)
		self.pageView:addWidgetToPage(newLayout, i, true)
		if v == self.defaultCity then
			self.realCurPage = i
		end
		if v == 13 then
			self:initAtlantisPalace(newLayout, pSize)
		end
	end
	self.pageView:scrollToPage(self.realCurPage - 1)
	self:initScroll()
	self:choosePalace(self.realCurPage)
	local flagOffX = self.palaceArray[self.realCurPage]:getPositionX()
	local scrollW = 200 * #self.palaceArray
	self.scroll:jumpToPercentHorizontal(math.min(100, math.max(0, 100 * ((flagOffX - 320) / (scrollW - 640)))))
end
function WorldMapKingdomCityChangePalace:initScroll()
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.width, #self.palaceKey * 200)
	self.scroll:setInnerContainerSize(cc.size(sH, sSize.height))
	for k, v in ipairs(self.palaceKey) do
		local palace
		if k == 1 then
			palace = self.Node_palace
		else
			palace = self.Node_palace:clone()
			palace:addTo(self.scroll)
		end
		SoraDGetChildByName(palace, "icon_palace"):setSpriteFrame(self.palaceList[v].icon)
		SoraDGetChildByName(palace, "Image_selected"):setVisible(false)
		palace:setPosition(200 * k - 100, sSize.height / 2)
		local btnTouch = SoraDGetChildByName(palace, "Button_touch")
		btnTouch:setSwallowTouches(false)
		btnTouch:setTag(k)
		btnTouch:addTouchEventListener(handler(self, self.btnChooseClick))
		self.palaceArray[k] = palace
	end
end
function WorldMapKingdomCityChangePalace:pageChange(button, type)
	if type == 0 then
		local curIndex = self.pageView:getCurPageIndex() + 1
		self:refreshBtnState()
		self:choosePalace(curIndex)
	end
end
function WorldMapKingdomCityChangePalace:refreshBtnState(...)
	local btnEnabled = true
	local curIndex = self.pageView:getCurPageIndex() + 1
	if self.realCurPage ~= curIndex then
		if self.palaceKey[curIndex] == 13 then
			local leftTime = atlantisActivityCtrl:getPalaceRemainTime()
			if 0 < leftTime then
				btnEnabled = true
			else
				btnEnabled = false
			end
		else
			btnEnabled = true
		end
	else
		btnEnabled = false
	end
	self.btnOk:setTouchEnabled(btnEnabled)
	self.btnOk:setBright(btnEnabled)
end
function WorldMapKingdomCityChangePalace:choosePalace(index)
	for k, v in ipairs(self.palaceArray) do
		SoraDGetChildByName(v, "Image_selected"):setVisible(k == index)
	end
	self.arrow_L:setVisible(index ~= 1)
	self.arrow_R:setVisible(index ~= #self.palaceArray)
	if self.palaceKey[index] == 13 then
		self.Top_Node:setVisible(true)
		if palaceInfoRead.checkAtlantisPalaceBuff() then
			self.Node_info:setVisible(true)
		else
			self.Node_info:setVisible(false)
		end
	else
		self.Top_Node:setVisible(false)
		self.Node_info:setVisible(false)
	end
end
function WorldMapKingdomCityChangePalace:btnChangeClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not SoraDIsSelfKing() then
			SoraDShowMsgTip(i18n("atlantiswar_text_0406"))
			self:closePanel()
			return
		end
		local gametop = gModuleMgr.getObject("gametop")
		local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
		local pageID = self.pageView:getCurPageIndex()
		local realPage = self.pageView:getPage(pageID):getChildByName("realPage")
		local palaceID = realPage:getTag()
		if palaceID == 13 and atlantisActivityCtrl:getPalaceRemainTime() <= 0 then
			SoraDShowMsgTip(i18n("atlantiswar_text_0365"))
			return
		end
		SoraDShowLoading(self)
		KWKingdomCtrl:changePlace(palaceID)
	end
end
function WorldMapKingdomCityChangePalace:btnChooseClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:choosePalace(button:getTag())
		self.pageView:scrollToPage(button:getTag() - 1)
	end
end
function WorldMapKingdomCityChangePalace:initAtlantisPalace(newLayout, pSize)
	local palaceBig = self.Node_palaceBig:clone()
	palaceBig:setPosition(pSize.width / 2, pSize.height / 2)
	palaceBig:addTo(newLayout)
	SoraDGetAllChildFromWidget(palaceBig, palaceBig)
	palaceBig.Sprite_palace:setVisible(false)
	palaceBig.Text_name:setString(i18n("atlantiswar_text_0362"))
	local atlantisWarUtil = include("atlantisWarUtil")
	_ENV = i18n("atlantiswar_text_0362")
	i18n("atlantiswar_text_0362").day = atlantisWarUtil.getPalaceTimeDays()
	self.Text_des:setString(i18n("atlantiswar_text_0360", i18n("atlantiswar_text_0362")))
	self.Text_attr1:setString(i18n("atlantiswar_text_0273"))
	self.Text_attr2:setString(i18n("atlantiswar_text_0274"))
	self.Text_attr3:setString(i18n("atlantiswar_text_0275"))
	local refreshTimeEnd = function(timeEnd)
		self.Node_time:setVisible(not timeEnd)
		self.Text_des:setVisible(timeEnd)
		if timeEnd then
			self.Text_info:setString(i18n("atlantiswar_text_0361"))
		else
			self.Text_info:setString(i18n("atlantiswar_text_0363"))
		end
		_UPVALUE3_ = self.Text_info
		self.Text_info[1] = self.Text_attr1
		self.Text_info[2] = self.Text_attr2
		self.Text_info[3] = self.Text_attr3
		for i, v in ipairs(self.Text_info) do
			if timeEnd then
				v:setColor(cc.c3b(215, 195, 155))
			else
				v:setColor(cc.c3b(255, 200, 100))
			end
		end
	end
	local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
	local leftTime = atlantisActivityCtrl:getPalaceRemainTime()
	if 0 < leftTime then
		local Text_time = SoraDCreateTimerLabel(nil, self.Text_time)
		Text_time:beginTime(leftTime)
		Text_time:setTimeEndListener(function()
			refreshTimeEnd(true)
			self:refreshBtnState()
		end)
		refreshTimeEnd(false)
	else
		refreshTimeEnd(true)
	end
end
return WorldMapKingdomCityChangePalace
