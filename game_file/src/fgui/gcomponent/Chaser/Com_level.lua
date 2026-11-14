local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local artifactRuneRead = include("artifactRuneRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_level = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Chaser/Com_level", Com_level)
function Com_level:onInit()
	self.isFirst = true
	self.fields.Button_touch:addClickListener(handler(self, self.btnTouchClick))
	self.fields.Movie:setAllFrameName("dh_bsyh_hc_%02d.png", 1)
	self.fields.Movie:setVisible(false)
end
function Com_level:onShow()
end
_UPVALUE5_, Com_level.playAddAct = function(self)
	self.fields.Movie:setVisible(true)
	self.fields.Movie:setPlaySettings(0, -1, 1, -1)
	self.fields.icon_rune:setAlpha(0)
	_UPVALUE1_ = -1
	;(-1)[1] = ffa.delay(0.15)
	;(-1)[2] = ffa.fadeIn(0.2)
	;(-1)[3] = ffa.fadeIn(0.2)
	self.fields.icon_rune:runAction(ffa.seq(-1))
end, function(self)
	self.fields.Movie:setVisible(true)
	self.fields.Movie:setPlaySettings(0, -1, 1, -1)
	self.fields.icon_rune:setAlpha(0)
	_UPVALUE1_ = -1
	;(-1)[1] = ffa.delay(0.15)
	;(-1)[2] = ffa.fadeIn(0.2)
	;(-1)[3] = ffa.fadeIn(0.2)
	self.fields.icon_rune:runAction(ffa.seq(-1))
end
;(function(self)
	self.fields.Movie:setVisible(true)
	self.fields.Movie:setPlaySettings(0, -1, 1, -1)
	self.fields.icon_rune:setAlpha(0)
	_UPVALUE1_ = -1
	;(-1)[1] = ffa.delay(0.15)
	;(-1)[2] = ffa.fadeIn(0.2)
	;(-1)[3] = ffa.fadeIn(0.2)
	self.fields.icon_rune:runAction(ffa.seq(-1))
end)[1] = "dh_ZW_addhongse_%02d.png"
;(function(self)
	self.fields.Movie:setVisible(true)
	self.fields.Movie:setPlaySettings(0, -1, 1, -1)
	self.fields.icon_rune:setAlpha(0)
	_UPVALUE1_ = -1
	;(-1)[1] = ffa.delay(0.15)
	;(-1)[2] = ffa.fadeIn(0.2)
	;(-1)[3] = ffa.fadeIn(0.2)
	self.fields.icon_rune:runAction(ffa.seq(-1))
end)[2] = "dh_ZW_addlanse_%02d.png"
;(function(self)
	self.fields.Movie:setVisible(true)
	self.fields.Movie:setPlaySettings(0, -1, 1, -1)
	self.fields.icon_rune:setAlpha(0)
	_UPVALUE1_ = -1
	;(-1)[1] = ffa.delay(0.15)
	;(-1)[2] = ffa.fadeIn(0.2)
	;(-1)[3] = ffa.fadeIn(0.2)
	self.fields.icon_rune:runAction(ffa.seq(-1))
end)[3] = "dh_ZW_addgreen_%02d.png"
;(function(self)
	self.fields.Movie:setVisible(true)
	self.fields.Movie:setPlaySettings(0, -1, 1, -1)
	self.fields.icon_rune:setAlpha(0)
	_UPVALUE1_ = -1
	;(-1)[1] = ffa.delay(0.15)
	;(-1)[2] = ffa.fadeIn(0.2)
	;(-1)[3] = ffa.fadeIn(0.2)
	self.fields.icon_rune:runAction(ffa.seq(-1))
end)[4] = "dh_ZW_addchengse_%02d.png"
local (function(self)
	self.fields.Movie:setVisible(true)
	self.fields.Movie:setPlaySettings(0, -1, 1, -1)
	self.fields.icon_rune:setAlpha(0)
	_UPVALUE1_ = -1
	;(-1)[1] = ffa.delay(0.15)
	;(-1)[2] = ffa.fadeIn(0.2)
	;(-1)[3] = ffa.fadeIn(0.2)
	self.fields.icon_rune:runAction(ffa.seq(-1))
end)[5], configPng = "dh_ZW_addcaise_%02d.png", function(self)
	self.fields.Movie:setVisible(true)
	self.fields.Movie:setPlaySettings(0, -1, 1, -1)
	self.fields.icon_rune:setAlpha(0)
	_UPVALUE1_ = -1
	;(-1)[1] = ffa.delay(0.15)
	;(-1)[2] = ffa.fadeIn(0.2)
	;(-1)[3] = ffa.fadeIn(0.2)
	self.fields.icon_rune:runAction(ffa.seq(-1))
end
function Com_level:initData(data, isMine, group)
	self.data = data
	dump(self.data, "self.data")
	self.group = group
	print("string.formaype)", configPng[self.data.holeType])
	self.fields.img_d:setURL(string.format("img_warpattern_d_%02d.png", self.data.holeType))
	local framesNpc = display.newFrames(configPng[self.data.holeType], 1, 30)
	local animationNpc = display.newAnimation(framesNpc, 0.08333333333333333)
	self.fields.Movie_normal:setAnimation(animationNpc)
	self.fields.Movie:setVisible(false)
	self.fields.Text_lv:setVisible(false)
	if self.data.showType == 0 then
		self.fields.img_add:setVisible(false)
		self.fields.Node_rune:setVisible(false)
		self.fields.icon_lock:setVisible(true)
	elseif self.data.showType == 1 then
		self.fields.img_add:setVisible(true)
		self.fields.Node_rune:setVisible(false)
		self.fields.icon_lock:setVisible(false)
	else
		local runeInfo = godArmsRuneCtrl:getRuneInfo(self.data.uid)
		if runeInfo then
			self.fields.img_add:setVisible(false)
			self.fields.Node_rune:setVisible(true)
			self.fields.icon_lock:setVisible(false)
			local info = artifactRuneRead.getRuneInfo(runeInfo.rid)
			self.fields.icon_rune:setURL(info.Runelcon)
			local lvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, runeInfo.level)
			local season = SoraDGetCtrl("nebulaActivityCtrl"):getCurSeason() or 1
			local subscript = artifactRuneRead.getRuneSubscript(runeInfo.rid)
			if subscript then
				self.fields.img_warpattern:setVisible(true)
				self.fields.img_warpattern:setSpriteFrame(subscript)
			else
				self.fields.img_warpattern:setVisible(false)
			end
			self.fields.Text_stage:setString(lvCfg.Class)
			_ENV = string.format("img_warpattern_d_%02d.png", self.data.holeType)
			string.format("img_warpattern_d_%02d.png", self.data.holeType).lv = lvCfg.Level
			self.fields.Text_lv:setString(i18n("common_text_101", string.format("img_warpattern_d_%02d.png", self.data.holeType)))
			self.fields.Text_lv:setVisible(true)
			if isMine and not self.isFirst then
				self:playAddAct()
			end
		else
			self.fields.img_add:setVisible(false)
			self.fields.Node_rune:setVisible(false)
			self.fields.icon_lock:setVisible(false)
		end
	end
	self.isFirst = false
end
function Com_level:getUid()
	return self.data.showType == 2 and self.data.uid or 0
end
function Com_level:btnTouchClick()
	SoraDPlaySound()
	if self.data.showType == 0 then
		if self.data.unlockTip then
			if self.data.unlockTip.key == 1 then
				_ENV = nil
				;(nil).lv = self.data.unlockTip.val
				SoraDShowMsgTip(i18n("common_text_3868", nil))
			elseif self.data.unlockTip.key == 2 then
				local nebulaMileStoneRead = include("nebulaMileStoneRead")
				_ENV = i18n("common_text_3868", nil)
				i18n("common_text_3868", nil).name = nebulaMileStoneRead.getName(self.data.unlockTip.val)
				SoraDShowMsgTip(i18n("Weapon_Rune_tips_003", i18n("common_text_3868", nil)))
			elseif self.data.unlockTip.key == 3 then
				local collegeDesRead = include("collegeDesRead")
				_ENV = i18n("Weapon_Rune_tips_003", i18n("common_text_3868", nil))
				i18n("Weapon_Rune_tips_003", i18n("common_text_3868", nil)).name = collegeDesRead.getName(self.data.unlockTip.val)
				i18n("Weapon_Rune_tips_003", i18n("common_text_3868", nil)).num = self.data.unlockTip.lv
				SoraDShowMsgTip(i18n("Weapon_Rune_technologyID_01", i18n("Weapon_Rune_tips_003", i18n("common_text_3868", nil))))
			end
		end
		return
	end
	if self.data.showType == 1 then
		local holeType = self.data.holeType
		local isHave = godArmsRuneCtrl:checkFreeRune(holeType, self.data.godArmsID, self.group)
		if not isHave then
			_ENV = self.group
			self.group.content = i18n("Weapon_Rune_tips_076")
			self.group.confirmString = i18n("common_text_477")
			function self.group.confirmFunc()
				_ENV = nil
				;(nil).holeType = holeType
				uiManager:show("RuneChooseItem", nil)
			end
			uiManager:show("MessageBox", self.group)
		elseif artifactRuneRead.isRuneSetLock(self.group - 1) then
			SoraDShowMsgTip(i18n("Weapon_Rune_tips_095"))
		else
			_ENV = i18n("Weapon_Rune_tips_095")
			i18n("Weapon_Rune_tips_095").data = self.data
			i18n("Weapon_Rune_tips_095").group = self.group
			uiManager:show("RuneAddView", i18n("Weapon_Rune_tips_095"))
		end
		return
	end
	if self.data.showType == 2 then
		_ENV = uiManager
		uiManager.data = self.data
		uiManager.group = self.group
		uiManager:show("RunePopView", uiManager)
		return
	end
end
return Com_level
