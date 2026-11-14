local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local buffDesRead = include("buffDesRead")
local newstart_effect = require_data("newstart_effect", true).data
local buffCtrl = SoraDGetCtrl("buffCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_newServerGain = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewServerReturn/Com_newServerGain", Com_newServerGain)
function Com_newServerGain:onInit()
	self.activityID = gActivityTimeActivityID.NEW_START_EFFECT_ACTIVITY
	local proxy = uiManager:getOrCreateProxy("NewServerReturn")
	proxy:initActivityTime(self.fields.Label_time, self.activityID)
	self.fields.Text_tip:setString(i18n("newstart_text_12"))
	self.fields.Text_subTitle:setString(i18n("newstart_text_3"))
	self.fields.List_buff:setItemRenderer(handler(self, self.onItemRendererEvent))
	self.fields.List_buff:setNumItems(#newstart_effect)
end
function Com_newServerGain:onShow()
end
function Com_newServerGain:onItemRendererEvent(index, object)
	local data = newstart_effect[index + 1]
	local Com_skillIcon = object:getChild("Com_skillIcon")
	Com_skillIcon:setIcon(data.EffectIcon)
	Com_skillIcon:getChild("n14"):setTexture("SinglePicture/G_round.png")
	local buffID = data.buffId
	local effectType = buffltCtrl:getEffectType(buffID)
	local buffNum1 = buffltCtrl:getEffect(buffID)
	local title, _ = buffDesRead.getTitleBase(effectType, true)
	local value = buffDesRead.getTitleValueWithValue(effectType, buffNum1)
	newstart_effect = nil
	;(nil).title = title
	newstart_effect, newstart_effect, (nil).value = nil, nil, value
	newstart_effect, (nil).value, (nil).color = nil, nil, "#0CFF00"
	;(nil).__default, (nil).color = nil, "#CEAE6F"
	local buffStr = i18n_html("common_text_3904", nil, nil)
	object:getChild("Text_detail"):setString(buffStr)
	local Text_time = SoraDCreateTimerLabel(self, object:getChild("Text_time"))
	Text_time:setTimeEndListener(function()
		Text_time:setString(i18n("Anchor_text_21"))
	end)
	local leftTime = buffCtrl:getRemainTimeByBuffID(buffID)
	if leftTime then
		Text_time:beginTime(leftTime)
	else
		Text_time:setString(i18n("Anchor_text_21"))
	end
	object:fixChildrenPos()
	object:getChild("n7"):fix()
end
return Com_newServerGain
