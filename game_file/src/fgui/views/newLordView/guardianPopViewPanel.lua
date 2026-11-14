local guardianRead = include("guardianRead")
local buffDesRead = include("buffDesRead")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local loginGiftCtrl = SoraDGetCtrl("loginGiftCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local guardianCtrl = SoraDGetCtrl("guardianCtrl")
_UPVALUE3_ = "guardianCtrl"
_UPVALUE3_, ("guardianCtrl")[1] = "protect_name_01", "protect_name_01"
_UPVALUE3_, ("guardianCtrl")[2] = "protect_name_01", "protect_name_02"
local _UPVALUE3_, ("guardianCtrl")[3], title = "protect_name_01", "protect_name_03", "guardianCtrl"
_UPVALUE3_, ("protect_name_01")[1] = "protect_title_01", "protect_title_01"
_UPVALUE3_, ("protect_name_01")[2] = "protect_title_01", "protect_title_02"
local _UPVALUE3_, ("protect_name_01")[3], privilegeTitle = "protect_title_01", "protect_title_03", "protect_name_01"
;("protect_title_01")[1] = "frame_protect_01.png"
;("protect_title_01")[2] = "frame_protect_02.png"
local ("protect_title_01")[3], iconName = "frame_protect_03.png", "protect_title_01"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local guardianPopViewPanel = class("guardianPopViewPanel", baseFguiPanel)
function guardianPopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("guardianPopViewPanel:ctor", self.viewName)
end
function guardianPopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function guardianPopViewPanel:onInit()
	print("=======guardianPopViewPanel:onInit")
	self.isShow = true
	self.curPage = 1
	self.pagesCount = 3
	self.fields.Panel_bg:setString(i18n("activity_name_32"))
	self.fields.Text_Show:setString(i18n("protect_text_02"))
	self.fields.btn_Show:addClickListener(handler(self, self.btnClickShow))
	self.fields.btn_instruct:addClickListener(handler(self, self.btnClickExplain))
	self.fields.Lab_nolv:setVisible(false)
	self.fields.Button_Left:addClickListener(handler(self, self.btnLeftPageClick))
	self.fields.Button_Right:addClickListener(handler(self, self.btnRightPageClick))
	self.fields.btn_instruct:fixPos()
	self.fields.com_box:fixPos()
	self.fields.n3:fixPos()
	self.fields.btn_Show:fixPos()
	self.fields.Text_Show:fixPos()
	self.fields.LoadingBar_progress:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.Button_Left:fixPos()
	self.fields.Button_Left:setRotation(SoraDFIsRA() and 180 or 0)
	self.fields.Button_Right:fixPos()
	self.fields.Button_Right:setRotation(SoraDFIsRA() and 0 or 180)
end
function guardianPopViewPanel:onShow()
	print("=======guardianPopViewPanel:onShow")
	self.fields.PageView_events:setItemRenderer(handler(self, self.onPageItemRenderer))
	self:initData()
end
function guardianPopViewPanel:onPageItemRenderer(index, obj)
	obj:initData(self.buffInfo[index + 1])
end
function guardianPopViewPanel:initData()
	self:updataData()
	self.curPage = self.guardType == 0 and 1 or self.guardType
	self.fields.Text_LvName:setString(i18n(privilegeTitle[self.curPage]))
	self.buffInfo = self:getScrollData(self.guardType)
	self.fields.PageView_events:setNumItems(#self.buffInfo)
	self.fields.List_point:setSelectedIndex(self.curPage - 1)
end
function guardianPopViewPanel:updataData(target, data)
	if data and data.reward then
		SoraDMailGainItems(data.reward, true)
	end
	local maxPage = guardianRead.getPageNum()
	self.guardType = guardianCtrl:getGuardType()
	self.fields.Image_Center_Icon:setSpriteFrame(iconName[self.guardType == 0 and 1 or self.guardType])
	self.isShow = guardianCtrl:getIsShow()
	self.loginDays = guardianCtrl:getLoginDay()
	self.castleLv = SoraDGetCastleLv()
	local needDays = guardianRead.getProperty(self.guardType + 1, "num") or 0
	local needLv = guardianRead.getProperty(self.guardType + 1, "lv") or 0
	self.isCanReceive = guardianCtrl:getIsCanReceive()
	self.fields.Lab_nolv:setVisible(false)
	local imageFontTypeName = "frame_font_guardian_" .. self.guardType .. (SoraDFIsRA() and "_ar" or "_en") .. ".png"
	if SoraDGetDefaultLanguage() == "ko" then
		imageFontTypeName = "frame_font_guardian_0" .. self.guardType .. "_ko" .. ".png"
	end
	self.fields.com_box:initData(0)
	if self.guardType == 0 then
		self.fields.Image_Type:setVisible(false)
		self.fields.LoadingBar_progress:setVisible(true)
		self.fields.Text_progress:setVisible(true)
		self.fields.Text_tip:setVisible(false)
		self.fields.Lab_nolv:setVisible(true)
		if needLv > self.castleLv then
			_ENV = nil
			;(nil).lv = fguiHelper.getColorString("#BE2828", needLv)
			;(nil).name = i18n(title[self.guardType + 1])
			self.fields.Lab_nolv:setString(i18n("protect_text_05", nil))
		else
			_ENV = i18n("protect_text_05", nil)
			i18n("protect_text_05", nil).lv = fguiHelper.getColorString("#BE2828", needDays)
			i18n("protect_text_05", nil).name = i18n(title[self.guardType + 1])
			self.fields.Lab_nolv:setString(i18n("protect_text_06", i18n("protect_text_05", nil)))
		end
		self.fields.LoadingBar_progress:setMax(needDays)
		self.fields.LoadingBar_progress:setValue(self.loginDays)
		_ENV = i18n("protect_text_06", i18n("protect_text_05", nil))
		i18n("protect_text_06", i18n("protect_text_05", nil)).var1 = self.loginDays
		i18n("protect_text_06", i18n("protect_text_05", nil)).var2 = needDays
		self.fields.Text_progress:setString(i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil))))
		_ENV = i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil)))
		i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil))).num = fguiHelper.getColorString("#FFAA00", self.loginDays)
		i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil))).maxNum = needDays
		self.fields.Text_Days:setString(i18n("protect_text_07", i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil)))))
	elseif self.guardType == maxPage then
		self.fields.Image_Type:setVisible(true)
		self.fields.Image_Type:setSpriteFrame(imageFontTypeName)
		self.fields.LoadingBar_progress:setVisible(false)
		self.fields.Text_progress:setVisible(false)
		self.fields.Text_tip:setVisible(true)
		_ENV = i18n("protect_text_07", i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil))))
		i18n("protect_text_07", i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil)))).num = self.loginDays
		self.fields.Text_tip:setString(i18n("king_road_01", i18n("protect_text_07", i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil))))))
	else
		self.fields.Image_Type:setVisible(true)
		self.fields.Image_Type:setSpriteFrame(imageFontTypeName)
		self.fields.LoadingBar_progress:setVisible(true)
		self.fields.Text_progress:setVisible(true)
		self.fields.Text_tip:setVisible(false)
		if needLv > self.castleLv then
			self.fields.Lab_nolv:setVisible(true)
			_ENV = i18n("king_road_01", i18n("protect_text_07", i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil)))))
			i18n("king_road_01", i18n("protect_text_07", i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil))))).lv = fguiHelper.getColorString("#BE2828", needLv)
			i18n("king_road_01", i18n("protect_text_07", i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil))))).name = i18n(title[self.guardType + 1])
			self.fields.Lab_nolv:setString(i18n("protect_text_05", i18n("king_road_01", i18n("protect_text_07", i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil)))))))
		end
		self.fields.LoadingBar_progress:setMax(needDays)
		self.fields.LoadingBar_progress:setValue(self.loginDays)
		_ENV = i18n("protect_text_05", i18n("king_road_01", i18n("protect_text_07", i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil))))))
		i18n("protect_text_05", i18n("king_road_01", i18n("protect_text_07", i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil)))))).var1 = self.loginDays
		i18n("protect_text_05", i18n("king_road_01", i18n("protect_text_07", i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil)))))).var2 = needDays
		self.fields.Text_progress:setString(i18n("%{var1}/%{var2}", i18n("protect_text_05", i18n("king_road_01", i18n("protect_text_07", i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil))))))))
		_ENV = i18n("%{var1}/%{var2}", i18n("protect_text_05", i18n("king_road_01", i18n("protect_text_07", i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil)))))))
		i18n("%{var1}/%{var2}", i18n("protect_text_05", i18n("king_road_01", i18n("protect_text_07", i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil))))))).num = fguiHelper.getColorString("#FFAA00", self.loginDays)
		i18n("%{var1}/%{var2}", i18n("protect_text_05", i18n("king_road_01", i18n("protect_text_07", i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil))))))).maxNum = needDays
		self.fields.Text_Days:setString(i18n("protect_text_07", i18n("%{var1}/%{var2}", i18n("protect_text_05", i18n("king_road_01", i18n("protect_text_07", i18n("%{var1}/%{var2}", i18n("protect_text_06", i18n("protect_text_05", nil)))))))))
	end
	if self.guardType ~= 0 and self.isCanReceive then
		self.fields.com_box:initData(2)
	elseif self.guardType ~= 0 then
		self.fields.com_box:initData(1)
	end
	self.fields.btn_Show:setSelected(self.isShow)
end
function guardianPopViewPanel:getScrollData(level)
	if not guardianRead.getProperty(level == 0 and 1 or level, "buff") then
		local guardianRead, buffData = guardianRead.getProperty(level == 0 and 1 or level, "buff"), guardianRead.getProperty(level == 0 and 1 or level, "buff")
	end
	local index = 1
	local guardianRead, buffInfo = "buff", "buff"
	for i, v in ipairs(buffData) do
		local guardianRead, singleTmp
		singleTmp.buffID = v
		singleTmp.isNew = not guardianRead.getBuffIsNew(level - 1, v)
		local effectType = buffltCtrl:getEffectType(v)
		local effectValue = buffltCtrl:getEffect(v)
		singleTmp.des = buffDesRead.getTitleBase(effectType)
		if effectValue then
			singleTmp.numDes = buffDesRead.getTitleValueWithValue(effectType, effectValue, false, SoraDFIsRA())
		else
			single.numDes = ""
		end
		if singleTmp.isNew then
			table.insert(buffInfo, index, singleTmp)
			index = index + 1
		else
			table.insert(buffInfo, singleTmp)
		end
	end
	return buffInfo
end
function guardianPopViewPanel:btnLeftPageClick()
	SoraDPlaySound()
	self.curPage = self.curPage + 1
	if self.curPage > self.pagesCount then
		self.curPage = 1
	end
	self.fields.Text_LvName:setString(i18n(privilegeTitle[self.curPage]))
	self.buffInfo = self:getScrollData(self.curPage)
	self.fields.PageView_events:setNumItems(#self.buffInfo)
	self.fields.List_point:setSelectedIndex(self.curPage - 1)
end
function guardianPopViewPanel:btnRightPageClick()
	SoraDPlaySound()
	self.curPage = self.curPage - 1
	if self.curPage < 1 then
		self.curPage = self.pagesCount
	end
	self.fields.Text_LvName:setString(i18n(privilegeTitle[self.curPage]))
	self.buffInfo = self:getScrollData(self.curPage)
	self.fields.PageView_events:setNumItems(#self.buffInfo)
	self.fields.List_point:setSelectedIndex(self.curPage - 1)
end
function guardianPopViewPanel:btnClickExplain()
	SoraDPlaySound()
	_ENV = nil
	;(nil).num = guardianRead.getProperty(1, "num")
	SoraDShowHelpMsgTip(i18n("protect_text_01", nil))
end
function guardianPopViewPanel:btnClickShow()
	SoraDPlaySound()
	self.isShow = not self.isShow
	self.fields.btn_Show:setSelected(self.isShow)
	_ENV = self.isShow
	self.isShow.show = self.isShow
	guardianCtrl:sendReqShow(self.isShow)
	SoraDShowMsgTip(self.isShow and i18n("protect_text_03") or i18n("protect_text_04"))
end
return guardianPopViewPanel
