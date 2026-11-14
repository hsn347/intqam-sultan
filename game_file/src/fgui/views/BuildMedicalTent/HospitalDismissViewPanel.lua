local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HospitalDismissViewPanel = class("HospitalDismissViewPanel", baseFguiPanel)
local gametop = gModuleMgr.getObject("gametop")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
function HospitalDismissViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("HospitalDismissViewPanel:ctor", self.viewName)
end
function HospitalDismissViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HospitalDismissViewPanel:onInit()
	print("=======HospitalDismissViewPanel:onInit")
	self.tableWounded, _ENV = print, print
	self.dismissCount = 0
	self.fields.slider:setInpuBoxFixPos()
	self.fields.btndismiss:setTitleText(i18n("common_text_326"))
	self.fields.btndismiss:addTouchEventListener(handler(self, self.btndismissClickCallBack))
	self.fields.slider:setSliderCallBack(handler(self, self.sliderChange))
end
function HospitalDismissViewPanel:onShow()
	print("=======HospitalDismissViewPanel:onShow")
end
function HospitalDismissViewPanel:initData(itemData)
	self.tableWounded = itemData
	_UPVALUE0_ = nil
	;(nil).maxValue = self.tableWounded.num
	;(nil).minValue = 0
	;(nil).curValue = 0
	self.fields.slider:initData(nil)
	self.fields.slider:setMinValue(0)
end
function HospitalDismissViewPanel:setTitle(txt)
	self.fields.Text_title:setString(txt)
end
function HospitalDismissViewPanel:sliderChange(curVal)
	local isCanDismiss = 0 < curVal
	self.fields.btndismiss:setTouchEnabled(isCanDismiss)
	self.fields.btndismiss:setBright(isCanDismiss)
	self.dismissCount = curVal
end
function HospitalDismissViewPanel:btndismissClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local armyLogic = include("armyLogic")
		local armyDesRead = include("armyDesRead")
		local bid = armyDesRead.getBuildID(self.tableWounded.id)
		local soldierList, curIndex = armyLogic.getCanTrainList(bid)
		local curLv = armyLogic.getArmyLV(self.tableWounded.id)
		local maxLv = armyLogic.getArmyLV(soldierList[curIndex].armyid)
		if maxLv <= curLv + 1 then
			SoraDShowMsgBox(i18n("common_text_2564"), i18n("common_text_204"))
			self:close(button, type)
			return
		end
		local panel = SoraDCreatePanel("commonPromptBox")
		_ENV = type
		type.msg = i18n("common_text_405")
		type.yes = i18n("common_text_054")
		panel:initData(type)
		panel:setHandle(handler(self, self.dismissExit))
		panel:show()
	end
end
function HospitalDismissViewPanel:dismissExit(obtype)
	if obtype == MSGBOX_CALLBACK_YES then
		if self.dismissCount > 0 then
			armyCtrl:fireArmyReq(self.tableWounded.id, self.dismissCount, ARMY_OPTYPE.WOUNDED_ARMY)
		end
		self:removeFromParent()
	end
end
return HospitalDismissViewPanel
