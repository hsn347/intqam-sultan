local baseFguiPanel = require("fgui.base.baseFguiPanel")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local OpenSesameViewPanel = class("OpenSesameViewPanel", baseFguiPanel)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local openSesameCtrl = SoraDGetCtrl("openSesameCtrl")
function OpenSesameViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("OpenSesameViewPanel:ctor", self.viewName)
end
function OpenSesameViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function OpenSesameViewPanel:onInit()
	self.view:fixChildrenPos()
	self.activityID = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001546
	self.activityBeginTime = activityShowCtrl:getBeginTimeSecond(self.activityID)
	self.itemID = openSesameCtrl:getItemID()
	print("=======OpenSesameViewPanel:onInit", self.itemID)
	self.fields.Com_title:initData(i18n("activity_name_9001546"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Button_award:setString(i18n("soldier_rush_text_11"))
	self.fields.Button_award:addClickListener(handler(self, self.onClickPreaward))
	self.fields.Com_have:initData(self.itemID)
	_ENV = handler(self, self.onClickPreaward)
	handler(self, self.onClickPreaward).num = 1
	self.fields.Button_one:setString(i18n("OpenSesame_02", handler(self, self.onClickPreaward)))
	self.fields.Button_one:addClickListener(handler(self, self.onClickOne))
	_ENV = handler(self, self.onClickOne)
	handler(self, self.onClickOne).num = 10
	self.fields.Button_ten:setString(i18n("OpenSesame_02", handler(self, self.onClickOne)))
	self.fields.Button_ten:addClickListener(handler(self, self.onClickTen))
	openSesameCtrl:sendReqInitDataMsg()
	_ENV = handler(self, self.onClickTen)
	handler(self, self.onClickTen).byUID = true
	local isSeleckted = SoraDConfigGet("Game:OpenSesameViewPanel:isChecked~integer", handler(self, self.onClickTen)) == self.activityBeginTime
	self.fields.button_check:setSelected(isSeleckted)
	self.fields.button_check:setString(i18n("Canyon_Treasur_text_27"))
	self.fields.button_check:addClickListener(function()
		SoraDPlaySound()
		_ENV = self.fields.button_check
		self.fields.button_check.byUID = true
		SoraDConfigSet("Game:OpenSesameViewPanel:isChecked~integer", self.fields.button_check:isSelected() and self.activityBeginTime or 0, self.fields.button_check)
	end)
	self.fields.button_check:fixChildrenPos()
	fguiHelper.get_fields(self.fields.button_check).n3:fix()
end
function OpenSesameViewPanel:onShow()
	print("=======OpenSesameViewPanel:onShow")
	self:updateView()
	self.fields.bg:setX(self.fields.bg:getX() - 1)
	self.fields.bg:setY(self.fields.bg:getY() + 1)
end
function OpenSesameViewPanel:updateView()
	self:updateButton()
end
function OpenSesameViewPanel:updateButton()
	self.isFree = openSesameCtrl:getIsFree()
	self.fields.Button_one:setCost(self.itemID, self.isFree and 0 or 1)
	self.fields.Button_ten:setCost(self.itemID, 10)
	self.fields.Com_have:updateNum()
end
function OpenSesameViewPanel:onClickPreaward()
	SoraDPlaySound()
	uiManager:show("OpenSesamePop"):setOwnerKey(self)
end
function OpenSesameViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("OpenSesame_01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function OpenSesameViewPanel:onClickOne()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.itemID) > 0 or self.isFree then
		openSesameCtrl:sendLottery(1)
	else
		SoraDShowMsgTip(i18n("common_text_2512"))
	end
end
function OpenSesameViewPanel:onClickTen()
	SoraDPlaySound()
	if backpackCtrl:getItemCount(self.itemID) >= 10 then
		openSesameCtrl:sendLottery(10)
	else
		SoraDShowMsgTip(i18n("common_text_2512"))
	end
end
function OpenSesameViewPanel:onGetReward(rewards)
	local showFunc = function()
		SoraDCloseLoading(self:displayObject())
		_ENV = self:displayObject()
		self:displayObject().rewards = rewards
		self:displayObject().onCloseCallback = function()
			if not tolua.isnull(self) then
				self.fields.Usm_1:clearEffect()
				self.fields.Usm_3:setVisible(true)
			end
		end
		uiManager:show("OpenSesameAward", self:displayObject())
	end
	SoraDShowLoading(self:displayObject(), nil, nil, true)
	if not self.fields.button_check:isSelected() then
		self.fields.Usm_3:setVisible(false)
		self.fields.Usm_1:setPrepareCallback(function()
			self.fields.Usm_1:getCriSprite():start()
			self:runAction(ffa.seq(ffa.delay(2.2), ffa.callFunc(function()
				showFunc()
			end)))
		end)
		self.fields.Usm_1:setEffectPath(#rewards == 1 and "zhimakaimen01.usm" or "zhimakaimen10.usm", false, true)
	else
		showFunc()
	end
end
return OpenSesameViewPanel
