local achiDesRead = include("achiDesRead")
local achievementctrl = SoraDGetCtrl("achievementctrl")
local dressCtrl = SoraDGetCtrl("dressCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local honourWallViewPanel = class("honourWallViewPanel", baseFguiPanel)
function honourWallViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("honourWallViewPanel:ctor", self.viewName)
end
function honourWallViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function honourWallViewPanel:onInit()
	print("=======honourWallViewPanel:onInit")
	self.tab = 1
	self.medalData, _ENV, self.achiData, _ENV, self.menu = print, print, print, print, 1
	self.fields.Com_title:initData(i18n("common_text_1530"), handler(self, self.onClickClose))
	self.fields.Button_achievementPage:addClickListener(handler(self, self.btnConnectAchiClick))
	_ENV = handler(self, self.btnConnectAchiClick)
	handler(self, self.btnConnectAchiClick).num = 3
	self.fields.Text_medalTitle:setString(i18n("common_text_1985", handler(self, self.btnConnectAchiClick)))
	self.fields.List_achi:setVirtual()
	self.fields.List_achi:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_medal:setVirtual()
	self.fields.List_medal:setItemRenderer(handler(self, self.onMedalRenderer))
end
function honourWallViewPanel:onShow()
	print("=======honourWallViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initGameButton()
	self.fields.Button_achievementPage:setVisible(device.platform ~= "android")
	self.otherData = self.param and self.param.otherData
	self.isToAchi = self.param and self.param.isToAchi
	self.jumpID = self.param and self.param.jumpID
	self.isReqForList = self.param and self.param.isReqForList
	if self.otherData then
		self.fields.Com_title:setString(i18n("common_text_2005"))
		self.controllers.c2:setSelectedIndex(1)
		self.tab = 2
	else
		self.controllers.c2:setSelectedIndex(0)
	end
	_ENV = 0
	_ENV, _ENV, (0).defaultClick = i18n("common_text_2005")
	i18n("common_text_2005").title = i18n("common_text_1752")
	_ENV, self.tab[1], i18n("common_text_2005").tag = i18n("common_text_2005")
	i18n("common_text_2005").title = i18n("common_text_2005")
	;(0).tabsetArray, self.tab[2], i18n("common_text_2005").tag = self.tab, i18n("common_text_2005")
	;(0).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(0)
	_ENV = 0
	_ENV, _ENV, (0).defaultClick = self, self.menu, self.menu
	self.title = i18n("rechare_activename_1142")
	_ENV, self.menu[1], self.tag = self, self, 1
	self.title = i18n("common_text_4504")
	_ENV, self.menu[2], self.tag = self, self, 2
	self.title = i18n("common_text_370")
	;(0).tabsetArray, self.menu[3], self.tag = self.menu, self, 3
	;(0).callback = handler(self, self.onClickMenuTab)
	self.fields.com_TabW:initView(0)
end
function honourWallViewPanel:initGameButton()
	local txt = ""
	local img = "icon_cjxt_btn.png"
	if device.platform == "android" then
		txt = "Google Play"
		img = "icon_google_login.png"
	elseif device.platform == "ios" then
		txt = "Game Center"
	elseif device.platform == "mac" then
		txt = "Game Center"
	end
	self.fields.Button_achievementPage:setTitle(txt)
	self.fields.Button_achievementPage:setIcon(img)
end
function honourWallViewPanel:onClickTab(tag)
	self.tab = tag
	self.controllers.c1:setSelectedIndex(self.tab - 1)
	if self.tab == 2 then
		self:initMedalData()
	end
end
function honourWallViewPanel:onClickMenuTab(tag)
	if self.isToAchi then
		if self.isReqForList then
			self.menu = tag
			self:reqForList()
			self.isReqForList = nil
		elseif self.jumpID then
			self.menu = self:getClassByMedalID(self.jumpID)
			self.achiData = self:getAchiListByType(self.menu)
			self.fields.List_achi:setNumItems(#self.achiData)
			self.fields.com_TabW:setToTab(self.menu)
			self:jumpToAppointID(self.jumpID)
			self.jumpID = nil
		end
		self.isToAchi = nil
	else
		self.menu = tag
		self.achiData = self:getAchiListByType(self.menu)
		self.fields.List_achi:setNumItems(#self.achiData)
		self.fields.List_achi:jumpToTop()
	end
	self:updateRedPoint()
end
function honourWallViewPanel:getClassByMedalID(medalID)
	local index = 1
	for i = 1, 3 do
		local achiData = self:getAchiListByType(i)
		for k, v in ipairs(achiData) do
			if v.medalID == medalID then
				return i
			end
		end
	end
	return index
end
function honourWallViewPanel:jumpToAppointID(jumpID)
	for k, v in ipairs(self.achiData) do
		if tonumber(v.medalID) == tonumber(jumpID) then
			local index = k
			self.fields.List_achi:scrollToView(index - 1)
			break
		end
	end
end
function honourWallViewPanel:reqForList()
	SoraDShowLoading(self)
	achievementctrl:sendRefresh()
end
function honourWallViewPanel:initData(target, data)
	SoraDCloseLoading(self)
	if data.redata and data.redata.id then
		local giftList = achiDesRead.getInfoById(data.redata.id).achiGift
		giftList = SoraDIntArr2Table(giftList)
		SoraDMailGainItems(giftList)
		self:initMedalData()
	end
	if self.tab == 1 then
		self:onClickMenuTab(self.menu)
		self:updateRedPoint()
	else
		self:initMedalData()
	end
end
function honourWallViewPanel:initMedalData(targer, redata)
	if self.tab ~= 2 then
		return
	end
	if redata and redata.redata and redata.redata.id then
		local medalInfo = achiDesRead.getMedalById(redata.redata.id)
		achiDesRead = nil
		;(nil).medal = i18n(medalInfo.medalName)
		SoraDShowMsgTip(i18n("common_text_2023", nil))
	end
	local tmpTbl = self.otherData or achievementctrl:getAchievementData()
	local otherInfo = achievementctrl:getAchievementInfo()
	self.medalData, achiDesRead = achievementctrl, achievementctrl
	if next(tmpTbl) then
		local medalTbl, medalActiveTbl = self:medalFactory(tmpTbl, otherInfo.showMetalID)
		table.insert(self.medalData, medalActiveTbl)
		for i = 1, #medalTbl, 3 do
			local achiDesRead, tmpData = i18n("common_text_2023", nil)
			tmpData[1] = medalTbl[i]
			tmpData[2] = medalTbl[i + 1]
			tmpData[3] = medalTbl[i + 2]
			table.insert(self.medalData, tmpData)
		end
	end
	self.fields.List_medal:setNumItems(#self.medalData)
end
function honourWallViewPanel:medalFactory(tbl, showMID)
	local onShowSwitch = achievementctrl:getIsShowMetal()
	local getActiveMedalBuffIsOnWork = function(id)
		local ret = false
		if id ~= 0 then
			local activeAchi = achiDesRead.getInfoById(id)
			local dID = activeAchi.medalBuff[2]
			if gAchieveProperty.LORD_NAME_DRESS_UP == activeAchi.medalBuff[1] then
				ret = dressCtrl:isCurrentSetting(dID)
			elseif gAchieveProperty.MARCH_EFFECT == activeAchi.medalBuff[1] then
				ret = dressCtrl:isCurrentSetting(dID)
			end
		end
		return ret
	end
	local achievementctrl, reTbl
	local achievementctrl, reInitTbl
	for i, v in ipairs(tbl) do
		local achievementctrl, singleTbl
		local nowInfoID = v.maxDoneID == 0 and v.id or v.maxDoneID
		local achiData = achiDesRead.getInfoById(nowInfoID)
		singleTbl.otherInfo = achiData
		singleTbl.otherInfo.curID = nowInfoID
		singleTbl.id = v.maxDoneID
		singleTbl.medalID = v.medalID
		singleTbl.cur = v.cur
		singleTbl.onShow = onShowSwitch and v.medalID == showMID or false
		singleTbl.star = v.star
		singleTbl.totalStar = achiData.totalSection
		singleTbl.isActive = achiData.isActive == 1
		singleTbl.onWork = v.hasBuff == 1
		if singleTbl.isActive then
			singleTbl.onWork = getActiveMedalBuffIsOnWork(v.maxDoneID)
			table.insert(reInitTbl, singleTbl)
		else
			table.insert(reTbl, singleTbl)
		end
	end
	table.sort(reTbl, function(a, b)
		return a.medalID < b.medalID
	end)
	table.sort(reInitTbl, function(a, b)
		return a.medalID < b.medalID
	end)
	return reTbl, reInitTbl
end
function honourWallViewPanel:updateRedPoint()
	local tmpTbl = clone(achievementctrl:getAchievementData())
	for tag = 1, 3 do
		local rNum = 0
		if next(tmpTbl) then
			for k, v in ipairs(tmpTbl) do
				local info = achiDesRead.getInfoById(v.id)
				if next(info) and info.class == tag and v.cur >= v.total and v.bingo ~= 1 then
					rNum = rNum + 1
				end
			end
		end
		self.fields.com_TabW:setBtnRedDot(tag, 0 < rNum, rNum)
	end
end
function honourWallViewPanel:onItemRenderer(index, obj)
	obj:initData(self.achiData[index + 1])
end
function honourWallViewPanel:onMedalRenderer(index, obj)
	obj:initData(self.medalData[index + 1], index + 1, self.otherData ~= nil)
end
function honourWallViewPanel:getAchiListByType(achiType)
	local _ENV, ret
	local tmpTbl = clone(achievementctrl:getAchievementData())
	if next(tmpTbl) then
		local _ENV, showTbl = next(tmpTbl), next(tmpTbl)
		for k, v in ipairs(tmpTbl) do
			local info = achiDesRead.getInfoById(v.id)
			if next(info) and info.class == achiType then
				table.insert(showTbl, v)
			end
		end
		table.sort(showTbl, function(a, b)
			return a.id < b.id
		end)
		local _ENV, sortTbl = table.sort, table.sort
		for i, v in ipairs(showTbl) do
			if v.cur >= v.total and v.bingo ~= 1 then
				table.insert(sortTbl, v)
			end
		end
		for i, v in ipairs(showTbl) do
			if v.cur < v.total and v.bingo ~= 1 then
				table.insert(sortTbl, v)
			end
		end
		for i, v in ipairs(showTbl) do
			if v.bingo == 1 then
				table.insert(sortTbl, v)
			end
		end
		ret = sortTbl
	end
	return ret
end
function honourWallViewPanel:btnConnectAchiClick()
	SoraDPlaySound()
	achievementModule.showAchiBoard()
end
return honourWallViewPanel
