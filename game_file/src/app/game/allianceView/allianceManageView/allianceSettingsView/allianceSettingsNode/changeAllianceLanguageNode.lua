local ChangeAllianceLanguageNode = class("changeAllianceLanguageNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("changeAllianceLanguageNode")
	end
	return target
end)
function ChangeAllianceLanguageNode:ctor()
	self.tableLanguageList, _ENV = nil, nil
	self.ownLanguage = gLanguage.ALL
	self.curLanguage = nil
	self.nodeSize = SoraDGetChildByName(self, "Panel_size")
	self.nodeSize:setSwallowTouches(false)
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.labelNotice:setString(i18n("common_text_250"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_language")
	self:initData()
end
function ChangeAllianceLanguageNode:initData()
	local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	self.tableLanguageList = permissionCtrl:getLanguageMenu()
	self.ownLanguage = allianceMgr:getAllianceProperty("language")
	self:initScroll()
end
function ChangeAllianceLanguageNode:initScroll()
	local scrollH = math.max(self.scroll:getContentSize().height, 65 * math.ceil(#self.tableLanguageList / 2))
	self.scroll:setInnerContainerSize(cc.size(550, scrollH))
	for i, v in ipairs(self.tableLanguageList) do
		local single = SoraDCreatePanel("changeAllianceLanguageSingle")
		local posX = 500 - (i - 1) % 2 * 275
		local posY = scrollH - 65 * math.floor((i - 1) / 2)
		single:setScroll(self.scroll)
		single:initData(v)
		single:setHandle(handler(self, self.updateScroll))
		if v == self.ownLanguage then
			single:setCheck(true)
			self.curLanguage = single
			self.scroll:jumpToPercentVertical(100 * (scrollH - posY) / scrollH)
		end
		single:setPosition(cc.p(posX, posY))
		single:addTo(self.scroll)
		SoraDFTarget(single)
	end
end
function ChangeAllianceLanguageNode:updateScroll(target, lid)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceSetting = gametop.playertop_:getModule("allianceSetting")
	if self.curLanguage then
		self.curLanguage:setCheck(false)
	end
	self.curLanguage = target
	self.ownLanguage = lid
	allianceSetting:reqModifyLanguage(self.ownLanguage)
end
function ChangeAllianceLanguageNode:getSingleH()
	return self.nodeSize:getContentSize().height
end
return ChangeAllianceLanguageNode
