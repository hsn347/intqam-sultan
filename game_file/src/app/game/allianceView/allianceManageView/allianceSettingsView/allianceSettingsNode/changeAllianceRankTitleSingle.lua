local ChangeAllianceRankTitleSingle = class("changeAllianceRankTitleSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("changeAllianceRankTitleSingle")
	end
	return target
end)
function ChangeAllianceRankTitleSingle:ctor()
	self.nowTitle = nil
	self.handle = nil
	self.rankID = gAllianceRank.R0
	self.labelOld = SoraDGetChildByName(self, "Text_old")
	self.tfdNew = SoraDGetChildByName(self, "TextField_new")
	self.imgLv = SoraDGetChildByName(self, "Image_lv")
	self.spriteErr = SoraDGetChildByName(self, "Sprite_err")
	_ENV = "Sprite_err"
	;("Sprite_err").func = handler(self, self.OnInputName)
	self.tfdNew = SoraDChangeToEditBox(self.tfdNew, "Sprite_err")
	self.tfdNew:setPlaceHolder(i18n("common_text_4122"))
	self.tfdNew:setPlaceHolderColor(cc.c3b(170, 170, 170))
	self.tfdNew:setColor(cc.c3b(255, 255, 255))
	self.tfdNew:setTextColor(cc.c3b(50, 20, 0))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_SETTINGS_SUCCESS", handler(self, self.updateOldTitle))
end
function ChangeAllianceRankTitleSingle:initData(rank)
	local allianceDesRead = include("allianceDesRead")
	self.rankID = rank
	self:updateOldTitle()
	self.tfdNew:setString("")
	self.imgLv:loadTexture(allianceDesRead.getIcon(self.rankID), ccui.TextureResType.plistType)
	if self.rankID == gAllianceRank.OFFICIAL then
		self.imgLv:setContentSize(cc.size(60, 60))
	end
	self.spriteErr:setVisible(false)
end
function ChangeAllianceRankTitleSingle:updateOldTitle()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local oldTitle = ""
	if self.rankID == gAllianceRank.OFFICIAL then
		oldTitle = allianceMgr:getAllianceProperty("r" .. self.rankID .. "Name") or i18n("alliance_office_title_02")
	else
		oldTitle = allianceMgr:getAllianceProperty("r" .. self.rankID .. "Name")
	end
	if string.utf8len(oldTitle) == 0 then
		_ENV = "r" .. self.rankID .. "Name"
		;("r" .. self.rankID .. "Name").rank = self.rankID
		oldTitle = i18n("common_text_205", "r" .. self.rankID .. "Name")
	end
	self.labelOld:setString(oldTitle)
end
function ChangeAllianceRankTitleSingle:setHandle(handle)
	self.handle = handle
end
function ChangeAllianceRankTitleSingle:updateChangeBtnTouchEnable(isCanTouch)
	if self.handle then
		self.handle(self.rankID, isCanTouch)
	end
	self.spriteErr:setVisible(true)
	if isCanTouch then
		self.nowTitle = self.tfdNew:getString()
		self.spriteErr:setSpriteFrame("icon_g.png")
	else
		self.nowTitle = nil
		self.spriteErr:setSpriteFrame("icon_no.png")
	end
end
function ChangeAllianceRankTitleSingle:getRankTitle()
	self.tfdNew:setString("")
	self.spriteErr:setVisible(false)
	return self.nowTitle
end
function ChangeAllianceRankTitleSingle:OnInputName(eventType, textField)
	if eventType == "return" then
		local str = textField:getString()
		local input = textField:getCharCount()
		local regx = "^[؀-ؿa-zـ-ٿA-Zڀ-ڿ0-9ۀ-ۿ ]+$"
		local ret = string.match(str, regx)
		if ret ~= nil and gModuleMgr.sharedMgr("shieldedWordsltCtrl"):hasShieldedWord(str) then
			ret = nil
		end
		self:updateChangeBtnTouchEnable(input <= ALLIANCE_CHANGE_RANK_MAX and input >= ALLIANCE_CHANGE_RANK_MIN and ret ~= nil)
	end
end
return ChangeAllianceRankTitleSingle
