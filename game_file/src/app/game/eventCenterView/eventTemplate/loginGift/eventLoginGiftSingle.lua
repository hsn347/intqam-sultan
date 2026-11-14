local gametop = gModuleMgr.getObject("gametop")
local loginGiftCtrl = gametop.playertop_:getModule("loginGiftCtrl")
local MAX_AWARD_NUM = 5
local eventLoginGiftSingle = class("eventLoginGiftSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventLoginGiftSingle")
	end
	return target
end)
function eventLoginGiftSingle:ctor()
	self.awardArray, _ENV, self.data, _ENV = nil, nil, nil, nil
	self.taskStatus = gBtnTargetStatusDef.GO
	self.Button_go = SoraDGetChildByName(self, "Button_go")
	SoraDAutoSizeButtonText(self.Button_go, cc.size(120, 50))
	self.Button_go:setSwallowTouches(false)
	self.Button_go:setTitleText(i18n("common_text_477"))
	self.Button_go:addTouchEventListener(handler(self, self.btnOperateClick))
	self.Text_des = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_des"))
	self.Text_schedule = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_schedule"))
end
function eventLoginGiftSingle:initData(data, otherData)
	self.data = data
	if otherData then
		self.view = otherData.view
		self.ownScroll = otherData.scroll
	end
	local lang = "king_road_01"
	local targetNum = self.data.aimDays
	_ENV = nil
	_ENV, _ENV, (nil).num = targetNum, targetNum and string.formatnumberthousands(targetNum) or "", targetNum and string.formatnumberthousands(targetNum) or ""
	targetNum.color = "#ffff00"
	_ENV, (targetNum and string.formatnumberthousands(targetNum) or "").num, targetNum.i = targetNum, targetNum, "true"
	;(targetNum and string.formatnumberthousands(targetNum) or "").__default, targetNum.color = targetNum, "#d7c39b"
	local str_des = i18n_html(lang, nil, targetNum and string.formatnumberthousands(targetNum) or "")
	self.Text_des:setString(str_des)
	local isReceived = loginGiftCtrl:isReceived(self.data.taskIndex)
	self.taskStatus = gBtnTargetStatusDef.GO
	if isReceived then
		self.taskStatus = gBtnTargetStatusDef.GOT
	elseif self.data.loginDays >= self.data.aimDays then
		self.taskStatus = gBtnTargetStatusDef.GET
	end
	_ENV = nil
	;(nil).count = self.data.loginDays
	_ENV, (nil).total = self.data.aimDays, self.data.aimDays
	if self.data.loginDays >= self.data.aimDays then
		_ENV = self.data.loginDays
		self.data.loginDays.color = "#d7c39b"
		if self.data.loginDays then
			goto lbl_84
		end
	end
	_ENV = self.data.loginDays
	_ENV, self.data.aimDays.count, self.data.loginDays.color = self.data.loginDays, self.data.loginDays, "#be2828"
	::lbl_84::
	_ENV, self.data.aimDays.total, self.data.loginDays.color = self.data.loginDays, self.data.loginDays, "#d7c39b"
	self.data.aimDays.__default, self.data.loginDays.color = self.data.loginDays, "#d7c39b"
	self.Text_schedule:setString(i18n_html("common_text_3683", nil, self.data.aimDays))
	self:setBtnStatus()
	self:setAward()
end
function eventLoginGiftSingle:setBtnStatus()
	self.Button_go:setBright(self.taskStatus == gBtnTargetStatusDef.GET)
	self.Button_go:setTitleText(self.taskStatus == gBtnTargetStatusDef.GOT and i18n("common_text_1892") or i18n("common_text_1146"))
	self.Button_go:setTitleColor(self.taskStatus == gBtnTargetStatusDef.GET and cc.c3b(255, 255, 255) or cc.c3b(120, 120, 120))
	self.Button_go:loadTextureNormal(self.taskStatus == gBtnTargetStatusDef.GOT and "btn_gray_small.png" or self.taskStatus == gBtnTargetStatusDef.GO and "btn_blue_small_01.png" or "btn_green_small_01.png", ccui.TextureResType.plistType)
end
function eventLoginGiftSingle:setAward()
	for k, v in ipairs(self.data.reward) do
		if not self.awardArray[k] and k <= MAX_AWARD_NUM then
			self.awardArray[k] = include("commonItemAward").new()
			self.awardArray[k]:setScale(0.8)
			self.awardArray[k]:setBaseScale(1.0)
			self.awardArray[k]:setOwnView(self.view)
			self.awardArray[k]:setOwnScroll(self.ownScroll)
			self.awardArray[k]:setPosition(SoraDFPosX(640 - (60 + (k - 1) * 90)), 70)
			self.awardArray[k]:addTo(self)
		end
		if self.awardArray[k] then
			self.awardArray[k]:initData(v.id, v.count)
			self.awardArray[k]:setVisible(k <= MAX_AWARD_NUM)
		end
	end
	if #self.awardArray > #self.data.reward then
		for k = #self.awardArray, #self.data.reward + 1, -1 do
			self.awardArray[k]:setVisible(false)
		end
	end
end
function eventLoginGiftSingle:btnOperateClick(button, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.taskStatus == gBtnTargetStatusDef.GET then
			SoraDShowLoading(self.view)
			loginGiftCtrl:sendReqClaimGiftMsg(self.data.taskIndex)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return eventLoginGiftSingle
