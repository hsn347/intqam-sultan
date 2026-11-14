local baseComponent = require("fgui.base.baseComponent")
local Com_rLetter_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RamadanLetter/Com_rLetter_list", Com_rLetter_list)
local ramadanLetterCtrl = SoraDGetCtrl("ramadanLetterCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local ramadanLetterRead = include("ramadanLetterRead")
function Com_rLetter_list:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.text_status2 = SoraDCreateTimerLabel(self, self.fields.text_status2)
	self.text_status2:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_RAMADAN_LETTER"
		;(nil).subMsg = "init"
		SoraDSendMessage(nil)
	end)
	self.text_status = SoraDCreateTimerLabel(self, self.fields.text_status)
	self.text_status:setTimeEndListener(function()
		_ENV = nil
		;(nil).msg = "MESSAGE_RAMADAN_LETTER"
		;(nil).subMsg = "init"
		SoraDSendMessage(nil)
	end)
	self.fields.text_desc:setString(i18n("common_text_1036"))
	self.fields.icon_bg:addClickEventListener(handler(self, self.onIconClick))
	self.fields.button_box:addClickEventListener(handler(self, self.onRewardClick))
end
function Com_rLetter_list:onShow()
end
function Com_rLetter_list:initData(cfg)
	self.cfg = cfg
	self.isOpen = false
	_ENV = nil
	;(nil).item = cfg.chapter
	self.fields.text_title:setString(i18n("ramadan_letter_02", nil))
	local activityStartTime = activityShowCtrl:getBeginTimeSecond(gActivityTimeActivityID.RAMADAN_LETTER_ACTIVITY)
	local curActivityID = cfg.activityID
	local curStartTime = activityStartTime + (cfg.time - 1) * 24 * 60 * 60
	self.text_status:removeTime()
	if curStartTime > serviceFunctions.systemTime() then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.bg_lock:setVisible(true)
		self.fields.icon_bg:setVisible(false)
		self.text_status:setTimeLast(function(strTime)
			_ENV = nil
			;(nil).time = strTime
			return i18n("common_text_606", nil)
		end)
		self.text_status:beginTime(curStartTime - serviceFunctions.systemTime())
	else
		self.controllers.c1:setSelectedIndex(0)
		if self.cfg.index == 4 then
			self.fields.icon_bg:setIcon("bg_ramadanletter_0" .. cfg.index .. ".png")
		else
			self.fields.icon_bg:setIcon("bg_ramadanletter_0" .. cfg.index .. ".png")
		end
		self.fields.icon_bg:setVisible(true)
		self.fields.bg_lock:setVisible(false)
		self.isOpen = true
		local timer = activityShowCtrl:getTimeInfoByID(curActivityID)
		if timer then
			local leftTime = timer.timerNode.timer:getRemainTime()
			self.text_status2:setTimeLast(function(strTime)
				local state = activityShowCtrl:getStateByID(curActivityID)
				if state == gActivityState.OPEN then
					activityShowCtrl = nil
					;(nil).time = strTime
					return i18n("common_text_607", nil)
				else
					activityShowCtrl = nil
					;(nil).time = strTime
					return i18n("common_text_606", nil)
				end
			end)
			self.text_status2:beginTime(leftTime)
		else
			self.text_status2:setString(i18n("common_text_1859"))
		end
	end
	local isHaveReward = ramadanLetterCtrl:getIsHaveReward(cfg.chapter)
	fguiHelper.get_controllers(self.fields.button_box).c1:setSelectedIndex(isHaveReward and 0 or 1)
	self.fields.ani:setVisible(isHaveReward)
	if isHaveReward then
		self.fields.ani:setAllFrameName("dh_Tex_XL_zylx01_0%02d.png", 0)
		self.fields.ani:setPlaySettings(0, -1, -1)
	end
end
function Com_rLetter_list:onIconClick()
	if self.isOpen then
		SoraDPlaySound()
		SoraDShowMsgBoxNew(i18n("ramadan_letter_04"), i18n("common_text_204"), nil, function(exitType, other)
			if exitType ~= MSGBOX_CALLBACK_YES then
				return
			end
			local noticeData = ramadanLetterRead.getDialogues(self.cfg.chapter)
			_ENV = nil
			;(nil).callback = function()
				_ENV = nil
				;(nil).showAction = true
				;(nil).chapter = self.cfg.chapter
				uiManager:show("RamadanLetterAward", nil)
			end
			table.insert(noticeData, nil)
			gModuleMgr.sharedMgr("mildGuideManager"):createNoticeLine(noticeData)
		end)
	end
end
function Com_rLetter_list:onRewardClick()
	_ENV = nil
	;(nil).showAction = false
	;(nil).chapter = self.cfg.chapter
	uiManager:show("RamadanLetterAward", nil)
end
return Com_rLetter_list
