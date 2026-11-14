local nebulaAllStarRead = include("nebulaAllStarRead")
local nebulaWarRead = include("nebulaWarRead")
local publicRead = include("publicRead")
local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_guess = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaAllStarWar/Com_guess", Com_guess)
function Com_guess:onInit()
	self.campList, _ENV, self.selectIndex = nil, nil, nil
	self.odds = 1
	self.coinID = gIDDef.NEBULA_ALLSTAR_QUIZ_COIN
	self.fields.List:setItemRenderer(handler(self, self.onCampRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseItem))
	self.fields.List:setAlignCenter(true)
	self.fields.Button_bet:setString(i18n("NebulaAllstar_213"))
	self.fields.Button_bet:addClickListener(handler(self, self.btnBetClick))
	self.fields.Button_bet:setEnabled(false)
	self.fields.slider:setSliderCallBack(handler(self, self.sliderUpdate))
	self.fields.slider:setInpuBoxFixPos()
	self.fields.Com_income:setIcon(publicRead.getIcon(self.coinID))
	self.fields.Com_bet:setPreStr(i18n("NebulaAllstar_217"))
	self.fields.Com_bet:setIcon(publicRead.getIcon(self.coinID))
	self.fields.Text_settling = SoraDCreateTimerLabel(self, self.fields.Text_settling)
	self.fields.Text_done:setString(i18n("NebulaAllstar_224"))
	self.fields.icon_win:fixPos()
	self.fields.Text_odds:fixPos()
	self.fields.Com_income:fixPos()
	self.fields.Com_bet:fixPos()
end
function Com_guess:onShow()
end
function Com_guess:onCampRenderer(index, obj)
	local regionId = self.campList[index + 1].camp
	obj:setTitle(nebulaWarRead.getAreaName(regionId))
	obj:setIcon(nebulaWarRead.getAreaIcon(regionId))
	if self.selectIndex then
		obj:setSelected(index + 1 == self.selectIndex)
	else
		obj:setSelected(false)
	end
	local c_win = obj:getController("c_win")
	if self.quizbetInfo and self.quizbetInfo.winCamp and self.quizbetInfo.winCamp == regionId then
		c_win:setSelectedIndex(1)
	else
		c_win:setSelectedIndex(0)
	end
	if not obj.isInit then
		local _fields = fguiHelper.get_fields(obj)
		_fields.mv_win:setAllFrameName("dh_zhaiyueqd7_%.3d.png", 0)
		_fields.Load_win:setSpriteFrame(SoraDFIsRA() and "title_yjyh_win.png" or "title_yjyh_win_en.png")
	end
end
function Com_guess:onChooseItem()
	SoraDPlaySound()
	self.selectIndex = self.fields.List:getSelectedIndex() + 1
	self:setOdds(self.selectIndex)
	self.fields.Com_income:setTitle(math.ceil(self.odds * self.fields.slider:getSliderCurValue()))
	self.fields.Button_bet:setEnabled(self.fields.slider:getSliderCurValue() > 0 and self.selectIndex ~= nil)
end
function Com_guess:setOdds(camp)
	if camp then
		local quizTurnRank = nebulaAllStarCtrl:getQuizTurnRank(camp, self.turn)
		self.odds = nebulaAllStarRead.getOddByRank(quizTurnRank)
		nebulaAllStarCtrl = nil
		;(nil).num = fguiHelper.getColorString("#FFD43E", self.odds)
		self.fields.Text_odds:setString(i18n("NebulaAllstar_216", nil))
	else
		nebulaAllStarCtrl = i18n("NebulaAllstar_216", nil)
		i18n("NebulaAllstar_216", nil).num = fguiHelper.getColorString("#FFD43E", "???")
		self.fields.Text_odds:setString(i18n("NebulaAllstar_216", i18n("NebulaAllstar_216", nil)))
	end
end
function Com_guess:initData(themeID, index, tag, turnPass, turn)
	self.themeID = themeID
	self.turnPass = turnPass
	self.turn = turn
	self.selectIndex = nil
	local cfg = nebulaAllStarRead.getThemeCfg(self.themeID)
	self.fields.Text_title:setString(i18n(cfg.ThemeName))
	self.fields.Text_dec:setString(i18n(cfg.ThemeDec))
	self.campList = nebulaAllStarCtrl:getCampInfo()
	self.quizbetInfo = nebulaAllStarCtrl:getViewerQuizBetByID(self.themeID)
	self.fields.Com_income:setPreStr(i18n("NebulaAllstar_218"))
	if tag == 1 then
		self:updateViewType1()
	else
		self:updateViewType2()
	end
	self.fields.List:setNumItems(#self.campList)
	self.fields.List:setScrollEnable(math.ceil(#self.campList / 5) * 111 > self.fields.List:getHeight())
	self.fields.List:setTouchEnabled(self.controllers.c1:getSelectedIndex() == 0)
end
function Com_guess:updateViewType1(...)
	if self.quizbetInfo and self.quizbetInfo.result then
		self:updatQquizbetResult()
		return
	end
	local isBet = self.quizbetInfo ~= nil
	if self.turnPass then
		if isBet then
			self.controllers.c1:setSelectedIndex(2)
			self:setOdds(self.quizbetInfo.camp)
			self:setWaiting()
		else
			self.selectIndex = nil
			self.controllers.c1:setSelectedIndex(1)
		end
	else
		self.controllers.c1:setSelectedIndex(isBet and 2 or 0)
		if isBet then
			self:setOdds(self.quizbetInfo.camp)
		else
			self:setOdds(self.selectIndex)
		end
		if not isBet then
			local myCoin = nebulaAllStarCtrl:getViewerQuizCoin()
			local maxQuizNum = nebulaAllStarRead.getConstValue("QuizMAXNum", 2000)
			nebulaAllStarCtrl = nil
			;(nil).minValue = math.min(myCoin, 1)
			;(nil).curValue = math.min(myCoin, 1)
			;(nil).maxValue = math.min(myCoin, maxQuizNum)
			;(nil).allowZero = true
			self.fields.slider:initData(nil)
		else
			self:setWaiting()
		end
	end
end
function Com_guess:updatQquizbetResult()
	self:setOdds(self.quizbetInfo.camp)
	self.controllers.c1:setSelectedIndex(self.quizbetInfo.result and 3 or 2)
	if not self.quizbetInfo.result then
		self:setWaiting()
	else
		self.selectIndex = self.quizbetInfo.camp
		self.fields.Com_bet:setTitle(self.quizbetInfo.quizCoin)
		self.fields.Text_settling:endTime()
		self.fields.Com_income:setPreStr(i18n("NebulaAllstar_223"))
		if self.quizbetInfo.result == 1 then
			self.fields.Com_income:setTitle(math.ceil(self.odds * self.quizbetInfo.quizCoin))
			self.fields.icon_win:setSpriteFrame(SoraDFIsRA() and "frame_qmx_success_ar.png" or "frame_qmx_success_en.png")
		else
			self.fields.Com_income:setTitle(0)
			self.fields.icon_win:setSpriteFrame(SoraDFIsRA() and "frame_qmx_fail_ar.png" or "frame_qmx_fail_en.png")
		end
	end
end
function Com_guess:updateViewType2(...)
	self:updatQquizbetResult()
end
function Com_guess:setWaiting()
	self.selectIndex = self.quizbetInfo.camp
	self.fields.Com_income:setTitle(math.ceil(self.quizbetInfo.quizCoin * self.odds))
	self.fields.Com_bet:setTitle(self.quizbetInfo.quizCoin)
	local cfg = nebulaAllStarRead.getThemeCfg(self.themeID)
	if cfg.InvoiceTime[1] == 1 then
		self.fields.Text_settling:setTimeLast(function(timeStr)
			_ENV = nil
			;(nil).time = timeStr
			return i18n("NebulaAllstar_12", nil)
		end)
		local leftTime = cfg.InvoiceTime[2] - nebulaAllStarCtrl:getWarStarPassTime()
		self.fields.Text_settling:beginTime(leftTime)
	else
		self.fields.Text_settling:endTime()
		self.fields.Text_settling:setString(i18n("NebulaAllstar_296"))
	end
end
function Com_guess:sliderUpdate(value)
	if self.selectIndex then
		self.fields.Com_income:setTitle(math.ceil(value * self.odds))
	else
		self.fields.Com_income:setTitle("???")
	end
	self.fields.Button_bet:setEnabled(self.fields.slider:getSliderCurValue() > 0 and self.selectIndex ~= nil)
end
function Com_guess:btnBetClick()
	SoraDPlaySound()
	nebulaAllStarCtrl:reqViewerQuiz(self.themeID, self.selectIndex, self.fields.slider:getSliderCurValue())
end
return Com_guess
