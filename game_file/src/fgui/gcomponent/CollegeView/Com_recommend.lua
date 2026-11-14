local collegeDesRead = include("collegeDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_recommend = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CollegeView/Com_recommend", Com_recommend)
function Com_recommend:onInit()
	self.fields.Button_study:setString(i18n("common_text_062"))
	self.fields.Button_study:addClickListener(handler(self, self.btnStudyClick))
	self:fixChildrenPos()
end
function Com_recommend:onShow()
end
function Com_recommend:initData(data)
	self.tid = data.technologyID
	self.type = collegeDesRead.getType(self.tid)
	local typeData = collegeDesRead.getTypeTitleIcon(self.type)
	self.fields.Text_typeName:setString(i18n(typeData.title))
	self.fields.Text_typeName:setColor(typeData.color)
	self.fields.Text_techName:setString(collegeDesRead.getName(self.tid))
	local addFighting = collegeDesRead.getFight(self.tid, data.currentLevel + 1) - collegeDesRead.getFight(self.tid, data.currentLevel)
	collegeDesRead = collegeDesRead.getName(self.tid)
	collegeDesRead.getName(self.tid).power = string.format("+%s", addFighting)
	self.fields.Text_powerAdd:setString(i18n("common_text_128", collegeDesRead.getName(self.tid)))
	self.fields.btn_college:initData(self.tid, self.type)
end
function Com_recommend:btnStudyClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).techID = self.tid
	;(nil).techType = self.type
	uiManager:show("collegeDetailsView", nil)
end
return Com_recommend
