local happyEggCtrl = SoraDGetCtrl("happyEggCtrl")
local newLotteryRead = include("newLotteryRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HappyEggPopPanel = class("HappyEggPopPanel", baseFguiPanel)
function HappyEggPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HappyEggPopPanel:ctor", self.viewName)
end
function HappyEggPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HappyEggPopPanel:onInit()
	print("=======HappyEggPopPanel:onInit")
	self.chooseInfo, _ENV = print, print
	self.activityID = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001544
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_Confirm:setString(i18n("common_text_204"))
	self.fields.Button_Confirm:addClickListener(handler(self, self.onClickConfirm))
	_ENV = handler(self, self.onClickConfirm)
	handler(self, self.onClickConfirm).num = happyEggCtrl:getLeftResetCont()
	self.fields.Text_Tips:setString(i18n("Lamp_secret_text_09", handler(self, self.onClickConfirm)))
end
function HappyEggPopPanel:onShow()
	print("=======HappyEggPopPanel:onShow")
	self.awardList = newLotteryRead.getGroupChooseAward(self.activityID, happyEggCtrl:getClassType())
	self.maxNum = #self.awardList
	self.fields.List:setNumItems(#self.awardList)
	self.fields.Text_Tips:setVisible(not happyEggCtrl:isFirstChoose())
	self:updatebtn()
end
function HappyEggPopPanel:onItemRenderer(index, obj)
	obj:initData(self.awardList[self.maxNum - index], self.maxNum - index, handler(self, self.backChooseItem))
end
function HappyEggPopPanel:backChooseItem(groupType, chooseInfo)
	self.chooseInfo[groupType] = chooseInfo
	self:updatebtn()
end
function HappyEggPopPanel:updatebtn()
	self.totoalNum = 0
	for i, v in ipairs(self.chooseInfo) do
		self.totoalNum = self.totoalNum + table.nums(v)
	end
	self.fields.Button_Confirm:setBright(true)
	if 0 >= happyEggCtrl:getLeftResetCont() or self.totoalNum ~= 8 then
		self.fields.Button_Confirm:setBright(false)
	end
end
function HappyEggPopPanel:onClickConfirm()
	SoraDPlaySound()
	if happyEggCtrl:getLeftResetCont() > 0 then
		if self.totoalNum == 8 then
			dump(self:getChooseInfo(), "self:getChooseInfo()")
			_ENV = "self:getChooseInfo()"
			;("self:getChooseInfo()").byUID = true
			local noticeTime = SoraDConfigGet("Game:HappyEggView:timeNotice2~integer", "self:getChooseInfo()") or 0
			local isSameDay = serviceFunctions.isSameDay(noticeTime)
			if isSameDay then
				happyEggCtrl:reqCommonLottery9001544Select(self:getChooseInfo())
				self:removeFromParent()
			else
				_ENV = self:getChooseInfo()
				self:getChooseInfo().content = i18n("happyegg_13")
				self:getChooseInfo().confirmFunc = function()
					happyEggCtrl:reqCommonLottery9001544Select(self:getChooseInfo())
					self:removeFromParent()
				end
				self:getChooseInfo().cancelString = i18n("common_text_185")
				self:getChooseInfo().remindString = i18n("coffeeCraftsman_text_27")
				self:getChooseInfo().remindFunc = function(value)
					if value then
						_ENV = nil
						;(nil).byUID = true
						SoraDConfigSet("Game:HappyEggView:timeNotice2~integer", serviceFunctions.systemTime(), nil)
					end
				end
				uiManager:show("MessageBox", self:getChooseInfo())
			end
		else
			SoraDShowMsgTip(i18n("Lamp_secret_text_04"))
		end
	else
		SoraDShowMsgTip(i18n("Lamp_secret_text_05"))
	end
end
function HappyEggPopPanel:getChooseInfo()
	local _ENV, ret
	for _, groupList in ipairs(self.chooseInfo) do
		for _, index in ipairs(groupList) do
			table.insert(ret, index)
		end
	end
	return ret
end
function HappyEggPopPanel:onHide()
	happyEggCtrl:saveChoosList(self:getChooseInfo())
end
return HappyEggPopPanel
