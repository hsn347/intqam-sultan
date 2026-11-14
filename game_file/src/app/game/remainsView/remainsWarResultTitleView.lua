local remainsWarRead = include("remainsWarRead")
local remainsWarUtil = include("remainsWarUtil")
local remainsWarResultTitleView = class("remainsWarResultTitleView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("remainsWarResultTitleView")
	end
	return target
end)
function remainsWarResultTitleView:ctor()
	self:setBackGround(229.5)
	self.isInRemains = true
	self:initWidget()
end
function remainsWarResultTitleView:initWidget()
	SoraDGetChildByName(self, "Top_Text_tips"):setString(i18n("remains_text_323"))
	self.nodeResutl = SoraDGetChildByName(self, "Top_Node_result")
	self.Top_Image_bg = SoraDGetChildByName(self, "Top_Image_bg")
	local bgH = self.Top_Image_bg:getContentSize().height
	self.Top_Image_bg:setScale((display.height - (960 - bgH)) / bgH)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_title")
	self.Button_ok = SoraDGetChildByName(self, "Button_ok")
	self.Button_ok:setTitleText(i18n("common_text_204"))
	self.Button_ok:addTouchEventListener(handler(self, self.onBtnOKClick))
	self.Button_share = SoraDGetChildByName(self, "Button_share")
	self.Button_share:addTouchEventListener(handler(self, self.onBtnShareClick))
	self.Button_ok:setPositionX(320 + SoraDFSign(160))
	self.Button_share:setPositionX(320 - SoraDFSign(160))
end
function remainsWarResultTitleView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_RESUT_SHARE", handler(self, self.updateShareStatus))
end
function remainsWarResultTitleView:initData(data)
	if not data.resultInfo then
		_ENV = data.resultInfo
	end
	self.tableSingleData = data.resultInfo
	if not self.tableSingleData.ruinsWarSettleData then
		local _ENV, ruinsWarSettleData = self.tableSingleData.ruinsWarSettleData, self.tableSingleData.ruinsWarSettleData
	end
	if not ruinsWarSettleData[_G.RW_CAMP.SOUTH] then
		local _ENV, southData = ruinsWarSettleData[_G.RW_CAMP.SOUTH], ruinsWarSettleData[_G.RW_CAMP.SOUTH]
	end
	if not ruinsWarSettleData[_G.RW_CAMP.NORTH] then
		local _ENV, northData = ruinsWarSettleData[_G.RW_CAMP.NORTH], ruinsWarSettleData[_G.RW_CAMP.NORTH]
	end
	self.southData = southData
	self.northData = northData
	if not southData.members then
		_ENV = southData.members
	end
	if not remainsWarUtil.isSelfIn(southData.members) then
		if not northData.members then
			_ENV = northData.members
		end
	end
	self.isInRemains = remainsWarUtil.isSelfIn(northData.members)
	self.titleUser = self.tableSingleData.titleUser
	self:setViewStatus()
	self:updateScrollTitle()
	self:updateShareStatus()
end
function remainsWarResultTitleView:setViewStatus()
	if not self.isInRemains then
		self.Button_share:setVisible(false)
		self.Button_ok:setPositionX(320)
	else
		local animateNmae
		local bSuc = self.tableSingleData.isWin
		if not bSuc then
			if SoraDFIsRA() then
				animateNmae = "heroTrialLoseAr"
			else
				animateNmae = "heroTrialLoseEn"
			end
		elseif SoraDFIsRA() then
			animateNmae = "heroTrialWinAr"
		else
			animateNmae = "heroTrialWinEn"
		end
		if animateNmae then
			local node = SoraDCreatAnimation(animateNmae, nil, false)
			self.nodeResutl:addChild(node)
		end
	end
end
function remainsWarResultTitleView:updateScrollTitle(...)
	if not self.titleUser or not next(self.titleUser) then
		return
	end
	local itemH = 92
	local sSize = self.scroll:getContentSize()
	local sH = math.max(sSize.height, itemH * 5)
	self.scroll:setInnerContainerSize(cc.size(sSize.width, sH))
	local posy = sH
	for i = 1, 5 do
		local uid = self.titleUser[tostring(i)]
		local data, camp = self:getPlayerData(uid)
		if data then
			local item = SoraDCreatePanel("remainsWarTitleSingle")
			item:setVisible(true)
			item:addTo(self.scroll)
			posy = posy - itemH
			item:setPosition(display.cx, posy)
			_ENV = display.cx
			display.cx.data = data
			display.cx.titleType = i
			display.cx.camp = camp
			item:initData(display.cx)
		end
	end
end
function remainsWarResultTitleView:getPlayerData(uid)
	if not self.southData.members then
		_ENV = self.southData.members
	end
	for i, v in ipairs(self.southData.members) do
		if v.uid == uid then
			return v, _G.RW_CAMP.SOUTH
		end
	end
	if not self.northData.members then
		_ENV = self.northData.members
	end
	for i, v in ipairs(self.northData.members) do
		if v.uid == uid then
			return v, _G.RW_CAMP.NORTH
		end
	end
end
function remainsWarResultTitleView:onBtnOKClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:close(self, ccui.TouchEventType.ended)
	end
end
function remainsWarResultTitleView:onBtnShareClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("remainsWarResultShareBox")
		panel:show()
	end
end
function remainsWarResultTitleView:updateShareStatus()
	local remainsWarUtil = include("remainsWarUtil")
	local err = remainsWarUtil.checkResultShare()
	local enable = gErrDef.Err_None == err
	if enable then
		self.Button_share:setTitleText(i18n("common_text_533"))
	else
		self.Button_share:setTitleText(i18n("remains_text_198"))
	end
	self.Button_share:setTouchEnabled(enable)
	self.Button_share:setBright(enable)
end
function remainsWarResultTitleView:close(ref, type)
	if type == ccui.TouchEventType.ended then
		if not self.isInRemains then
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINSCEN_ONSHOW"
			;(nil).viewType = VIEW_TYPE_CITY
			SoraDSendMessage(nil)
		else
			local panel = SoraDCreatePanel("remainsWarScoreView")
			panel:show()
			panel:initData(self.tableSingleData)
		end
		self:closePanel()
	end
end
return remainsWarResultTitleView
