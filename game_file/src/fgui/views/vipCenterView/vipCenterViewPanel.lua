local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local privilegeGiftCtrl = SoraDGetCtrl("privilegeGiftCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
local privilegeGiftRead = include("privilegeGiftRead")
local rechargeRead = include("rechargeRead")
local vipDailyGiftltCtrl = include("vipDailyGiftltCtrl")
local vipLocalData = include("vipLocalData")
local lordLocalData = include("lordLocalData")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local vipCenterViewPanel = class("vipCenterViewPanel", baseFguiPanel)
function vipCenterViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("vipCenterViewPanel:ctor", self.viewName)
end
function vipCenterViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function vipCenterViewPanel:onInit()
	print("=======vipCenterViewPanel:onInit")
	self.isHideCurrentSceneView = true
	self.fields.Com_title:initData(i18n("VIP"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_loadDes:setString(i18n("common_text_3971"))
	self.fields.Text_vipTime = SoraDCreateTimerLabel(self, self.fields.Text_vipTime)
	self.fields.Text_vipTime:setTimeLast(function(strTime)
		return i18n("lucky_text_15") .. ":" .. fguiHelper.getColorString("#FFD43E", strTime)
	end)
	self.fields.Text_vipTime:setVisible(false)
	self.fields.Button_addInt:setString(i18n("vip_text_02"))
	self.fields.Button_addInt:addClickListener(handler(self, self.btnAddIntClick))
	self.fields.Com_vipPackage:setStatus(true)
	self.fields.Com_vipPackage:addClickListener(handler(self, self.btnVipPackageInfoClick))
	if not commonCheck.VIP_PRIVILEGE_GIFT then
		self.fields.Com_vipPackage:setVisible(false)
	end
	self.fields.btn_shining:addClickListener(handler(self, self.btnShiningClick))
	self.fields.Button_lock:addClickListener(handler(self, self.btnLockClick))
	self.fields.Button_lock:setVisible(false)
	self.fields.Button_left:addTouchEventListener(handler(self, self.btnLeftPageClick))
	self.fields.Button_right:addTouchEventListener(handler(self, self.btnRightPageClick))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onPageItemRenderer))
	if display.height < 1136 then
		local offsetX = -0.4 * display.height + 380
		self.fields.nl:setPositionX(-offsetX)
		self.fields.nr:setPositionX(self:getWidth() + offsetX)
	end
	self.fields.Bar:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.Com_vip:fixPos()
	self.fields.btn_shining:fixPos()
	self.fields.com_curVip:fixPos()
	self.fields.com_nextVip:fixPos()
	self.fields.Text_curIntegral:fixPos()
	self.fields.Text_goOnDay:fixPos()
	self.fields.Text_nextLogin:fixPos()
	self.fields.Text_vipTime:fixPos()
	self.fields.Com_vipPackage:fixPos()
	self.fields.Button_left:fixPos()
	self.fields.Button_left:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.Button_right:fixPos()
	self.fields.Button_right:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.n2:fix()
end
function vipCenterViewPanel:onShow()
	print("=======vipCenterViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.isKLVOpen = kingdomLevelDataModuleAPI:isOpen()
	self.pagesCount = self.isKLVOpen and VIP_MAX_LV - 1 or VIP_SVIP_LV
	self.fields.List:addEventListener(fgui.UIEventType.ScrollEnd, function()
		local itemIndex = self.fields.List:childIndexToItemIndex(0)
		self.curLookLv = itemIndex % self.pagesCount + 1
		print("==self.curLookLv==", itemIndex, self.curLookLv)
		local isSvip = self.curLookLv > VIP_SVIP_LV
		self.fields.Lab_vip:initData(isSvip and self.curLookLv - VIP_SVIP_LV or self.curLookLv, isSvip)
		local slv, blv = self:getLookCurLv(self.curLookLv)
		local kLv = kingdomLevelDataModuleAPI:getKingdomLevel()
		self.fields.Button_lock:setVisible(isSvip and kLv < vipLocalData.vip2kLevel(slv))
		self:setBtnLeftRight()
	end)
	self:initData()
end
function vipCenterViewPanel:endShow()
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	if not guideCtrl:updateGuideModule(gGuideModule.VIP) then
		print("触发引导")
	end
end
function vipCenterViewPanel:onPageItemRenderer(index, obj)
	obj:initPageData(index + 1, self.pagesCount)
end
function vipCenterViewPanel:initData(target, data)
	self.vipInfo = lordInfoCtrl:getVipDetails()
	self.fields.List:setNumItems(self.pagesCount)
	self:initHeadNode()
	self:setBtnShiningStatus()
end
function vipCenterViewPanel:setBtnShiningStatus()
	self.fields.btn_shining:setBoxStatus(0)
	if self.vipInfo.level < VIP_LV5_LIMITED then
		self.fields.btn_shining:setBoxStatus(2)
	else
		local vipInfo = lordInfoCtrl:getVip()
		if not vipInfo or not vipInfo[2] then
			self.fields.btn_shining:setBoxStatus(2)
		end
		if lordInfoCtrl:vipDailyGiftBeGot() then
			self.fields.btn_shining:setBoxStatus(1)
		end
	end
end
function vipCenterViewPanel:initHeadNode()
	self.curLookLv = self.isKLVOpen and math.min(self.vipInfo.level, VIP_MAX_LV - 1) or math.min(self.vipInfo.level, VIP_SVIP_LV - 1)
	self.fields.List:scrollToView(self.curLookLv - 1)
	self:setBtnLeftRight()
	self.fields.Text_curIntegral:setString(i18n("common_text_448") .. fguiHelper.getColorString("#FFD43E", string.formatnumberthousands(self.vipInfo.vipPoint)))
	_ENV = string.formatnumberthousands(self.vipInfo.vipPoint)
	string.formatnumberthousands(self.vipInfo.vipPoint).day = self.vipInfo.vipLogin
	self.fields.Text_goOnDay:setString(i18n("common_text_450") .. fguiHelper.getColorString("#FFD43E", i18n("common_text_227", string.formatnumberthousands(self.vipInfo.vipPoint))))
	if self.isKLVOpen then
		if self.vipInfo.level >= VIP_SVIP_LV then
			self.fields.Text_nextLogin:setString(i18n("common_text_692") .. fguiHelper.getColorString("#FFD43E", self.vipInfo.nextVipPoint .. " " .. i18n("common_text_3852")))
			self.fields.Text_curIntegral:setString(i18n("common_text_3975") .. _pq(fguiHelper.getColorString("#FFD43E", string.formatnumberthousands(self.vipInfo.vipPoint))))
		else
			_ENV = fguiHelper.getColorString("#FFD43E", string.formatnumberthousands(self.vipInfo.vipPoint))
			fguiHelper.getColorString("#FFD43E", string.formatnumberthousands(self.vipInfo.vipPoint)).count = self.vipInfo.nextVipPoint
			self.fields.Text_nextLogin:setString(i18n("common_text_692") .. fguiHelper.getColorString("#FFD43E", i18n("common_text_444", fguiHelper.getColorString("#FFD43E", string.formatnumberthousands(self.vipInfo.vipPoint)))))
		end
	else
		_ENV = i18n("common_text_444", fguiHelper.getColorString("#FFD43E", string.formatnumberthousands(self.vipInfo.vipPoint)))
		i18n("common_text_444", fguiHelper.getColorString("#FFD43E", string.formatnumberthousands(self.vipInfo.vipPoint))).count = self.vipInfo.nextVipPoint
		self.fields.Text_nextLogin:setString(i18n("common_text_692") .. fguiHelper.getColorString("#FFD43E", i18n("common_text_444", i18n("common_text_444", fguiHelper.getColorString("#FFD43E", string.formatnumberthousands(self.vipInfo.vipPoint))))))
	end
	self:initVipGift()
	self:vipTimerUpdate()
	self:initProgressBar()
	self:initUnderPage()
end
function vipCenterViewPanel:initUnderPage()
	self:setBuffLv(self.vipInfo.level)
	local slv, blv = self:getLookCurLv(self.vipInfo.level)
	self:initVipPrivilegePackages(self.vipInfo.level)
end
function vipCenterViewPanel:setPageView()
	self.fields.List:scrollToView(self.curLookLv - 1, true)
	self:setBtnLeftRight()
end
function vipCenterViewPanel:setBtnLeftRight()
	if self.curLookLv >= self.pagesCount then
		self.fields.Button_left:setVisible(false)
		self.fields.Button_right:setVisible(true)
	elseif self.curLookLv <= 1 then
		self.fields.Button_left:setVisible(true)
		self.fields.Button_right:setVisible(false)
	else
		self.fields.Button_left:setVisible(true)
		self.fields.Button_right:setVisible(true)
	end
end
function vipCenterViewPanel:setBuffLv(minLv)
	local slv, blv = self:getLookCurLv(minLv)
	local kLv = kingdomLevelDataModuleAPI:getKingdomLevel()
	local isSvip = slv > VIP_SVIP_LV
	self.fields.Lab_vip:initData(isSvip and slv - VIP_SVIP_LV or slv, isSvip)
	self.fields.Button_lock:setVisible(isSvip and kLv < vipLocalData.vip2kLevel(slv))
end
function vipCenterViewPanel:initProgressBar()
	local kingdomLev = kingdomLevelDataModuleAPI:getKingdomLevel() or 0
	local maxVipLev = vipLocalData.getMaxVipLev(kingdomLev)
	local maxLordLev = lordLocalData.getMaxLordLev(kingdomLev)
	local bp, ep, cp, lv = vipLocalData.getVipPointShowData(self.vipInfo.realVipPoint, maxVipLev)
	local slv, blv = self:getLookCurLv(lv)
	local maxPoint = ep - bp
	self.fields.Bar:setMax(maxPoint)
	self.fields.Bar:setValue(cp)
	kingdomLevelDataModuleAPI = nil
	;(nil).var1 = cp
	;(nil).var2 = maxPoint
	self.fields.Text_progress:setString(i18n("%{var1}/%{var2}", nil))
	self.fields.com_curVip:initData(slv)
	self.fields.com_curVip:setStatus(true)
	local isMaxLv = false
	if slv >= VIP_MAX_LV - 1 then
		self.fields.com_nextVip:initData(blv - 1)
	else
		self.fields.com_nextVip:initData(blv)
	end
	if self.isKLVOpen then
		if self.vipInfo.level < VIP_MAX_LV - 1 then
			self.fields.com_nextVip:setStatus(false)
		else
			self.fields.com_nextVip:setStatus(true)
			self.fields.Bar:setValue(maxPoint)
			self.fields.Text_progress:setString("MAX")
			isMaxLv = true
		end
	elseif self.vipInfo.level < VIP_SVIP_LV then
		self.fields.com_nextVip:setStatus(false)
	else
		self.fields.com_nextVip:setStatus(true)
		self.fields.Bar:setValue(maxPoint)
		self.fields.Text_progress:setString("MAX")
		isMaxLv = true
	end
	self.fields.Button_addInt:setVisible(not isMaxLv)
	self.fields.Text_loadDes:setString(isMaxLv and i18n("common_text_4879") or i18n("common_text_3971"))
end
function vipCenterViewPanel:getLookCurLv(minLv)
	if self.isKLVOpen then
		minLv = math.max(math.min(minLv, VIP_MAX_LV - 1), 1)
	else
		minLv = math.max(math.min(minLv, VIP_SVIP_LV - 1), 1)
	end
	return minLv, minLv + 1
end
function vipCenterViewPanel:initVipGift(target, redata)
	SoraDCloseLoading(self)
	if redata and redata.result then
		local itemList = redata.giftInfo
		if next(itemList) ~= nil then
			SoraDMailGainItems(itemList, true)
		end
	end
	self.fields.Com_vip:initData()
	self:setBtnShiningStatus()
end
function vipCenterViewPanel:vipTimerUpdate()
	local stopTimer = function()
		self.fields.Text_vipTime:setVisible(false)
	end
	self.vipTimerQueue = queueCtrl:queryQueue(gQueueTypeDef.vip_time)
	if self.vipTimerQueue then
		local leftTime = self.vipTimerQueue.timerNode.timer:getRemainTime()
		if 0 < leftTime then
			self.fields.Text_vipTime:beginTime(self.vipTimerQueue.timerNode.timer:getRemainTime())
			self.fields.Text_vipTime:setTimeEndListener(stopTimer)
			self.fields.Text_vipTime:setVisible(true)
		else
			stopTimer()
		end
	else
		stopTimer()
	end
end
function vipCenterViewPanel:updateVipPrivilegeGift(target, data)
	self:initVipPrivilegePackages(self.curLookLv)
end
function vipCenterViewPanel:initVipPrivilegePackages(curLv, isPageTurn)
	if not commonCheck.VIP_PRIVILEGE_GIFT then
		return
	end
	local packageInfo = privilegeGiftRead.getVipPrivilegePackageDataByLv(curLv)
	local packageName = i18n(rechargeRead.getPageViewData(packageInfo.rechargeID).activeName)
	local retValue = privilegeGiftCtrl:getErrByRechargeID(packageInfo.rechargeID)
	local curPrice = paymentManager.judgePrice(packageInfo.rechargeID, packageInfo.price)
	local discount = packageInfo.originalPrice / packageInfo.price
	local oriPrice = paymentManager.calculateDiscount(packageInfo.rechargeID, curPrice, discount, packageInfo.originalPrice)
	self.fields.Com_vipPackage:setStatus(true)
	if retValue == gErrDef.Err_PRIVILEGE_GIFT_ALREADY_BUY then
		self.fields.Com_vipPackage:setStatus(false)
	elseif retValue == gErrDef.Err_PRIVILEGE_GIFT_VIP_LV_NOT_ENOUGH then
		self.fields.Com_vipPackage:setStatus(false)
	end
	paymentManager.OnemtOpenGiftUI(packageInfo.rechargeID, gRechargeActiveFromEnum.ROAD29, isPageTurn)
end
function vipCenterViewPanel:returnLookLv(small2big)
	if small2big then
		self.curLookLv = math.min(self.curLookLv + 1, self.pagesCount)
		return self.curLookLv
	else
		self.curLookLv = math.max(self.curLookLv - 1, 1)
		return self.curLookLv
	end
end
function vipCenterViewPanel:turnPage(actionFoward)
	print("actionFoward===", actionFoward)
	local curLookLv = self:returnLookLv(actionFoward)
	print("curLookLv", curLookLv)
	self.curLookLv = curLookLv
	self:setPageView()
end
function vipCenterViewPanel:btnLeftPageClick()
	SoraDPlaySound()
	self:turnPage(true)
end
function vipCenterViewPanel:btnRightPageClick()
	SoraDPlaySound()
	self:turnPage(false)
end
function vipCenterViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("VIP")
	;(nil).content = i18n("common_text_4624")
	uiManager:show("RuleView", nil)
end
function vipCenterViewPanel:btnAddIntClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemType = gItemType.VIP_POINT
	;(nil).itemType2 = self.isKLVOpen and gItemType.S_VIP_POINT or nil
	uiManager:show("vipBuyView", nil)
end
function vipCenterViewPanel:btnShiningClick()
	SoraDPlaySound()
	if self.vipInfo.level < VIP_LV5_LIMITED then
		_ENV = nil
		;(nil).level = VIP_LV5_LIMITED
		uiManager:show("vipCenterRewardView", nil)
	else
		local vipInfo = lordInfoCtrl:getVip()
		if not lordInfoCtrl:vipDailyGiftBeGot() and vipInfo and not not vipInfo[2] then
			SoraDShowLoading(self)
			lordInfoCtrl:getVipDailyGift()
		else
			_ENV = VIP_LV5_LIMITED
			VIP_LV5_LIMITED.level = self.vipInfo.level
			uiManager:show("vipCenterRewardView", VIP_LV5_LIMITED)
		end
	end
end
function vipCenterViewPanel:btnVipPackageInfoClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).curLv = self.curLookLv
	uiManager:show("vipPrivilegeGiftPopView", nil)
end
function vipCenterViewPanel:btnLockClick()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("common_text_4311"))
end
function vipCenterViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_vipGift" then
		return self.fields.Com_vip:getBtnVipGift()
	else
		return self.fields[itemName]
	end
end
return vipCenterViewPanel
