local activityTimeRead = include("activityTimeRead")
local baseComponent = require("fgui.base.baseComponent")
local Progress_score = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://WarHorn/Progress_score", Progress_score)
function Progress_score:onInit()
	self.activityID = gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581
	self.fields.Btn_add:addClickListener(handler(self, self.jumpToRechargeView))
	self:fixChildrenPos()
end
function Progress_score:onShow()
end
function Progress_score:initData(lv, curScore, maxScore)
	_ENV = nil
	;(nil).lv = lv
	self.fields.Text_lv:setString(i18n("common_text_101", nil))
	_ENV = i18n("common_text_101", nil)
	i18n("common_text_101", nil).var1 = curScore
	i18n("common_text_101", nil).var2 = maxScore
	self.fields.Text_score:setString(i18n("%{var1}/%{var2}", i18n("common_text_101", nil)))
	self.fields.bar:setWidth(math.min(446, 446 * curScore / maxScore))
end
function Progress_score:jumpToRechargeView()
	SoraDPlaySound()
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).rechargeIDList = activityTimeRead.getRechargeId(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID))
		uiManager:show("rechargeView", nil)
	else
		local panel = SoraDCreatePanel("rechargeView")
		panel:jumpToLimitNodeByList(12, activityTimeRead.getRechargeId(self.activityID, SoraDGetCtrl("activityShowCtrl"):getParamClassType(self.activityID)))
		panel:show()
	end
end
return Progress_score
