local activity_9001611_Ctrl = SoraDGetCtrl("activity_9001611_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local com_list = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001611/com_list", com_list)
function com_list:onInit()
	self.fields.Text_finish:setString(i18n("common_text_2601"))
	self.fields.Button_go:setString(i18n("common_text_678"))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
	self.fields.Button_touch:addClickListener(handler(self, self.btnTouchClick))
	self:fixChildrenPos()
	self.fields.Bar:setScaleX(SoraDFIsRA() and -1 or 1)
end
function com_list:onShow()
end
function com_list:initData(data)
	self.data = data
	self.fields.icon:setSpriteFrame(self.data.icon)
	self.fields.Text_name:setString(i18n(self.data.name))
	_ENV = i18n(self.data.name)
	i18n(self.data.name).num = fguiHelper.getColorString("#416e36", self.data.point)
	self.fields.Text_des:setString(i18n("common_text_4457", i18n(self.data.name)))
	self.fields.Text_point:setString(self.data.point)
	self.times = activity_9001611_Ctrl:getTimes(self.data.type)
	_ENV = i18n("common_text_4457", i18n(self.data.name))
	i18n("common_text_4457", i18n(self.data.name)).var1 = self.times
	i18n("common_text_4457", i18n(self.data.name)).var2 = self.data.quest
	self.fields.Text_progress:setString(i18n("%{var1}/%{var2}", i18n("common_text_4457", i18n(self.data.name))))
	self.fields.Bar:setMax(self.data.quest)
	self.fields.Bar:setValue(self.times)
	local isDone = self.times >= self.data.quest
	self.controllers.c1:setSelectedIndex(isDone and 1 or 0)
	self.fields.Button_go:setVisible(not isDone and (self.data.jump ~= 0 or self.data.type == 9))
end
function com_list:btnTouchClick()
	SoraDPlaySound()
	local parameter = self.data.parameter
	if self.data.type == 6 then
		parameter = math.floor(parameter / 3600)
	end
	_ENV = nil
	;(nil).data = self.data
	uiManager:show("Activity_9001611_reward", nil)
end
function com_list:btnGoClick()
	SoraDPlaySound()
	if self.data.type == 9 then
	elseif self.data.jump ~= 0 then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		mildGuideManager:starMildByNewPlayerQuestID(self.data.jump, nil)
		SoraDRemoveAllPanelFromManager()
	end
end
return com_list
