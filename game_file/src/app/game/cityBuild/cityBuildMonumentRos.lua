local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildMonumentRos = class("cityBuildMonumentRos", function()
	return cityBuildBaseEntity.new()
end)
function cityBuildMonumentRos:ctor()
	print("create monument!!")
	self:setBuildIndex(cityBuildConstDef.buildIndexDef.index_MonumentRos)
	self.bid = BUILDID.HERO_CENOTAPH
end
function cityBuildMonumentRos:onMessageListener()
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_MONUMENT_VIEW", handler(self, self.msgUpdateView))
end
function cityBuildMonumentRos:onAfterInitWithBuildCell()
	self:updateView()
end
function cityBuildMonumentRos:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("buildDes_name_124"), i18n("buildDes_name_124")
	i18n("buildDes_name_124").x = 0
	;(nil).pos, i18n("buildDes_name_124").y = i18n("buildDes_name_124"), -150
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildMonumentRos:msgUpdateView(target, data)
	self:updateView()
end
function cityBuildMonumentRos:updateView()
	print("刷新纪念碑=======")
	self:updateIsLock()
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
function cityBuildMonumentRos:showEffect()
	if not self.effectNode then
		if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
			self.effectNode = SoraDCreatAnimation("yingxiongjinian_bzt")
			self.effectNode:setPosition(0, -110)
		else
			self.effectNode = SoraDCreatAnimation("yingxiongjinian")
			self.effectNode:setPosition(3, -140)
		end
		self.effectNode:addTo(self)
	end
	self.effectNode:setVisible(true)
end
function cityBuildMonumentRos:hideEffect()
	if self.effectNode then
		self.effectNode:removeFromParent()
		self.effectNode = nil
	end
end
return cityBuildMonumentRos
