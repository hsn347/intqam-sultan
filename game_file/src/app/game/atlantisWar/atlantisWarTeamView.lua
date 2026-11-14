local atlantisWarCtrl = SoraDGetCtrl("atlantisWarCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local atlantisWarTeamView = class("atlantisWarTeamView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("atlantisWarTeamView")
	end
	return target
end)
function atlantisWarTeamView:ctor()
	self.isHideCurrentSceneView = true
	self:initWidget()
end
function atlantisWarTeamView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_GREEN_POINT_UPDATE", function(target, data)
		if data.type == GREEN_POINT_NOTICE_TYPE.ALLIANCE_WAR then
			self:refreshRedPoint()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", function(...)
		self:removeFromParent()
	end)
end
function atlantisWarTeamView:initWidget()
	SoraDGetAllChildFromWidget(self._ccsView, self)
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.ccs_title:setTitle(i18n("atlantiswar_text_0139"))
	self.Button_setting:addTouchEventListener(handler(self, self.btnSettingClick))
	_ENV, _ENV = self.Button_setting, self.Button_setting.addTouchEventListener
	self.Button_setting.title = i18n("atlantiswar_text_0139")
	self.Button_setting.handle = handler(self, self.btn_onClick_btns)
	_ENV, self.Button_setting.addTouchEventListener[1], self.Button_setting.name = self.Button_setting, self.Button_setting, "atlantisTeamView"
	self.Button_setting.title = i18n("free_team_text_47")
	self.Button_setting.handle = handler(self, self.btn_onClick_btns)
	self.viewList, _ENV, self.Button_setting.addTouchEventListener[2], self.Button_setting.name = self.Button_setting, self.Button_setting, self.Button_setting, "allianceWarView"
	local arry = self.Button_setting.addTouchEventListener
	for i, v in ipairs(arry) do
		local panel = SoraDCreatePanel(v.name)
		self.viewList[i] = panel
		panel:addTo(self.Top_Node, -1)
		panel:setPositionY(display.height / 2)
		SoraDDeviceFitOffset(panel, nil, display.height + 60)
		panel:initAtlantisWarView()
		panel:setPositionY(-panel:getPositionY())
	end
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_tab")
	_ENV = "CCS_commonTabBtn_tab"
	;("CCS_commonTabBtn_tab").tabNum = 2
	;("CCS_commonTabBtn_tab").defaultClick = 2
	;("CCS_commonTabBtn_tab").tabsetArray = arry
	self.ccs_tab:initView("CCS_commonTabBtn_tab")
	self:refreshRedPoint()
end
function atlantisWarTeamView:btn_onClick_btns(tag, name)
	self.curSelect = tag
	for i, v in ipairs(self.viewList) do
		v:setVisible(tag == i)
	end
	self:refreshBtnSetting()
end
function atlantisWarTeamView:refreshBtnSetting(...)
	if self.curSelect == 1 then
		local showSetting = commonCheck.ATLANTISWAR_ARM and atlantisWarCtrl:getSelfMemberClass() >= gAtlantisRankType.Manager
		self.Button_setting:setVisible(showSetting)
	else
		self.Button_setting:setVisible(true)
	end
end
function atlantisWarTeamView:btnSettingClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.curSelect == 1 then
			SoraDCreatePanel("atlantisSettingPopView"):show()
		else
			_ENV = nil
			;(nil).viewType = 2
			uiManager:show("AllianceWarSettingView", nil)
		end
	end
end
function atlantisWarTeamView:refreshRedPoint(...)
	local allianceCount = kingdomMapCtrl:getHallWarCount()
	self.ccs_tab:setBigRedPointCount(2, allianceCount)
end
return atlantisWarTeamView
