local preDownloadMainWidget = class("preDownloadMainWidget", function(target)
	if target == nil then
		return SoraDCreateBasePanel("preDownloadMainWidget")
	end
	return target
end)
function preDownloadMainWidget:ctor()
	self.btnGo = SoraDGetChildByName(self, "Button_box")
	self.btnGo:setSwallowTouches(false)
	self.nodeInfo = SoraDGetChildByName(self, "Node_Info")
	self.spIcon = SoraDGetChildByName(self, "pre_download_icon")
	self.spEffect = SoraDGetChildByName(self, "Sprite_effect")
	self.Text_percent = SoraDGetChildByName(self, "Text_percent")
	self.btnGo:addTouchEventListener(handler(self, self.onClickGo))
end
function preDownloadMainWidget:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_PRE_DOWNLOAD_GAME_PROGRESS", handler(self, self.updateeProgress))
	SoraDAddMessage(self, "MESSAGE_PRE_DOWNLOAD_GAME_DOWNSUC", handler(self, self.initData))
end
function preDownloadMainWidget:initData()
	local preDownloadUtil = include("preDownloadUtil")
	local DOWNLOAD_STATUS = preDownloadUtil.DOWNLOAD_STATUS
	local status = preDownloadUtil.getPreDownloadStatus()
	if status == DOWNLOAD_STATUS.DOWNLOAD_STATUS_NORMAL or status == DOWNLOAD_STATUS.DOWNLOAD_STATUS_DOWN_UNACTIVE then
		self.spIcon:setSpriteFrame("icon_activity_9001322_01.png")
		self.nodeInfo:setVisible(true)
		self.Text_percent:setString(i18n("download_first_name"))
		self:addEffect()
	else
		local isComplete = status == DOWNLOAD_STATUS.DOWNLOAD_STATUS_DOWN_COMPLE
		self.nodeInfo:setVisible(not isComplete)
		if isComplete then
			self.spIcon:setSpriteFrame("icon_activity_9001322_02.png")
			self.spEffect:stopAllActions()
		else
			self.spIcon:setSpriteFrame("icon_activity_9001322_01.png")
			self:addEffect()
		end
		local gametop = gModuleMgr.getObject("gametop")
		local preDownloadCtrl = gametop.playertop_:getModule("preDownloadCtrl")
		if preDownloadCtrl:isPlayerDownloaded() then
			self:updateeProgress_imp(1, 1)
		else
			local downloaded = preDownloadCtrl:getSizeDownloading()
			if downloaded <= 0 and (status == DOWNLOAD_STATUS.DOWNLOAD_STATUS_DOWN_PAUSE or status == DOWNLOAD_STATUS.DOWNLOAD_STATUS_DOWN_PAUSE_NETWORK) then
				self.Text_percent:setString(i18n("download_first_name"))
			else
				local total = preDownloadCtrl:getSizeTotal()
				self:updateeProgress_imp(downloaded, total)
			end
		end
	end
end
function preDownloadMainWidget:addEffect()
	_G.SoraDMixtureGLONE(self.spEffect)
	self.spEffect:stopAllActions()
	local frames = display.newFrames("dh_yuxiazai_%02d.png", 1, 25)
	local animation = display.newAnimation(frames, 0.08333333333333333)
	self.spEffect:playAnimationForever(animation)
end
function preDownloadMainWidget:updateeProgress(target, data)
	local total = data.total
	local downloaded = data.downloaded
	if not total or not downloaded then
		return
	end
	self:updateeProgress_imp(downloaded, total)
end
function preDownloadMainWidget:updateeProgress_imp(downloaded, total)
	self.total = total
	self.downloaded = downloaded
	local percent = 0
	if 0 < total then
		percent = downloaded / total * 100
	end
	percent = math.min(100, percent)
	self.Text_percent:setString(string.format("%0.1f%%", percent))
	if 60 <= percent and percent < 100 then
		if not self.log60 then
			self.log60 = true
			print("pre_download_success", 60)
			_ENV = 60
			;(60).progress = 60
			userSDKManager.logEvent(gSDKDef.TDonEvent.pre_download_success, 60)
		end
	elseif 30 <= percent and not self.log30 then
		self.loglog30 = true
		print("pre_download_success", 30)
		_ENV = 30
		;(30).progress = 30
		userSDKManager.logEvent(gSDKDef.TDonEvent.pre_download_success, 30)
	end
end
function preDownloadMainWidget:onClickGo(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local preDownloadUtil = include("preDownloadUtil")
		local isShow = preDownloadUtil:isShowPreDownloadWidget()
		if isShow then
			_G.clientEventMgr.singleClickEvent(gActivityTimeActivityID.PREDOWNLOAD_REWARD_ACTIVITY, 3)
		end
	end
end
return preDownloadMainWidget
