local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaAllStarRead = include("nebulaAllStarRead")
local baseComponent = require("fgui.base.baseComponent")
local Energy_buildSingle2 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaEmperorWar/Energy_buildSingle2", Energy_buildSingle2)
function Energy_buildSingle2:onInit()
	self.fields.Text_name:addClickListener(handler(self, self.onClickBtnPos))
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnPos))
end
function Energy_buildSingle2:onShow()
end
function Energy_buildSingle2:initData(data, activityID)
	self.buildID = data.buildID
	self:setActivityID(activityID)
	local _ENV, cfg = self.setActivityID, self.setActivityID
	if self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		cfg = nebulaAllStarRead.getBuildConfig(self.buildID)
	else
		cfg = nebulaEmperorRead.getBuildConfig(self.buildID)
	end
	_ENV = nebulaEmperorRead.getBuildConfig(self.buildID)
	nebulaEmperorRead.getBuildConfig(self.buildID).x = cfg.x
	self.jumpPos, nebulaEmperorRead.getBuildConfig(self.buildID).y = nebulaEmperorRead.getBuildConfig(self.buildID), cfg.y
	local posStr = i18n("common_text_2155", self.jumpPos)
	_ENV = nil
	;(nil).u = true
	self.fields.Text_name:setString(i18n(cfg.name) .. SoraDWrapHtmlTagByStyle(posStr, nil))
	self.fields.Com_energy:updateEnergy()
end
function Energy_buildSingle2:setActivityID(activityID)
	self.activityID = activityID
	self.fields.Com_energy:setActivityID(activityID)
end
function Energy_buildSingle2:onClickBtnPos(...)
	SoraDPlaySound()
	SoraDGotoWorldMapPoint(self.jumpPos, true)
	SoraDRemoveAllPanelFromManager()
end
return Energy_buildSingle2
