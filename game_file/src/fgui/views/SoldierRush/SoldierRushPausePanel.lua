local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SoldierRushPausePanel = class("SoldierRushPausePanel", baseFguiPanel)
function SoldierRushPausePanel:ctor(...)
	self.super.ctor(self, ...)
	print("SoldierRushPausePanel:ctor", self.viewName)
end
function SoldierRushPausePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SoldierRushPausePanel:onInit()
	print("=======SoldierRushPausePanel:onInit")
	self.chapter = self.param.chapter
	self.gate = self.param.gate
	self.id = self.param.id
	self.fields.Panel_bg:setString(i18n("soldier_rush_text_22"))
	self.fields.Text_tip:setString(i18n("soldier_rush_text_10"))
	self.fields.Text_continue:setString(i18n("soldier_rush_text_46"))
	self.fields.Button_msg:setString(i18n("soldier_rush_text_47"))
	self.fields.Button_msg:addClickListener(handler(self, self.onBtnMsgClick))
	self.fields.Button_restart:setString(i18n("soldier_rush_text_23"))
	self.fields.Button_restart:addClickListener(handler(self, self.onBtnRestartClick))
	self.fields.Button_out:setString(i18n("soldier_rush_text_24"))
	self.fields.Button_out:addClickListener(handler(self, self.onBtnOutClick))
	self.fields.List_target:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_msg:fixPos()
	self.fields.Button_restart:fixPos()
	self.fields.Button_out:fixPos()
end
function SoldierRushPausePanel:onItemRenderer(index, obj)
	obj:initData(self.targetList[index + 1], self.id)
end
function SoldierRushPausePanel:onShow()
	print("=======SoldierRushPausePanel:onShow")
	self.targetList = soldierRushRead.getLevelStarCfg(self.id)
	self.fields.List_target:setNumItems(#self.targetList)
end
function SoldierRushPausePanel:onBtnMsgClick()
	SoraDPlaySound()
	uiManager:show("SoldierRushGameMsg")
end
function SoldierRushPausePanel:onBtnRestartClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_SOLDIERRUSH_UI_RESTART_GAME"
	;(nil).id = self.id
	;(nil).chapter = self.chapter
	;(nil).gate = self.gate
	SoraDSendMessage(nil)
	_UPVALUE3_ = nil
	;(nil)[1] = 0
	;(nil)[2] = 0
	;(nil)[3] = 0
	soldierRushCtrl:sendWin(self.id, nil, 3)
	self:close()
end
function SoldierRushPausePanel:onBtnOutClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("soldier_rush_text_20")
	;(nil).confirmString = i18n("common_text_204")
	;(nil).cancelString = i18n("common_text_185")
	;(nil).confirmFunc = function()
		if tolua.isnull(self) then
			return
		end
		_ENV = self
		self.msg = "MESSAGE_SOLDIERRUSH_UI_END_GAME"
		self.id = self.id
		self.chapter = self.chapter
		self.gate = self.gate
		SoraDSendMessage(self)
		_UPVALUE3_ = nil
		;(nil)[1] = 0
		;(nil)[2] = 0
		;(nil)[3] = 0
		soldierRushCtrl:sendWin(self.id, nil, 2)
		self:close()
	end
	uiManager:show("MessageBox", nil)
end
function SoldierRushPausePanel:onHide()
	print("=======SoldierRushPausePanel:onHide")
	_ENV = "=======SoldierRushPausePanel:onHide"
	;("=======SoldierRushPausePanel:onHide").msg = "MESSAGE_SOLDIERRUSH_UI_CONTINUE_GAME"
	;("=======SoldierRushPausePanel:onHide").id = self.id
	;("=======SoldierRushPausePanel:onHide").chapter = self.chapter
	;("=======SoldierRushPausePanel:onHide").gate = self.gate
	SoraDSendMessage("=======SoldierRushPausePanel:onHide")
end
return SoldierRushPausePanel
