local collegeDesRead = include("collegeDesRead")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_waiting = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CollegeView/Com_waiting", Com_waiting)
function Com_waiting:onInit()
	self.fields.Text_wait:setString(i18n("privilege_text_83"))
	self.fields.Text_idle:setString(i18n("herotrain_text_01"))
	self.fields.Text_waiting:setString(i18n("privilege_text_125"))
	self.fields.Button_sub:addClickListener(handler(self, self.btnSubClick))
	self:fixChildrenPos()
end
function Com_waiting:onShow()
end
function Com_waiting:initData(techID)
	self.techID = techID
	if self.techID then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_name:setString(collegeDesRead.getName(self.techID))
		local tableSingleData = technologyCtrl:getTechnoDataByID(self.techID, collegeDesRead.getType(self.techID))
		local addFighting = collegeDesRead.getFight(self.techID, tableSingleData.currentLevel + 1) - collegeDesRead.getFight(self.techID, tableSingleData.currentLevel)
		collegeDesRead = collegeDesRead.getType(self.techID)
		collegeDesRead.getType(self.techID).power = string.format("+%s", addFighting)
		self.fields.Text_power:setString(i18n("common_text_128", collegeDesRead.getType(self.techID)))
		self.fields.Image_techBg:setSpriteFrame(collegeDesRead.getBg(self.techID))
		self.fields.Image_icon:setSpriteFrame(collegeDesRead.getIcon(self.techID))
		local tableSingleData = technologyCtrl:getTechnoDataByID(self.techID, collegeDesRead.getType(self.techID))
		self.fields.Text_lv:setString(tostring(tableSingleData.currentLevel) .. "/" .. tostring(tableSingleData.maxLevel))
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Com_waiting:btnSubClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).techID = self.techID
	uiManager:show("collegeWaitCancelView", nil)
end
return Com_waiting
