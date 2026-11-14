local preDownloadUtil = include("preDownloadUtil")
local DOWNLOAD_STATUS = preDownloadUtil.DOWNLOAD_STATUS
local preDownloadActivity = class("preDownloadActivity", function(target)
	if target == nil then
		return SoraDCreateBasePanel("preDownloadActivity")
	end
	return target
end)
function preDownloadActivity:ctor()
	self.activityID = gActivityTimeActivityID.PREDOWNLOAD_REWARD_ACTIVITY
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_title")
	self.ccs_title:setTitle(i18n("download_first_name"))
	self.rewardArray, _ENV = self.ccs_title.setTitle, self.ccs_title.setTitle
	self.Center_Image = SoraDGetChildByName(self, "Center_Image")
	self.Center_Image:setContentSize(cc.size(852, 1386))
	self.bgSp = cc.criSprite.createCriSprite("yuxiazai_01.usm", false, true)
	self.bgSp:addTo(self.Center_Image)
	self.bgSp:setPosition(cc.p(426.0, 693.0))
	self.txtTip = SoraDGetChildByName(self, "Text_tip")
	self.txtTipAward = SoraDGetChildByName(self, "Text_tip_award")
	self.txtTipAward:setColor(cc.c3b(255, 255, 255))
	self.btnGo = SoraDGetChildByName(self, "Button_go")
	self.preDownloadProgressPro = SoraDGetExtendChildFromCCSByName(self, "CCS_preDownloadProgress_pro")
	self.Node_items = SoraDGetChildByName(self, "Node_items")
	self.btnGo:addTouchEventListener(handler(self, self.onClickGo))
	self.txtTip:setString(i18n("download_first_description_02"))
	self:initView()
end
function preDownloadActivity:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_PRE_DOWNLOAD_REFRESH", handler(self, self.reqPredownloadStartRSP))
	local gametop = gModuleMgr.getObject("gametop")
	local preDownloadCtrl = gametop.playertop_:getModule("preDownloadCtrl")
	if not preDownloadCtrl:getShowPreDownloadRedCfg() then
		preDownloadCtrl:setShowPreDownloadRedCfg(true)
	end
end
function preDownloadActivity:initView()
	self:initAwards()
	self:updateStatus()
end
function preDownloadActivity:updateStatus()
	local status = preDownloadUtil.getPreDownloadStatus()
	self.preDownloadProgressPro:initData(status)
	if status == DOWNLOAD_STATUS.DOWNLOAD_STATUS_DOWNING then
		self.txtTipAward:setString(i18n("download_first_description_04"))
		self.btnGo:loadTextures("btn_red_normal_01.png", "", "", ccui.TextureResType.plistType)
		self.btnGo:setTitleText(i18n("download_first_button_01"))
		self.btnGo:setTouchEnabled(true)
		self.btnGo:setBright(true)
	elseif status == DOWNLOAD_STATUS.DOWNLOAD_STATUS_DOWN_COMPLE then
		self.txtTipAward:setString(i18n("download_first_description_07"))
		self.btnGo:loadTextures("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
		self.btnGo:setTitleText(i18n("download_first_mail_title_08"))
		self.btnGo:setTouchEnabled(false)
		self.btnGo:setBright(false)
	else
		self.txtTipAward:setString(i18n("download_first_description_04"))
		self.btnGo:loadTextures("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
		self.btnGo:setTitleText(i18n("download_first_button"))
		self.btnGo:setTouchEnabled(true)
		self.btnGo:setBright(true)
	end
	_G.SoraDAutoSizeButtonTextByContent(self.btnGo)
end
function preDownloadActivity:initAwards()
	local preDownloadRead = include("preDownloadRead")
	if not preDownloadRead.getAward() then
		local _ENV, awards = preDownloadRead.getAward(), preDownloadRead.getAward()
	end
	self.award = awards
	local awardCount = math.floor(#self.award / 2)
	for i = 1, 4 do
		self.rewardArray[i] = include("commonItemAward").new()
		if i <= awardCount then
			self.rewardArray[i]:setBaseScale(1.0)
			self.rewardArray[i]:setOwnView(self)
			self.rewardArray[i]:initData(self.award[2 * i - 1], self.award[2 * i])
			self.rewardArray[i]:setPosition(0, 0)
			self.rewardArray[i]:addTo(self.Node_items)
		end
	end
	SoraDToCenter(self.Node_items, 120, SoraDFIsRA())
end
function preDownloadActivity:onClickGo(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local status = preDownloadUtil.getPreDownloadStatus()
		if status == DOWNLOAD_STATUS.DOWNLOAD_STATUS_DOWN_PAUSE_NETWORK then
			preDownloadUtil.checkPreDownloadAutoStart()
			_ENV = nil
			;(nil).msg = "MESSAGE_PRE_DOWNLOAD_REFRESH"
			SoraDSendMessage(nil)
		elseif status == DOWNLOAD_STATUS.DOWNLOAD_STATUS_DOWNING then
			local showMsg = i18n("download_first_description_022")
			_ENV = nil
			;(nil).layout = true
			SoraDShowMsgBox(showMsg, i18n("download_first_button_02"), i18n("download_first_button_01"), function(callType)
				if callType == MSGBOX_CALLBACK_NO then
					local gametop = gModuleMgr.getObject("gametop")
					local preDownloadCtrl = gametop.playertop_:getModule("preDownloadCtrl")
					if not preDownloadCtrl:isPlayerPause() then
						preDownloadCtrl:reqPredownloadStop()
						SoraDShowLoading(self, nil, nil, nil, 5)
					end
				end
			end, nil)
		else
			local gametop = gModuleMgr.getObject("gametop")
			local preDownloadCtrl = gametop.playertop_:getModule("preDownloadCtrl")
			preDownloadCtrl:reqPredownloadStart()
			SoraDShowLoading(self)
			userSDKManager.logEvent(gSDKDef.TDonEvent.click_pre_download)
		end
	end
end
function preDownloadActivity:reqPredownloadStartRSP(target, data)
	SoraDCloseLoading(self)
	self:updateStatus()
end
function preDownloadActivity:judgeClose()
	if self.activityID and not _G.clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
return preDownloadActivity
