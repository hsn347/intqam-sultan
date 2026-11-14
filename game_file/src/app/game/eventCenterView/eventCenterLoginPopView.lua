local EventCenterLoginPopView = class("eventCenterLoginPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventCenterLoginPopView")
	end
	return target
end)
function EventCenterLoginPopView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_worldMapKingdomCityBg_bg")
	self.txtNew = SoraDGetChildByName(self, "Text_new")
	self.txtTitle = SoraDGetChildByName(self, "Text_eventTitle")
	self.txtContent = SoraDGetChildByName(self, "Text_content")
	self.btnLook = SoraDGetChildByName(self, "Button_look")
	self.scroll = SoraDGetChildByName(self, "ScrollView_txt")
	self.btnLook:addTouchEventListener(handler(self, self.btnLookClick))
	self:initData()
	self:addDoubleFireEffect()
end
function EventCenterLoginPopView:initData()
	self.btnLook:setTitleText(i18n("common_text_829"))
	self.txtNew:setString(i18n("common_text_1136"))
	local gametop = gModuleMgr.getObject("gametop")
	local activityCtrl = gametop.playertop_:getModule("activityCtrl")
	local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
	if activityCtrl.activityState == gActivityState.OPEN then
		self.txtTitle:setString(i18n("common_text_605"))
		self.txtContent:setString(i18n("common_text_1134"))
	elseif romeActivityCtrl.state == gRomeActivityState.OPEN then
		self.txtTitle:setString(i18n("common_text_1221"))
		self.txtContent:setString(i18n("common_text_1665"))
	end
	local contentHeigh = SoraDGetAutoHeightLabel(self.txtContent, 350)
	self.scroll:setInnerContainerSize(cc.size(380, contentHeigh + 195))
	self.txtTitle:setPositionY(contentHeigh + 195 - 30)
	self.txtContent:setPositionY(contentHeigh + 195 - 55)
end
function EventCenterLoginPopView:btnLookClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local cityBuildConstDef = include("cityBuildConstDef")
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD_TIP_HAND"
		;(nil).buildIndex = cityBuildConstDef.OtherBuildDef.ActivityCenter
		SoraDSendMessage(nil)
		self:removeFromParent()
	end
end
function EventCenterLoginPopView:addDoubleFireEffect(...)
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_flame1_display.plist"
	;(nil).x = 33
	_ENV, (nil).pos, (nil).y = nil, nil, 48
	;(nil).x = 1.5
	_ENV, (nil)[1], (nil).scale, (nil).y = nil, nil, nil, 1.5
	_ENV, (nil).plist = nil, "et_flame2_display.plist"
	;(nil).x = 33
	_ENV, (nil).pos, (nil).y = nil, nil, 78
	;(nil).x = 2.5
	_ENV, (nil)[2], (nil).scale, (nil).y = nil, nil, nil, 2.5
	_ENV, (nil).plist = nil, "et_flame3_display.plist"
	;(nil).x = 33
	;(nil)[3], (nil).pos, (nil).y = nil, nil, 48
	local param
	local parNode1 = SoraDCreateEffectNode(param)
	parNode1:addTo(SoraDGetChildByName(self, "frame_lace_base_1"), -2)
	local parNode2 = SoraDCreateEffectNode(param)
	parNode2:addTo(SoraDGetChildByName(self, "frame_lace_base_2"), -2)
end
return EventCenterLoginPopView
