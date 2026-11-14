local achiDesRead = include("achiDesRead")
local achievementctrl = SoraDGetCtrl("achievementctrl")
local dressCtrl = SoraDGetCtrl("dressCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local medalPopViewPanel = class("medalPopViewPanel", baseFguiPanel)
function medalPopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("medalPopViewPanel:ctor", self.viewName)
end
function medalPopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function medalPopViewPanel:onInit()
	print("=======medalPopViewPanel:onInit")
	self.contentList, _ENV = print, print
	self.fields.Text_showTip:setString(i18n("common_text_2004"))
	self.fields.Button_switch:addClickListener(handler(self, self.btnSwitchClickCallBack))
	self.fields.Button_achi:addClickListener(handler(self, self.btnAchiClickCallBack))
	self.fields.Button_go:setTitleText(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onGoClick))
	self.fields.ScrollView_content:setItemRenderer(handler(self, self.onItemRenderer))
end
function medalPopViewPanel:onShow()
	print("=======medalPopViewPanel:onShow")
	self.oriData = self.param.myIconData
	self.medalInfo = achiDesRead.getInfoById(self.param.myIconData.id)
	self.achiId = self.param.myIconData.id
	self.isWork = self.param.isWork
	local tmpTbl = achievementctrl:getAchievementInfo()
	self.onShow = tmpTbl.showMetalID == self.oriData.medalID and tmpTbl.isShow
	self:initView()
end
function medalPopViewPanel:initView()
	self.fields.Panel_bg:setString(i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName))
	local achiInfo = achiDesRead.getInfoById(self.oriData.otherInfo.curID)
	if self.oriData.otherInfo.section >= self.oriData.otherInfo.totalSection then
		_ENV = i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName)
		i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName).achi = i18n(achiInfo.achiName)
		self.fields.Text_upTxt:setString(i18n("achievement_des_63", i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName)))
	else
		_ENV = i18n("achievement_des_63", i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName))
		i18n("achievement_des_63", i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName)).achi = i18n(achiInfo.achiName)
		self.fields.Text_upTxt:setString(i18n("common_text_2819", i18n("achievement_des_63", i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName))))
	end
	self.fields.achi:initPopData(self.oriData)
	if 1 == self.medalInfo.isActive then
		if table.nums(self.medalInfo.medalBuff) > 0 then
			self.controllers.c1:setSelectedIndex(1)
			local buffContent = achiDesRead.getMedalBuffStr(self.medalInfo.medalBuff)
			local medalName = i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName)
			if self.isWork then
				_ENV = i18n("common_text_2819", i18n("achievement_des_63", i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName)))
				i18n("common_text_2819", i18n("achievement_des_63", i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName))).medal = medalName
				i18n("common_text_2819", i18n("achievement_des_63", i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName))).str = buffContent
				self.fields.Text_achiTip:setString(i18n("common_text_1991", i18n("common_text_2819", i18n("achievement_des_63", i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName)))))
			else
				_ENV = i18n("common_text_1991", i18n("common_text_2819", i18n("achievement_des_63", i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName))))
				i18n("common_text_1991", i18n("common_text_2819", i18n("achievement_des_63", i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName)))).medal = medalName
				i18n("common_text_1991", i18n("common_text_2819", i18n("achievement_des_63", i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName)))).str = buffContent
				self.fields.Text_achiTip:setString(i18n("common_text_1988", i18n("common_text_1991", i18n("common_text_2819", i18n("achievement_des_63", i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName))))))
			end
			self.fields.Button_achi:setVal(self.isWork)
			local _content, _index = achiDesRead.getTheNextDiffBuff(self.oriData.id)
			if 0 < _index and _index < self.oriData.otherInfo.totalSection then
				_ENV = i18n("common_text_1988", i18n("common_text_1991", i18n("common_text_2819", i18n("achievement_des_63", i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName)))))
				i18n("common_text_1988", i18n("common_text_1991", i18n("common_text_2819", i18n("achievement_des_63", i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName))))).num = _index
				i18n("common_text_1988", i18n("common_text_1991", i18n("common_text_2819", i18n("achievement_des_63", i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName))))).str = _content
				self.fields.Text_downTxt:setString(i18n("common_text_1980", i18n("common_text_1988", i18n("common_text_1991", i18n("common_text_2819", i18n("achievement_des_63", i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName)))))))
			else
				self.fields.Text_downTxt:setString("")
			end
		else
			self.controllers.c1:setSelectedIndex(0)
			self.contentList = achiDesRead.getBuffListTblByID(self.achiId)
			self.fields.ScrollView_content:setNumItems(#self.contentList)
		end
	elseif 0 == self.medalInfo.isActive then
		self.controllers.c1:setSelectedIndex(0)
		self.contentList = achiDesRead.getBuffListTblByID(self.achiId)
		self.fields.ScrollView_content:setNumItems(#self.contentList)
	end
	self.fields.Text_upTxt:fixPos()
	self.fields.Text_downTxt:fixPos()
	self.fields.achi:fixPos()
	self.fields.Text_showTip:fixPos()
	self.fields.Button_switch:fixPos()
	self.fields.Text_achiTip:fixPos()
	self.fields.Button_achi:fixPos()
	self.fields.Button_switch:setVal(self.onShow)
end
function medalPopViewPanel:onItemRenderer(index, obj)
	obj:initData(self.contentList[index + 1], self.oriData.otherInfo.section)
end
function medalPopViewPanel:msgBackData(target, redata)
	if redata then
		self.onShow = redata.isShow
		if redata.isShow then
			local medalName = i18n(achiDesRead.getMedalById(redata.medalID).medalName)
			_ENV = nil
			;(nil).name = medalName
			SoraDShowMsgTip(i18n("common_text_2006", nil))
		end
	end
end
function medalPopViewPanel:btnSwitchClickCallBack()
	SoraDPlaySound()
	achievementctrl:sendSetMetal(self.oriData.medalID)
end
function medalPopViewPanel:btnAchiClickCallBack()
	SoraDPlaySound()
	local buffContent = achiDesRead.getMedalBuffStr(self.medalInfo.medalBuff)
	local medalName = i18n(achiDesRead.getMedalById(self.oriData.medalID).medalName)
	if not self.fields.Button_achi:getVal() then
		_ENV = nil
		;(nil).medal = medalName
		;(nil).str = buffContent
		self.fields.Text_achiTip:setString(i18n("common_text_1988", nil))
	else
		_ENV = i18n("common_text_1988", nil)
		i18n("common_text_1988", nil).medal = medalName
		i18n("common_text_1988", nil).str = buffContent
		self.fields.Text_achiTip:setString(i18n("common_text_1991", i18n("common_text_1988", nil)))
	end
	if self.isWork then
		local dressID = self.medalInfo.medalBuff[2]
		if dressID then
			dressCtrl:restoreAchiDress(dressID)
		end
	else
		local dressID = self.medalInfo.medalBuff[2]
		if dressID then
			dressCtrl:selectDress(dressID)
		end
	end
end
function medalPopViewPanel:onGoClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).isToAchi = true
	;(nil).jumpID = self.oriData.medalID
	uiManager:show("honourWallView", nil)
	self:close()
end
return medalPopViewPanel
