local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Button_mine = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://newLordView/Button_mine", Button_mine)
function Button_mine:onInit()
	self.fields.Text_mine:setString(i18n("common_text_3243"))
	self.fields.Btn_mine:addClickListener(handler(self, self.btnClick))
	self.fields.Label_timer:setTimeEndListener(handler(self, self.initData))
end
function Button_mine:onShow()
end
function Button_mine:initData()
	local leftTime, status = userSDKManager.getAvatarLastTime()
	if status == 10 then
		self.isInCD = false
		self.headStatus = 10
		self.fields.Btn_mine:setString(i18n("common_text_4080"))
		self.controllers.c1:setSelectedIndex(0)
	else
		self.headStatus = 20
		if leftTime and 0 < leftTime then
			self.isInCD = true
			self.controllers.c1:setSelectedIndex(1)
			self.fields.Btn_mine:setString("")
			self.fields.Label_timer:beginTime(leftTime)
		else
			self.isInCD = false
			self.fields.Btn_mine:setString(i18n("common_text_3243"))
			self.controllers.c1:setSelectedIndex(0)
		end
	end
end
function Button_mine:btnClick()
	SoraDPlaySound()
	if self.isInCD then
		SoraDShowMsgTip(i18n("common_text_3244"))
	elseif self.headStatus == 10 then
		SoraDShowMsgTip(i18n("common_text_4080"))
	else
		local vipData = lordInfoCtrl:getVip()
		if not (vipData[1] >= VIP_LV9_LIMITED) or not vipData[2] then
			_ENV = i18n("common_text_4080")
			i18n("common_text_4080").lv = VIP_LV9_LIMITED
			SoraDShowMsgBox(i18n("common_text_3242", i18n("common_text_4080")), i18n("mail_text_67"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					uiManager:show("vipCenterView")
				end
			end)
		else
			_ENV = i18n("mail_text_67")
			userSDKManager.logEvent(gSDKDef.TDonEvent.click_portrait, (i18n("mail_text_67")))
			SoraDCreatePanel("lordAvatarDiyView"):show()
		end
	end
end
return Button_mine
