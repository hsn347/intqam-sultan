local equipDesRead = include("equipDesRead")
local artifactRuneRead = include("artifactRuneRead")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local godArmsCtrl = SoraDGetCtrl("godArmsCtrl")
local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local skillActiveFlag = class("skillActiveFlag", function(target)
	if type(target) == "nil" then
		return SoraDCreateBasePanel("skillActiveFlag")
	elseif type(target) == "userdata" then
		return SoraDCreateCloneBasePanel(target, "skillActiveFlag")
	else
		return target
	end
end)
function skillActiveFlag:ctor()
	self.showRuneList, _ENV, self.isOpen = nil, nil, false
	self.Node_group = SoraDGetChildByName(self, "Node_group")
	self.Node_ch = SoraDGetChildByName(self, "Node_ch")
	self.frame_arrow = SoraDGetChildByName(self, "frame_arrow")
	self.Text_group = SoraDGetChildByName(self, "Text_group")
	self.Button_group = SoraDGetChildByName(self, "Button_group")
	self.Button_group:addTouchEventListener(handler(self, self.btnGroupClick))
	self.Button_group:setSwallowTouches(false)
	self.Image_arm = SoraDGetChildByName(self, "Image_arm")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.icon_skill = SoraDGetChildByName(self, "icon_skill")
	self.icon_lock = SoraDGetChildByName(self, "icon_lock")
	self.Image_select = SoraDGetChildByName(self, "Image_select")
	self.Button_select = SoraDGetChildByName(self, "Button_select")
	self.Button_select:addTouchEventListener(handler(self, self.btnTouchClick))
	self.Button_select:setSwallowTouches(false)
	self.Button_attr = SoraDGetChildByName(self, "Button_attr")
	self.Button_attr:addTouchEventListener(handler(self, self.btnAttrClick))
	self.Button_attr:setSwallowTouches(false)
	self.Node_rune = SoraDGetChildByName(self, "Node_rune")
end
function skillActiveFlag:initData(data, index)
	self.data = data
	self.index = index
	self.Image_arm:loadTexture(equipDesRead.getArtifactIcon(self.data.weaponID), ccui.TextureResType.plistType)
	local isUnLock = godArmsCtrl:isWeaponUnlock(self.data.weaponID)
	self.Image_arm:getVirtualRenderer():setState(isUnLock and 0 or 1)
	self.Text_name:setString(i18n(self.data.name))
	self.icon_skill:setSpriteFrame(self.data.icon)
	self.icon_skill:setColor(self.data.isActive and cc.c3b(255, 255, 255) or cc.c3b(120, 120, 120))
	self.icon_lock:setVisible(not self.data.isActive)
	self.runeInfo = godArmsRuneCtrl:getArmCfg(self.data.weaponID)
	local cfgCastleLv, cfgArtifactLv = artifactRuneRead.getUnlockCfg()
	local weaponData = godArmsCtrl:getArmsInfo(self.data.weaponID)
	local isShowGroup = self.runeInfo and weaponData and cfgArtifactLv <= weaponData.info.level
	local isUnlock = nebulaMileStoneCtrl:getPlusByUnlockType(gNebulaMileStoneUnlockType.UNLOCK_WAR_LINE_SYS, nil, lordInfoCtrl:getMapSourceKid()) ~= nil
	if not artifactRuneRead.getHoleInfo(self.data.weaponID) then
		local equipDesRead, holeCfg = artifactRuneRead.getHoleInfo(self.data.weaponID), artifactRuneRead.getHoleInfo(self.data.weaponID)
	end
	local isHoleCfg = next(holeCfg) and true or false
	local isVisible = isUnlock and cfgCastleLv <= SoraDGetCastleLv() and isHoleCfg and not self.data.isLock
	self.Node_ch:setVisible(isShowGroup and isVisible or false)
	self.Button_attr:setVisible(isShowGroup and isVisible or false)
	self.Node_rune:setVisible(isShowGroup and isVisible or false)
	if isShowGroup and isVisible then
		self.Text_group:setString(i18n("Weapon_Rune_tips_104"))
		self:updateShowRune()
	end
end
function skillActiveFlag:updateShowRune()
	for k, v in ipairs(self.showRuneList) do
		v:setVisible(false)
	end
	local setList = godArmsRuneCtrl:getArmDetailList(self.data.weaponID, 1)
	local _ENV, runeList = godArmsRuneCtrl, godArmsRuneCtrl
	for k, v in pairs(setList) do
		local runeData = godArmsRuneCtrl:getRuneInfo(v)
		if tonumber(k) and v ~= 0 and runeData then
			_ENV = nil
			;(nil).rid = runeData.rid
			;(nil).hole = tonumber(k)
			table.insert(runeList, nil)
		end
	end
	table.sort(runeList, function(a, b)
		return a.hole < b.hole
	end)
	dump(setList, "setList====")
	dump(runeList, "runeList====")
	for k, v in ipairs(runeList) do
		if not self.showRuneList[k] then
			self.showRuneList[k] = display.newSprite("#" .. artifactRuneRead.getRuneIcon(v.rid))
			self.showRuneList[k]:setScale(0.18)
			self.showRuneList[k]:addTo(self.Node_rune)
		else
			self.showRuneList[k]:setSpriteFrame(artifactRuneRead.getRuneIcon(v.rid))
			self.showRuneList[k]:setVisible(true)
		end
		local h = k % 4 == 0 and 4 or k % 4
		local posx = SoraDFPosX(30 - (h - 1) * 20, 0)
		local l = math.ceil(k / 4)
		local posy = 10 - (l - 1) * 20
		self.showRuneList[k]:setPosition(posx, posy)
	end
end
function skillActiveFlag:btnGroupClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isOpen = not self.isOpen
		_ENV = nil
		;(nil).msg = "MESSAGE_LORDINFO_SKILLS_ARTIFACT_SHOW"
		;(nil).data = self.data
		;(nil).index = self.index
		;(nil).globalPos = self.frame_arrow:convertToWorldSpace(cc.p(24, 24))
		SoraDSendMessage(nil)
	end
end
function skillActiveFlag:btnTouchClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:call4Fun()
	end
end
function skillActiveFlag:btnAttrClick(button, event)
	if event == ccui.TouchEventType.ended then
		_ENV = nil
		;(nil).data = self.data
		uiManager:show("RuneAttrTotal", nil)
	end
end
function skillActiveFlag:setSelect(bool)
	self.Image_select:setVisible(bool)
end
function skillActiveFlag:setScroll(scroll)
	self.scroll = scroll
end
function skillActiveFlag:setHandle(handle)
	self.handle = handle
end
function skillActiveFlag:call4Fun()
	if self.handle then
		_UPVALUE0_ = nil
		;(nil).sid = self.data.skillID
		;(nil).isOpened = self.data.isActive
		;(nil).skillNode = self
		;(nil).data = self.data
		self.handle("skillClick", nil)
	end
end
return skillActiveFlag
