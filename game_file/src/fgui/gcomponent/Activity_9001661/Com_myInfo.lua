local activity_9001661_Ctrl = SoraDGetCtrl("activity_9001661_Ctrl")
local activity_9001661_Read = include("activity_9001661_Read")
local constantRead = include("constantRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_myInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001661/Com_myInfo", Com_myInfo)
function Com_myInfo:onInit()
end
function Com_myInfo:onShow()
end
function Com_myInfo:initData(member)
	if member then
		self.controllers.c1:setSelectedIndex(1)
		if member.iconID and member.avatar then
			self.fields.Com_head:setHeadSprite(member.iconID, member.avatar)
			self.fields.Com_head:setAvatarFrame(member.avatarFrameId)
		end
		_ENV = nil
		;(nil).num = #member.assistanceUsers
		;(nil).maxnum = constantRead.getConstValue("FARM_ACCEPPT_HELP_NUM", 2)
		self.fields.Text_beAssCount:setString(i18n("bubble_farm_text9", nil))
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_head:setSelfHead(true)
		local curLv = activity_9001661_Ctrl:getGrowthLv()
		self.fields.Text_lv:setString("Lv." .. curLv)
		local remainHelpNum = math.max(0, constantRead.getConstValue("FARM_HELP_NUM", 2) - activity_9001661_Ctrl:getAssistanceTimes())
		_ENV = i18n("bubble_farm_text9", nil)
		i18n("bubble_farm_text9", nil).num = remainHelpNum
		self.fields.Text_assCount:setString(i18n("bubble_farm_text8", i18n("bubble_farm_text9", nil)))
		_ENV = i18n("bubble_farm_text8", i18n("bubble_farm_text9", nil))
		i18n("bubble_farm_text8", i18n("bubble_farm_text9", nil)).num = activity_9001661_Ctrl:getBeAssistanceTimes()
		i18n("bubble_farm_text8", i18n("bubble_farm_text9", nil)).maxnum = constantRead.getConstValue("FARM_ACCEPPT_HELP_NUM", 2)
		self.fields.Text_beAssCount:setString(i18n("bubble_farm_text9", i18n("bubble_farm_text8", i18n("bubble_farm_text9", nil))))
	end
	local textWidth = math.max(self.fields.Text_beAssCount:getWidth(), self.fields.Text_assCount:getWidth())
	self.fields.bg:setWidth(math.max(344, textWidth + 200))
end
return Com_myInfo
