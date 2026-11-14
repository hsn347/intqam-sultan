local cityltCtrl = include("cityltCtrl")
local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local buildDescribeRead = include("buildDescribeRead")
local cityBuildLockArea = class("cityBuildLockArea", function(target)
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(target)
	end
	return target
end)
function cityBuildLockArea:ctor()
	self.singleIsMoved = false
	self.lock_board = SoraDGetChildByName(self, "Lock_Board")
	self.btn_area_lock = SoraDGetChildByName(self, "Btn_Area_Lock")
	self.text_lv = SoraDGetChildByName(self, "text_lv")
	self.dh_lock_area = SoraDGetChildByName(self, "dh_lock_area")
	self.lock_board:setLocalZOrder(10)
	if self.btn_area_lock then
		self.btn_area_lock:setSwallowTouches(false)
		self.btn_area_lock:setPressedActionEnabled(false)
		self.btn_area_lock:addTouchEventListener(handler(self, self.onBtnAreaLock))
	end
end
function cityBuildLockArea:initWithData(data)
	self.areaid = data.areaid
	self:updateView()
end
function cityBuildLockArea:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_MAINCITYVIEW_UNLOCK_AREA_SUCCESS", handler(self, self.smsgUnLockAreaSuccess))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_SHOW_LOCKAREA_REQ_LOADING", handler(self, self.msgShowReqLoading))
end
function cityBuildLockArea:getPreIsCanUnLock()
	return self.isCanUnLock
end
function cityBuildLockArea:getIsCanUnLock()
	local openGroundInfo = cityltCtrl.getOpenGoundInfo(self.areaid)
	if not openGroundInfo then
		print("lock area not found!")
		return
	end
	local precond = openGroundInfo.preCond
	local errprecond = true
	if precond then
		for i = 1, #precond / 2 do
			local _bid = precond[2 * i - 1]
			local _blv = precond[2 * i]
			local _curlv = cityCtrl:getBuildMaxLv(_bid)
			local _isreach = true
			if _blv > _curlv then
				errprecond = false
				_isreach = false
				local strErrInfo = "common_text_048"
				local strBidName = buildDescribeRead.getName(_bid)
				cityltCtrl = nil
				;(nil).buildName = strBidName
				;(nil).lv = _blv
				self.tipInfo = i18n(strErrInfo, nil)
				if self.text_lv then
					self.text_lv:setString(tostring(_blv))
				end
				break
			elseif self.text_lv then
				self.text_lv:setString(tostring(_blv))
			end
		end
	end
	return errprecond
end
function cityBuildLockArea:updateView()
	local errprecond = self:getIsCanUnLock()
	self.isCanUnLock = errprecond
	if errprecond == false then
	elseif self.et_particle == nil then
		_ENV, _ENV = nil, self.et_particle
		_ENV, (nil).plist = nil, "et_chengwaikechai_01.plist"
		;(nil).x = 1.74
		_ENV, self.et_particle[1], (nil).scale, (nil).y = nil, nil, nil, 1.79
		_ENV, (nil).plist = nil, "et_chengwaikechai_02.plist"
		;(nil).x = -12
		self.et_particle[2], (nil).pos, (nil).y = nil, nil, -12
		local param = self.et_particle
		self.et_particle = SoraDCreateEffectNode(param)
		local x, y = self.btn_area_lock:getPosition()
		self.et_particle:setPosition(cc.p(x, y))
		self:addChild(self.et_particle, 88)
	end
end
function cityBuildLockArea:onBtnAreaLock(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		if true == self:getIsCanUnLock() then
			print("打开开启空地界面")
			self:openLockAreaPanel()
			local cityBuildConstDef = include("cityBuildConstDef")
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINCITY_PLAY_SOUND"
			;(nil).classify = "innercontrol"
			;(nil).index = 10
			;(nil).tag = cityBuildConstDef.ActionTag.Tag_Play_Click_Build_Sound
			SoraDSendMessage(nil)
		else
			self:ShowNodeTintOnce()
			local iconSprite = display.newSprite("#BG_undeveloped_surface_01.png")
			iconSprite:setScale(0.4)
			SoraDShowMsgTip(self.tipInfo, iconSprite)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function cityBuildLockArea:ShowNodeTintOnce()
	local showTint = function(target)
		target:stopAllActions()
		target:setColor(cc.c3b(100, 100, 100))
		local actionTintTo = cca.tintBy(0.2, 0.6078431372549019, 0.6078431372549019, 0.6078431372549019)
		target:runAction(actionTintTo)
	end
	showTint(self.dh_lock_area)
end
function cityBuildLockArea:openLockAreaPanel()
	local mainCityView = SoraDCurrentSceneShowView("mainCityView")
	if mainCityView and not mainCityView.isBuildBtnEnable then
		return
	end
	_ENV = nil
	;(nil).unlockAreaID = self.areaid
	uiManager:show("BuildCreateInfo", nil)
	_ENV = uiManager
	uiManager.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
	uiManager.offsetType = MAINCITYVIEW_OFFSET_TYPE_LOCK_AREA
	uiManager.areaid = self.areaid
	SoraDSendMessage(uiManager)
	_ENV = uiManager
	uiManager.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
	uiManager.isBuildBtnEnable = false
	uiManager.delay = 0.016666666666666666
	SoraDSendMessage(uiManager)
end
function cityBuildLockArea:confirm(type)
	if type == MSGBOX_CALLBACK_YES then
		print("confirm")
		cityCtrl:openGroundReq(self.areaid)
	end
end
function cityBuildLockArea:doUnLock()
	print("unlock area:" .. self.areaid)
	local doTint = function(target)
		local actionDelay = cca.delay(0.8)
		local actionFadeOut = cca.fadeOut(1.0)
		_UPVALUE2_ = nil
		;(nil)[1] = actionDelay
		;(nil)[2] = actionFadeOut
		local actSeq = cca.seq(nil)
		target:runAction(actSeq)
	end
	doTint(self.dh_lock_area)
	local funUnlockRead = include("funUnlockRead")
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.FUN_OPEN_PREVIEW)
	if unlockLv <= SoraDGetCastleLv() then
		local actionDelay = cca.delay(1.6)
		local callFunc = cca.callFunc(function()
			SoraDAddPopupWindow(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end, uiDequeTypeTab.BUILDUNLOCK)
			function _ENV(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end
			;(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end).msg = "MESSAGE_MAINCITYVIEW_UNLOCK_AREA"
			;(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end).areaid = self.areaid
			SoraDSendMessage(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end)
		end)
		_UPVALUE2_ = nil
		;(nil)[1] = actionDelay
		;(nil)[2] = callFunc
		local actionSeq = cca.seq(nil)
		self:runAction(actionSeq)
	else
		_ENV = cca.callFunc(function()
			SoraDAddPopupWindow(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end, uiDequeTypeTab.BUILDUNLOCK)
			function _ENV(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end
			;(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end).msg = "MESSAGE_MAINCITYVIEW_UNLOCK_AREA"
			;(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end).areaid = self.areaid
			SoraDSendMessage(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end)
		end)
		cca.callFunc(function()
			SoraDAddPopupWindow(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end, uiDequeTypeTab.BUILDUNLOCK)
			function _ENV(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end
			;(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end).msg = "MESSAGE_MAINCITYVIEW_UNLOCK_AREA"
			;(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end).areaid = self.areaid
			SoraDSendMessage(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end)
		end).msg = "MESSAGE_MAINCITYVIEW_UNLOCK_AREA"
		cca.callFunc(function()
			SoraDAddPopupWindow(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end, uiDequeTypeTab.BUILDUNLOCK)
			function _ENV(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end
			;(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end).msg = "MESSAGE_MAINCITYVIEW_UNLOCK_AREA"
			;(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end).areaid = self.areaid
			SoraDSendMessage(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end)
		end).areaid = self.areaid
		SoraDSendMessage((cca.callFunc(function()
			SoraDAddPopupWindow(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end, uiDequeTypeTab.BUILDUNLOCK)
			function _ENV(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end
			;(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end).msg = "MESSAGE_MAINCITYVIEW_UNLOCK_AREA"
			;(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end).areaid = self.areaid
			SoraDSendMessage(function(...)
				_ENV = nil
				;(nil).showType = 3
				uiManager:show("CityUpgradeUnlock", nil)
			end)
		end)))
	end
end
function cityBuildLockArea:smsgUnLockAreaSuccess(target, data)
	local areaid = data.areaid
	if areaid ~= self.areaid then
		return
	end
	self:doUnLock()
end
function cityBuildLockArea:hideBoardAndLv()
	self.lock_board:setVisible(false)
	self.text_lv:setVisible(false)
end
function cityBuildLockArea:msgShowReqLoading(target, data)
	local areaid = data.areaid
	if areaid ~= self.areaid then
		return
	end
	print("showLoading ----------------------------------------------------")
	local loading = SoraDShowLoading(self.btn_area_lock, self.btn_area_lock:getContentSize())
	loading:setPosition(cc.p(self.btn_area_lock:getContentSize().width / 2, self.btn_area_lock:getContentSize().height / 2))
end
function cityBuildLockArea:getLockAreaBtn()
	return self.btn_area_lock
end
return cityBuildLockArea
