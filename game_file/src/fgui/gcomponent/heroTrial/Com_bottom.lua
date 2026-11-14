local heroTrialCommon = include("heroTrialCommon")
local htPointMgr = include("htPointMgr")
local htBattleMgr = include("htBattleMgr")
local htLogMgr = include("htLogMgr")
local htMapMgr = include("htMapMgr")
local heroTrialCtrl = SoraDGetCtrl("heroTrialCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_bottom = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://heroTrial/Com_bottom", Com_bottom)
function Com_bottom:onInit()
	self.logList, _ENV = nil, nil
	self.switch = false
	self.isActing = false
	self.closeY = math.max(1070, display.height - 66)
	self.openY = self.closeY - 166
	self.fields.Btn_sweep:setString(i18n("epicbattle_btn_01"))
	self.fields.Btn_sweep:addClickListener(handler(self, self.onSweepClick))
	self.fields.Btn_auto:checkVip()
	self.fields.stopBtn:addClickListener(handler(self, self.onStopTrial))
	self.fields.upTouch:addClickListener(handler(self, self.onUp))
	self.fields.upTouch:setRotation(self.switch and 90 or -90)
	self:setPositionY(self.closeY)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onLogRenderer))
	self.fields.Btn_sweep:fixPos()
	self.fields.Btn_auto:fixPos()
	self.fields.stopBtn:fixPos()
end
function Com_bottom:onShow()
end
function Com_bottom:onLogRenderer(index, obj)
	obj:initData(self.logList[index + 1])
end
function Com_bottom:init(mapId, parent)
	self.mapId = mapId
	self.parent = parent
	self.fields.Btn_auto:init(self.mapId, self.parent)
	self:setAutoState()
	self:setLogView()
	self:setSweep()
end
function Com_bottom:setSweep()
	local isPass = htMapMgr.getIsPass(self.mapId)
	local hasPrivilege = SoraDGetCtrl("exaltedPrivilegeCtrl"):checkPrivilege(gExaltedPrivilegeType.HERO_TRIAL_SWEEP)
	if isPass and hasPrivilege then
		self.fields.Btn_sweep:setVisible(true)
		if htPointMgr.getPoint() > 0 then
			self.fields.Btn_sweep:getChild("title"):setColor(cc.c3b(255, 200, 100))
		else
			self.fields.Btn_sweep:getChild("title"):setColor(cc.c3b(190, 40, 40))
		end
	else
		self.fields.Btn_sweep:setVisible(false)
	end
end
function Com_bottom:setAutoBtnTouch(ret)
	self.fields.Btn_auto:setTouchEnabled(ret)
end
function Com_bottom:setLogView()
	if not htLogMgr:getLogList() then
		htLogMgr = htLogMgr:getLogList()
	end
	self.logList = htLogMgr:getLogList()
	self.fields.List:setNumItems(#self.logList)
end
function Com_bottom:setAutoState()
	local isAuto = htBattleMgr.autoStatus and true or false
	self.fields.Btn_auto:checkVip()
	self.fields.Btn_auto:setStatus(isAuto)
	if isAuto then
		self.fields.stopBtn:setVisible(false)
	elseif heroTrialCommon.isTrialStarted(self.mapId) then
		self.fields.stopBtn:setVisible(true)
	else
		self.fields.stopBtn:setVisible(false)
	end
end
function Com_bottom:onSweepClick()
	SoraDPlaySound()
	if htPointMgr.getPoint() <= 0 then
		SoraDShowMsgTip(i18n("privilege_text_95"))
		return
	end
	local dailyRemindManager = include("dailyRemindManager")
	local ctype = dailyRemindManager.REMIND_TYPE.heroTrialMapView
	if dailyRemindManager.checkNeedRemind(ctype) then
		SoraDShowMsgBox(i18n("privilege_text_96"), i18n("common_text_204"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				dailyRemindManager.addRemindToManager(ctype)
				heroTrialCtrl:reqSweep(self.mapId)
			end
		end)
	else
		heroTrialCtrl:reqSweep(self.mapId)
	end
end
function Com_bottom:onStopTrial()
	SoraDPlaySound()
	if heroTrialCommon.isTrialStarted(self.mapId) then
		_ENV = nil
		;(nil).point = HEROTRIAL_COST_POINTS
		SoraDShowMsgBox(i18n("common_text_1746", nil), i18n("common_text_054"), i18n("common_text_185"), function(event)
			if event == MSGBOX_CALLBACK_YES then
				if self.parent and self.parent.setQuitEvent then
					self.parent:setQuitEvent(2)
				end
				heroTrialCtrl:quitTrial()
			end
		end)
	end
end
function Com_bottom:onUp()
	SoraDPlaySound()
	if self.isActing then
		return
	end
	if self.switch then
		self.isActing = true
		self.fields.upTouch:setRotation(-90)
		_UPVALUE1_ = nil
		;(nil)[1] = ffa.exponentialOut(ffa.moveTo(0.5, self:getPositionX(), self.closeY))
		;(nil)[2] = ffa.callFunc(function()
			self.switch = not self.switch
			self.isActing = false
		end)
		;(nil)[3] = ffa.callFunc(function()
			self.switch = not self.switch
			self.isActing = false
		end)
		;(nil)[4] = ffa.callFunc(function()
			self.switch = not self.switch
			self.isActing = false
		end)
		;(nil)[5] = ffa.callFunc(function()
			self.switch = not self.switch
			self.isActing = false
		end)
		self:runAction(ffa.seq(nil))
	else
		self.isActing = true
		self.fields.upTouch:setRotation(90)
		_UPVALUE1_ = ffa.seq(nil)
		ffa.seq(nil)[1] = ffa.exponentialOut(ffa.moveTo(0.5, self:getPositionX(), self.openY))
		ffa.seq(nil)[2] = ffa.callFunc(function()
			self.switch = not self.switch
			self.isActing = false
		end)
		ffa.seq(nil)[3] = ffa.callFunc(function()
			self.switch = not self.switch
			self.isActing = false
		end)
		ffa.seq(nil)[4] = ffa.callFunc(function()
			self.switch = not self.switch
			self.isActing = false
		end)
		ffa.seq(nil)[5] = ffa.callFunc(function()
			self.switch = not self.switch
			self.isActing = false
		end)
		self:runAction(ffa.seq(ffa.seq(nil)))
	end
end
return Com_bottom
