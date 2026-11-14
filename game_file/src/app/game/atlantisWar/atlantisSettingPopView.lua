local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local atlantisSettingPopView = class("atlantisSettingPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("atlantisSettingPopView")
	end
	return target
end)
function atlantisSettingPopView:ctor()
	self.fromMinLv = atlantisWarCtrl:getOccupyQueueArmyMinLv()
	self.toMinLv = self.fromMinLv
	self:initWidget()
end
function atlantisSettingPopView:initWidget()
	_UPVALUE1_ = nil
	;(nil)[1] = "Center_Node"
	self.Center_Node = SoraDGetChildByFullPath(self._ccsView, nil)
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self.Center_Node, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("atlantiswar_text_0296"))
	_UPVALUE1_ = i18n("atlantiswar_text_0296")
	i18n("atlantiswar_text_0296")[1] = "Node_content"
	self.Node_content = SoraDGetChildByFullPath(self.Center_Node, i18n("atlantiswar_text_0296"))
	SoraDGetAllChildFromWidget(self.Node_content, self)
	self.Text_title_lv:setString(i18n("atlantiswar_text_0297"))
	self.Text_curLv = SoraDChangeTextToHtml(self.Text_curLv)
	self:refreshArmyForbidLvText()
	self.armySlider = SoraDGetExtendChildFromCCSByName(self.Node_content, "CCS_commonSlider_slider")
	_ENV = "CCS_commonSlider_slider"
	;("CCS_commonSlider_slider").maxValue = 12
	;("CCS_commonSlider_slider").minValue = 1
	_ENV, ("CCS_commonSlider_slider").curValue = self.toMinLv, self.toMinLv
	;("CCS_commonSlider_slider").editBoxData, self.toMinLv.color = self.toMinLv, display.COLOR_WHITE
	self.armySlider:initData("CCS_commonSlider_slider")
	self.armySlider:setSliderCallBack(handler(self, self.armyForbidLvChange))
	self.Button_sure:setTitleText(i18n("common_text_204"))
	self.Button_sure:addTouchEventListener(handler(self, self.btnSureClick))
end
function atlantisSettingPopView:initData()
end
function atlantisSettingPopView:refreshArmyForbidLvText(...)
	local armyDesRead = include("armyDesRead")
	_ENV = nil
	_ENV, _ENV, (nil).var = self.toMinLv, armyDesRead.getMassLimitArmyLvStr(self.toMinLv), armyDesRead.getMassLimitArmyLvStr(self.toMinLv)
	armyDesRead.getMassLimitArmyLvStr(self.toMinLv).var, self.toMinLv.color = self.toMinLv, "#D2AA64"
	local curLvStr = i18n_html("atlantiswar_text_0281", nil, (armyDesRead.getMassLimitArmyLvStr(self.toMinLv)))
	self.Text_curLv:setString(curLvStr)
end
function atlantisSettingPopView:armyForbidLvChange(lvLimit)
	if self.toMinLv == lvLimit then
		return
	end
	self.toMinLv = lvLimit
	self:refreshArmyForbidLvText()
end
function atlantisSettingPopView:btnSureClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		atlantisWarCtrl:reqSetArmyMinLv(self.fromMinLv, self.toMinLv)
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return atlantisSettingPopView
