local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildPrison = class("cityBuildPrison", function()
	return cityBuildBaseEntity.new()
end)
function cityBuildPrison:ctor()
	print("create prison!!")
	self:setBuildIndex(cityBuildConstDef.buildIndexDef.index_Prison)
	self.bid = BUILDID.HERO_PRISON
end
function cityBuildPrison:onMessageListener()
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_NOTICEOTHERHERO", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_RELEASESUCCESS", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROJAIN_EXECUTESUCCESS", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_PRISON_VIEW", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_MONUMENT_VIEW", handler(self, self.msgUpdateView))
end
function cityBuildPrison:onAfterInitWithBuildCell()
	self:updateView()
end
function cityBuildPrison:updateViewAfterBuild()
	self:updateView()
end
function cityBuildPrison:updateViewAfterReset()
	self:updateView()
end
function cityBuildPrison:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_125"), i18n("buildDes_name_125")
	i18n("buildDes_name_125").x = 0
	;(nil).pos, i18n("buildDes_name_125").y = i18n("buildDes_name_125"), -100
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildPrison:msgUpdateView(target, data)
	self:updateView()
end
function cityBuildPrison:updateView()
	self:updateIsLock()
	self:checkHasPrisioner()
	self:checkHasDeadHero()
	self:checkIdle()
end
function cityBuildPrison:checkIdle()
	local isLocked = self:getIsLocked()
	if isLocked then
		return
	end
	local hasPrisoner = self:hasPrisoner()
	print("cityBuildPrison:checkIdle() = ", hasPrisoner)
	if hasPrisoner then
		self:showEffect()
		self:hideZAnimation()
		return
	else
		self:showZAnimation()
		self:hideEffect()
		return
	end
end
function cityBuildPrison:checkHasDeadHero(...)
	local gametop = gModuleMgr.getObject("gametop")
	local heroCenotaphCtrl = gametop.playertop_:getModule("heroCenotaphCtrl")
	local isOpen = heroCenotaphCtrl:isOpenBlessing()
	if isOpen then
		self:showEffect()
		self:hideZAnimation()
	else
		self:hideEffect()
		self:showZAnimation()
	end
end
function cityBuildPrison:checkHasPrisioner()
	local isLocked = self:getIsLocked()
	if isLocked then
		return
	end
	if self:getIsCanSpeedUpFree() then
		return
	elseif self:getIsNeedReqHelp() then
		return
	end
	local hasPrisoner = self:hasPrisoner()
	if hasPrisoner then
		print("hasPrisoner = ", hasPrisoner, "self.buildIndex = ", self.buildIndex)
		_ENV = "hasPrisoner = "
		;("hasPrisoner = ").msg = "MESSAGE_MAINCITYVIEW_ADD_BUILD_TOP_TIP"
		;("hasPrisoner = ").buildIndex = self.buildIndex
		;("hasPrisoner = ").buildEntity = self
		;("hasPrisoner = ").buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_HAS_PRISONER
		SoraDSendMessage("hasPrisoner = ")
	else
		print("hasPrisoner = ", hasPrisoner, "self.buildIndex = ", self.buildIndex)
		_ENV = "hasPrisoner = "
		;("hasPrisoner = ").msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TOP_TIP"
		;("hasPrisoner = ").buildIndex = self.buildIndex
		;("hasPrisoner = ").buildEntity = self
		;("hasPrisoner = ").buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_HAS_PRISONER
		SoraDSendMessage("hasPrisoner = ")
	end
end
function cityBuildPrison:hasPrisoner()
	local gametop = gModuleMgr.getObject("gametop")
	local heroJailCtrl = gametop.playertop_:getModule("heroJailCtrl")
	return heroJailCtrl:isAnyoneInMyJail()
end
function cityBuildPrison:isCustomIdle()
	local isIdle = true
	if self:getIsLocked() then
		isIdle = false
	end
	if isIdle and self:hasPrisoner() then
		isIdle = false
	end
	return isIdle
end
function cityBuildPrison:showEffect()
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		if not self.et_node then
			self.et_node = SoraDCreatAnimation("yingxiongjianyu_bzt")
			self.et_node:setPosition(cc.p(-30, 0))
			self.et_node:addTo(self, 3)
		end
	elseif not self.et_node then
		_ENV, _ENV = self.et_node, self.et_node
		_ENV, self.et_node.plist = self, "et_jinzitaloading_01.plist"
		self.x = 0.09
		_ENV, self.et_node.scale, self.y = self, self, 0.135
		self.x = 143.47
		self.et_node.pos, self.y = self, 27.63
		_ENV, self.et_node[1], self.et_node.rotate = self.et_node, self.et_node, -131.65
		self.et_node.plist = "et_jinzitaloading_01.plist"
		_ENV, self.et_node.scale = self, 0.36
		self.x = 73.76
		self.et_node.pos, self.y = self, -56.02
		_ENV, self.et_node[2], self.et_node.rotate = self.et_node, self.et_node, -104.94
		_ENV, self.et_node.plist = self, "et_jianyujz_01.plist"
		self.x = 0.448
		_ENV, self.et_node.scale, self.y = self, self, 0.672
		self.x = 61.15
		self.et_node.pos, self.y = self, -45.59
		_ENV, self.et_node[3], self.et_node.rotate = self.et_node, self.et_node, -33.46
		self.et_node.plist = "et_jinzitaloading_05.plist"
		_ENV, self.et_node.scale = self, 0.18
		self.x = 127.71
		_ENV, self.et_node[4], self.et_node.pos, self.y = self.et_node, self.et_node, self, 34.75
		_ENV, self.et_node.plist = self, "et_jianyujz_01.plist"
		self.x = 0.38
		_ENV, self.et_node.scale, self.y = self, self, 0.569
		self.x = 47.68
		self.et_node.pos, self.y = self, 24.77
		_ENV, self.et_node[5], self.et_node.rotate = self.et_node, self.et_node, -14.91
		_ENV, self.et_node.plist = self, "et_jinzitaloading_01.plist"
		self.x = 0.12
		_ENV, self.et_node.scale, self.y = self, self, 0.135
		self.x = 44.06
		self.et_node.pos, self.y = self, 25.74
		self.et_node[6], self.et_node.rotate = self.et_node, -130.31
		local param = self.et_node
		self.et_node = SoraDCreateEffectNode(param)
		self.et_node:addTo(self, 3)
	else
		SoraDResetEffectNode(self.et_node)
	end
end
function cityBuildPrison:hideEffect()
	if self.et_node then
		self.et_node:removeFromParent()
		self.et_node = nil
	end
end
return cityBuildPrison
