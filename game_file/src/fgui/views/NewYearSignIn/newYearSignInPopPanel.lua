local newYearSignInRead = include("newYearSignInRead")
local newYearSignInCtrl = SoraDGetCtrl("newYearSignInCtrl")
local basePanel = require("fgui.base.baseFguiPanel")
local newYearSignInPopPanel = class("newYearSignInPopPanel", basePanel)
function newYearSignInPopPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function newYearSignInPopPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function newYearSignInPopPanel:onInit()
	self.fields.panel_normal:setString(i18n("decrypt_text_03"))
	self.fields.btnSignIn:addClickEventListener(handler(self, self.onClickSignIn))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
end
function newYearSignInPopPanel:onShow()
	self.state = newYearSignInCtrl:getDayRewardStatus(self.proxy.param.day)
	newYearSignInCtrl = nil
	newYearSignInCtrl, newYearSignInCtrl, (nil).day = nil, self.proxy.param.day, self.proxy.param.day
	self.proxy.param.day.day, (nil).color = nil, "#70C723"
	self.fields.txt_need:setString(i18n_html("common_text_2872", nil, self.proxy.param.day))
	local awardCfg = newYearSignInRead.getAwardByDay(self.proxy.param.day)
	newYearSignInRead = i18n_html("common_text_2872", nil, self.proxy.param.day)
	i18n_html("common_text_2872", nil, self.proxy.param.day)[1] = "id"
	i18n_html("common_text_2872", nil, self.proxy.param.day)[2] = "count"
	self.awardCfg = serviceFunctions.tableFormat(awardCfg, i18n_html("common_text_2872", nil, self.proxy.param.day))
	self.fields.scroll:setNumItems(#self.awardCfg)
	self.fields.btnSignIn:setEnabled(self.state == 3 or self.state == 2)
	if self.state == 3 then
		local needGold = newYearSignInCtrl:getGoldCost()
		self.fields.btnSignIn:initData(needGold)
	elseif self.state == 4 then
		self.fields.btnSignIn:setString(i18n(IsArClient and "common_text_3070" or "newyear_carnival_text_006"))
	elseif self.state == 5 then
		newYearSignInCtrl = i18n(IsArClient and "common_text_3070" or "newyear_carnival_text_006")
		i18n(IsArClient and "common_text_3070" or "newyear_carnival_text_006").day = 6
		self.fields.btnSignIn:setString(i18n("newyear_signin_text_02", i18n(IsArClient and "common_text_3070" or "newyear_carnival_text_006")))
	elseif self.state == 1 then
		self.fields.btnSignIn:setString(i18n("common_text_1892"))
	elseif self.state == 2 then
		self.fields.btnSignIn:setString(i18n("common_text_2477"))
	end
end
function newYearSignInPopPanel:onItemRenderer(index, object)
	local award = self.awardCfg[index + 1]
	object:initData(award.id, award.count)
	object:setGrayed(self.state == 1)
end
function newYearSignInPopPanel:onClickSignIn()
	SoraDPlaySound()
	SoraDCloseLoading()
	if self.state == 3 and not SoraDEnoughGold(newYearSignInCtrl:getGoldCost()) then
		return
	end
	newYearSignInCtrl:reqNewYearCarnivalSign(self.proxy.param.day)
	self:removeFromParent()
end
return newYearSignInPopPanel
