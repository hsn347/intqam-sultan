local baseComponent = require("fgui.base.baseComponent")
local artifactRuneRead = include("artifactRuneRead")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local Com_runeSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Chaser/Com_runeSingle", Com_runeSingle)
function Com_runeSingle:onInit()
	self.isChoose = false
	self.isLong = false
	self:addClickListener(handler(self, self.onClick))
	self:addLongPressListener(handler(self, self.onLongPress))
end
function Com_runeSingle:onShow()
end
function Com_runeSingle:registerEvent()
	SoraDAddMessage(self, "MESSAGE_UI_STRENGTHEN_EFFECT", handler(self, self.playCost))
end
function Com_runeSingle:initData(data, isChoose, isStrength, isOnlyChoose, cIndex, source, isInUse)
	self.data = data
	self.isChoose = isChoose
	self.isStrength = isStrength
	self.isOnlyChoose = isOnlyChoose
	self.cIndex = cIndex or 0
	self.source = source
	self.isInUse = isInUse
	self.fields.single:initData(self.data)
	self.controllers.c1:setSelectedIndex(self.isChoose and 1 or 0)
	if self.isStrength then
		self.fields.n36:setVisible(false)
	else
		self.fields.n37:setVisible(false)
		self.fields.n35:setVisible(false)
	end
end
function Com_runeSingle:onLongPress()
	if self.source and (self.source == "RuneAddView" or self.source == "RuneReplaceView") then
	else
		SoraDPlaySound()
		self.isLong = true
		if not self.data.isExp then
			_ENV = nil
			;(nil).data = self.data
			;(nil).cIndex = self.cIndex
			uiManager:show("RunePopView", nil)
		end
	end
end
function Com_runeSingle:playCost(target, data)
	local selectArray = data.selectArray
	local checkUid = function()
		local ret = false
		if self.data.uid then
			ret = SoraDisInList(self.data.uid, selectArray.uidList)
		end
		return ret
	end
	local checkUuid = function()
		local ret = false
		if self.data.uuid then
			if not selectArray.expRidList then
				self = selectArray.expRidList
			end
			for k, v in pairs(selectArray.expRidList) do
				if SoraDisInList(self.data.uuid, v) then
					ret = true
					break
				end
			end
		end
		return ret
	end
	if selectArray and (checkUid() or checkUuid()) then
		self.transitions.t0:play()
	end
end
function Com_runeSingle:onClick()
	if self.isLong then
		self.isLong = false
		return
	end
	SoraDPlaySound()
	local choose = function()
		self.isChoose = not self.isChoose
		self.controllers.c1:setSelectedIndex(self.isChoose and 1 or 0)
		if self.isOnlyChoose then
			self = self.controllers.c1
			self.controllers.c1.msg = "MESSAGE_UI_RUNE_CHOOSE"
			self.controllers.c1.data = self.data
			self.controllers.c1.isChoose = self.isChoose
			SoraDSendMessage(self.controllers.c1)
		else
			self = self.controllers.c1
			self.controllers.c1.msg = "MESSAGE_UI_RUNE_STRENGTHEN_CHOOSE"
			self.controllers.c1.data = self.data
			self.controllers.c1.isChoose = self.isChoose
			SoraDSendMessage(self.controllers.c1)
			self = self.controllers.c1
			self.controllers.c1.msg = "MESSAGE_UI_RUNE_REPLACE"
			self.controllers.c1.data = self.data
			self.controllers.c1.isChoose = self.isChoose
			SoraDSendMessage(self.controllers.c1)
		end
	end
	if self.source and (self.source == "RuneAddView" or self.source == "RuneReplaceView") then
	elseif self.data.isLock then
		SoraDShowMsgBox(i18n("Weapon_Rune_tips_031"), i18n("common_text_204"), i18n("common_text_185"), function(event)
			if event == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
				SoraDCheckSecondaryLock(function()
					godArmsRuneCtrl:sendLock(self.data.uid, 0)
					choose()
				end, gSecondaryLockType.ArmsRuneUnlock)
			end
		end)
		return
	end
	if self.data.isWear and (self.isInUse == true or self.isInUse == nil) then
		SoraDShowMsgBox(i18n("Weapon_Rune_tips_048"), i18n("common_text_204"), i18n("common_text_185"), function(event)
			if event == MSGBOX_CALLBACK_YES then
				_ENV = nil
				;(nil).msg = "MESSAGE_UI_RUNE_REPLACE_CHOOSE"
				;(nil).uid = self.data.uid
				SoraDSendMessage(nil)
			else
				_ENV = nil
				;(nil).msg = "MESSAGE_UI_RUNE_REPLACE_UNCHOOSE"
				SoraDSendMessage(nil)
			end
		end)
		return
	end
	if self.isStrength and not self.isChoose then
		local isGrowUp = false
		local isOrange = false
		if self.data.uid then
			for k, v in ipairs(self.data.extraProperty) do
				if v[2] > 1 then
					isGrowUp = true
				end
				local propertyArray, quality = artifactRuneRead.getPropertyArray(v[1])
				if 5 <= quality then
					isOrange = true
				end
			end
		end
		if isGrowUp then
			if GAME_RUNE_NOTIFY_GROWUP then
				choose()
			else
				_ENV = nil
				;(nil).content = i18n("Weapon_Rune_tips_039")
				;(nil).confirmFunc = function()
					choose()
				end
				;(nil).remindFunc = function(bCheck)
					GAME_RUNE_NOTIFY_GROWUP = bCheck
				end
				;(nil).remindString = i18n("build_gold_lvup_tips_name")
				uiManager:show("MessageBox", nil)
			end
			return
		end
		if isOrange then
			if GAME_RUNE_NOTIFY_ORANGE then
				choose()
			else
				_ENV = nil
				;(nil).content = i18n("Weapon_Rune_tips_040")
				;(nil).confirmFunc = function()
					choose()
				end
				;(nil).remindFunc = function(bCheck)
					GAME_RUNE_NOTIFY_ORANGE = bCheck
				end
				;(nil).remindString = i18n("build_gold_lvup_tips_name")
				uiManager:show("MessageBox", nil)
			end
			return
		end
		if self.data.class and self.data.class >= artifactRuneRead.getRuneClassRare() or self.data.exp and self.data.exp > 0 then
			if GAME_RUNE_NOTIFY_CLASS then
				choose()
			else
				_ENV = nil
				_ENV = artifactRuneRead.getPropertyArray(v[1])
				artifactRuneRead.getPropertyArray(v[1]).lv = self.data.cLevel or self.data.level
				artifactRuneRead.getPropertyArray(v[1]).num = self.data.class
				;(nil).content = i18n("Weapon_Rune_tips_041", artifactRuneRead.getPropertyArray(v[1]))
				;(nil).confirmFunc = function()
					choose()
				end
				;(nil).remindFunc = function(bCheck)
					GAME_RUNE_NOTIFY_CLASS = bCheck
				end
				;(nil).remindString = i18n("build_gold_lvup_tips_name")
				uiManager:show("MessageBox", nil)
			end
			return
		end
	end
	choose()
end
return Com_runeSingle
