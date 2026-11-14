local baseComponent = require("fgui.base.baseComponent")
local Button_hospital = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://KingStarBattle/Button_hospital", Button_hospital)
fgui.register_extension("ui://KingStarBattle/Button_hospital_hegemon", Button_hospital)
function Button_hospital:onInit()
	self.fields.title:setString(i18n("buildDes_name_206"))
	self.remainTime = SoraDCreateTimerLabel(nil, self.fields.title)
	self.remainTime:setTimeEndListener(handler(self, self.timeEndListener))
	self:addClickEventListener(handler(self, self.onClickBtnHospital))
end
function Button_hospital:onShow()
end
function Button_hospital:setWarType(warType)
	self.warType = warType
end
function Button_hospital:timeEndListener()
	self:setVisible(false)
	_ENV = self
	self.msg = "MESSAGE_HOSPITALVIEW_WARTYPE_UPDATE"
	self.warType = self.warType
	SoraDSendMessage(self)
end
function Button_hospital:onClickBtnHospital()
	SoraDPlaySound()
	local worldMapWarDef = include("worldMapWarDef")
	worldMapWarDef.clickHospitalView(self.warType)
end
function Button_hospital:onMsgUpdateWarData()
	if self.warType == gKingdomClassType.legendLord then
		local legendLordWarCtrl = SoraDGetCtrl("legendLordWarCtrl")
		if not legendLordWarCtrl:checkBackPlayerTime() then
			return
		end
		self:setVisible(true)
		self.controllers.title:setSelectedIndex(0)
		local backPlayerTime = legendLordWarCtrl:getBackPlayerTime()
		local remainTime = backPlayerTime - serviceFunctions.systemTime()
		self.remainTime:beginTime(remainTime)
	end
end
function Button_hospital:initData(data)
	self:setWarType(data.warType)
	if data.hideText then
		self.controllers.title:setSelectedIndex(1)
	end
	if data.style then
		self.controllers.style:setSelectedIndex(data.style)
	end
end
return Button_hospital
